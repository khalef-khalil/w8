/// Represents a pattern insight discovered from data analysis
class PatternInsight {
  final String title;
  final String description;
  final String? suggestion;
  final double confidence; // 0.0 to 1.0
  final PatternType type;

  const PatternInsight({
    required this.title,
    required this.description,
    this.suggestion,
    required this.confidence,
    required this.type,
  });
}

/// Types of patterns that can be detected
enum PatternType {
  sleepCorrelation,
  stressCorrelation,
  exerciseCorrelation,
  mealTimingCorrelation,
  weeklyPattern,
  trendPattern,
}

/// Result of pattern analysis
class PatternAnalysisResult {
  final List<PatternInsight> insights;
  final bool hasEnoughData;

  const PatternAnalysisResult({
    required this.insights,
    required this.hasEnoughData,
  });

  factory PatternAnalysisResult.empty() {
    return const PatternAnalysisResult(
      insights: [],
      hasEnoughData: false,
    );
  }
}
