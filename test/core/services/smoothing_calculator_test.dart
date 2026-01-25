import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/core/services/smoothing_calculator.dart';
import 'package:weight_tracker/models/weight_entry.dart';

void main() {
  group('SmoothingCalculator', () {
    test('should calculate rolling average for 7 days', () {
      final now = DateTime.now();
      final entries = [
        WeightEntry(date: now.subtract(const Duration(days: 1)), weight: 70.0),
        WeightEntry(date: now.subtract(const Duration(days: 2)), weight: 70.2),
        WeightEntry(date: now.subtract(const Duration(days: 3)), weight: 70.1),
        WeightEntry(date: now.subtract(const Duration(days: 4)), weight: 70.3),
        WeightEntry(date: now.subtract(const Duration(days: 5)), weight: 70.0),
        WeightEntry(date: now.subtract(const Duration(days: 6)), weight: 69.9),
        WeightEntry(date: now.subtract(const Duration(days: 7)), weight: 70.1),
      ];

      final average = SmoothingCalculator.calculateRolling7Days(entries);
      expect(average, closeTo(70.08, 0.01));
    });

    test('should return last weight if no entries in range', () {
      final now = DateTime.now();
      final entries = [
        WeightEntry(date: now.subtract(const Duration(days: 10)), weight: 70.0),
        WeightEntry(date: now.subtract(const Duration(days: 20)), weight: 69.5),
      ];

      final average = SmoothingCalculator.calculateRolling7Days(entries);
      expect(average, 70.0); // Should return last entry
    });

    test('should calculate EMA correctly', () {
      final entries = [
        WeightEntry(date: DateTime(2024, 1, 1), weight: 70.0),
        WeightEntry(date: DateTime(2024, 1, 2), weight: 70.2),
        WeightEntry(date: DateTime(2024, 1, 3), weight: 70.1),
        WeightEntry(date: DateTime(2024, 1, 4), weight: 70.3),
      ];

      final ema = SmoothingCalculator.calculateEMA(entries, 0.3);
      expect(ema, greaterThan(70.0));
      expect(ema, lessThan(70.3));
    });

    test('should calculate weighted average', () {
      final now = DateTime.now();
      final entries = [
        WeightEntry(date: now.subtract(const Duration(days: 1)), weight: 70.0),
        WeightEntry(date: now.subtract(const Duration(days: 2)), weight: 70.2),
        WeightEntry(date: now.subtract(const Duration(days: 3)), weight: 70.1),
      ];

      final weighted = SmoothingCalculator.calculateWeightedAverage(entries, 3);
      expect(weighted, greaterThan(70.0));
      expect(weighted, lessThan(70.2));
    });

    test('should handle empty list', () {
      final entries = <WeightEntry>[];
      final average = SmoothingCalculator.calculateRolling7Days(entries);
      expect(average, 0.0);
    });
  });
}
