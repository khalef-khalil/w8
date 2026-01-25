import '../models/goal_configuration.dart';

/// Seuils de validation adaptés selon l'unité de poids
class ValidationThresholds {
  final WeightUnit unit;

  ValidationThresholds(this.unit);

  /// Poids maximum autorisé
  double get maxWeight => unit == WeightUnit.kg ? 500.0 : 1100.0; // 500kg ou 1100lbs

  /// Changement impossible en 1 jour (erreur)
  double get impossibleChangePerDay => unit == WeightUnit.kg ? 5.0 : 11.0; // ~5kg ou ~11lbs

  /// Changement suspect en 1 jour (avertissement)
  double get suspiciousChangePerDay => unit == WeightUnit.kg ? 2.0 : 4.5; // ~2kg ou ~4.5lbs

  /// Changement suspect sur plusieurs jours (avertissement)
  double get suspiciousChangeMultiDay => unit == WeightUnit.kg ? 3.0 : 6.5; // ~3kg ou ~6.5lbs

  /// Différence significative avec le poids initial (première entrée)
  double get significantDifferenceFromInitial => unit == WeightUnit.kg ? 5.0 : 11.0; // ~5kg ou ~11lbs

  /// Changement significatif par rapport à l'objectif (avertissement)
  double get significantGoalChange => unit == WeightUnit.kg ? 1.0 : 2.2; // ~1kg ou ~2.2lbs

  /// Nom de l'unité pour les messages
  String get unitName => unit == WeightUnit.kg ? 'kg' : 'lbs';
}
