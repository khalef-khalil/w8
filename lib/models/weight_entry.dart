import '../core/models/weight_entry_tags.dart';

/// Modèle représentant une entrée de poids
class WeightEntry {
  final DateTime date;
  final double weight;
  final WeightEntryTags? tags; // Optional context tags

  WeightEntry({
    required this.date,
    required this.weight,
    this.tags,
  });

  WeightEntry copyWith({
    DateTime? date,
    double? weight,
    WeightEntryTags? tags,
  }) {
    return WeightEntry(
      date: date ?? this.date,
      weight: weight ?? this.weight,
      tags: tags ?? this.tags,
    );
  }

  // Calculer la médiane pour une liste de poids
  static double calculateMedian(List<double> weights) {
    if (weights.isEmpty) return 0.0;
    
    final sorted = List<double>.from(weights)..sort();
    final mid = sorted.length ~/ 2;
    
    if (sorted.length % 2 == 0) {
      return (sorted[mid - 1] + sorted[mid]) / 2.0;
    } else {
      return sorted[mid];
    }
  }
}
