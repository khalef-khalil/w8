import 'package:hive/hive.dart';
import '../../l10n/app_localizations.dart';

part 'achievement.g.dart';

/// Types of achievements users can unlock
@HiveType(typeId: 2)
enum AchievementType {
  @HiveField(0)
  firstEntry,
  @HiveField(1)
  streak7Days,
  @HiveField(2)
  streak30Days,
  @HiveField(3)
  streak100Days,
  @HiveField(4)
  progress25Percent,
  @HiveField(5)
  progress50Percent,
  @HiveField(6)
  progress75Percent,
  @HiveField(7)
  goalReached,
  @HiveField(8)
  consistency10Days,
  @HiveField(9)
  consistency30Days,
  @HiveField(10)
  consistency100Days,
}

/// Achievement model
@HiveType(typeId: 3)
class Achievement extends HiveObject {
  @HiveField(0)
  final AchievementType type;

  @HiveField(1)
  final DateTime unlockedAt;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String icon;

  Achievement({
    required this.type,
    required this.unlockedAt,
    required this.title,
    required this.description,
    required this.icon,
  });

  /// Get achievement title
  static String getTitle(AchievementType type, AppLocalizations l10n) {
    switch (type) {
      case AchievementType.firstEntry:
        return l10n.achievementJourneyStarted;
      case AchievementType.streak7Days:
        return l10n.achievementWeekWarrior;
      case AchievementType.streak30Days:
        return l10n.achievementMonthlyMaster;
      case AchievementType.streak100Days:
        return l10n.achievementCenturyChampion;
      case AchievementType.progress25Percent:
        return l10n.achievementQuarterComplete;
      case AchievementType.progress50Percent:
        return l10n.achievementHalfwayHero;
      case AchievementType.progress75Percent:
        return l10n.achievementAlmostThere;
      case AchievementType.goalReached:
        return l10n.achievementGoalAchieved;
      case AchievementType.consistency10Days:
        return l10n.achievement10DayTracker;
      case AchievementType.consistency30Days:
        return l10n.achievement30DayTracker;
      case AchievementType.consistency100Days:
        return l10n.achievement100DayTracker;
    }
  }

  /// Get achievement description
  static String getDescription(AchievementType type, AppLocalizations l10n) {
    switch (type) {
      case AchievementType.firstEntry:
        return l10n.achievementJourneyStartedDesc;
      case AchievementType.streak7Days:
        return l10n.achievementWeekWarriorDesc;
      case AchievementType.streak30Days:
        return l10n.achievementMonthlyMasterDesc;
      case AchievementType.streak100Days:
        return l10n.achievementCenturyChampionDesc;
      case AchievementType.progress25Percent:
        return l10n.achievementQuarterCompleteDesc;
      case AchievementType.progress50Percent:
        return l10n.achievementHalfwayHeroDesc;
      case AchievementType.progress75Percent:
        return l10n.achievementAlmostThereDesc;
      case AchievementType.goalReached:
        return l10n.achievementGoalAchievedDesc;
      case AchievementType.consistency10Days:
        return l10n.achievement10DayTrackerDesc;
      case AchievementType.consistency30Days:
        return l10n.achievement30DayTrackerDesc;
      case AchievementType.consistency100Days:
        return l10n.achievement100DayTrackerDesc;
    }
  }

  /// Get achievement icon (Material icon name)
  static String getIcon(AchievementType type) {
    switch (type) {
      case AchievementType.firstEntry:
        return 'flag';
      case AchievementType.streak7Days:
        return 'local_fire_department';
      case AchievementType.streak30Days:
        return 'whatshot';
      case AchievementType.streak100Days:
        return 'emoji_events';
      case AchievementType.progress25Percent:
        return 'looks_one';
      case AchievementType.progress50Percent:
        return 'looks_two';
      case AchievementType.progress75Percent:
        return 'looks_3';
      case AchievementType.goalReached:
        return 'military_tech';
      case AchievementType.consistency10Days:
        return 'check_circle';
      case AchievementType.consistency30Days:
        return 'verified';
      case AchievementType.consistency100Days:
        return 'workspace_premium';
    }
  }
}
