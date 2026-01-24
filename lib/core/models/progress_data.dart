/// Modèle représentant les données de progression
class ProgressData {
  final double? currentWeight;
  final double? initialWeight;
  final double? targetWeight;
  final double weightGained;
  final double progress; // 0.0 à 1.0
  final int weeksElapsed;
  final int totalWeeks;

  ProgressData({
    this.currentWeight,
    this.initialWeight,
    this.targetWeight,
    required this.weightGained,
    required this.progress,
    required this.weeksElapsed,
    required this.totalWeeks,
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
