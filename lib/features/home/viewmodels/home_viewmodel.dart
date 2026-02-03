import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/weight_entry.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../core/services/streak_service.dart';
import '../../../core/services/smoothing_calculator.dart';
import '../../../core/utils/date_utils.dart' as date_utils;
import '../../../core/models/progress_data.dart';
import '../../../core/models/progress_metrics.dart';
import '../../../core/models/goal_configuration.dart';

/// ViewModel pour l'écran d'accueil
class HomeViewModel extends StateNotifier<AsyncValue<HomeState>> {
  HomeViewModel() : super(const AsyncValue.loading()) {
    _loadData();
    _watchChanges();
  }

  /// Charger les données initiales
  Future<void> _loadData() async {
    state = const AsyncValue.loading();
    try {
      final entries = HiveStorageService.getWeightEntries();
      final progress = _calculateProgress(entries);
      
      // Calculer les métriques avancées si configuration disponible
      final goal = GoalStorageService.getGoalConfiguration();
      ProgressMetrics? metrics;
      if (goal != null) {
        metrics = ProgressMetrics.fromEntries(goal, entries);
      }

      // Calculer les streaks
      final currentStreak = StreakService.calculateCurrentStreak(entries);
      final longestStreak = StreakService.calculateLongestStreak(entries);
      final daysSinceLast = StreakService.daysSinceLastEntry(entries);
      final hasEntryToday = StreakService.hasEntryToday(entries);
      final totalDaysTracked = StreakService.totalDaysTracked(entries);

      state = AsyncValue.data(HomeState(
        entries: entries,
        progress: progress,
        metrics: metrics,
        goalConfig: goal,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        daysSinceLastEntry: daysSinceLast,
        hasEntryToday: hasEntryToday,
        totalDaysTracked: totalDaysTracked,
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Écouter les changements dans le stockage
  void _watchChanges() {
    try {
      HiveStorageService.watchWeightEntries().listen((event) {
        _loadData();
      });
    } catch (e) {
      // Ignorer si Hive n'est pas encore initialisé
    }
  }

  /// Calculer le progrès
  ProgressData _calculateProgress(List<WeightEntry> entries) {
    final config = GoalStorageService.getGoalConfiguration();
    
    if (config == null) {
      // Fallback si pas de configuration (ancien système)
      if (entries.isEmpty) {
        return ProgressData.empty();
      }
      final initialWeight = HiveStorageService.getInitialWeight() ?? entries.first.weight;
      final targetWeight = initialWeight + 15.0; // Default fallback
      final result = SmoothingCalculator.getRolling7DaysMedianWithPeriod(entries);
      return ProgressData(
        currentWeight: result.weight,
        initialWeight: initialWeight,
        targetWeight: targetWeight,
        weightGained: result.weight - initialWeight,
        progress: ((result.weight - initialWeight) / 15.0).clamp(0.0, 1.0),
        weeksElapsed: 0,
        totalWeeks: 24,
        currentWeightPeriodStart: result.periodStart,
        currentWeightPeriodEnd: result.periodEnd,
      );
    }

    // Current weight = 7-day rolling median (fallback to last entry if no entries in last 7 days)
    final result = entries.isEmpty
        ? (weight: config.initialWeight, periodStart: null, periodEnd: null)
        : SmoothingCalculator.getRolling7DaysMedianWithPeriod(entries);
    final currentWeight = entries.isEmpty ? config.initialWeight! : result.weight;

    if (kDebugMode && entries.isNotEmpty) {
      debugPrint('[CurrentWeight] entries: n=${entries.length} first=${entries.first.date} last=${entries.last.date}');
      debugPrint('[CurrentWeight] rolling 7-day median → currentWeight=$currentWeight');
    }

    final weightChange = currentWeight - config.initialWeight;
    final totalWeightChange = config.targetWeight - config.initialWeight;
    final progress = totalWeightChange != 0
        ? (weightChange / totalWeightChange).clamp(0.0, 1.0)
        : 0.0;

    // Calculer les semaines écoulées depuis le début réel de l'objectif
    final weeksElapsed = date_utils.AppDateUtils.getWeeksBetween(
      config.goalStartDate,
      DateTime.now(),
    );

    return ProgressData(
      currentWeight: currentWeight,
      initialWeight: config.initialWeight,
      targetWeight: config.targetWeight,
      weightGained: weightChange,
      progress: progress,
      weeksElapsed: weeksElapsed,
      totalWeeks: config.totalWeeks,
      currentWeightPeriodStart: result.periodStart,
      currentWeightPeriodEnd: result.periodEnd,
    );
  }

  /// Rafraîchir les données
  Future<void> refresh() async {
    await _loadData();
  }
}

/// État de l'écran d'accueil
class HomeState {
  final List<WeightEntry> entries;
  final ProgressData progress;
  final ProgressMetrics? metrics;
  final GoalConfiguration? goalConfig;
  final int currentStreak;
  final int longestStreak;
  final int daysSinceLastEntry;
  final bool hasEntryToday;
  final int totalDaysTracked;

  HomeState({
    required this.entries,
    required this.progress,
    this.metrics,
    this.goalConfig,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.daysSinceLastEntry = 0,
    this.hasEntryToday = false,
    this.totalDaysTracked = 0,
  });
}

/// Provider pour le ViewModel
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, AsyncValue<HomeState>>(
  (ref) => HomeViewModel(),
);
