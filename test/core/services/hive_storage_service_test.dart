import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weight_tracker/core/services/hive_storage_service.dart';
import 'package:weight_tracker/models/weight_entry.dart';

void main() {
  group('HiveStorageService', () {
    setUpAll(() async {
      // Initialize Hive for testing
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(WeightEntryAdapter());
      }
    });

    setUp(() async {
      // Clear any existing data before each test
      try {
        final box = await Hive.openBox<WeightEntry>('weight_entries_test');
        await box.clear();
        await box.close();
      } catch (e) {
        // Box might not exist, that's okay
      }
    });

    test('should save and retrieve weight entries', () async {
      await HiveStorageService.init();
      
      final entry1 = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0),
        weight: 70.5,
      );
      final entry2 = WeightEntry(
        date: DateTime(2024, 1, 15, 20, 0), // Same day, different time
        weight: 70.8,
      );

      await HiveStorageService.saveWeightEntry(entry1);
      await HiveStorageService.saveWeightEntry(entry2);

      final entries = HiveStorageService.getWeightEntries();
      expect(entries.length, 2);
      expect(entries[0].weight, 70.5);
      expect(entries[1].weight, 70.8);
    });

    test('should support multiple entries per day', () async {
      await HiveStorageService.init();
      
      final morning = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0),
        weight: 70.5,
      );
      final evening = WeightEntry(
        date: DateTime(2024, 1, 15, 20, 0),
        weight: 70.8,
      );

      await HiveStorageService.saveWeightEntry(morning);
      await HiveStorageService.saveWeightEntry(evening);

      final entries = HiveStorageService.getWeightEntries();
      expect(entries.length, 2); // Both should be saved
      expect(entries.any((e) => e.weight == 70.5), isTrue);
      expect(entries.any((e) => e.weight == 70.8), isTrue);
    });

    test('should delete weight entry by timestamp', () async {
      await HiveStorageService.init();
      
      final entry1 = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0),
        weight: 70.5,
      );
      final entry2 = WeightEntry(
        date: DateTime(2024, 1, 15, 20, 0),
        weight: 70.8,
      );

      await HiveStorageService.saveWeightEntry(entry1);
      await HiveStorageService.saveWeightEntry(entry2);

      await HiveStorageService.deleteWeightEntry(entry1.date);

      final entries = HiveStorageService.getWeightEntries();
      expect(entries.length, 1);
      expect(entries[0].weight, 70.8);
    });

    test('should update weight entry', () async {
      await HiveStorageService.init();
      
      final original = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0),
        weight: 70.5,
      );
      final updated = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0), // Same timestamp
        weight: 70.7,
      );

      await HiveStorageService.saveWeightEntry(original);
      await HiveStorageService.updateWeightEntry(original, updated);

      final entries = HiveStorageService.getWeightEntries();
      expect(entries.length, 1);
      expect(entries[0].weight, 70.7);
    });

    test('should update weight entry with different timestamp', () async {
      await HiveStorageService.init();
      
      final original = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0),
        weight: 70.5,
      );
      final updated = WeightEntry(
        date: DateTime(2024, 1, 15, 9, 0), // Different timestamp
        weight: 70.7,
      );

      await HiveStorageService.saveWeightEntry(original);
      await HiveStorageService.updateWeightEntry(original, updated);

      final entries = HiveStorageService.getWeightEntries();
      expect(entries.length, 1);
      expect(entries[0].weight, 70.7);
      expect(entries[0].date.hour, 9);
    });

    test('should return entries sorted by date', () async {
      await HiveStorageService.init();
      
      final entry1 = WeightEntry(
        date: DateTime(2024, 1, 20, 8, 0),
        weight: 71.0,
      );
      final entry2 = WeightEntry(
        date: DateTime(2024, 1, 15, 8, 0),
        weight: 70.5,
      );
      final entry3 = WeightEntry(
        date: DateTime(2024, 1, 18, 8, 0),
        weight: 70.8,
      );

      await HiveStorageService.saveWeightEntry(entry1);
      await HiveStorageService.saveWeightEntry(entry2);
      await HiveStorageService.saveWeightEntry(entry3);

      final entries = HiveStorageService.getWeightEntries();
      expect(entries.length, 3);
      expect(entries[0].date, entry2.date);
      expect(entries[1].date, entry3.date);
      expect(entries[2].date, entry1.date);
    });
  });
}
