/// Modèle représentant les données de progression
class ProgressData {
  final double? currentWeight;
  final double? initialWeight;
  final double? targetWeight;
  final double weightGained;
  final double progress; // 0.0 à 1.0
  final int weeksElapsed;
  final int totalWeeks;
  /// When non-null, current weight is from a 7-day rolling median over this range (for "which dates" UI).
  final DateTime? currentWeightPeriodStart;
  final DateTime? currentWeightPeriodEnd;

  ProgressData({
    this.currentWeight,
    this.initialWeight,
    this.targetWeight,
    required this.weightGained,
    required this.progress,
    required this.weeksElapsed,
    required this.totalWeeks,
    this.currentWeightPeriodStart,
    this.currentWeightPeriodEnd,
  });

  /// Créer un ProgressData vide
  factory ProgressData.empty() {
    return ProgressData(
      weightGained: 0.0,
      progress: 0.0,
      weeksElapsed: 0,
      totalWeeks: 24,
    );
  }
}
