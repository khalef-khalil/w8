import 'package:hive_flutter/hive_flutter.dart';
import '../../models/weight_entry.dart';
import '../models/achievement.dart';
import '../models/progress_metrics.dart';
import '../models/goal_configuration.dart';
import '../../l10n/app_localizations.dart';
import 'streak_service.dart';

/// Service for managing user achievements
class AchievementService {
  static const String _boxName = 'achievements';

  /// Initialize achievements storage
  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(AchievementTypeAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(AchievementAdapter());
    }
    await Hive.openBox<Achievement>(_boxName);
  }

  /// Get all unlocked achievements
  static List<Achievement> getUnlockedAchievements() {
    try {
      final box = Hive.box<Achievement>(_boxName);
      return box.values.toList()
        ..sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
    } catch (e) {
      return [];
    }
  }

  /// Check if an achievement is unlocked
  static bool isUnlocked(AchievementType type) {
    try {
      final box = Hive.box<Achievement>(_boxName);
      return box.values.any((a) => a.type == type);
    } catch (e) {
      return false;
    }
  }

  /// Unlock an achievement
  static Future<Achievement?> unlockAchievement(AchievementType type, AppLocalizations l10n) async {
    // Check if already unlocked
    if (isUnlocked(type)) {
      return null;
    }

    try {
      final box = Hive.box<Achievement>(_boxName);
      final achievement = Achievement(
        type: type,
        unlockedAt: DateTime.now(),
        title: Achievement.getTitle(type, l10n),
        description: Achievement.getDescription(type, l10n),
        icon: Achievement.getIcon(type),
      );

      await box.put(type.toString(), achievement);
      return achievement;
    } catch (e) {
      return null;
    }
  }

  /// Check for new achievements based on current state
  static Future<List<Achievement>> checkAchievements({
    required List<WeightEntry> entries,
    required ProgressMetrics? metrics,
    required GoalConfiguration? goalConfig,
    required AppLocalizations l10n,
  }) async {
    final newAchievements = <Achievement>[];

    if (entries.isEmpty) {
      return newAchievements;
    }

    // Check streak achievements
    final currentStreak = StreakService.calculateCurrentStreak(entries);
    if (currentStreak >= 7 && !isUnlocked(AchievementType.streak7Days)) {
      final achievement = await unlockAchievement(AchievementType.streak7Days, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }
    if (currentStreak >= 30 && !isUnlocked(AchievementType.streak30Days)) {
      final achievement = await unlockAchievement(AchievementType.streak30Days, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }
    if (currentStreak >= 100 && !isUnlocked(AchievementType.streak100Days)) {
      final achievement = await unlockAchievement(AchievementType.streak100Days, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }

    // Check consistency achievements (total days tracked)
    final totalDays = StreakService.totalDaysTracked(entries);
    if (totalDays >= 10 && !isUnlocked(AchievementType.consistency10Days)) {
      final achievement = await unlockAchievement(AchievementType.consistency10Days, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalDays >= 30 && !isUnlocked(AchievementType.consistency30Days)) {
      final achievement = await unlockAchievement(AchievementType.consistency30Days, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }
    if (totalDays >= 100 && !isUnlocked(AchievementType.consistency100Days)) {
      final achievement = await unlockAchievement(AchievementType.consistency100Days, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }

    // Check first entry achievement (unlock when user has at least one entry)
    if (entries.isNotEmpty && !isUnlocked(AchievementType.firstEntry)) {
      final achievement = await unlockAchievement(AchievementType.firstEntry, l10n);
      if (achievement != null) newAchievements.add(achievement);
    }

    // Check progress achievements (only if we have a goal)
    if (goalConfig != null && metrics != null) {
      final currentWeight = entries.isNotEmpty ? entries.last.weight : null;
      if (currentWeight != null) {
        final totalChange = goalConfig.targetWeight - goalConfig.initialWeight;
        final currentChange = currentWeight - goalConfig.initialWeight;
        final progress = totalChange != 0
            ? (currentChange / totalChange).clamp(0.0, 1.0)
            : 0.0;

        if (progress >= 0.25 && !isUnlocked(AchievementType.progress25Percent)) {
          final achievement = await unlockAchievement(AchievementType.progress25Percent, l10n);
          if (achievement != null) newAchievements.add(achievement);
        }
        if (progress >= 0.50 && !isUnlocked(AchievementType.progress50Percent)) {
          final achievement = await unlockAchievement(AchievementType.progress50Percent, l10n);
          if (achievement != null) newAchievements.add(achievement);
        }
        if (progress >= 0.75 && !isUnlocked(AchievementType.progress75Percent)) {
          final achievement = await unlockAchievement(AchievementType.progress75Percent, l10n);
          if (achievement != null) newAchievements.add(achievement);
        }
        if (progress >= 1.0 && !isUnlocked(AchievementType.goalReached)) {
          final achievement = await unlockAchievement(AchievementType.goalReached, l10n);
          if (achievement != null) newAchievements.add(achievement);
        }
      }
    }

    return newAchievements;
  }

  /// Get achievement progress (for locked achievements)
  static double getAchievementProgress(
    AchievementType type,
    List<WeightEntry> entries,
    ProgressMetrics? metrics,
    GoalConfiguration? goalConfig,
  ) {
    if (isUnlocked(type)) return 1.0;

    switch (type) {
      case AchievementType.streak7Days:
      case AchievementType.streak30Days:
      case AchievementType.streak100Days:
        final currentStreak = StreakService.calculateCurrentStreak(entries);
        final target = type == AchievementType.streak7Days
            ? 7
            : (type == AchievementType.streak30Days ? 30 : 100);
        return (currentStreak / target).clamp(0.0, 1.0);

      case AchievementType.consistency10Days:
      case AchievementType.consistency30Days:
      case AchievementType.consistency100Days:
        final totalDays = StreakService.totalDaysTracked(entries);
        final target = type == AchievementType.consistency10Days
            ? 10
            : (type == AchievementType.consistency30Days ? 30 : 100);
        return (totalDays / target).clamp(0.0, 1.0);

      case AchievementType.progress25Percent:
      case AchievementType.progress50Percent:
      case AchievementType.progress75Percent:
      case AchievementType.goalReached:
        if (goalConfig == null || metrics == null || entries.isEmpty) {
          return 0.0;
        }
        final currentWeight = entries.last.weight;
        final totalChange = goalConfig.targetWeight - goalConfig.initialWeight;
        final currentChange = currentWeight - goalConfig.initialWeight;
        final progress = totalChange != 0
            ? (currentChange / totalChange).clamp(0.0, 1.0)
            : 0.0;
        final target = type == AchievementType.progress25Percent
            ? 0.25
            : (type == AchievementType.progress50Percent
                ? 0.50
                : (type == AchievementType.progress75Percent ? 0.75 : 1.0));
        return (progress / target).clamp(0.0, 1.0);

      case AchievementType.firstEntry:
        return entries.isNotEmpty ? 1.0 : 0.0;
    }
  }
}
