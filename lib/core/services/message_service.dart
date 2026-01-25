import '../models/validation_result.dart';
import '../models/goal_configuration.dart';
import '../utils/weight_converter.dart';

/// Service pour générer des messages utilisateur-friendly et encourageants
class MessageService {
  /// Convertir un message de validation technique en message encourageant
  static String makeSupportive(String technicalMessage, {
    WeightUnit? unit,
  }) {
    // Messages de base
    if (technicalMessage.contains('doit être supérieur à 0')) {
      return 'Please enter a weight greater than 0';
    }
    
    if (technicalMessage.contains('doit être inférieur')) {
      final max = unit == WeightUnit.lbs ? '1100 lbs' : '500 kg';
      return 'Please enter a weight less than $max';
    }

    // Messages de changement
    if (technicalMessage.contains('Changement trop important')) {
      return 'This weight change seems unusually large. Please double-check your entry.';
    }

    if (technicalMessage.contains('Changement important détecté')) {
      return 'This is a significant change from your last entry. Is everything okay? You can still save it.';
    }

    if (technicalMessage.contains('très différent')) {
      return 'This weight is quite different from your initial weight. Is this correct?';
    }

    // Messages d'objectif
    if (technicalMessage.contains('prendre du poids') && 
        technicalMessage.contains('perdre')) {
      return 'You\'re gaining weight while your goal is to lose. That\'s okay—setbacks happen. Do you want to continue?';
    }

    if (technicalMessage.contains('perdre du poids') && 
        technicalMessage.contains('gagner')) {
      return 'You\'re losing weight while your goal is to gain. That\'s okay—setbacks happen. Do you want to continue?';
    }

    if (technicalMessage.contains('s\'éloignes significativement')) {
      return 'You\'re moving away from your goal. This might be normal (fluctuations, life events). Is this correct?';
    }

    if (technicalMessage.contains('semble inhabituel')) {
      return 'This weight seems unusual compared to your recent entries. Is everything okay?';
    }

    // Par défaut, retourner le message original
    return technicalMessage;
  }

  /// Générer un message encourageant pour le statut
  static String getStatusMessage({
    required bool isOnTrack,
    required bool isAhead,
    required bool isBehind,
    int? daysAhead,
    int? daysBehind,
  }) {
    if (isOnTrack) {
      return 'You\'re right on track! Keep up the great work!';
    } else if (isAhead && daysAhead != null) {
      return 'You\'re ahead of schedule! ${daysAhead > 0 ? '$daysAhead days ahead' : 'Great progress!'}';
    } else if (isBehind && daysBehind != null) {
      return 'You\'re making progress! A bit slower than planned, but you\'re still moving toward your goal.';
    } else if (isAhead) {
      return 'You\'re ahead of schedule! Great job!';
    } else if (isBehind) {
      return 'You\'re making progress! Keep going!';
    }
    return 'Keep tracking to see your progress!';
  }

  /// Générer un message pour la prédiction
  static String getPredictionMessage({
    required DateTime predictedDate,
    required DateTime goalEndDate,
  }) {
    final daysDiff = predictedDate.difference(goalEndDate).inDays;
    
    if (daysDiff.abs() <= 7) {
      return 'You\'re on track to reach your goal around the planned date!';
    } else if (daysDiff > 0) {
      return 'At your current rate, you\'ll reach your goal about ${daysDiff} days after your target date. That\'s okay—progress is progress!';
    } else {
      return 'At your current rate, you\'ll reach your goal about ${daysDiff.abs()} days before your target date. Great job!';
    }
  }

  /// Générer un message pour les streaks
  static String getStreakMessage(int currentStreak) {
    if (currentStreak == 0) {
      return 'Start tracking to build your streak!';
    } else if (currentStreak == 1) {
      return 'Great start! Keep it going!';
    } else if (currentStreak < 7) {
      return '$currentStreak days in a row! You\'re building a great habit!';
    } else if (currentStreak < 30) {
      return '$currentStreak days in a row! You\'re doing amazing!';
    } else if (currentStreak < 100) {
      return '$currentStreak days in a row! This is incredible!';
    } else {
      return '$currentStreak days in a row! You\'re a tracking champion!';
    }
  }

  /// Générer un message pour les célébrations
  static String getCelebrationMessage(String achievement) {
    switch (achievement) {
      case 'first_entry':
        return 'Great! You\'ve started your journey!';
      case '7_day_streak':
        return '🎉 7 days in a row! You\'re building an amazing habit!';
      case '30_day_streak':
        return '🎉 30 days! You\'re a tracking superstar!';
      case '100_day_streak':
        return '🎉 100 days! This is incredible dedication!';
      case '25_percent':
        return '🎉 You\'re 25% there! Keep going!';
      case '50_percent':
        return '🎉 Halfway there! You\'re doing amazing!';
      case '75_percent':
        return '🎉 75% complete! You\'re almost there!';
      case 'goal_reached':
        return '🎉 Congratulations! You\'ve reached your goal!';
      default:
        return 'Great progress!';
    }
  }
}
