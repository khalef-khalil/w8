import 'dart:math' as math;
import '../../models/weight_entry.dart';
import '../models/goal_configuration.dart';
import '../models/validation_result.dart';
import '../models/validation_thresholds.dart';
import '../utils/weight_converter.dart';

/// Service de validation intelligente des poids
class WeightValidationService {
  /// Validation basique du poids (en kg, unité interne)
  /// [unit] est utilisé uniquement pour les messages d'erreur
  static ValidationResult validateBasic(double weight, WeightUnit unit) {
    if (weight <= 0) {
      return ValidationResult.error('Please enter a weight greater than 0');
    }
    
    final thresholds = ValidationThresholds(unit);
    if (weight > thresholds.maxWeight) {
      final maxDisplay = WeightConverter.forDisplay(thresholds.maxWeight, unit);
      return ValidationResult.error(
        'Please enter a weight less than ${maxDisplay.toStringAsFixed(0)} ${thresholds.unitName}'
      );
    }

    return ValidationResult.success();
  }

  /// Validation contextuelle basée sur l'historique
  static ValidationResult validateContextual(
    double newWeight,
    List<WeightEntry> history,
    GoalConfiguration? goal,
  ) {
    final unit = goal?.unit ?? WeightUnit.kg;
    final thresholds = ValidationThresholds(unit);
    
    // Validation basique d'abord
    final basicValidation = validateBasic(newWeight, unit);
    if (!basicValidation.isValid) {
      return basicValidation;
    }

    // Si pas d'historique, c'est la première entrée
    if (history.isEmpty) {
      // Vérifier cohérence avec l'objectif si disponible
      if (goal != null) {
        final diffFromInitial = (newWeight - goal.initialWeight).abs();
        if (diffFromInitial > thresholds.significantDifferenceFromInitial) {
          final newDisplay = WeightConverter.forDisplay(newWeight, unit);
          final initialDisplay = WeightConverter.forDisplay(goal.initialWeight, unit);
          return ValidationResult.warning(
            'This weight (${newDisplay.toStringAsFixed(2)} ${thresholds.unitName}) is quite different '
            'from your initial weight (${initialDisplay.toStringAsFixed(2)} ${thresholds.unitName}). '
            'Is this correct?',
            requiresConfirmation: true,
          );
        }
      }
      return ValidationResult.success();
    }

    final lastEntry = history.last;
    final lastWeight = lastEntry.weight;
    final daysSinceLast = DateTime.now().difference(lastEntry.date).inDays;

    // Calculer le changement
    final change = newWeight - lastWeight;
    final changeAbs = change.abs();

    // Cas 1: Changement physiologiquement impossible
    if (daysSinceLast <= 1 && changeAbs > thresholds.impossibleChangePerDay) {
      final changeSignDisplay = WeightConverter.forDisplay(change, unit);
      return ValidationResult.error(
        'This weight change (${change > 0 ? '+' : ''}${changeSignDisplay.toStringAsFixed(2)} ${thresholds.unitName}) seems unusually large. '
        'Please double-check your entry.',
      );
    }

    // Cas 2: Changement suspect en 1 jour
    if (daysSinceLast == 1 && changeAbs > thresholds.suspiciousChangePerDay) {
      final changeSignDisplay = WeightConverter.forDisplay(change, unit);
      return ValidationResult.warning(
        'This is a significant change (${change > 0 ? '+' : ''}${changeSignDisplay.toStringAsFixed(2)} ${thresholds.unitName} in 1 day). '
        'Is everything okay? Normal daily fluctuations are usually less than ${WeightConverter.forDisplay(thresholds.suspiciousChangePerDay, unit).toStringAsFixed(1)} ${thresholds.unitName}/day. You can still save it.',
        requiresConfirmation: true,
      );
    }

    // Cas 3: Changement suspect sur plusieurs jours
    if (daysSinceLast <= 3 && changeAbs > thresholds.suspiciousChangeMultiDay) {
      final changeSignDisplay = WeightConverter.forDisplay(change, unit);
      return ValidationResult.warning(
        'This is a significant change (${change > 0 ? '+' : ''}${changeSignDisplay.toStringAsFixed(2)} ${thresholds.unitName} in $daysSinceLast day${daysSinceLast > 1 ? 's' : ''}). '
        'Is everything okay? You can still save it.',
        requiresConfirmation: true,
      );
    }

    // Cas 4: Vérifier cohérence avec l'objectif
    if (goal != null) {
      // Si on gagne du poids alors que l'objectif est de perdre
      if (goal.type == GoalType.loss && change > thresholds.significantGoalChange) {
        final changeDisplay = WeightConverter.forDisplay(change, unit);
        return ValidationResult.warning(
          'You\'re gaining weight (${changeDisplay.toStringAsFixed(2)} ${thresholds.unitName}) while your goal is to lose. '
          'That\'s okay—setbacks happen. Do you want to continue?',
          requiresConfirmation: true,
        );
      }

      // Si on perd du poids alors que l'objectif est de gagner
      if (goal.type == GoalType.gain && change < -thresholds.significantGoalChange) {
        final changeDisplay = WeightConverter.forDisplay(change, unit);
        return ValidationResult.warning(
          'You\'re losing weight (${changeDisplay.toStringAsFixed(2)} ${thresholds.unitName}) while your goal is to gain. '
          'That\'s okay—setbacks happen. Do you want to continue?',
          requiresConfirmation: true,
        );
      }

      // Si on s'éloigne beaucoup de l'objectif
      final currentProgress = (newWeight - goal.initialWeight) / 
                             (goal.targetWeight - goal.initialWeight);
      if (currentProgress < -0.2) {
        // On est à plus de 20% en dessous du point de départ
        return ValidationResult.warning(
          'You\'re moving away from your goal. This might be normal (fluctuations, life events). Is this correct?',
          requiresConfirmation: true,
        );
      }
    }

    // Cas 5: Détecter les valeurs aberrantes par rapport à la tendance
    // Utiliser une fenêtre plus large (7 dernières entrées au lieu de 3)
    if (history.length >= 7) {
      final recentWeights = history
          .sublist(history.length - 7)
          .map((e) => e.weight)
          .toList();
      
      final average = recentWeights.reduce((a, b) => a + b) / recentWeights.length;
      final stdDev = _calculateStdDev(recentWeights, average);
      
      // Si le nouveau poids est à plus de 2 écarts-types de la moyenne
      // Seuil minimum d'écart-type ajusté selon l'unité
      final minStdDev = unit == WeightUnit.kg ? 0.5 : 1.1; // ~0.5kg ou ~1.1lbs
      if ((newWeight - average).abs() > 2 * stdDev && stdDev > minStdDev) {
        return ValidationResult.warning(
          'This weight seems unusual compared to your recent entries. '
          'Is everything okay? You can still save it.',
          requiresConfirmation: true,
        );
      }
    }

    return ValidationResult.success();
  }

  /// Calculer l'écart-type
  static double _calculateStdDev(List<double> values, double mean) {
    if (values.isEmpty) return 0.0;
    
    final variance = values
        .map((v) => (v - mean) * (v - mean))
        .reduce((a, b) => a + b) / values.length;
    
    return math.sqrt(variance);
  }

  /// Valider une entrée complète
  static Future<ValidationResult> validateEntry(
    WeightEntry entry,
    List<WeightEntry> history,
    GoalConfiguration? goal,
  ) async {
    final unit = goal?.unit ?? WeightUnit.kg;
    
    // Validation basique
    final basicResult = validateBasic(entry.weight, unit);
    if (!basicResult.isValid) {
      return basicResult;
    }

    // Validation contextuelle
    return validateContextual(entry.weight, history, goal);
  }
}
