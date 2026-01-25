import '../../models/weight_entry.dart';
import '../utils/date_utils.dart' as date_utils;

/// Service pour calculer les streaks de suivi
class StreakService {
  /// Calculer le streak actuel (jours consécutifs avec au moins une entrée)
  static int calculateCurrentStreak(List<WeightEntry> entries) {
    if (entries.isEmpty) return 0;

    // Trier par date décroissante (plus récent en premier)
    final sorted = List<WeightEntry>.from(entries)
      ..sort((a, b) => b.date.compareTo(a.date));

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    
    int streak = 0;
    DateTime currentDate = todayStart;

    // Vérifier si aujourd'hui a une entrée
    final hasToday = sorted.any((e) => 
      date_utils.AppDateUtils.isSameDay(e.date, today)
    );

    if (!hasToday) {
      // Si pas d'entrée aujourd'hui, commencer à hier
      currentDate = currentDate.subtract(const Duration(days: 1));
    }

    // Parcourir les jours en arrière
    for (int i = 0; i < 365; i++) { // Max 365 jours
      final hasEntry = sorted.any((e) => 
        date_utils.AppDateUtils.isSameDay(e.date, currentDate)
      );

      if (hasEntry) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break; // Streak brisé
      }
    }

    return streak;
  }

  /// Calculer le streak le plus long
  static int calculateLongestStreak(List<WeightEntry> entries) {
    if (entries.isEmpty) return 0;

    // Trier par date croissante
    final sorted = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.date.compareTo(b.date));

    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;

    for (final entry in sorted) {
      final entryDate = DateTime(
        entry.date.year,
        entry.date.month,
        entry.date.day,
      );

      if (lastDate == null) {
        // Première entrée
        currentStreak = 1;
        longestStreak = 1;
      } else {
        final daysDiff = entryDate.difference(lastDate).inDays;
        
        if (daysDiff == 0) {
          // Même jour, continue le streak
          // (ne pas incrémenter, on compte les jours, pas les entrées)
        } else if (daysDiff == 1) {
          // Jour consécutif
          currentStreak++;
        } else {
          // Gap dans le streak
          longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;
          currentStreak = 1; // Recommencer
        }
      }

      lastDate = entryDate;
    }

    // Vérifier le dernier streak
    longestStreak = currentStreak > longestStreak ? currentStreak : longestStreak;

    return longestStreak;
  }

  /// Obtenir le nombre de jours depuis la dernière entrée
  static int daysSinceLastEntry(List<WeightEntry> entries) {
    if (entries.isEmpty) return 0;

    final lastEntry = entries.reduce((a, b) => 
      a.date.isAfter(b.date) ? a : b
    );

    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final lastEntryStart = DateTime(
      lastEntry.date.year,
      lastEntry.date.month,
      lastEntry.date.day,
    );

    return todayStart.difference(lastEntryStart).inDays;
  }

  /// Vérifier si l'utilisateur a une entrée aujourd'hui
  static bool hasEntryToday(List<WeightEntry> entries) {
    if (entries.isEmpty) return false;

    final today = DateTime.now();
    return entries.any((e) => 
      date_utils.AppDateUtils.isSameDay(e.date, today)
    );
  }

  /// Obtenir le nombre total de jours avec au moins une entrée
  static int totalDaysTracked(List<WeightEntry> entries) {
    if (entries.isEmpty) return 0;

    final uniqueDays = <String>{};
    for (final entry in entries) {
      final dayKey = '${entry.date.year}-${entry.date.month}-${entry.date.day}';
      uniqueDays.add(dayKey);
    }

    return uniqueDays.length;
  }
}
