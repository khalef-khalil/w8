import 'package:flutter/material.dart';

/// User preferences for personalization
class UserPreferences {
  final ThemeMode themeMode;
  final MotivationType? motivationType;
  final bool showStreakCard;
  final bool showProgressCard;
  final bool showChartCard;
  final bool showInsightsCard;
  final bool showPatternInsights;

  const UserPreferences({
    this.themeMode = ThemeMode.system,
    this.motivationType,
    this.showStreakCard = true,
    this.showProgressCard = true,
    this.showChartCard = true,
    this.showInsightsCard = true,
    this.showPatternInsights = true,
  });

  UserPreferences copyWith({
    ThemeMode? themeMode,
    MotivationType? motivationType,
    bool? showStreakCard,
    bool? showProgressCard,
    bool? showChartCard,
    bool? showInsightsCard,
    bool? showPatternInsights,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      motivationType: motivationType ?? this.motivationType,
      showStreakCard: showStreakCard ?? this.showStreakCard,
      showProgressCard: showProgressCard ?? this.showProgressCard,
      showChartCard: showChartCard ?? this.showChartCard,
      showInsightsCard: showInsightsCard ?? this.showInsightsCard,
      showPatternInsights: showPatternInsights ?? this.showPatternInsights,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.name,
      'motivationType': motivationType?.name,
      'showStreakCard': showStreakCard,
      'showProgressCard': showProgressCard,
      'showChartCard': showChartCard,
      'showInsightsCard': showInsightsCard,
      'showPatternInsights': showPatternInsights,
    };
  }

  /// Create from map
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      themeMode: _parseThemeMode(map['themeMode']),
      motivationType: map['motivationType'] != null
          ? MotivationType.values.firstWhere(
              (e) => e.name == map['motivationType'],
              orElse: () => MotivationType.progress,
            )
          : null,
      showStreakCard: map['showStreakCard'] as bool? ?? true,
      showProgressCard: map['showProgressCard'] as bool? ?? true,
      showChartCard: map['showChartCard'] as bool? ?? true,
      showInsightsCard: map['showInsightsCard'] as bool? ?? true,
      showPatternInsights: map['showPatternInsights'] as bool? ?? true,
    );
  }

  static ThemeMode _parseThemeMode(dynamic value) {
    if (value == null) return ThemeMode.system;
    final str = value.toString();
    switch (str) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}

/// Types of motivation for users
enum MotivationType {
  progress, // Focus on progress toward goal
  streaks, // Focus on consistency and streaks
  data, // Focus on analytics and insights
  balanced, // Balanced view of all metrics
}

