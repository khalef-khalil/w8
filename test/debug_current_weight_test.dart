// Read-only debug: user's export data, Tuesday Feb 3 2026, week starts Monday.
// Run: flutter test test/debug_current_weight_test.dart
// No writes to app data; only exercises date/utils logic with this dataset.

import 'package:flutter_test/flutter_test.dart';
import 'package:weight_tracker/core/utils/date_utils.dart' as date_utils;
import 'package:weight_tracker/models/weight_entry.dart';
import 'package:weight_tracker/core/models/goal_configuration.dart';

void main() {
  // Exact entries from user export (read-only)
  final entries = [
    WeightEntry(date: DateTime.parse('2026-01-24T09:43:00.000'), weight: 61.15),
    WeightEntry(date: DateTime.parse('2026-01-25T08:58:00.000'), weight: 61.3),
    WeightEntry(date: DateTime.parse('2026-01-26T08:12:00.000'), weight: 61.3),
    WeightEntry(date: DateTime.parse('2026-01-27T07:53:00.000'), weight: 61.9),
    WeightEntry(date: DateTime.parse('2026-01-28T07:48:00.000'), weight: 61.6),
    WeightEntry(date: DateTime.parse('2026-01-29T09:18:00.000'), weight: 62.05),
    WeightEntry(date: DateTime.parse('2026-01-29T23:00:00.000'), weight: 63.1),
    WeightEntry(date: DateTime.parse('2026-01-30T08:26:00.000'), weight: 62.1),
    WeightEntry(date: DateTime.parse('2026-01-31T07:46:00.000'), weight: 62.5),
    WeightEntry(date: DateTime.parse('2026-02-01T08:33:00.000'), weight: 63.1),
    WeightEntry(date: DateTime.parse('2026-02-02T06:05:00.000'), weight: 63.6),
    WeightEntry(date: DateTime.parse('2026-02-03T06:10:00.000'), weight: 63.9),
  ];

  test('DEBUG: current weight source (last complete week median)', () {
    final weekStartsOn = WeekStartDay.monday;

    // 1) Print each entry's (y, m, d) and weight
    print('--- All entries (date y-m-d, weight) ---');
    for (var i = 0; i < entries.length; i++) {
      final e = entries[i];
      print('  ${i + 1}. ${e.date.year}-${e.date.month.toString().padLeft(2, '0')}-${e.date.day.toString().padLeft(2, '0')} ${e.weight}');
    }

    final startDate = entries.first.date;
    final endDate = entries.last.date;
    final firstWeekStart = date_utils.AppDateUtils.getWeekStart(startDate, weekStartsOn);
    final lastWeekStart = date_utils.AppDateUtils.getWeekStart(endDate, weekStartsOn);

    print('--- Week bounds (Monday start) ---');
    print('  firstEntry.date: ${startDate}  weekday=${startDate.weekday} (1=Mon, 7=Sun)');
    print('  lastEntry.date:  ${endDate}  weekday=${endDate.weekday}');
    print('  getWeekStart(first): $firstWeekStart');
    print('  getWeekStart(last):  $lastWeekStart');

    // 2) Last complete week = Mon Jan 26 - Sun Feb 1 (Feb 2 is Monday, start of current week)
    final weekJan26 = DateTime(2026, 1, 26);
    final weightsJan26 = date_utils.AppDateUtils.getWeeklyWeights(entries, weekJan26);
    final medianJan26 = weightsJan26.isEmpty
        ? null
        : WeightEntry.calculateMedian(weightsJan26);

    print('--- Week Mon Jan 26 - Sun Feb 1 (weekStart = 2026-01-26 00:00) ---');
    print('  getWeeklyWeights(entries, Jan26).length = ${weightsJan26.length}');
    final sortedW = List<double>.from(weightsJan26)..sort();
    print('  weights (sorted): $sortedW');
    print('  median = $medianJan26');

    // 3) What getLastCompleteWeekMedian returns
    final lastComplete = date_utils.AppDateUtils.getLastCompleteWeekMedian(
      entries,
      weekStartsOn,
    );

    print('--- getLastCompleteWeekMedian(entries, monday) ---');
    print('  result: $lastComplete');
    if (lastComplete != null) {
      print('  => currentWeight would be ${lastComplete.value}');
    }

    // 4) All complete weeks from getWeeklyMedians
    final medians = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      weekStartsOn,
      minEntries: 3,
      onlyCompleteWeeks: true,
    );
    print('--- getWeeklyMedians(onlyCompleteWeeks: true) ---');
    for (var i = 0; i < medians.length; i++) {
      final m = medians[i];
      final w = date_utils.AppDateUtils.getWeeklyWeights(entries, m.key);
      print('  week ${m.key} (y-m-d): n=${w.length} median=${m.value}  weights=$w');
    }

    // Assert: last complete week = Mon Jan 26 - Sun Feb 1 (8 entries), median (62.05+62.1)/2 = 62.075
    expect(weightsJan26.length, 8, reason: 'Week Jan26-Feb1 should have 8 entries');
    expect(medianJan26, closeTo(62.075, 0.01), reason: 'Median of 8 should be 62.075');
    if (lastComplete != null) {
      expect(lastComplete.key, DateTime(2026, 1, 26), reason: 'Last complete week should start Mon Jan 26');
      expect(lastComplete.value, closeTo(62.075, 0.01), reason: 'getLastCompleteWeekMedian should be 62.075');
    }
  });
}
