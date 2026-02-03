import '../../models/weight_entry.dart';

/// Calculateur de lissage pour les poids
class SmoothingCalculator {
  /// Calculer la moyenne mobile sur N jours
  static double calculateRollingAverage(
    List<WeightEntry> entries,
    int days,
  ) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries
        .where((e) => e.date.isAfter(cutoffDate))
        .toList();

    if (recentEntries.isEmpty) {
      return entries.isNotEmpty ? entries.last.weight : 0.0;
    }

    final sum = recentEntries.map((e) => e.weight).reduce((a, b) => a + b);
    return sum / recentEntries.length;
  }

  /// Calculer la moyenne pondérée (jours récents plus importants)
  static double calculateWeightedAverage(
    List<WeightEntry> entries,
    int days,
  ) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries
        .where((e) => e.date.isAfter(cutoffDate))
        .toList();

    if (recentEntries.isEmpty) {
      return entries.isNotEmpty ? entries.last.weight : 0.0;
    }

    double weightedSum = 0.0;
    double totalWeight = 0.0;

    for (final entry in recentEntries) {
      final daysAgo = DateTime.now().difference(entry.date).inDays;
      final weight = days + 1 - daysAgo; // Plus récent = plus de poids
      weightedSum += entry.weight * weight;
      totalWeight += weight;
    }

    return totalWeight > 0 ? weightedSum / totalWeight : 0.0;
  }

  /// Calculer la moyenne mobile exponentielle (EMA)
  static double calculateEMA(
    List<WeightEntry> entries,
    double alpha, // Facteur de lissage (0-1, généralement 0.2-0.3)
  ) {
    if (entries.isEmpty) return 0.0;

    // Trier par date
    final sorted = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    double ema = sorted.first.weight;

    for (int i = 1; i < sorted.length; i++) {
      ema = alpha * sorted[i].weight + (1 - alpha) * ema;
    }

    return ema;
  }

  /// Calculer la moyenne mobile simple sur 7 jours
  static double calculateRolling7Days(List<WeightEntry> entries) {
    return calculateRollingAverage(entries, 7);
  }

  /// Start of calendar day for (now - (days - 1)), so "last 7 days" = 7 calendar days including today.
  static DateTime _startOfDayAgo(int days) {
    final now = DateTime.now();
    final ago = now.subtract(Duration(days: days - 1));
    return DateTime(ago.year, ago.month, ago.day);
  }

  static bool _isInLastCalendarDays(DateTime entryDate, int days) {
    final cutoffDay = _startOfDayAgo(days);
    final entryDay = DateTime(entryDate.year, entryDate.month, entryDate.day);
    return !entryDay.isBefore(cutoffDay);
  }

  /// Médiane des poids sur les 7 derniers jours calendaires (aujourd’hui inclus). Si aucun dans la fenêtre → dernier poids.
  static double calculateRolling7DaysMedian(List<WeightEntry> entries) {
    if (entries.isEmpty) return 0.0;
    const days = 7;
    final recent = entries.where((e) => _isInLastCalendarDays(e.date, days)).toList();
    if (recent.isEmpty) return entries.last.weight;
    final weights = recent.map((e) => e.weight).toList();
    return WeightEntry.calculateMedian(weights);
  }

  /// Rolling 7-day median plus la période utilisée (pour affichage "which dates").
  /// [periodStart]/[periodEnd] = min/max des dates des entrées dans la fenêtre, ou null si last-weigh-in.
  static ({double weight, DateTime? periodStart, DateTime? periodEnd})
      getRolling7DaysMedianWithPeriod(List<WeightEntry> entries) {
    if (entries.isEmpty) {
      return (weight: 0.0, periodStart: null, periodEnd: null);
    }
    const days = 7;
    final recent = entries.where((e) => _isInLastCalendarDays(e.date, days)).toList();
    if (recent.isEmpty) {
      return (weight: entries.last.weight, periodStart: null, periodEnd: null);
    }
    final weights = recent.map((e) => e.weight).toList();
    final start = recent.map((e) => e.date).reduce((a, b) => a.isBefore(b) ? a : b);
    final end = recent.map((e) => e.date).reduce((a, b) => a.isAfter(b) ? a : b);
    return (
      weight: WeightEntry.calculateMedian(weights),
      periodStart: start,
      periodEnd: end,
    );
  }

  /// Calculer la moyenne mobile simple sur 30 jours
  static double calculateRolling30Days(List<WeightEntry> entries) {
    return calculateRollingAverage(entries, 30);
  }
}
