import 'package:hive_flutter/hive_flutter.dart';
import '../../models/weight_entry.dart';
import '../constants/app_constants.dart';
import '../models/weight_entry_tags.dart';
import 'achievement_service.dart';
import 'goal_storage_service.dart';
import 'metrics_cache.dart';

/// Service de stockage utilisant Hive pour une meilleure performance
class HiveStorageService {
  static Box<WeightEntry>? _weightEntriesBox;

  /// Initialiser Hive et ouvrir les boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Enregistrer le type adapter pour WeightEntry
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WeightEntryAdapter());
    }
    
    // Ouvrir les boxes
    _weightEntriesBox = await Hive.openBox<WeightEntry>(
      AppConstants.weightEntriesBoxName,
    );
    
    // Initialiser GoalStorageService (ouvre aussi le settings box)
    await GoalStorageService.init();
    
    // Migrer depuis l'ancien système si nécessaire
    await GoalStorageService.migrateFromOldSystem();
    
    // Migrer les entrées de poids depuis les clés basées sur la date vers les clés basées sur le timestamp
    await _migrateDateKeysToTimestampKeys();
    
    // Initialize achievements service
    await AchievementService.init();
  }

  /// Migrer les entrées depuis les clés basées sur la date vers les clés basées sur le timestamp
  /// Cette migration permet de supporter plusieurs entrées par jour
  static Future<void> _migrateDateKeysToTimestampKeys() async {
    if (_weightEntriesBox == null) return;
    
    // Vérifier si la migration a déjà été effectuée
    // Utiliser le settings box pour stocker le flag de migration
    final settingsBox = await Hive.openBox(AppConstants.appSettingsBoxName);
    final migrationKey = 'migrated_to_timestamp_keys';
    if (settingsBox.get(migrationKey) == true) {
      return; // Migration déjà effectuée
    }
    
    final entriesToMigrate = <String, WeightEntry>{};
    final keysToDelete = <String>[];
    
    // Parcourir toutes les clés pour trouver celles qui utilisent l'ancien format (date seulement)
    for (final key in _weightEntriesBox!.keys) {
      if (key is String) {
        // Vérifier si c'est une clé de date (format: YYYY-MM-DD)
        final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
        if (datePattern.hasMatch(key)) {
          try {
            final entry = _weightEntriesBox!.get(key);
            if (entry != null) {
              // Créer une nouvelle clé basée sur le timestamp
              final newKey = _getTimestampKey(entry.date);
              entriesToMigrate[newKey] = entry;
              keysToDelete.add(key);
            }
          } catch (e) {
            // Ignorer les erreurs de lecture, continuer la migration
            print('Erreur lors de la migration de la clé $key: $e');
          }
        }
      }
    }
    
    // Sauvegarder les entrées avec les nouvelles clés
    for (final entry in entriesToMigrate.entries) {
      await _weightEntriesBox!.put(entry.key, entry.value);
    }
    
    // Supprimer les anciennes clés
    for (final key in keysToDelete) {
      await _weightEntriesBox!.delete(key);
    }
    
    // Marquer la migration comme effectuée dans le settings box
    await settingsBox.put(migrationKey, true);
  }

  /// Sauvegarder une entrée de poids
  /// Utilise un timestamp ISO8601 comme clé pour permettre plusieurs entrées par jour
  static Future<void> saveWeightEntry(WeightEntry entry) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    MetricsCache.clearCache(); // Clear cache when entries change
    
    // Utiliser une clé basée sur le timestamp complet (ISO8601) pour permettre plusieurs entrées par jour
    final key = _getTimestampKey(entry.date);
    
    await _weightEntriesBox!.put(key, entry);
  }

  /// Récupérer toutes les entrées de poids triées par date
  static List<WeightEntry> getWeightEntries() {
    if (_weightEntriesBox == null) return [];
    
    final entries = _weightEntriesBox!.values.toList();
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  /// Supprimer une entrée de poids par son timestamp exact
  /// Pour supprimer par date seulement, utiliser [deleteWeightEntryByDate]
  static Future<void> deleteWeightEntry(DateTime dateTime) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    MetricsCache.clearCache(); // Clear cache when entries change
    final key = _getTimestampKey(dateTime);
    await _weightEntriesBox!.delete(key);
  }

  /// Supprimer toutes les entrées d'un jour donné (pour compatibilité)
  /// Utilisé lors de la migration depuis l'ancien système
  static Future<void> deleteWeightEntryByDate(DateTime date) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    final dateKey = _getDateKey(date);
    // Chercher toutes les entrées qui commencent par cette date
    final keysToDelete = <String>[];
    for (final key in _weightEntriesBox!.keys) {
      if (key is String && key.startsWith(dateKey)) {
        keysToDelete.add(key);
      }
    }
    for (final key in keysToDelete) {
      await _weightEntriesBox!.delete(key);
    }
  }

  /// Mettre à jour une entrée (supprime l'ancienne si le timestamp change)
  static Future<void> updateWeightEntry(
    WeightEntry original,
    WeightEntry updated,
  ) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    MetricsCache.clearCache(); // Clear cache when entries change
    final originalKey = _getTimestampKey(original.date);
    final updatedKey = _getTimestampKey(updated.date);
    
    // Si le timestamp a changé, supprimer l'ancienne entrée
    if (originalKey != updatedKey) {
      await _weightEntriesBox!.delete(originalKey);
    }
    
    // Sauvegarder la nouvelle entrée
    await _weightEntriesBox!.put(updatedKey, updated);
  }

  /// Obtenir la date de début de l'objectif (déprécié - utiliser GoalStorageService)
  @Deprecated('Use GoalStorageService.getGoalStartDate() instead')
  static DateTime getGoalStartDate() {
    return GoalStorageService.getGoalStartDate();
  }

  /// Obtenir le poids initial (déprécié - utiliser GoalStorageService)
  @Deprecated('Use GoalStorageService.getInitialWeight() instead')
  static double? getInitialWeight() {
    return GoalStorageService.getInitialWeight();
  }

  /// Obtenir le poids cible (déprécié - utiliser GoalStorageService)
  @Deprecated('Use GoalStorageService.getTargetWeight() instead')
  static double? getTargetWeight() {
    return GoalStorageService.getTargetWeight();
  }

  /// Générer une clé unique basée sur le timestamp complet (ISO8601)
  /// Permet plusieurs entrées par jour
  static String _getTimestampKey(DateTime dateTime) {
    // Utiliser ISO8601 format comme clé unique
    return dateTime.toIso8601String();
  }

  /// Générer une clé basée sur la date seulement (pour migration et compatibilité)
  @Deprecated('Use _getTimestampKey for new entries. This is only for migration.')
  static String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Écouter les changements dans la box des entrées
  static Stream<BoxEvent> watchWeightEntries() {
    if (_weightEntriesBox == null) {
      throw Exception('Hive non initialisé');
    }
    return _weightEntriesBox!.watch();
  }
}

