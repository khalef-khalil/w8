import '../../models/weight_entry.dart';
import '../models/progress_metrics.dart';
import '../models/goal_configuration.dart';
import 'streak_service.dart';

/// Types of celebrations that can be triggered
enum CelebrationType {
  firstEntry,
  streak7Days,
  streak30Days,
  streak100Days,
  progress25Percent,
  progress50Percent,
  progress75Percent,
  goalReached,
}

/// Service to detect and trigger celebrations
class CelebrationService {
  /// Check if a new entry triggers any celebrations
  static List<CelebrationType> checkCelebrations({
    required List<WeightEntry> entries,
    required ProgressMetrics? metrics,
    required GoalConfiguration? goalConfig,
  }) {
    final celebrations = <CelebrationType>[];

    if (entries.isEmpty) {
      return celebrations;
    }

    // First entry celebration
    if (entries.length == 1) {
      celebrations.add(CelebrationType.firstEntry);
    }

    // Streak celebrations
    final currentStreak = StreakService.calculateCurrentStreak(entries);
    if (currentStreak == 7) {
      celebrations.add(CelebrationType.streak7Days);
    } else if (currentStreak == 30) {
      celebrations.add(CelebrationType.streak30Days);
    } else if (currentStreak == 100) {
      celebrations.add(CelebrationType.streak100Days);
    }

    // Progress celebrations (only if we have a goal)
    if (goalConfig != null && metrics != null) {
      // Calculate progress from goal
      final currentWeight = entries.isNotEmpty ? entries.last.weight : null;
      if (currentWeight == null) return celebrations;
      
      final totalChange = goalConfig.targetWeight - goalConfig.initialWeight;
      final currentChange = currentWeight - goalConfig.initialWeight;
      final progress = totalChange != 0 ? (currentChange / totalChange).clamp(0.0, 1.0) : 0.0;
      
      // Check for milestone achievements (only trigger once per milestone)
      // We check if we're at or just passed a milestone
      if (progress >= 0.25 && progress < 0.30) {
        celebrations.add(CelebrationType.progress25Percent);
      } else if (progress >= 0.50 && progress < 0.55) {
        celebrations.add(CelebrationType.progress50Percent);
      } else if (progress >= 0.75 && progress < 0.80) {
        celebrations.add(CelebrationType.progress75Percent);
      } else if (progress >= 1.0) {
        celebrations.add(CelebrationType.goalReached);
      }
    }

    return celebrations;
  }

  /// Get celebration message for a celebration type
  static String getCelebrationMessage(CelebrationType type) {
    switch (type) {
      case CelebrationType.firstEntry:
        return 'Great! You\'ve started your journey!';
      case CelebrationType.streak7Days:
        return '🎉 7 days in a row! You\'re building an amazing habit!';
      case CelebrationType.streak30Days:
        return '🎉 30 days! You\'re a tracking superstar!';
      case CelebrationType.streak100Days:
        return '🎉 100 days! This is incredible dedication!';
      case CelebrationType.progress25Percent:
        return '🎉 You\'re 25% there! Keep going!';
      case CelebrationType.progress50Percent:
        return '🎉 Halfway there! You\'re doing amazing!';
      case CelebrationType.progress75Percent:
        return '🎉 75% complete! You\'re almost there!';
      case CelebrationType.goalReached:
        return '🎉 Congratulations! You\'ve reached your goal!';
    }
  }

  /// Get celebration title for a celebration type
  static String getCelebrationTitle(CelebrationType type) {
    switch (type) {
      case CelebrationType.firstEntry:
        return 'Journey Started!';
      case CelebrationType.streak7Days:
        return '7 Day Streak!';
      case CelebrationType.streak30Days:
        return '30 Day Streak!';
      case CelebrationType.streak100Days:
        return '100 Day Streak!';
      case CelebrationType.progress25Percent:
        return '25% Complete!';
      case CelebrationType.progress50Percent:
        return 'Halfway There!';
      case CelebrationType.progress75Percent:
        return '75% Complete!';
      case CelebrationType.goalReached:
        return 'Goal Achieved!';
    }
  }
}
