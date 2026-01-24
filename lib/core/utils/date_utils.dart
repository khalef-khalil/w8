import '../../models/weight_entry.dart';
import '../models/goal_configuration.dart';

/// Utilitaires pour les manipulations de dates
class AppDateUtils {
  /// 1 = Monday .. 7 = Sunday
  static int _weekdayNumber(WeekStartDay d) {
    switch (d) {
      case WeekStartDay.monday:
        return 1;
      case WeekStartDay.tuesday:
        return 2;
      case WeekStartDay.wednesday:
        return 3;
      case WeekStartDay.thursday:
        return 4;
      case WeekStartDay.friday:
        return 5;
      case WeekStartDay.saturday:
        return 6;
      case WeekStartDay.sunday:
        return 7;
    }
  }

  /// Calculer le début de la semaine selon [weekStartsOn].
  static DateTime getWeekStart(
    DateTime date, [
    WeekStartDay weekStartsOn = WeekStartDay.monday,
  ]) {
    final startNum = _weekdayNumber(weekStartsOn);
    final daysSince = (date.weekday - startNum + 7) % 7;
    return date.subtract(Duration(days: daysSince));
  }

  /// Vérifier si deux dates sont dans la même semaine
  static bool isSameWeek(
    DateTime date1,
    DateTime date2, [
    WeekStartDay weekStartsOn = WeekStartDay.monday,
  ]) {
    final weekStart1 = getWeekStart(date1, weekStartsOn);
    final weekStart2 = getWeekStart(date2, weekStartsOn);
    return weekStart1.year == weekStart2.year &&
        weekStart1.month == weekStart2.month &&
        weekStart1.day == weekStart2.day;
  }

  /// Vérifier si deux dates sont le même jour
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Calculer le nombre de semaines entre deux dates
  static int getWeeksBetween(DateTime start, DateTime end) {
    final difference = end.difference(start).inDays;
    return (difference / 7).floor();
  }

  /// Obtenir les poids d'une semaine spécifique
  static List<double> getWeeklyWeights(
    List<WeightEntry> entries,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return entries
        .where((entry) =>
            entry.date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            entry.date.isBefore(weekEnd.add(const Duration(days: 1))))
        .map((entry) => entry.weight)
        .toList();
  }

  /// Obtenir la médiane hebdomadaire
  static double? getWeeklyMedian(
    List<WeightEntry> entries,
    DateTime weekStart,
  ) {
    final weights = getWeeklyWeights(entries, weekStart);
    if (weights.isEmpty) return null;
    return WeightEntry.calculateMedian(weights);
  }

  /// Obtenir toutes les médianes hebdomadaires
  static List<MapEntry<DateTime, double>> getWeeklyMedians(
    List<WeightEntry> entries, [
    WeekStartDay weekStartsOn = WeekStartDay.monday,
  ]) {
    if (entries.isEmpty) return [];

    final startDate = entries.first.date;
    final endDate = entries.last.date;
    final medians = <MapEntry<DateTime, double>>[];

    DateTime currentWeek = getWeekStart(startDate, weekStartsOn);

    while (currentWeek.isBefore(endDate) ||
        isSameWeek(currentWeek, endDate, weekStartsOn)) {
      final median = getWeeklyMedian(entries, currentWeek);
      if (median != null) {
        medians.add(MapEntry(currentWeek, median));
      }
      currentWeek = currentWeek.add(const Duration(days: 7));
    }

    return medians;
  }
}
