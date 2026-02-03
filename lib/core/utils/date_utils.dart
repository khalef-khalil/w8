import 'package:flutter/foundation.dart';

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

  /// Obtenir les poids d'une semaine spécifique.
  /// Compares (year, month, day) so the full last day of the week is included
  /// regardless of time or timezone.
  static List<double> getWeeklyWeights(
    List<WeightEntry> entries,
    DateTime weekStart,
  ) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final wsY = weekStart.year;
    final wsM = weekStart.month;
    final wsD = weekStart.day;
    final weY = weekEnd.year;
    final weM = weekEnd.month;
    final weD = weekEnd.day;

    bool inRange(int y, int m, int d) {
      if (y < wsY || (y == wsY && (m < wsM || (m == wsM && d < wsD)))) return false;
      if (y > weY || (y == weY && (m > weM || (m == weM && d > weD)))) return false;
      return true;
    }

    return entries
        .where((entry) => inRange(entry.date.year, entry.date.month, entry.date.day))
        .map((entry) => entry.weight)
        .toList();
  }

  /// Obtenir la médiane hebdomadaire
  /// [minEntries] : nombre minimum d'entrées requis (défaut: 3)
  /// Retourne null si moins d'entrées que le minimum
  static double? getWeeklyMedian(
    List<WeightEntry> entries,
    DateTime weekStart, {
    int minEntries = 3,
  }) {
    final weights = getWeeklyWeights(entries, weekStart);
    if (weights.isEmpty || weights.length < minEntries) return null;
    return WeightEntry.calculateMedian(weights);
  }
  
  /// Vérifier si une semaine est complète (a au moins [minEntries] entrées)
  static bool isWeekComplete(
    List<WeightEntry> entries,
    DateTime weekStart, {
    int minEntries = 3,
  }) {
    final weights = getWeeklyWeights(entries, weekStart);
    return weights.length >= minEntries;
  }

  /// Obtenir toutes les médianes hebdomadaires
  /// Amélioré pour mieux gérer les données éparses
  /// [minEntries] : nombre minimum d'entrées par semaine (défaut: 3)
  /// [onlyCompleteWeeks] : si true, n'inclut que les semaines complètes
  static List<MapEntry<DateTime, double>> getWeeklyMedians(
    List<WeightEntry> entries,
    WeekStartDay weekStartsOn, {
    int minEntries = 3,
    bool onlyCompleteWeeks = false,
  }) {
    if (entries.isEmpty) return [];

    final startDate = entries.first.date;
    final endDate = entries.last.date;
    final medians = <MapEntry<DateTime, double>>[];

    // Commencer à la semaine de la première entrée
    DateTime currentWeek = getWeekStart(startDate, weekStartsOn);
    // S'assurer qu'on inclut la semaine de la dernière entrée
    final lastWeek = getWeekStart(endDate, weekStartsOn);

    // Parcourir toutes les semaines entre le début et la fin
    while (currentWeek.isBefore(lastWeek) || 
           currentWeek.isAtSameMomentAs(lastWeek) ||
           isSameWeek(currentWeek, lastWeek, weekStartsOn)) {
      // Si onlyCompleteWeeks, vérifier que la semaine est complète
      if (onlyCompleteWeeks && !isWeekComplete(entries, currentWeek, minEntries: minEntries)) {
        currentWeek = currentWeek.add(const Duration(days: 7));
        continue;
      }
      
      final median = getWeeklyMedian(entries, currentWeek, minEntries: minEntries);
      if (median != null) {
        medians.add(MapEntry(currentWeek, median));
      }
      currentWeek = currentWeek.add(const Duration(days: 7));
      
      // Protection contre les boucles infinies
      if (currentWeek.isAfter(endDate.add(const Duration(days: 14)))) {
        break;
      }
    }

    return medians;
  }
  
  /// Obtenir la dernière semaine complète avec médiane valide.
  /// "Last complete week" = the full week (Mon–Sun) that ends the day before the
  /// current week's Monday. E.g. if current week is Mon Feb 2 – Sun Feb 8, then
  /// last complete week is Mon Jan 26 – Sun Feb 1 (previous Monday = currentMonday - 7).
  static MapEntry<DateTime, double>? getLastCompleteWeekMedian(
    List<WeightEntry> entries,
    WeekStartDay weekStartsOn,
  ) {
    if (entries.isEmpty) return null;

    final ref = entries.last.date;
    final currentWeekMonday = getWeekStart(ref, weekStartsOn);
    // Last complete week = previous full week: Mon (currentMonday - 7) to Sun (currentMonday - 1).
    final lastCompleteWeekStart = currentWeekMonday.subtract(const Duration(days: 7));
    // Normalize to midnight so week boundaries are Mon 00:00 - Sun 00:00 (next day)
    final weekStartMidnight = DateTime(lastCompleteWeekStart.year, lastCompleteWeekStart.month, lastCompleteWeekStart.day);

    final weights = getWeeklyWeights(entries, weekStartMidnight);
    if (weights.length < 3) return null;

    final median = WeightEntry.calculateMedian(weights);

    if (kDebugMode) {
      final weekEnd = weekStartMidnight.add(const Duration(days: 6));
      debugPrint('[CurrentWeight] lastCompleteWeek: ${weekStartMidnight.year}-${weekStartMidnight.month.toString().padLeft(2, '0')}-${weekStartMidnight.day} (Mon) → ${weekEnd.year}-${weekEnd.month.toString().padLeft(2, '0')}-${weekEnd.day} (Sun)');
      debugPrint('[CurrentWeight] ref=entries.last.date: $ref  weekStartsOn: $weekStartsOn');
      debugPrint('[CurrentWeight] weights in week (n=${weights.length}): $weights  → median: $median');
    }

    return MapEntry(weekStartMidnight, median);
  }
}
