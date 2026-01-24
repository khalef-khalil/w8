import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/weight_entry.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../core/services/goal_storage_service.dart';
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

      state = AsyncValue.data(HomeState(
        entries: entries,
        progress: progress,
        metrics: metrics,
        goalConfig: goal,
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
      final lastWeekMedians = date_utils.AppDateUtils.getWeeklyMedians(
        entries,
        WeekStartDay.monday,
      );
      final currentWeight = lastWeekMedians.isNotEmpty
          ? lastWeekMedians.last.value
          : entries.last.weight;
      return ProgressData(
        currentWeight: currentWeight,
        initialWeight: initialWeight,
        targetWeight: targetWeight,
        weightGained: currentWeight - initialWeight,
        progress: ((currentWeight - initialWeight) / 15.0).clamp(0.0, 1.0),
        weeksElapsed: 0,
        totalWeeks: 24,
      );
    }

    // Utiliser la médiane de la dernière semaine ou le dernier poids
    final lastWeekMedians = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      config.weekStartDay,
    );
    final currentWeight = lastWeekMedians.isNotEmpty
        ? lastWeekMedians.last.value
        : (entries.isNotEmpty ? entries.last.weight : config.initialWeight);

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

  HomeState({
    required this.entries,
    required this.progress,
    this.metrics,
    this.goalConfig,
  });
}

/// Provider pour le ViewModel
final homeViewModelProvider = StateNotifierProvider<HomeViewModel, AsyncValue<HomeState>>(
  (ref) => HomeViewModel(),
);
