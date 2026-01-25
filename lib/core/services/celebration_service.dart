import '../../models/weight_entry.dart';
import '../models/progress_metrics.dart';
import '../models/goal_configuration.dart';
import 'streak_service.dart';
import '../../l10n/app_localizations.dart';

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
  static String getCelebrationMessage(CelebrationType type, AppLocalizations l10n) {
    switch (type) {
      case CelebrationType.firstEntry:
        return l10n.celebrationJourneyStartedMessage;
      case CelebrationType.streak7Days:
        return l10n.celebration7DayStreakMessage;
      case CelebrationType.streak30Days:
        return l10n.celebration30DayStreakMessage;
      case CelebrationType.streak100Days:
        return l10n.celebration100DayStreakMessage;
      case CelebrationType.progress25Percent:
        return l10n.celebration25PercentMessage;
      case CelebrationType.progress50Percent:
        return l10n.celebration50PercentMessage;
      case CelebrationType.progress75Percent:
        return l10n.celebration75PercentMessage;
      case CelebrationType.goalReached:
        return l10n.celebrationGoalReachedMessage;
    }
  }

  /// Get celebration title for a celebration type
  static String getCelebrationTitle(CelebrationType type, AppLocalizations l10n) {
    switch (type) {
      case CelebrationType.firstEntry:
        return l10n.celebrationJourneyStarted;
      case CelebrationType.streak7Days:
        return l10n.celebration7DayStreak;
      case CelebrationType.streak30Days:
        return l10n.celebration30DayStreak;
      case CelebrationType.streak100Days:
        return l10n.celebration100DayStreak;
      case CelebrationType.progress25Percent:
        return l10n.celebration25Percent;
      case CelebrationType.progress50Percent:
        return l10n.celebration50Percent;
      case CelebrationType.progress75Percent:
        return l10n.celebration75Percent;
      case CelebrationType.goalReached:
        return l10n.celebrationGoalReached;
    }
  }
}
