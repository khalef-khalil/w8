import '../../models/weight_entry.dart';
import '../models/goal_configuration.dart';
import '../services/smoothing_calculator.dart';
import '../services/statistical_calculator.dart';
import '../utils/date_utils.dart' as date_utils;

/// Métriques de progression avancées
class ProgressMetrics {
  final GoalConfiguration goal;
  final List<WeightEntry> entries;
  final double currentWeight; // Poids actuel (7-day rolling median)
  final DateTime calculationDate;

  ProgressMetrics({
    required this.goal,
    required this.entries,
    required this.currentWeight,
    DateTime? calculationDate,
  }) : calculationDate = calculationDate ?? DateTime.now();

  /// Progression basée sur le temps écoulé (0.0 à 1.0)
  double get progressByTime {
    final elapsed = calculationDate.difference(goal.goalStartDate).inDays;
    final total = goal.totalDurationDays;
    return total > 0 ? (elapsed / total).clamp(0.0, 1.0) : 0.0;
  }

  /// Progression basée sur le poids (0.0 à 1.0)
  /// Gère explicitement les dépassements d'objectif
  double get progressByWeight {
    final totalChange = goal.targetWeight - goal.initialWeight;
    if (totalChange == 0) return 0.0;
    
    final currentChange = currentWeight - goal.initialWeight;
    final progress = currentChange / totalChange;
    
    // Si l'objectif est atteint ou dépassé, retourner 1.0
    if (goal.type == GoalType.gain && progress >= 1.0) return 1.0;
    if (goal.type == GoalType.loss && progress <= 1.0) return 1.0;
    
    // Si on va dans la mauvaise direction, retourner 0.0
    if (goal.type == GoalType.gain && progress < 0) return 0.0;
    if (goal.type == GoalType.loss && progress > 0) return 0.0;
    
    return progress.clamp(0.0, 1.0);
  }

  /// Gain/perte actuel
  double get currentWeightChange => currentWeight - goal.initialWeight;

  /// Gain/perte total requis
  double get totalWeightChange => goal.targetWeight - goal.initialWeight;

  /// Vitesse actuelle (kg/semaine)
  /// Utilise la tendance récente au lieu de tout l'historique pour une meilleure précision
  double get currentRatePerWeek {
    if (entries.isEmpty) return 0.0;

    // Utiliser StatisticalCalculator pour calculer la vitesse basée sur la tendance récente
    // Cela donne une meilleure estimation que la méthode simple start-to-now
    final recentRate = StatisticalCalculator.calculateRecentRatePerWeek(
      entries,
      goal,
      weeksToConsider: 4, // Utiliser les 4 dernières semaines
    );

    return recentRate;
  }

  /// Vitesse requise (kg/semaine)
  double get requiredRatePerWeek => goal.requiredRatePerWeek;

  /// Comparaison des vitesses
  ComparisonResult compareRates() {
    final current = currentRatePerWeek;
    final required = requiredRatePerWeek;
    
    // Ajuster selon le type d'objectif (gain/perte)
    final adjustedCurrent = goal.type == GoalType.gain 
        ? current 
        : (goal.type == GoalType.loss ? -current : current.abs());
    final adjustedRequired = goal.type == GoalType.gain 
        ? required 
        : (goal.type == GoalType.loss ? -required : required.abs());
    
    final ratio = adjustedRequired != 0 
        ? (adjustedCurrent / adjustedRequired).abs() 
        : 0.0;
    
    return ComparisonResult(
      currentRate: current,
      requiredRate: required,
      ratio: ratio,
      isOnTrack: ratio >= 0.9 && ratio <= 1.1, // 90-110% de la vitesse requise
      isAhead: ratio > 1.1,
      isBehind: ratio < 0.9,
    );
  }

  /// Prédire la date d'atteinte de l'objectif
  DateTime? predictGoalDate() {
    final currentRate = currentRatePerWeek;
    if (currentRate == 0 || (goal.type == GoalType.gain && currentRate < 0) || 
        (goal.type == GoalType.loss && currentRate > 0)) {
      return null; // Pas de progression ou direction incorrecte
    }

    final remaining = goal.targetWeight - currentWeight;
    if (remaining == 0) {
      return calculationDate; // Déjà atteint
    }

    // Si la direction est incorrecte, on ne peut pas prédire
    if ((goal.type == GoalType.gain && remaining < 0) ||
        (goal.type == GoalType.loss && remaining > 0)) {
      return null; // Déjà dépassé l'objectif
    }

    // Vérifier que la vitesse est dans la bonne direction
    if ((goal.type == GoalType.gain && currentRate <= 0) ||
        (goal.type == GoalType.loss && currentRate >= 0)) {
      return null; // Pas de progression ou mauvais sens
    }

    final weeksRemaining = remaining.abs() / currentRate.abs();
    final daysRemaining = (weeksRemaining * 7).round();

    return calculationDate.add(Duration(days: daysRemaining));
  }

