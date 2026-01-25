/// Time range options for chart display
enum ChartTimeRange {
  weeks4, // Last 4 weeks
  months3, // Last 3 months
  months6, // Last 6 months
  all, // All data
}

extension ChartTimeRangeExtension on ChartTimeRange {
  String getLabel(BuildContext context) {
    switch (this) {
      case ChartTimeRange.weeks4:
        return context.l10n.last4Weeks;
      case ChartTimeRange.months3:
        return context.l10n.last3Months;
      case ChartTimeRange.months6:
        return context.l10n.last6Months;
      case ChartTimeRange.all:
        return context.l10n.allTime;
    }
  }

  /// Get the start date for this time range
  DateTime? getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case ChartTimeRange.weeks4:
        return now.subtract(const Duration(days: 28));
      case ChartTimeRange.months3:
        return DateTime(now.year, now.month - 3, now.day);
      case ChartTimeRange.months6:
        return DateTime(now.year, now.month - 6, now.day);
      case ChartTimeRange.all:
        return null; // No limit
    }
  }
}
