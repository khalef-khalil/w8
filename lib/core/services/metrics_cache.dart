import '../models/goal_configuration.dart';
import '../utils/date_utils.dart' as date_utils;
import '../../models/weight_entry.dart';

/// Cache for calculated metrics to avoid recomputation
class MetricsCache {
  static MapEntry<List<WeightEntry>, List<MapEntry<DateTime, double>>>? _weeklyMediansCache;
  static DateTime? _cacheTimestamp;
  static const Duration _cacheExpiry = Duration(minutes: 5);

  /// Get cached weekly medians or calculate and cache them
  static List<MapEntry<DateTime, double>> getWeeklyMedians(
    List<WeightEntry> entries,
    WeekStartDay weekStartsOn,
  ) {
    // Check if cache is valid
    if (_weeklyMediansCache != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheExpiry &&
        _listEquals(_weeklyMediansCache!.key, entries)) {
      return _weeklyMediansCache!.value;
    }

    // Calculate and cache
    final medians = date_utils.AppDateUtils.getWeeklyMedians(
      entries,
      weekStartsOn,
    );
    _weeklyMediansCache = MapEntry(entries, medians);
    _cacheTimestamp = DateTime.now();
    return medians;
  }

  /// Clear the cache (call when entries are modified)
  static void clearCache() {
    _weeklyMediansCache = null;
    _cacheTimestamp = null;
  }

  /// Check if two lists of WeightEntry are equal
  static bool _listEquals(List<WeightEntry> a, List<WeightEntry> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i].date != b[i].date || a[i].weight != b[i].weight) {
        return false;
      }
    }
    return true;
  }
}