/// Adapter Hive pour WeightEntry
class WeightEntryAdapter extends TypeAdapter<WeightEntry> {
  @override
  final int typeId = 0;

  @override
  WeightEntry read(BinaryReader reader) {
    final date = DateTime.parse(reader.readString());
    final weight = reader.readDouble();
    
    // Read optional tags (for backward compatibility)
    // Check if there's more data (tags) by checking if we can read a bool
    WeightEntryTags? tags;
    try {
      // Try to read the hasTags flag - if it fails, there are no tags (old format)
      if (reader.availableBytes > 0) {
        final hasTags = reader.readBool();
        if (hasTags) {
          final sleepQuality = reader.readByte();
          final stressLevel = reader.readByte();
          final exercised = reader.readBool();
          final mealTiming = reader.readString();
          final notes = reader.readString();
          
          tags = WeightEntryTags(
            sleepQuality: sleepQuality > 0 && sleepQuality <= 5 ? sleepQuality : null,
            stressLevel: stressLevel > 0 && stressLevel <= 5 ? stressLevel : null,
            exercised: exercised ? true : null,
            mealTiming: mealTiming.isNotEmpty ? mealTiming : null,
            notes: notes.isNotEmpty ? notes : null,
          );
        }
      }
    } catch (e) {
      // If reading tags fails, assume no tags (backward compatibility with old entries)
      tags = null;
    }
    
    return WeightEntry(date: date, weight: weight, tags: tags);
  }

  @override
  void write(BinaryWriter writer, WeightEntry obj) {
    writer.writeString(obj.date.toIso8601String());
    writer.writeDouble(obj.weight);
    
    // Write optional tags
    final hasTags = obj.tags != null && !obj.tags!.isEmpty;
    writer.writeBool(hasTags);
    if (hasTags) {
      final tags = obj.tags!;
      writer.writeByte(tags.sleepQuality ?? 0);
      writer.writeByte(tags.stressLevel ?? 0);
      writer.writeBool(tags.exercised ?? false);
      writer.writeString(tags.mealTiming ?? '');
      writer.writeString(tags.notes ?? '');
    }
  }
}
