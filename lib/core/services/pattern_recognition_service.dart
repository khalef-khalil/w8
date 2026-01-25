import '../../models/weight_entry.dart';
import '../models/pattern_insight.dart';

/// Service for analyzing patterns and correlations in weight data
class PatternRecognitionService {
  /// Minimum number of entries with context needed for pattern analysis
  static const int minEntriesForAnalysis = 7;

  /// Analyze patterns in weight entries with context
  static PatternAnalysisResult analyzePatterns(List<WeightEntry> entries) {
    if (entries.length < minEntriesForAnalysis) {
      return PatternAnalysisResult.empty();
    }

    // Filter entries with context tags
    final entriesWithContext = entries
        .where((e) => e.tags != null && !e.tags!.isEmpty)
        .toList();

    if (entriesWithContext.length < minEntriesForAnalysis) {
      return PatternAnalysisResult.empty();
    }

    final insights = <PatternInsight>[];

    // Analyze sleep quality correlation
    final sleepInsight = _analyzeSleepCorrelation(entriesWithContext);
    if (sleepInsight != null) {
      insights.add(sleepInsight);
    }

    // Analyze stress correlation
    final stressInsight = _analyzeStressCorrelation(entriesWithContext);
    if (stressInsight != null) {
      insights.add(stressInsight);
    }

    // Analyze exercise correlation
    final exerciseInsight = _analyzeExerciseCorrelation(entriesWithContext);
    if (exerciseInsight != null) {
      insights.add(exerciseInsight);
    }

    // Analyze meal timing correlation
    final mealInsight = _analyzeMealTimingCorrelation(entriesWithContext);
    if (mealInsight != null) {
      insights.add(mealInsight);
    }

    return PatternAnalysisResult(
      insights: insights,
      hasEnoughData: true,
    );
  }

  /// Analyze correlation between sleep quality and weight change
  static PatternInsight? _analyzeSleepCorrelation(List<WeightEntry> entries) {
    // Group entries by sleep quality
    final sleepGroups = <int, List<_WeightChange>>{};
    
    for (var i = 1; i < entries.length; i++) {
      final current = entries[i];
      final previous = entries[i - 1];
      final tags = current.tags;
      
      if (tags?.sleepQuality != null) {
        final change = current.weight - previous.weight;
        final daysDiff = current.date.difference(previous.date).inDays;
        final changePerDay = daysDiff > 0 ? change / daysDiff : change;
        
        sleepGroups.putIfAbsent(tags!.sleepQuality!, () => []).add(
          _WeightChange(change: changePerDay, daysDiff: daysDiff),
        );
      }
    }

    if (sleepGroups.length < 2) return null;

    // Calculate average change per day for each sleep quality level
    final averages = <int, double>{};
    for (final entry in sleepGroups.entries) {
      final avg = entry.value
          .map((wc) => wc.change)
          .reduce((a, b) => a + b) / entry.value.length;
      averages[entry.key] = avg;
    }

    // Find best and worst sleep quality
    final sorted = averages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    if (sorted.length < 2) return null;

    final worstSleep = sorted.first;
    final bestSleep = sorted.last;
    final difference = (bestSleep.value - worstSleep.value).abs();

    // Only report if difference is significant (more than 0.1 kg/day)
    if (difference < 0.1) return null;

    final isPositive = bestSleep.value < worstSleep.value; // Negative change is good for weight loss

    return PatternInsight(
      title: 'Sleep Quality Impact',
      description: isPositive
          ? 'You tend to ${bestSleep.value < 0 ? "lose" : "gain"} more weight when you sleep ${bestSleep.key >= 4 ? "well" : "poorly"} (${bestSleep.key}/5). '
              'When sleep quality is ${worstSleep.key}/5, your weight changes by ${worstSleep.value.toStringAsFixed(2)} kg/day on average.'
          : 'Your weight changes are similar regardless of sleep quality.',
      suggestion: bestSleep.key >= 4
          ? 'Try to maintain good sleep habits (${bestSleep.key}/5) for better weight management.'
          : 'Consider improving your sleep quality - it may help with your weight goals.',
      confidence: (difference / 0.5).clamp(0.0, 1.0), // Normalize to 0-1
      type: PatternType.sleepCorrelation,
    );
  }

  /// Analyze correlation between stress level and weight change
  static PatternInsight? _analyzeStressCorrelation(List<WeightEntry> entries) {
    final stressGroups = <int, List<_WeightChange>>{};
    
    for (var i = 1; i < entries.length; i++) {
      final current = entries[i];
      final previous = entries[i - 1];
      final tags = current.tags;
      
      if (tags?.stressLevel != null) {
        final change = current.weight - previous.weight;
        final daysDiff = current.date.difference(previous.date).inDays;
        final changePerDay = daysDiff > 0 ? change / daysDiff : change;
        
        stressGroups.putIfAbsent(tags!.stressLevel!, () => []).add(
          _WeightChange(change: changePerDay, daysDiff: daysDiff),
        );
      }
    }

    if (stressGroups.length < 2) return null;

    final averages = <int, double>{};
    for (final entry in stressGroups.entries) {
      final avg = entry.value
          .map((wc) => wc.change)
          .reduce((a, b) => a + b) / entry.value.length;
      averages[entry.key] = avg;
    }

    final sorted = averages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    if (sorted.length < 2) return null;

    final lowStress = sorted.first;
    final highStress = sorted.last;
    final difference = (highStress.value - lowStress.value).abs();

    if (difference < 0.1) return null;

    return PatternInsight(
      title: 'Stress Level Impact',
      description: 'When stress is ${lowStress.key <= 2 ? "low" : "high"} (${lowStress.key}/5), '
          'your weight changes by ${lowStress.value.toStringAsFixed(2)} kg/day on average. '
          'Higher stress (${highStress.key}/5) shows ${highStress.value.toStringAsFixed(2)} kg/day.',
      suggestion: lowStress.key <= 2
          ? 'Managing stress levels may help with your weight goals.'
          : 'Your weight changes are more favorable when stress is lower.',
      confidence: (difference / 0.5).clamp(0.0, 1.0),
      type: PatternType.stressCorrelation,
    );
  }

