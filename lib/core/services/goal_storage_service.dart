import 'package:hive_flutter/hive_flutter.dart';
import '../models/goal_configuration.dart';
import '../constants/app_constants.dart';

/// Service de stockage pour la configuration de l'objectif
class GoalStorageService {
  static Box? _settingsBox;

  /// Initialiser (appelé après HiveStorageService.init())
  static Future<void> init() async {
    _settingsBox = await Hive.openBox(AppConstants.appSettingsBoxName);
  }

  /// Sauvegarder la configuration de l'objectif
  static Future<void> saveGoalConfiguration(GoalConfiguration config) async {
    if (_settingsBox == null) {
      throw Exception('GoalStorageService non initialisé');
    }

    final validation = config.validate();
    if (!validation.isValid) {
      throw Exception(validation.message ?? 'Configuration invalide');
    }

    await _settingsBox!.put('goal_configuration', config.toJson());
    await _settingsBox!.put('onboarding_completed', true);
  }

  /// Récupérer la configuration de l'objectif
  static GoalConfiguration? getGoalConfiguration() {
    if (_settingsBox == null) return null;

    final raw = _settingsBox!.get('goal_configuration');
    if (raw == null || raw is! Map) return null;
    final json = Map<String, dynamic>.from(raw as Map);

    try {
      return GoalConfiguration.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  /// Vérifier si l'onboarding est terminé
  static bool isOnboardingCompleted() {
    if (_settingsBox == null) return false;
    return _settingsBox!.get('onboarding_completed') as bool? ?? false;
  }

  /// Saved app locale (e.g. 'en', 'fr'). Null until user selects in onboarding.
  static String? getLocale() {
    if (_settingsBox == null) return null;
    return _settingsBox!.get('locale') as String?;
  }

  /// Persist chosen locale from onboarding. Default is English.
  static Future<void> saveLocale(String languageCode) async {
    if (_settingsBox == null) {
      throw Exception('GoalStorageService non initialisé');
    }
    await _settingsBox!.put('locale', languageCode);
  }

  /// Update stored goal configuration (e.g. from Settings). Does not change onboarding_completed.
  static Future<void> updateGoalConfiguration(GoalConfiguration config) async {
    if (_settingsBox == null) {
      throw Exception('GoalStorageService non initialisé');
    }
    final validation = config.validate();
    if (!validation.isValid) {
      throw Exception(validation.message ?? 'Configuration invalide');
    }
    await _settingsBox!.put('goal_configuration', config.toJson());
  }

  /// Marquer l'onboarding comme terminé
  static Future<void> setOnboardingCompleted(bool completed) async {
    if (_settingsBox == null) {
      throw Exception('GoalStorageService non initialisé');
    }
    await _settingsBox!.put('onboarding_completed', completed);
  }

  /// Obtenir le poids initial (pour compatibilité avec ancien code)
  static double? getInitialWeight() {
    final config = getGoalConfiguration();
    return config?.initialWeight;
  }

  /// Obtenir la date de début de l'objectif (pour compatibilité)
  static DateTime getGoalStartDate() {
    final config = getGoalConfiguration();
    return config?.goalStartDate ?? DateTime.now();
  }

  /// Obtenir le poids cible (pour compatibilité)
  static double? getTargetWeight() {
    final config = getGoalConfiguration();
    return config?.targetWeight;
  }

  /// Migrer depuis l'ancien système (SharedPreferences)
  static Future<GoalConfiguration?> migrateFromOldSystem() async {
    if (_settingsBox == null) return null;

    // Vérifier si on a déjà une configuration
    if (getGoalConfiguration() != null) {
      return getGoalConfiguration();
    }

    // Vérifier si on a des données de l'ancien système
    final oldInitialWeight = _settingsBox!.get('initial_weight') as double?;
    final oldStartDateString = _settingsBox!.get('goal_start_date') as String?;

    if (oldInitialWeight != null && oldStartDateString != null) {
      // Créer une configuration par défaut basée sur l'ancien système
      final oldStartDate = DateTime.parse(oldStartDateString);
      final targetWeight = oldInitialWeight + AppConstants.goalWeightGain;

      final config = GoalConfiguration(
        initialWeight: oldInitialWeight,
        targetWeight: targetWeight,
        goalStartDate: oldStartDate,
        durationMonths: AppConstants.goalDurationMonths,
        type: GoalType.gain,
      );

      await saveGoalConfiguration(config);
      return config;
    }

    return null;
  }
}
