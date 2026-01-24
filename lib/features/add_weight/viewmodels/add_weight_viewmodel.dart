import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/weight_entry.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../core/services/weight_validation_service.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../core/models/validation_result.dart';

/// ViewModel pour l'écran d'ajout de poids
class AddWeightViewModel extends StateNotifier<AsyncValue<void>> {
  AddWeightViewModel() : super(const AsyncValue.data(null));

  /// Valider une entrée de poids
  Future<ValidationResult> validateEntry(WeightEntry entry) async {
    try {
      final history = HiveStorageService.getWeightEntries();
      final goal = GoalStorageService.getGoalConfiguration();
      return WeightValidationService.validateEntry(entry, history, goal);
    } catch (e) {
      return ValidationResult.error('Erreur lors de la validation: $e');
    }
  }

  /// Valider une entrée pour mise à jour (exclut [exclude] de l'historique)
  Future<ValidationResult> validateEntryForUpdate(
    WeightEntry entry,
    WeightEntry exclude,
  ) async {
    try {
      final history = HiveStorageService.getWeightEntries();
      final excludeKey = _dateKey(exclude.date);
      final filtered = history
          .where((e) => _dateKey(e.date) != excludeKey)
          .toList();
      final goal = GoalStorageService.getGoalConfiguration();
      return WeightValidationService.validateEntry(entry, filtered, goal);
    } catch (e) {
      return ValidationResult.error('Erreur lors de la validation: $e');
    }
  }

  static String _dateKey(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  /// Sauvegarder une entrée de poids
  Future<bool> saveWeightEntry(WeightEntry entry) async {
    state = const AsyncValue.loading();
    try {
      // Validation avant sauvegarde
      final validation = await validateEntry(entry);
      
      if (!validation.isValid) {
        state = AsyncValue.error(
          Exception(validation.message ?? 'Validation échouée'),
          StackTrace.current,
        );
        return false;
      }

      await HiveStorageService.saveWeightEntry(entry);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Mettre à jour une entrée (l'UI doit valider avant avec [validateEntryForUpdate])
  Future<bool> updateWeightEntry(
    WeightEntry original,
    WeightEntry updated,
  ) async {
    state = const AsyncValue.loading();
    try {
      await HiveStorageService.updateWeightEntry(original, updated);
      state = const AsyncValue.data(null);
      return true;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  /// Réinitialiser l'état
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour le ViewModel
final addWeightViewModelProvider = StateNotifierProvider<AddWeightViewModel, AsyncValue<void>>(
  (ref) => AddWeightViewModel(),
);
