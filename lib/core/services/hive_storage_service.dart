import 'package:hive_flutter/hive_flutter.dart';
import '../../models/weight_entry.dart';
import '../constants/app_constants.dart';
import 'goal_storage_service.dart';

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
  }

  /// Sauvegarder une entrée de poids
  static Future<void> saveWeightEntry(WeightEntry entry) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    
    // Utiliser une clé basée sur la date pour permettre un seul poids par jour
    final key = _getDateKey(entry.date);
    
    await _weightEntriesBox!.put(key, entry);
    
    // Note: Le poids initial est maintenant géré par GoalConfiguration
    // On garde la compatibilité avec l'ancien système pour migration
  }

  /// Récupérer toutes les entrées de poids triées par date
  static List<WeightEntry> getWeightEntries() {
    if (_weightEntriesBox == null) return [];
    
    final entries = _weightEntriesBox!.values.toList();
    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  /// Supprimer une entrée de poids
  static Future<void> deleteWeightEntry(DateTime date) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    final key = _getDateKey(date);
    await _weightEntriesBox!.delete(key);
  }

  /// Mettre à jour une entrée (supprime l'ancienne si la date change)
  static Future<void> updateWeightEntry(
    WeightEntry original,
    WeightEntry updated,
  ) async {
    if (_weightEntriesBox == null) throw Exception('Hive non initialisé');
    final sameDay = _getDateKey(original.date) == _getDateKey(updated.date);
    if (!sameDay) {
      await _weightEntriesBox!.delete(_getDateKey(original.date));
    }
    await _weightEntriesBox!.put(_getDateKey(updated.date), updated);
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

  /// Générer une clé unique basée sur la date
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
    return WeightEntry(date: date, weight: weight);
  }

  @override
  void write(BinaryWriter writer, WeightEntry obj) {
    writer.writeString(obj.date.toIso8601String());
    writer.writeDouble(obj.weight);
  }
}
