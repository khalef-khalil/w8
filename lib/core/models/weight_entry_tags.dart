/// Tags and context for weight entries
class WeightEntryTags {
  final int? sleepQuality; // 1-5 scale
  final int? stressLevel; // 1-5 scale
  final bool? exercised; // true/false
  final String? mealTiming; // "before_breakfast", "after_breakfast", "before_lunch", "after_lunch", "before_dinner", "after_dinner", "other"
  final String? notes; // Free-form notes

  const WeightEntryTags({
    this.sleepQuality,
    this.stressLevel,
    this.exercised,
    this.mealTiming,
    this.notes,
  });

  /// Create empty tags
  factory WeightEntryTags.empty() {
    return const WeightEntryTags();
  }

  /// Check if tags are empty (no data)
  bool get isEmpty {
    return sleepQuality == null &&
        stressLevel == null &&
        exercised == null &&
        mealTiming == null &&
        (notes == null || notes!.isEmpty);
  }

  /// Create a copy with updated fields
  WeightEntryTags copyWith({
    int? sleepQuality,
    int? stressLevel,
    bool? exercised,
    String? mealTiming,
    String? notes,
  }) {
    return WeightEntryTags(
      sleepQuality: sleepQuality ?? this.sleepQuality,
      stressLevel: stressLevel ?? this.stressLevel,
      exercised: exercised ?? this.exercised,
      mealTiming: mealTiming ?? this.mealTiming,
      notes: notes ?? this.notes,
    );
  }

  /// Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'sleepQuality': sleepQuality,
      'stressLevel': stressLevel,
      'exercised': exercised,
      'mealTiming': mealTiming,
      'notes': notes,
    };
  }

  /// Create from map
  factory WeightEntryTags.fromMap(Map<String, dynamic> map) {
    return WeightEntryTags(
      sleepQuality: map['sleepQuality'] as int?,
      stressLevel: map['stressLevel'] as int?,
      exercised: map['exercised'] as bool?,
      mealTiming: map['mealTiming'] as String?,
      notes: map['notes'] as String?,
    );
  }

  /// Get sleep quality label
  String? get sleepQualityLabel {
    if (sleepQuality == null) return null;
    switch (sleepQuality) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Average';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return null;
    }
  }

  /// Get stress level label
  String? get stressLevelLabel {
    if (stressLevel == null) return null;
    switch (stressLevel) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Moderate';
      case 4:
        return 'High';
      case 5:
        return 'Very High';
      default:
        return null;
    }
  }

  /// Get meal timing label
  String? get mealTimingLabel {
    if (mealTiming == null) return null;
    switch (mealTiming) {
      case 'before_breakfast':
        return 'Before Breakfast';
      case 'after_breakfast':
        return 'After Breakfast';
      case 'before_lunch':
        return 'Before Lunch';
      case 'after_lunch':
        return 'After Lunch';
      case 'before_dinner':
        return 'Before Dinner';
      case 'after_dinner':
        return 'After Dinner';
      case 'other':
        return 'Other';
      default:
        return mealTiming;
    }
  }
}
