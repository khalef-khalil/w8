import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/core/services/statistical_calculator.dart';
import 'package:weight_tracker/core/models/goal_configuration.dart';
import 'package:weight_tracker/models/weight_entry.dart';

void main() {
  group('StatisticalCalculator', () {
    final baseGoal = GoalConfiguration(
      initialWeight: 70.0,
      targetWeight: 85.0,
      goalStartDate: DateTime(2024, 1, 1),
      durationMonths: 6,
      type: GoalType.gain,
      weekStartDay: WeekStartDay.monday,
    );

    group('calculateRecentRatePerWeek', () {
      test('should calculate rate from weekly medians', () {
        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          // Week 2
          WeightEntry(date: DateTime(2024, 1, 22), weight: 71.0),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 71.2),
          WeightEntry(date: DateTime(2024, 1, 24), weight: 71.1),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
          weeksToConsider: 4,
        );

        // Should be approximately 1.0 kg/week
        expect(rate, greaterThan(0.5));
        expect(rate, lessThan(1.5));
      });

      test('should use only recent weeks when specified', () {
        final entries = <WeightEntry>[];
        // Create 6 weeks of data
        for (int week = 0; week < 6; week++) {
          for (int day = 0; day < 7; day++) {
            entries.add(WeightEntry(
              date: DateTime(2024, 1, 15).add(Duration(days: week * 7 + day)),
              weight: 70.0 + week * 0.5, // 0.5 kg/week
            ));
          }
        }

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
          weeksToConsider: 4,
        );

        // Should use only last 4 weeks
        expect(rate, greaterThan(0.3));
        expect(rate, lessThan(0.7));
      });

      test('should fallback to simple rate when insufficient weekly medians', () {
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
        );

        // Should use simple rate calculation
        expect(rate, isNot(double.nan));
        expect(rate, isNot(double.infinity));
      });

      test('should return 0.0 for empty entries', () {
        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          [],
          baseGoal,
        );
        expect(rate, 0.0);
      });

      test('should handle gaps in weekly medians', () {
        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          // Gap of 2 weeks
          // Week 4
          WeightEntry(date: DateTime(2024, 2, 5), weight: 72.0),
          WeightEntry(date: DateTime(2024, 2, 6), weight: 72.2),
          WeightEntry(date: DateTime(2024, 2, 7), weight: 72.1),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
        );

        // Should still calculate rate despite gap
        expect(rate, isNot(double.nan));
        expect(rate, isNot(double.infinity));
      });

      test('should handle loss goal correctly', () {
        final lossGoal = GoalConfiguration(
          initialWeight: 85.0,
          targetWeight: 70.0,
          goalStartDate: DateTime(2024, 1, 1),
          durationMonths: 6,
          type: GoalType.loss,
          weekStartDay: WeekStartDay.monday,
        );

        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 85.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 84.8),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 84.9),
          // Week 2
          WeightEntry(date: DateTime(2024, 1, 22), weight: 84.0),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 83.8),
          WeightEntry(date: DateTime(2024, 1, 24), weight: 83.9),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          lossGoal,
        );

        // Should be negative (losing weight)
        expect(rate, lessThan(0));
        expect(rate, greaterThan(-2.0));
      });

      test('should handle different week start days', () {
        final sundayGoal = GoalConfiguration(
          initialWeight: 70.0,
          targetWeight: 85.0,
          goalStartDate: DateTime(2024, 1, 1),
          durationMonths: 6,
          type: GoalType.gain,
          weekStartDay: WeekStartDay.sunday,
        );

        final entries = [
          // Week 1 (Sunday start)
          WeightEntry(date: DateTime(2024, 1, 14), weight: 70.0), // Sun
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.2), // Mon
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.1), // Tue
          // Week 2
          WeightEntry(date: DateTime(2024, 1, 21), weight: 71.0), // Sun
          WeightEntry(date: DateTime(2024, 1, 22), weight: 71.2), // Mon
          WeightEntry(date: DateTime(2024, 1, 23), weight: 71.1), // Tue
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          sundayGoal,
        );

        expect(rate, greaterThan(0.5));
        expect(rate, lessThan(1.5));
      });
    });

    group('Edge cases', () {
      test('should handle single complete week', () {
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
        );

        // Should fallback to simple rate
        expect(rate, isNot(double.nan));
      });

      test('should handle entries with outliers', () {
        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 200.0), // Outlier
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          // Week 2
          WeightEntry(date: DateTime(2024, 1, 22), weight: 71.0),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 71.2),
          WeightEntry(date: DateTime(2024, 1, 24), weight: 71.1),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
        );

        // Median should ignore outlier, rate should be reasonable
        expect(rate, greaterThan(0.5));
        expect(rate, lessThan(1.5));
      });

      test('should handle very slow progress', () {
        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.05),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.02),
          // Week 2
          WeightEntry(date: DateTime(2024, 1, 22), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 70.15),
          WeightEntry(date: DateTime(2024, 1, 24), weight: 70.12),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
        );

        // Should detect slow but positive rate
        expect(rate, greaterThan(0));
        expect(rate, lessThan(0.2));
      });

      test('should handle no progress (maintenance)', () {
        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.05),
          // Week 2
          WeightEntry(date: DateTime(2024, 1, 22), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 24), weight: 70.05),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          baseGoal,
        );

        // Should be close to 0
        expect(rate.abs(), lessThan(0.1));
      });

      test('should handle goal start date in future', () {
        final futureGoal = GoalConfiguration(
          initialWeight: 70.0,
          targetWeight: 85.0,
          goalStartDate: DateTime(2025, 1, 1),
          durationMonths: 6,
          type: GoalType.gain,
          weekStartDay: WeekStartDay.monday,
        );

        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
        ];

        final rate = StatisticalCalculator.calculateRecentRatePerWeek(
          entries,
          futureGoal,
        );

        // Should use simple rate calculation
        expect(rate, isNot(double.nan));
      });
    });
  });
}
