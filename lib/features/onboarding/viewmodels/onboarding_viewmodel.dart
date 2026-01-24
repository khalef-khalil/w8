import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/models/validation_result.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../models/weight_entry.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../l10n/app_localizations.dart';

/// ViewModel pour l'onboarding
class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel() : super(OnboardingState.initial());

  /// Mettre à jour le type d'objectif
  void setGoalType(GoalType type) {
    state = state.copyWith(goalType: type);
  }

  /// Mettre à jour le poids initial
  void setInitialWeight(double weight) {
    state = state.copyWith(initialWeight: weight);
  }

  /// Mettre à jour le poids cible
  void setTargetWeight(double weight) {
    state = state.copyWith(targetWeight: weight);
  }

  /// Mettre à jour la date de début
  void setGoalStartDate(DateTime date) {
    state = state.copyWith(goalStartDate: date);
  }

  /// Mettre à jour la durée
  void setDurationMonths(int months) {
    state = state.copyWith(durationMonths: months);
  }

  /// Mettre à jour l'unité
  void setUnit(WeightUnit unit) {
    state = state.copyWith(unit: unit);
  }

  /// Mettre à jour le début de semaine
  void setWeekStartDay(WeekStartDay day) {
    state = state.copyWith(weekStartDay: day);
  }

  /// Sauvegarder la configuration de l'objectif
  Future<SaveResult> saveGoalConfiguration() async {
    try {
      final config = GoalConfiguration(
        initialWeight: state.initialWeight!,
        targetWeight: state.targetWeight!,
        goalStartDate: state.goalStartDate!,
        durationMonths: state.durationMonths!,
        type: state.goalType!,
        unit: state.unit!,
        weekStartDay: state.weekStartDay!,
      );

      final validation = config.validate();
      if (!validation.isValid) {
        return SaveResult.error(validation.message ?? 'Configuration invalide');
      }

      if (validation.isWarning) {
        // On accepte quand même les warnings, mais on les note
        state = state.copyWith(warningMessage: validation.message);
      }

      await GoalStorageService.saveGoalConfiguration(config);
      return SaveResult.success();
    } catch (e) {
      return SaveResult.error(e.toString());
    }
  }

  /// Sauvegarder la première entrée de poids
  Future<SaveResult> saveFirstEntry(WeightEntry entry) async {
    try {
      // Vérifier que la configuration existe
      final config = GoalStorageService.getGoalConfiguration();
      if (config == null) {
        return SaveResult.error('Configuration de l\'objectif manquante');
      }

      await HiveStorageService.saveWeightEntry(entry);
      await GoalStorageService.setOnboardingCompleted(true);
      return SaveResult.success();
    } catch (e) {
      return SaveResult.error(e.toString());
    }
  }

  /// Validate current step. Pass [l10n] for localized messages.
  ValidationResult validateCurrentStep(int step, AppLocalizations l10n) {
    switch (step) {
      case 1:
        if (state.goalType == null) {
          return ValidationResult.error(l10n.selectGoalType);
        }
        if (state.initialWeight == null || state.initialWeight! <= 0) {
          return ValidationResult.error(l10n.enterInitialWeight);
        }
        if (state.targetWeight == null || state.targetWeight! <= 0) {
          return ValidationResult.error(l10n.enterTargetWeight);
        }
        if (state.goalStartDate == null) {
          return ValidationResult.error(l10n.invalidGoalStartDate);
        }
        if (state.durationMonths == null || state.durationMonths! < 1) {
          return ValidationResult.error(l10n.enterDuration);
        }
        if (state.goalType == GoalType.gain &&
            state.targetWeight! <= state.initialWeight!) {
          return ValidationResult.error(l10n.targetMustBeGreater);
        }
        if (state.goalType == GoalType.loss &&
            state.targetWeight! >= state.initialWeight!) {
          return ValidationResult.error(l10n.targetMustBeLess);
        }
        return ValidationResult.success();
      default:
        return ValidationResult.success();
    }
  }
}

/// État de l'onboarding
class OnboardingState {
  final GoalType? goalType;
  final double? initialWeight;
  final double? targetWeight;
  final DateTime? goalStartDate;
  final int? durationMonths;
  final WeightUnit? unit;
  final WeekStartDay? weekStartDay;
  final String? warningMessage;

  OnboardingState({
    this.goalType,
    this.initialWeight,
    this.targetWeight,
    this.goalStartDate,
    this.durationMonths,
    this.unit,
    this.weekStartDay,
    this.warningMessage,
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      goalType: GoalType.gain,
      unit: WeightUnit.kg,
      weekStartDay: WeekStartDay.monday,
    );
  }

  OnboardingState copyWith({
    GoalType? goalType,
    double? initialWeight,
    double? targetWeight,
    DateTime? goalStartDate,
    int? durationMonths,
    WeightUnit? unit,
    WeekStartDay? weekStartDay,
    String? warningMessage,
  }) {
    return OnboardingState(
      goalType: goalType ?? this.goalType,
      initialWeight: initialWeight ?? this.initialWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      goalStartDate: goalStartDate ?? this.goalStartDate,
      durationMonths: durationMonths ?? this.durationMonths,
      unit: unit ?? this.unit,
      weekStartDay: weekStartDay ?? this.weekStartDay,
      warningMessage: warningMessage ?? this.warningMessage,
    );
  }
}

/// Résultat d'une sauvegarde
class SaveResult {
  final bool success;
  final String? error;

  SaveResult.success()
      : success = true,
        error = null;

  SaveResult.error(this.error)
      : success = false;
}

/// Provider pour le ViewModel
final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>(
  (ref) => OnboardingViewModel(),
);
