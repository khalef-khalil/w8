import 'validation_result.dart';

/// Configuration de l'objectif utilisateur
class GoalConfiguration {
  final double initialWeight;
  final double targetWeight;
  final DateTime goalStartDate;
  final int durationMonths;
  /// Extra days beyond full months (0–31). Used with duration or derived from [goalEndDateOverride].
  final int durationDays;
  /// When set, goal end is this exact date (e.g. user picked "use end date"). Otherwise end = start + months + days.
  final DateTime? goalEndDateOverride;
  final GoalType type;
  final WeightUnit unit;
  final WeekStartDay weekStartDay;

  GoalConfiguration({
    required this.initialWeight,
    required this.targetWeight,
    required this.goalStartDate,
    required this.durationMonths,
    this.durationDays = 0,
    this.goalEndDateOverride,
    required this.type,
    this.unit = WeightUnit.kg,
    this.weekStartDay = WeekStartDay.monday,
  });

  /// Créer depuis JSON (pour Hive)
  Map<String, dynamic> toJson() {
    return {
      'initialWeight': initialWeight,
      'targetWeight': targetWeight,
      'goalStartDate': goalStartDate.toIso8601String(),
      'durationMonths': durationMonths,
      'durationDays': durationDays,
      if (goalEndDateOverride != null)
        'goalEndDateOverride': goalEndDateOverride!.toIso8601String(),
      'type': type.name,
      'unit': unit.name,
      'weekStartDay': weekStartDay.name,
    };
  }

  /// Créer depuis JSON (pour Hive)
  factory GoalConfiguration.fromJson(Map<String, dynamic> json) {
    return GoalConfiguration(
      initialWeight: (json['initialWeight'] as num).toDouble(),
      targetWeight: (json['targetWeight'] as num).toDouble(),
      goalStartDate: DateTime.parse(json['goalStartDate'] as String),
      durationMonths: json['durationMonths'] as int,
      durationDays: (json['durationDays'] as int?) ?? 0,
      goalEndDateOverride: json['goalEndDateOverride'] != null
          ? DateTime.parse(json['goalEndDateOverride'] as String)
          : null,
      type: GoalType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => GoalType.gain,
      ),
      unit: WeightUnit.values.firstWhere(
        (e) => e.name == json['unit'],
        orElse: () => WeightUnit.kg,
      ),
      weekStartDay: WeekStartDay.values.firstWhere(
        (e) => e.name == json['weekStartDay'],
        orElse: () => WeekStartDay.monday,
      ),
    );
  }

  /// Valider la configuration
  ValidationResult validate() {
    if (initialWeight <= 0 || initialWeight > 500) {
      return ValidationResult.error('Poids initial invalide');
    }
    
    if (targetWeight <= 0 || targetWeight > 500) {
      return ValidationResult.error('Poids cible invalide');
    }

    // Vérifier cohérence avec le type d'objectif
    if (type == GoalType.gain && targetWeight <= initialWeight) {
      return ValidationResult.error(
        'Pour un objectif de gain de poids, le poids cible doit être supérieur au poids initial',
      );
    }

    if (type == GoalType.loss && targetWeight >= initialWeight) {
      return ValidationResult.error(
        'Pour un objectif de perte de poids, le poids cible doit être inférieur au poids initial',
      );
    }

    if (type == GoalType.maintain && 
        (targetWeight - initialWeight).abs() > 1.0) {
      return ValidationResult.error(
        'Pour un objectif de maintien, le poids cible doit être proche du poids initial',
      );
    }

    // Vérifier la date de début
    if (goalStartDate.isAfter(DateTime.now())) {
      return ValidationResult.error('La date de début ne peut pas être dans le futur');
    }

    // Vérifier la durée
    if (durationMonths < 1 || durationMonths > 24) {
      return ValidationResult.error('La durée doit être entre 1 et 24 mois');
    }
    if (durationDays < 0 || durationDays > 31) {
      return ValidationResult.error('Les jours supplémentaires doivent être entre 0 et 31');
    }
    if (goalEndDateOverride != null &&
        !goalEndDateOverride!.isAfter(goalStartDate)) {
      return ValidationResult.error('La date de fin doit être après la date de début');
    }

    // Vérifier que le gain/perte est réaliste
    final weightChange = (targetWeight - initialWeight).abs();
    final totalMonthsApprox = durationMonths + (durationDays / 30.0);
    final maxRealisticChange = totalMonthsApprox * 2.0; // 2kg/mois max

    if (weightChange > maxRealisticChange) {
      final durationStr = durationDays > 0
          ? '$durationMonths mois et $durationDays jours'
          : '$durationMonths mois';
      return ValidationResult.warning(
        'L\'objectif semble ambitieux (${weightChange.toStringAsFixed(2)}kg en $durationStr). '
        'Est-ce réaliste ?',
      );
    }

    return ValidationResult.success();
  }

  /// Calculer le gain/perte total
  double get weightChange => (targetWeight - initialWeight).abs();

  /// Total duration in days (for rate and weeks).
  int get totalDurationDays {
    if (goalEndDateOverride != null) {
      return goalEndDateOverride!.difference(goalStartDate).inDays;
    }
    // Approximate: 30 days per month + extra days
    return durationMonths * 30 + durationDays;
  }

  /// Calculer la vitesse requise (kg/mois)
  double get requiredRatePerMonth => weightChange / (totalDurationDays / 30.0);

  /// Calculer la vitesse requise (kg/semaine)
  double get requiredRatePerWeek => weightChange / (totalDurationDays / 7.0);

  /// Calculer la date de fin théorique
  DateTime get goalEndDate {
    if (goalEndDateOverride != null) return goalEndDateOverride!;
    final afterMonths = DateTime(
      goalStartDate.year,
      goalStartDate.month + durationMonths,
      goalStartDate.day,
    );
    return afterMonths.add(Duration(days: durationDays));
  }

  /// Calculer le nombre total de semaines
  int get totalWeeks => (totalDurationDays / 7).ceil().clamp(1, 999);

  GoalConfiguration copyWith({
    double? initialWeight,
    double? targetWeight,
    DateTime? goalStartDate,
    int? durationMonths,
    int? durationDays,
    DateTime? goalEndDateOverride,
    GoalType? type,
    WeightUnit? unit,
    WeekStartDay? weekStartDay,
  }) {
    return GoalConfiguration(
      initialWeight: initialWeight ?? this.initialWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      goalStartDate: goalStartDate ?? this.goalStartDate,
      durationMonths: durationMonths ?? this.durationMonths,
      durationDays: durationDays ?? this.durationDays,
      goalEndDateOverride: goalEndDateOverride ?? this.goalEndDateOverride,
      type: type ?? this.type,
      unit: unit ?? this.unit,
      weekStartDay: weekStartDay ?? this.weekStartDay,
    );
  }
}

/// Type d'objectif
enum GoalType {
  gain,     // Gain de poids
  loss,     // Perte de poids
  maintain, // Maintien du poids
}

/// Unité de poids
enum WeightUnit {
  kg,
  lbs,
}

/// Jour de début de semaine
enum WeekStartDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

// ValidationResult est maintenant dans validation_result.dart
