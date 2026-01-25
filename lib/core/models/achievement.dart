import 'package:hive/hive.dart';

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
  static String getTitle(AchievementType type) {
    switch (type) {
      case AchievementType.firstEntry:
        return 'Journey Started';
      case AchievementType.streak7Days:
        return 'Week Warrior';
      case AchievementType.streak30Days:
        return 'Monthly Master';
      case AchievementType.streak100Days:
        return 'Century Champion';
      case AchievementType.progress25Percent:
        return 'Quarter Complete';
      case AchievementType.progress50Percent:
        return 'Halfway Hero';
      case AchievementType.progress75Percent:
        return 'Almost There';
      case AchievementType.goalReached:
        return 'Goal Achieved';
      case AchievementType.consistency10Days:
        return '10 Day Tracker';
      case AchievementType.consistency30Days:
        return '30 Day Tracker';
      case AchievementType.consistency100Days:
        return '100 Day Tracker';
    }
  }

  /// Get achievement description
  static String getDescription(AchievementType type) {
    switch (type) {
      case AchievementType.firstEntry:
        return 'You\'ve started your weight tracking journey!';
      case AchievementType.streak7Days:
        return 'Tracked your weight for 7 days in a row!';
      case AchievementType.streak30Days:
        return 'Tracked your weight for 30 days in a row!';
      case AchievementType.streak100Days:
        return 'Tracked your weight for 100 days in a row!';
      case AchievementType.progress25Percent:
        return 'You\'re 25% of the way to your goal!';
      case AchievementType.progress50Percent:
        return 'You\'re halfway to your goal!';
      case AchievementType.progress75Percent:
        return 'You\'re 75% of the way to your goal!';
      case AchievementType.goalReached:
        return 'Congratulations! You\'ve reached your goal!';
      case AchievementType.consistency10Days:
        return 'Tracked your weight for 10 days total!';
      case AchievementType.consistency30Days:
        return 'Tracked your weight for 30 days total!';
      case AchievementType.consistency100Days:
        return 'Tracked your weight for 100 days total!';
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
