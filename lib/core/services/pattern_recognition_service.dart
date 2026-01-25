import '../../models/weight_entry.dart';
import '../models/pattern_insight.dart';
import '../../l10n/app_localizations.dart';

/// Service for analyzing patterns and correlations in weight data
class PatternRecognitionService {
  /// Minimum number of entries with context needed for pattern analysis
  static const int minEntriesForAnalysis = 7;

  /// Analyze patterns in weight entries with context
  static PatternAnalysisResult analyzePatterns(List<WeightEntry> entries, AppLocalizations l10n) {
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
    final sleepInsight = _analyzeSleepCorrelation(entriesWithContext, l10n);
    if (sleepInsight != null) {
      insights.add(sleepInsight);
    }

    // Analyze stress correlation
    final stressInsight = _analyzeStressCorrelation(entriesWithContext, l10n);
    if (stressInsight != null) {
      insights.add(stressInsight);
    }

    // Analyze exercise correlation
    final exerciseInsight = _analyzeExerciseCorrelation(entriesWithContext, l10n);
    if (exerciseInsight != null) {
      insights.add(exerciseInsight);
    }

    // Analyze meal timing correlation
    final mealInsight = _analyzeMealTimingCorrelation(entriesWithContext, l10n);
    if (mealInsight != null) {
      insights.add(mealInsight);
    }

    return PatternAnalysisResult(
      insights: insights,
      hasEnoughData: true,
    );
  }

  /// Analyze correlation between sleep quality and weight change
  static PatternInsight? _analyzeSleepCorrelation(List<WeightEntry> entries, AppLocalizations l10n) {
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

    final action = bestSleep.value < 0 ? l10n.patternLose : l10n.patternGain;
    final quality = bestSleep.key >= 4 ? l10n.patternSleepWell : l10n.patternSleepPoorly;
    final changeStr = worstSleep.value.toStringAsFixed(2);

    return PatternInsight(
      title: l10n.patternSleepQualityImpact,
      description: isPositive
          ? l10n.patternSleepQualityDescription(action, quality, bestSleep.key, worstSleep.key, changeStr)
          : l10n.patternSleepQualitySimilar,
      suggestion: bestSleep.key >= 4
          ? l10n.patternSleepQualitySuggestionGood(bestSleep.key)
          : l10n.patternSleepQualitySuggestionImprove,
      confidence: (difference / 0.5).clamp(0.0, 1.0), // Normalize to 0-1
      type: PatternType.sleepCorrelation,
    );
  }

  /// Analyze correlation between stress level and weight change
  static PatternInsight? _analyzeStressCorrelation(List<WeightEntry> entries, AppLocalizations l10n) {
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

    final level = lowStress.key <= 2 ? l10n.patternStressLow : l10n.patternStressHigh;
    final changeStr = lowStress.value.toStringAsFixed(2);
    final highChangeStr = highStress.value.toStringAsFixed(2);

    return PatternInsight(
      title: l10n.patternStressLevelImpact,
      description: l10n.patternStressLevelDescription(level, lowStress.key, changeStr, highStress.key, highChangeStr),
      suggestion: lowStress.key <= 2
          ? l10n.patternStressLevelSuggestion
          : l10n.patternStressLevelSuggestionFavorable,
      confidence: (difference / 0.5).clamp(0.0, 1.0),
      type: PatternType.stressCorrelation,
    );
  }

  /// Analyze correlation between exercise and weight change
  static PatternInsight? _analyzeExerciseCorrelation(List<WeightEntry> entries, AppLocalizations l10n) {
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

    final withExerciseStr = avgWith.toStringAsFixed(2);
    final withoutExerciseStr = avgWithout.toStringAsFixed(2);

    return PatternInsight(
      title: l10n.patternExerciseImpact,
      description: avgWith < avgWithout
          ? l10n.patternExerciseDescription(withExerciseStr, withoutExerciseStr)
          : l10n.patternExerciseDescriptionAlt(withExerciseStr, withoutExerciseStr),
      suggestion: avgWith < avgWithout
          ? l10n.patternExerciseSuggestion
          : l10n.patternExerciseSuggestionConsistent,
      confidence: (difference / 0.3).clamp(0.0, 1.0),
      type: PatternType.exerciseCorrelation,
    );
  }

  /// Analyze correlation between meal timing and weight change
  static PatternInsight? _analyzeMealTimingCorrelation(List<WeightEntry> entries, AppLocalizations l10n) {
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

    final timingLabel = _getMealTimingLabel(bestTiming.key, l10n);
    final changeStr = bestTiming.value.toStringAsFixed(2);

    return PatternInsight(
      title: l10n.patternMealTimingPattern,
      description: l10n.patternMealTimingDescription(timingLabel, changeStr),
      suggestion: l10n.patternMealTimingSuggestion(timingLabel),
      confidence: (difference / 0.3).clamp(0.0, 1.0),
      type: PatternType.mealTimingCorrelation,
    );
  }

  static String _getMealTimingLabel(String timing, AppLocalizations l10n) {
    switch (timing) {
      case 'before_breakfast':
        return l10n.beforeBreakfast;
      case 'after_breakfast':
        return l10n.afterBreakfast;
      case 'before_lunch':
        return l10n.beforeLunch;
      case 'after_lunch':
        return l10n.afterLunch;
      case 'before_dinner':
        return l10n.beforeDinner;
      case 'after_dinner':
        return l10n.afterDinner;
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
