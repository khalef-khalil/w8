import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/core/services/weight_validation_service.dart';
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/core/models/goal_configuration.dart';
import 'package:weight_tracker/core/models/validation_result.dart';

void main() {
  group('WeightValidationService', () {
    test('should validate basic weight in kg', () {
      final result1 = WeightValidationService.validateBasic(70.5, WeightUnit.kg);
      expect(result1.isValid, isTrue);

      final result2 = WeightValidationService.validateBasic(0, WeightUnit.kg);
      expect(result2.isValid, isFalse);

      final result3 = WeightValidationService.validateBasic(501, WeightUnit.kg);
      expect(result3.isValid, isFalse);
    });

    test('should validate basic weight in lbs', () {
      final result1 = WeightValidationService.validateBasic(155, WeightUnit.lbs);
      expect(result1.isValid, isTrue);

      final result2 = WeightValidationService.validateBasic(0, WeightUnit.lbs);
      expect(result2.isValid, isFalse);

      final result3 = WeightValidationService.validateBasic(1101, WeightUnit.lbs);
      expect(result3.isValid, isFalse);
    });

    test('should validate first entry with goal', () async {
      final goal = GoalConfiguration(
        initialWeight: 70.0,
        targetWeight: 85.0,
        goalStartDate: DateTime(2024, 1, 1),
        durationMonths: 6,
        type: GoalType.gain,
        unit: WeightUnit.kg,
      );

      final entry = WeightEntry(
        date: DateTime.now(),
        weight: 70.2,
      );

      final result = await WeightValidationService.validateEntry(
        entry,
        [],
        goal,
      );

      expect(result.isValid, isTrue);
    });

    test('should warn on large change in one day (kg)', () async {
      final goal = GoalConfiguration(
        initialWeight: 70.0,
        targetWeight: 85.0,
        goalStartDate: DateTime(2024, 1, 1),
        durationMonths: 6,
        type: GoalType.gain,
        unit: WeightUnit.kg,
      );

      final history = [
        WeightEntry(
          date: DateTime.now().subtract(const Duration(days: 1)),
          weight: 70.0,
        ),
      ];

      final entry = WeightEntry(
        date: DateTime.now(),
        weight: 72.5, // +2.5kg in one day (suspicious)
      );

      final result = await WeightValidationService.validateEntry(
        entry,
        history,
        goal,
      );

      expect(result.isValid, isTrue);
      expect(result.isWarning, isTrue);
      expect(result.requiresConfirmation, isTrue);
    });

    test('should error on impossible change in one day (kg)', () async {
      final goal = GoalConfiguration(
        initialWeight: 70.0,
        targetWeight: 85.0,
        goalStartDate: DateTime(2024, 1, 1),
        durationMonths: 6,
        type: GoalType.gain,
        unit: WeightUnit.kg,
      );

      final history = [
        WeightEntry(
          date: DateTime.now().subtract(const Duration(days: 1)),
          weight: 70.0,
        ),
      ];

      final entry = WeightEntry(
        date: DateTime.now(),
        weight: 76.0, // +6kg in one day (impossible)
      );

      final result = await WeightValidationService.validateEntry(
        entry,
        history,
        goal,
      );

      expect(result.isValid, isFalse);
    });

    test('should warn when moving opposite to goal (loss goal, gaining)', () async {
      final goal = GoalConfiguration(
        initialWeight: 80.0,
        targetWeight: 70.0,
        goalStartDate: DateTime(2024, 1, 1),
        durationMonths: 6,
        type: GoalType.loss,
        unit: WeightUnit.kg,
      );

      final history = [
        WeightEntry(
          date: DateTime.now().subtract(const Duration(days: 1)),
          weight: 75.0,
        ),
      ];

      final entry = WeightEntry(
        date: DateTime.now(),
        weight: 76.5, // Gaining weight when goal is to lose
      );

      final result = await WeightValidationService.validateEntry(
        entry,
        history,
        goal,
      );

      expect(result.isValid, isTrue);
      expect(result.isWarning, isTrue);
      expect(result.requiresConfirmation, isTrue);
    });

    test('should use unit-aware thresholds for lbs', () async {
      final goal = GoalConfiguration(
        initialWeight: 154.0, // ~70kg in lbs
        targetWeight: 187.0, // ~85kg in lbs
        goalStartDate: DateTime(2024, 1, 1),
        durationMonths: 6,
        type: GoalType.gain,
        unit: WeightUnit.lbs,
      );

      final history = [
        WeightEntry(
          date: DateTime.now().subtract(const Duration(days: 1)),
          weight: 154.0,
        ),
      ];

      final entry = WeightEntry(
        date: DateTime.now(),
        weight: 158.0, // +4lbs (~1.8kg) - should be suspicious in lbs
      );

      final result = await WeightValidationService.validateEntry(
        entry,
        history,
        goal,
      );

      expect(result.isValid, isTrue);
      expect(result.isWarning, isTrue);
    });
  });
}
