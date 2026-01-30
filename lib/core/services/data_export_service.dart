import 'dart:convert';
import 'package:intl/intl.dart';
import '../../models/weight_entry.dart';
import '../services/hive_storage_service.dart';
import '../services/goal_storage_service.dart';
import '../models/goal_configuration.dart';
import '../utils/weight_converter.dart';

/// Service pour exporter les données de l'application
class DataExportService {
  /// Exporter toutes les entrées de poids au format CSV
  /// Retourne le contenu CSV sous forme de chaîne
  static Future<String> exportToCSV() async {
    final entries = HiveStorageService.getWeightEntries();
    final goal = GoalStorageService.getGoalConfiguration();
    final unit = goal?.unit ?? WeightUnit.kg;
    
    final buffer = StringBuffer();
    
    // En-tête CSV
    buffer.writeln('Date,Time,Weight (${unit == WeightUnit.kg ? "kg" : "lbs"})');
    
    // Données
    for (final entry in entries) {
      final date = DateFormat('yyyy-MM-dd').format(entry.date);
      final time = DateFormat('HH:mm:ss').format(entry.date);
      final weight = WeightConverter.forDisplay(entry.weight, unit);
      
      buffer.writeln('$date,$time,${weight.toStringAsFixed(2)}');
    }
    
    return buffer.toString();
  }

  /// Exporter toutes les données au format JSON
  /// Inclut les entrées de poids et la configuration de l'objectif
  static Future<Map<String, dynamic>> exportToJSON() async {
    final entries = HiveStorageService.getWeightEntries();
    final goal = GoalStorageService.getGoalConfiguration();
    
    final data = <String, dynamic>{
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
      'entries': entries.map((e) => {
        'date': e.date.toIso8601String(),
        'weight': e.weight, // Toujours en kg pour la précision
      }).toList(),
    };
    
    if (goal != null) {
      data['goal'] = {
        'initialWeight': goal.initialWeight,
        'targetWeight': goal.targetWeight,
        'goalStartDate': goal.goalStartDate.toIso8601String(),
        'durationMonths': goal.durationMonths,
        'durationDays': goal.durationDays,
        if (goal.goalEndDateOverride != null)
          'goalEndDateOverride': goal.goalEndDateOverride!.toIso8601String(),
        'type': goal.type.name,
        'unit': goal.unit.name,
        'weekStartDay': goal.weekStartDay.name,
      };
    }
    
    return data;
  }

  /// Exporter au format JSON comme chaîne de caractères
  static Future<String> exportToJSONString() async {
    final data = await exportToJSON();
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// Importer des données depuis un JSON
  /// Retourne le nombre d'entrées importées
  static Future<int> importFromJSON(String jsonString) async {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Importer les entrées
      final entries = data['entries'] as List<dynamic>?;
      if (entries != null) {
        int imported = 0;
        for (final entryData in entries) {
          try {
            final entry = WeightEntry(
              date: DateTime.parse(entryData['date'] as String),
              weight: (entryData['weight'] as num).toDouble(),
            );
            await HiveStorageService.saveWeightEntry(entry);
            imported++;
          } catch (e) {
            // Ignorer les entrées invalides
            print('Erreur lors de l\'importation d\'une entrée: $e');
          }
        }
        
        // Importer la configuration de l'objectif si présente
        final goalData = data['goal'] as Map<String, dynamic>?;
        if (goalData != null) {
          try {
            final goal = GoalConfiguration(
              initialWeight: (goalData['initialWeight'] as num).toDouble(),
              targetWeight: (goalData['targetWeight'] as num).toDouble(),
              goalStartDate: DateTime.parse(goalData['goalStartDate'] as String),
              durationMonths: goalData['durationMonths'] as int,
              durationDays: (goalData['durationDays'] as int?) ?? 0,
              goalEndDateOverride: goalData['goalEndDateOverride'] != null
                  ? DateTime.parse(goalData['goalEndDateOverride'] as String)
                  : null,
              type: GoalType.values.firstWhere(
                (e) => e.name == goalData['type'] as String,
                orElse: () => GoalType.gain,
              ),
              unit: WeightUnit.values.firstWhere(
                (e) => e.name == goalData['unit'] as String,
                orElse: () => WeightUnit.kg,
              ),
              weekStartDay: WeekStartDay.values.firstWhere(
                (e) => e.name == goalData['weekStartDay'] as String,
                orElse: () => WeekStartDay.monday,
              ),
            );
            await GoalStorageService.updateGoalConfiguration(goal);
          } catch (e) {
            print('Erreur lors de l\'importation de la configuration: $e');
          }
        }
        
        return imported;
      }
      
      return 0;
    } catch (e) {
      throw Exception('Erreur lors de l\'importation: $e');
    }
  }

  /// Obtenir le nombre total d'entrées
  static int getEntryCount() {
    return HiveStorageService.getWeightEntries().length;
  }

  /// Obtenir la date de la première entrée
  static DateTime? getFirstEntryDate() {
    final entries = HiveStorageService.getWeightEntries();
    if (entries.isEmpty) return null;
    return entries.first.date;
  }

  /// Obtenir la date de la dernière entrée
  static DateTime? getLastEntryDate() {
    final entries = HiveStorageService.getWeightEntries();
    if (entries.isEmpty) return null;
    return entries.last.date;
  }
}