  /// Analyze correlation between exercise and weight change
  static PatternInsight? _analyzeExerciseCorrelation(List<WeightEntry> entries) {
    final exerciseGroups = <bool, List<_WeightChange>>{};
    
    for (var i = 1; i < entries.length; i++) {
      final current = entries[i];
      final previous = entries[i - 1];
      final tags = current.tags;
      
      if (tags?.exercised != null) {
        final change = current.weight - previous.weight;
        final daysDiff = current.date.difference(previous.date).inDays;
        final changePerDay = daysDiff > 0 ? change / daysDiff : change;
        
        exerciseGroups.putIfAbsent(tags!.exercised!, () => []).add(
          _WeightChange(change: changePerDay, daysDiff: daysDiff),
        );
      }
    }

    if (exerciseGroups.length < 2) return null;

    final withExercise = exerciseGroups[true];
    final withoutExercise = exerciseGroups[false];

    if (withExercise == null || withoutExercise == null) return null;

    final avgWith = withExercise
        .map((wc) => wc.change)
        .reduce((a, b) => a + b) / withExercise.length;
    final avgWithout = withoutExercise
        .map((wc) => wc.change)
        .reduce((a, b) => a + b) / withoutExercise.length;

    final difference = (avgWith - avgWithout).abs();

    if (difference < 0.1) return null;

    return PatternInsight(
      title: 'Exercise Impact',
      description: avgWith < avgWithout
          ? 'On days you exercise, your weight changes by ${avgWith.toStringAsFixed(2)} kg/day on average, '
              'compared to ${avgWithout.toStringAsFixed(2)} kg/day when you don\'t exercise.'
          : 'Exercise days show ${avgWith.toStringAsFixed(2)} kg/day change vs ${avgWithout.toStringAsFixed(2)} kg/day on rest days.',
      suggestion: avgWith < avgWithout
          ? 'Keep up the exercise! It appears to be helping with your weight goals.'
          : 'Consider maintaining a consistent exercise routine.',
      confidence: (difference / 0.3).clamp(0.0, 1.0),
      type: PatternType.exerciseCorrelation,
    );
  }

  /// Analyze correlation between meal timing and weight change
  static PatternInsight? _analyzeMealTimingCorrelation(List<WeightEntry> entries) {
    final mealGroups = <String, List<_WeightChange>>{};
    
    for (var i = 1; i < entries.length; i++) {
      final current = entries[i];
      final previous = entries[i - 1];
      final tags = current.tags;
      
      if (tags?.mealTiming != null) {
        final change = current.weight - previous.weight;
        final daysDiff = current.date.difference(previous.date).inDays;
        final changePerDay = daysDiff > 0 ? change / daysDiff : change;
        
        mealGroups.putIfAbsent(tags!.mealTiming!, () => []).add(
          _WeightChange(change: changePerDay, daysDiff: daysDiff),
        );
      }
    }

    if (mealGroups.length < 2) return null;

    final averages = <String, double>{};
    for (final entry in mealGroups.entries) {
      final avg = entry.value
          .map((wc) => wc.change)
          .reduce((a, b) => a + b) / entry.value.length;
      averages[entry.key] = avg;
    }

    final sorted = averages.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    if (sorted.length < 2) return null;

    final bestTiming = sorted.first;
    final worstTiming = sorted.last;
    final difference = (bestTiming.value - worstTiming.value).abs();

    if (difference < 0.1) return null;

    final timingLabel = _getMealTimingLabel(bestTiming.key);

    return PatternInsight(
      title: 'Meal Timing Pattern',
      description: 'Your weight changes are most favorable when weighing ${timingLabel}. '
          'Average change: ${bestTiming.value.toStringAsFixed(2)} kg/day.',
      suggestion: 'Try to weigh yourself at consistent times (${timingLabel}) for more accurate tracking.',
      confidence: (difference / 0.3).clamp(0.0, 1.0),
      type: PatternType.mealTimingCorrelation,
    );
  }

  static String _getMealTimingLabel(String timing) {
    switch (timing) {
      case 'before_breakfast':
        return 'before breakfast';
      case 'after_breakfast':
        return 'after breakfast';
      case 'before_lunch':
        return 'before lunch';
      case 'after_lunch':
        return 'after lunch';
      case 'before_dinner':
        return 'before dinner';
      case 'after_dinner':
        return 'after dinner';
      default:
        return timing;
    }
  }
}

/// Helper class for weight change calculations
class _WeightChange {
  final double change;
  final int daysDiff;

  _WeightChange({required this.change, required this.daysDiff});
}
