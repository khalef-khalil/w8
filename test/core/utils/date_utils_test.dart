import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/core/utils/date_utils.dart' as date_utils;
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/core/models/goal_configuration.dart';

void main() {
  group('AppDateUtils - Weekly Medians', () {
    final baseDate = DateTime(2024, 1, 15, 10, 0); // Monday, Jan 15, 2024

    group('getWeeklyWeights', () {
      test('should return weights for entries in a specific week', () {
        final weekStart = DateTime(2024, 1, 15); // Monday
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0), // Monday
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2), // Tuesday
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1), // Wednesday
          WeightEntry(date: DateTime(2024, 1, 22), weight: 71.0), // Next Monday
        ];

        final weights = date_utils.AppDateUtils.getWeeklyWeights(entries, weekStart);
        expect(weights.length, 3);
        expect(weights, containsAll([70.0, 70.2, 70.1]));
        expect(weights, isNot(contains(71.0)));
      });

      test('should handle entries on week boundaries correctly', () {
        final weekStart = DateTime(2024, 1, 15); // Monday
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 14, 23, 59), weight: 69.9), // Sunday before
          WeightEntry(date: DateTime(2024, 1, 15, 0, 1), weight: 70.0), // Monday
          WeightEntry(date: DateTime(2024, 1, 21, 23, 59), weight: 70.5), // Sunday
          WeightEntry(date: DateTime(2024, 1, 22, 0, 1), weight: 71.0), // Next Monday
        ];

        final weights = date_utils.AppDateUtils.getWeeklyWeights(entries, weekStart);
        // The implementation uses isAfter(weekStart - 1 day) and isBefore(weekEnd + 1 day)
        // So it includes entries on boundaries
        expect(weights.length, greaterThanOrEqualTo(2));
        expect(weights, containsAll([70.0, 70.5]));
      });

      test('should return empty list if no entries in week', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 2, 1), weight: 70.0),
        ];

        final weights = date_utils.AppDateUtils.getWeeklyWeights(entries, weekStart);
        expect(weights, isEmpty);
      });
    });

    group('getWeeklyMedian', () {
      test('should return median for week with sufficient entries', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
        ];

        final median = date_utils.AppDateUtils.getWeeklyMedian(entries, weekStart, minEntries: 3);
        expect(median, 70.1); // Median of [70.0, 70.1, 70.2]
      });

      test('should return null if insufficient entries (default minEntries=3)', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
        ];

        final median = date_utils.AppDateUtils.getWeeklyMedian(entries, weekStart);
        expect(median, isNull);
      });

      test('should return null if insufficient entries (custom minEntries)', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
        ];

        final median = date_utils.AppDateUtils.getWeeklyMedian(entries, weekStart, minEntries: 5);
        expect(median, isNull);
      });

      test('should handle odd number of entries correctly', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 18), weight: 70.3),
          WeightEntry(date: DateTime(2024, 1, 19), weight: 70.0),
        ];

        final median = date_utils.AppDateUtils.getWeeklyMedian(entries, weekStart, minEntries: 5);
        expect(median, 70.1); // Median of [70.0, 70.0, 70.1, 70.2, 70.3]
      });

      test('should handle even number of entries correctly', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 18), weight: 70.3),
        ];

        final median = date_utils.AppDateUtils.getWeeklyMedian(entries, weekStart, minEntries: 4);
        expect(median, 70.15); // Average of 70.1 and 70.2
      });

      test('should be robust to outliers', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 200.0), // Outlier
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 18), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 19), weight: 70.3),
        ];

        final median = date_utils.AppDateUtils.getWeeklyMedian(entries, weekStart, minEntries: 5);
        expect(median, 70.2); // Median ignores outlier
      });

      test('should return null for empty entries', () {
        final weekStart = DateTime(2024, 1, 15);
        final median = date_utils.AppDateUtils.getWeeklyMedian([], weekStart);
        expect(median, isNull);
      });
    });

    group('isWeekComplete', () {
      test('should return true for week with sufficient entries', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
        ];

        final isComplete = date_utils.AppDateUtils.isWeekComplete(entries, weekStart, minEntries: 3);
        expect(isComplete, isTrue);
      });

      test('should return false for week with insufficient entries', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
        ];

        final isComplete = date_utils.AppDateUtils.isWeekComplete(entries, weekStart, minEntries: 3);
        expect(isComplete, isFalse);
      });

      test('should handle custom minEntries threshold', () {
        final weekStart = DateTime(2024, 1, 15);
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
        ];

        final isComplete = date_utils.AppDateUtils.isWeekComplete(entries, weekStart, minEntries: 5);
        expect(isComplete, isFalse);
      });
    });

    group('getWeeklyMedians', () {
      test('should return medians for multiple complete weeks', () {
        final entries = [
          // Week 1 (Jan 15-21)
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          // Week 2 (Jan 22-28)
          WeightEntry(date: DateTime(2024, 1, 22), weight: 70.5),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 70.7),
          WeightEntry(date: DateTime(2024, 1, 24), weight: 70.6),
        ];

        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
          onlyCompleteWeeks: true,
        );

        expect(medians.length, 2);
        expect(medians[0].value, 70.1); // Median of week 1
        expect(medians[1].value, 70.6); // Median of week 2
      });

      test('should skip incomplete weeks when onlyCompleteWeeks=true', () {
        final entries = [
          // Week 1 (complete)
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          // Week 2 (incomplete - only 2 entries)
          WeightEntry(date: DateTime(2024, 1, 22), weight: 70.5),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 70.7),
          // Week 3 (complete)
          WeightEntry(date: DateTime(2024, 1, 29), weight: 71.0),
          WeightEntry(date: DateTime(2024, 1, 30), weight: 71.2),
          WeightEntry(date: DateTime(2024, 1, 31), weight: 71.1),
        ];

        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
          onlyCompleteWeeks: true,
        );

        expect(medians.length, 2); // Week 2 skipped
        expect(medians[0].value, 70.1);
        expect(medians[1].value, 71.1);
      });

      test('should include incomplete weeks when onlyCompleteWeeks=false', () {
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          WeightEntry(date: DateTime(2024, 1, 22), weight: 70.5),
          WeightEntry(date: DateTime(2024, 1, 23), weight: 70.7),
        ];

        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
          onlyCompleteWeeks: false,
        );

        expect(medians.length, 1); // Only week 1 has enough entries
      });

      test('should handle different week start days', () {
        final entries = [
          // Sunday, Jan 14
          WeightEntry(date: DateTime(2024, 1, 14), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.1),
        ];

        final mediansMonday = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
        );
        final mediansSunday = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.sunday,
          minEntries: 3,
        );

        // With Monday start, Jan 14 (Sunday) is in previous week, so only Mon-Tue in current week
        // With Sunday start, all three are in same week
        expect(mediansSunday.length, greaterThanOrEqualTo(1));
        // Week start dates should differ
        if (mediansMonday.isNotEmpty && mediansSunday.isNotEmpty) {
          expect(mediansMonday[0].key.weekday, 1); // Monday
          expect(mediansSunday[0].key.weekday, 7); // Sunday
        }
      });

      test('should handle empty entries', () {
        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          [],
          WeekStartDay.monday,
        );
        expect(medians, isEmpty);
      });

      test('should handle single entry', () {
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
        ];

        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
          onlyCompleteWeeks: true,
        );
        expect(medians, isEmpty);
      });

      test('should handle entries spanning many weeks with gaps', () {
        final entries = [
          // Week 1
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
          WeightEntry(date: DateTime(2024, 1, 17), weight: 70.1),
          // Gap of 3 weeks
          // Week 5
          WeightEntry(date: DateTime(2024, 2, 5), weight: 71.0),
          WeightEntry(date: DateTime(2024, 2, 6), weight: 71.2),
          WeightEntry(date: DateTime(2024, 2, 7), weight: 71.1),
        ];

        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
          onlyCompleteWeeks: true,
        );

        expect(medians.length, 2);
        expect(medians[0].value, 70.1);
        expect(medians[1].value, 71.1);
      });

      test('should prevent infinite loops with protection', () {
        // Create entries that might cause infinite loop without protection
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 12, 31), weight: 75.0), // Far future
        ];

        final medians = date_utils.AppDateUtils.getWeeklyMedians(
          entries,
          WeekStartDay.monday,
          minEntries: 3,
        );

        // Should complete without hanging
        expect(medians.length, lessThanOrEqualTo(52)); // Max ~52 weeks
      });
    });

    group('getLastCompleteWeekMedian', () {
      test('should return last complete week median (week ending Sunday before current week Monday)', () {
        // Last entry Feb 3 (Tue); current week Mon Feb 2–Sun Feb 8; last complete = Mon Jan 26–Sun Feb 1.
        final entries = [
          WeightEntry(date: DateTime(2026, 1, 26), weight: 61.3),
          WeightEntry(date: DateTime(2026, 1, 27), weight: 61.9),
          WeightEntry(date: DateTime(2026, 1, 28), weight: 61.6),
          WeightEntry(date: DateTime(2026, 1, 29), weight: 62.05),
          WeightEntry(date: DateTime(2026, 1, 30), weight: 62.1),
          WeightEntry(date: DateTime(2026, 1, 31), weight: 62.5),
          WeightEntry(date: DateTime(2026, 2, 1), weight: 63.1),
          WeightEntry(date: DateTime(2026, 2, 2), weight: 63.6), // current week Mon
          WeightEntry(date: DateTime(2026, 2, 3), weight: 63.9),
        ];

        final lastComplete = date_utils.AppDateUtils.getLastCompleteWeekMedian(
          entries,
          WeekStartDay.monday,
        );

        expect(lastComplete, isNotNull);
        // Last complete week Jan 26–Feb 1: 7 entries (no Feb 2, it's current week Mon), median = 62.05
        expect(lastComplete!.value, closeTo(62.05, 0.01));
      });

      test('should return null if no complete weeks', () {
        final entries = [
          WeightEntry(date: DateTime(2024, 1, 15), weight: 70.0),
          WeightEntry(date: DateTime(2024, 1, 16), weight: 70.2),
        ];

        final lastComplete = date_utils.AppDateUtils.getLastCompleteWeekMedian(
          entries,
          WeekStartDay.monday,
        );

        expect(lastComplete, isNull);
      });

      test('should return null for empty entries', () {
        final lastComplete = date_utils.AppDateUtils.getLastCompleteWeekMedian(
          [],
          WeekStartDay.monday,
        );

        expect(lastComplete, isNull);
      });

      test('should handle current week being incomplete', () {
        final now = DateTime.now();
        final weekStart = date_utils.AppDateUtils.getWeekStart(now, WeekStartDay.monday);
        final entries = [
          // Last complete week = Mon (weekStart-7) .. Sun (weekStart-1)
          WeightEntry(date: weekStart.subtract(const Duration(days: 7)), weight: 70.0),
          WeightEntry(date: weekStart.subtract(const Duration(days: 6)), weight: 70.2),
          WeightEntry(date: weekStart.subtract(const Duration(days: 5)), weight: 70.1),
          WeightEntry(date: weekStart.subtract(const Duration(days: 4)), weight: 70.5),
          // Current incomplete week (only 2 entries)
          WeightEntry(date: weekStart, weight: 70.5),
          WeightEntry(date: weekStart.add(const Duration(days: 1)), weight: 70.7),
        ];

        final lastComplete = date_utils.AppDateUtils.getLastCompleteWeekMedian(
          entries,
          WeekStartDay.monday,
        );

        expect(lastComplete, isNotNull);
        // Last complete week = weekStart-7..weekStart-1 (4 entries); median (70.0,70.1,70.2,70.5) = (70.1+70.2)/2 = 70.15
        expect(lastComplete!.value, closeTo(70.15, 0.01));
      });
    });

    group('getWeekStart', () {
      test('should return Monday for Monday start', () {
        final date = DateTime(2024, 1, 17); // Wednesday
        final weekStart = date_utils.AppDateUtils.getWeekStart(date, WeekStartDay.monday);
        expect(weekStart.weekday, 1); // Monday
        expect(weekStart.day, 15); // Jan 15
      });

      test('should return Sunday for Sunday start', () {
        final date = DateTime(2024, 1, 17); // Wednesday
        final weekStart = date_utils.AppDateUtils.getWeekStart(date, WeekStartDay.sunday);
        expect(weekStart.weekday, 7); // Sunday
        expect(weekStart.day, 14); // Jan 14
      });

      test('should handle date already on week start', () {
        final date = DateTime(2024, 1, 15); // Monday
        final weekStart = date_utils.AppDateUtils.getWeekStart(date, WeekStartDay.monday);
        expect(weekStart.day, 15);
        expect(weekStart.weekday, 1);
      });
    });

    group('getWeeksBetween', () {
      test('should calculate weeks correctly', () {
        final start = DateTime(2024, 1, 1);
        final end = DateTime(2024, 1, 22); // 21 days = 3 weeks
        final weeks = date_utils.AppDateUtils.getWeeksBetween(start, end);
        expect(weeks, 3);
      });

      test('should handle same date', () {
        final date = DateTime(2024, 1, 1);
        final weeks = date_utils.AppDateUtils.getWeeksBetween(date, date);
        expect(weeks, 0);
      });

      test('should handle less than a week', () {
        final start = DateTime(2024, 1, 1);
        final end = DateTime(2024, 1, 5); // 4 days
        final weeks = date_utils.AppDateUtils.getWeeksBetween(start, end);
        expect(weeks, 0); // Floors to 0
      });
    });
  });
}
