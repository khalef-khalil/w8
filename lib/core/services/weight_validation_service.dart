import 'dart:math' as math;
import '../../models/weight_entry.dart';
import '../models/goal_configuration.dart';
import '../models/validation_result.dart';

/// Service de validation intelligente des poids
class WeightValidationService {
  /// Validation basique du poids
  static ValidationResult validateBasic(double weight) {
    if (weight <= 0) {
      return ValidationResult.error('Le poids doit être supérieur à 0');
    }
    
    if (weight > 500) {
      return ValidationResult.error('Le poids doit être inférieur à 500 kg');
    }

    return ValidationResult.success();
  }

  /// Validation contextuelle basée sur l'historique
  static ValidationResult validateContextual(
    double newWeight,
    List<WeightEntry> history,
    GoalConfiguration? goal,
  ) {
    // Validation basique d'abord
    final basicValidation = validateBasic(newWeight);
    if (!basicValidation.isValid) {
      return basicValidation;
    }

    // Si pas d'historique, c'est la première entrée
    if (history.isEmpty) {
      // Vérifier cohérence avec l'objectif si disponible
      if (goal != null) {
        final diffFromInitial = (newWeight - goal.initialWeight).abs();
        if (diffFromInitial > 5.0) {
          return ValidationResult.warning(
            'Le poids saisi (${newWeight.toStringAsFixed(2)}kg) est très différent '
            'du poids initial configuré (${goal.initialWeight.toStringAsFixed(2)}kg). '
            'Est-ce correct ?',
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

    // Cas 1: Changement physiologiquement impossible (>5kg en 1 jour)
    if (daysSinceLast <= 1 && changeAbs > 5.0) {
      return ValidationResult.error(
        'Changement trop important détecté (${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}kg). '
        'Cela semble impossible. Vérifiez votre saisie.',
      );
    }

    // Cas 2: Changement suspect (>2kg en 1 jour)
    if (daysSinceLast == 1 && changeAbs > 2.0) {
      return ValidationResult.warning(
        'Changement important détecté (${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}kg en 1 jour). '
        'Est-ce correct ? Les fluctuations normales sont généralement inférieures à 2kg/jour.',
        requiresConfirmation: true,
      );
    }

    // Cas 3: Changement suspect (>3kg en quelques jours)
    if (daysSinceLast <= 3 && changeAbs > 3.0) {
      return ValidationResult.warning(
        'Changement important détecté (${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}kg en $daysSinceLast jour${daysSinceLast > 1 ? 's' : ''}). '
        'Est-ce correct ?',
        requiresConfirmation: true,
      );
    }

    // Cas 4: Vérifier cohérence avec l'objectif
    if (goal != null) {
      // Si on gagne du poids alors que l'objectif est de perdre
      if (goal.type == GoalType.loss && change > 1.0) {
        return ValidationResult.warning(
          'Tu es en train de prendre du poids (${change.toStringAsFixed(2)}kg) alors que ton objectif est de perdre. '
          'Veux-tu continuer ?',
          requiresConfirmation: true,
        );
      }

      // Si on perd du poids alors que l'objectif est de gagner
      if (goal.type == GoalType.gain && change < -1.0) {
        return ValidationResult.warning(
          'Tu es en train de perdre du poids (${change.toStringAsFixed(2)}kg) alors que ton objectif est de gagner. '
          'Veux-tu continuer ?',
          requiresConfirmation: true,
        );
      }

      // Si on s'éloigne beaucoup de l'objectif
      final currentProgress = (newWeight - goal.initialWeight) / 
                             (goal.targetWeight - goal.initialWeight);
      if (currentProgress < -0.2) {
        // On est à plus de 20% en dessous du point de départ
        return ValidationResult.warning(
          'Tu t\'éloignes significativement de ton objectif. Vérifie que c\'est correct.',
          requiresConfirmation: true,
        );
      }
    }

    // Cas 5: Détecter les valeurs aberrantes par rapport à la tendance
    if (history.length >= 3) {
      final recentWeights = history
          .sublist(history.length - 3)
          .map((e) => e.weight)
          .toList();
      
      final average = recentWeights.reduce((a, b) => a + b) / recentWeights.length;
      final stdDev = _calculateStdDev(recentWeights, average);
      
      // Si le nouveau poids est à plus de 2 écarts-types de la moyenne
      if ((newWeight - average).abs() > 2 * stdDev && stdDev > 0.5) {
        return ValidationResult.warning(
          'Ce poids semble inhabituel par rapport à tes dernières pesées. '
          'Est-ce correct ?',
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
    // Validation basique
    final basicResult = validateBasic(entry.weight);
    if (!basicResult.isValid) {
      return basicResult;
    }

    // Validation contextuelle
    return validateContextual(entry.weight, history, goal);
  }
}
