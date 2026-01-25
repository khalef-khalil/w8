import '../../models/weight_entry.dart';
import '../utils/date_utils.dart' as date_utils;
import '../models/goal_configuration.dart';
import 'smoothing_calculator.dart';

/// Service pour les calculs statistiques avancés
class StatisticalCalculator {
  /// Calculer la vitesse actuelle basée sur la tendance récente
  /// Utilise les dernières N semaines au lieu de tout l'historique
  static double calculateRecentRatePerWeek(
    List<WeightEntry> entries,
    GoalConfiguration goal,
    {int weeksToConsider = 4}
  ) {
    if (entries.isEmpty) return 0.0;

    // Utiliser les médianes hebdomadaires pour une meilleure précision
    final weeklyMedians = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      goal.weekStartDay,
    );

    if (weeklyMedians.length < 2) {
      // Pas assez de données, utiliser la méthode simple
      return _calculateSimpleRate(entries, goal);
    }

    // Prendre les dernières N semaines
    final recentMedians = weeklyMedians.length > weeksToConsider
        ? weeklyMedians.sublist(weeklyMedians.length - weeksToConsider)
        : weeklyMedians;

    if (recentMedians.length < 2) {
      return _calculateSimpleRate(entries, goal);
    }

    // Calculer la tendance linéaire sur les médianes récentes
    final firstMedian = recentMedians.first;
    final lastMedian = recentMedians.last;
    
    final weeksBetween = date_utils.AppDateUtils.getWeeksBetween(
      firstMedian.key,
      lastMedian.key,
    );

    if (weeksBetween == 0) return 0.0;

    final weightChange = lastMedian.value - firstMedian.value;
    return weightChange / weeksBetween;
  }

  /// Calculer la vitesse simple (méthode de fallback)
  static double _calculateSimpleRate(
    List<WeightEntry> entries,
    GoalConfiguration goal,
  ) {
    final daysElapsed = DateTime.now().difference(goal.goalStartDate).inDays;
    if (daysElapsed == 0) return 0.0;

    final currentWeight = entries.isNotEmpty
        ? entries.last.weight
        : goal.initialWeight;
    final weightChange = currentWeight - goal.initialWeight;
    return (weightChange / daysElapsed) * 7;
  }

  /// Obtenir les médianes hebdomadaires avec interpolation optionnelle
  /// [interpolateMissingWeeks] : si true, interpole les semaines manquantes
  static List<MapEntry<DateTime, double>> getWeeklyMediansWithInterpolation(
    List<WeightEntry> entries,
    WeekStartDay weekStartsOn, {
    bool interpolateMissingWeeks = false,
  }) {
    if (entries.isEmpty) return [];

    final medians = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      weekStartsOn,
    );

    if (!interpolateMissingWeeks || medians.length < 2) {
      return medians;
    }

    // Interpoler les semaines manquantes
    final interpolated = <MapEntry<DateTime, double>>[];
    for (int i = 0; i < medians.length; i++) {
      interpolated.add(medians[i]);

      // Vérifier s'il y a un gap avant la prochaine médiane
      if (i < medians.length - 1) {
        final currentWeek = medians[i].key;
        final nextWeek = medians[i + 1].key;
        final weeksBetween = date_utils.AppDateUtils.getWeeksBetween(
          currentWeek,
          nextWeek,
        );

        // Si plus d'une semaine entre les deux, interpoler
        if (weeksBetween > 1) {
          final weightDiff = medians[i + 1].value - medians[i].value;
          final weightPerWeek = weightDiff / weeksBetween;

          for (int j = 1; j < weeksBetween; j++) {
            final interpolatedWeek = currentWeek.add(Duration(days: 7 * j));
            final interpolatedWeight = medians[i].value + (weightPerWeek * j);
            interpolated.add(MapEntry(interpolatedWeek, interpolatedWeight));
          }
        }
      }
    }

    return interpolated;
  }

  /// Calculer la tendance (pente) sur une période donnée
  /// Retourne le changement de poids par semaine
  static double calculateTrend(
    List<WeightEntry> entries,
    DateTime startDate,
    DateTime endDate,
  ) {
    if (entries.isEmpty) return 0.0;

    final periodEntries = entries
        .where((e) => e.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
            e.date.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    if (periodEntries.length < 2) return 0.0;

    final firstWeight = periodEntries.first.weight;
    final lastWeight = periodEntries.last.weight;
    final weeks = date_utils.AppDateUtils.getWeeksBetween(
      periodEntries.first.date,
      periodEntries.last.date,
    );

    if (weeks == 0) return 0.0;

    return (lastWeight - firstWeight) / weeks;
  }

  /// Calculer la volatilité (écart-type) des poids récents
  static double calculateVolatility(
    List<WeightEntry> entries,
    {int days = 30}
  ) {
    if (entries.isEmpty) return 0.0;

    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    final recentEntries = entries
        .where((e) => e.date.isAfter(cutoffDate))
        .map((e) => e.weight)
        .toList();

    if (recentEntries.length < 2) return 0.0;

    final mean = recentEntries.reduce((a, b) => a + b) / recentEntries.length;
    final variance = recentEntries
        .map((w) => (w - mean) * (w - mean))
        .reduce((a, b) => a + b) / recentEntries.length;

    return variance > 0 ? variance : 0.0;
  }

  /// Prédire le poids futur basé sur la tendance récente
  static double? predictFutureWeight(
    List<WeightEntry> entries,
    GoalConfiguration goal,
    int weeksFromNow,
  ) {
    if (entries.isEmpty) return null;

    final recentRate = calculateRecentRatePerWeek(entries, goal);
    if (recentRate == 0.0) return null;

    final currentWeight = entries.isNotEmpty
        ? entries.last.weight
        : goal.initialWeight;

    return currentWeight + (recentRate * weeksFromNow);
  }
}