  /// Calculer les semaines écoulées depuis le début réel
  int get weeksElapsed {
    return date_utils.AppDateUtils.getWeeksBetween(
      goal.goalStartDate,
      calculationDate,
    );
  }

  /// Calculer le nombre total de semaines
  int get totalWeeks => goal.totalWeeks;

  /// Calculer le poids projeté dans X semaines
  double? projectedWeight(int weeksFromNow) {
    final currentRate = currentRatePerWeek;
    if (currentRate == 0) return null;

    final projectedChange = currentRate * weeksFromNow;
    return currentWeight + projectedChange;
  }

  /// Vérifier si on est en avance sur l'objectif
  bool get isAhead {
    return progressByWeight > progressByTime + 0.05; // 5% d'avance
  }

  /// Vérifier si on est en retard sur l'objectif
  bool get isBehind {
    return progressByWeight < progressByTime - 0.05; // 5% de retard
  }

  /// Calculer le nombre de jours d'avance/retard
  int get daysAheadOrBehind {
    final expectedProgress = progressByTime;
    final actualProgress = progressByWeight;
    
    final diff = actualProgress - expectedProgress;
    final totalDays = goal.totalDurationDays;
    return (diff * totalDays).round();
  }

  /// Obtenir un poids actuel lissé (rolling 7 jours)
  double get smoothedCurrentWeight {
    if (entries.length < 3) {
      return entries.isNotEmpty ? entries.last.weight : goal.initialWeight;
    }
    return SmoothingCalculator.calculateRolling7Days(entries);
  }
  
  /// Progression lissée avec moyenne mobile exponentielle (EMA)
  /// Plus stable que progressByWeight, réduit les sauts brusques
  double get smoothedProgress {
    if (entries.length < 3) {
      return progressByWeight;
    }
    
    // Utiliser EMA pour lisser le poids actuel
    final smoothedWeight = SmoothingCalculator.calculateEMA(entries, 0.3);
    final totalChange = goal.targetWeight - goal.initialWeight;
    if (totalChange == 0) return 0.0;
    
    final currentChange = smoothedWeight - goal.initialWeight;
    final progress = currentChange / totalChange;
    
    // Gérer les dépassements comme dans progressByWeight
    if (goal.type == GoalType.gain && progress >= 1.0) return 1.0;
    if (goal.type == GoalType.loss && progress <= 1.0) return 1.0;
    if (goal.type == GoalType.gain && progress < 0) return 0.0;
    if (goal.type == GoalType.loss && progress > 0) return 0.0;
    
    return progress.clamp(0.0, 1.0);
  }

  /// Créer depuis une liste d'entrées
  /// Current weight = 7-day rolling median (fallback to last entry if no entries in last 7 days, else initial)
  factory ProgressMetrics.fromEntries(
    GoalConfiguration goal,
    List<WeightEntry> entries,
  ) {
    final currentWeight = entries.isEmpty
        ? goal.initialWeight
        : SmoothingCalculator.calculateRolling7DaysMedian(entries);

    return ProgressMetrics(
      goal: goal,
      entries: entries,
      currentWeight: currentWeight,
    );
  }
  
  /// Obtenir un indicateur de confiance dans les données (0.0 à 1.0)
  /// 1.0 = données très fiables, 0.0 = données peu fiables
  double get dataConfidence {
    if (entries.isEmpty) return 0.0;
    
    // Vérifier le nombre de semaines complètes récentes
    final completeWeeks = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      goal.weekStartDay,
      minEntries: 3,
      onlyCompleteWeeks: true,
    );
    
    // Plus de semaines complètes = plus de confiance
    if (completeWeeks.length >= 4) return 1.0;
    if (completeWeeks.length >= 2) return 0.75;
    if (completeWeeks.length >= 1) return 0.5;
    
    // Vérifier la consistance des entrées récentes
    if (entries.length >= 7) {
      final recentEntries = entries.sublist(entries.length - 7);
      final daysSpan = recentEntries.last.date.difference(recentEntries.first.date).inDays;
      if (daysSpan <= 10) return 0.4; // Entrées récentes et fréquentes
    }
    
    return 0.25; // Données peu fiables
  }
}

/// Résultat de comparaison des vitesses
class ComparisonResult {
  final double currentRate;
  final double requiredRate;
  final double ratio;
  final bool isOnTrack;
  final bool isAhead;
  final bool isBehind;

  ComparisonResult({
    required this.currentRate,
    required this.requiredRate,
    required this.ratio,
    required this.isOnTrack,
    required this.isAhead,
    required this.isBehind,
  });

  /// Calculer les jours d'avance
  int daysAhead() {
    if (!isAhead || requiredRate == 0) return 0;
    final weeksAhead = (currentRate - requiredRate) / requiredRate;
    return (weeksAhead * 7).round();
  }

  /// Calculer les jours de retard
  int daysBehind() {
    if (!isBehind || requiredRate == 0) return 0;
    final weeksBehind = (requiredRate - currentRate) / requiredRate;
    return (weeksBehind * 7).round();
  }
}
