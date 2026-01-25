import '../models/progress_metrics.dart';
import '../models/goal_configuration.dart';
import '../../l10n/app_localizations.dart';

/// Service for generating actionable recommendations based on progress
class InsightRecommendationsService {
  /// Get actionable recommendations based on current progress
  static List<String> getRecommendations(ProgressMetrics metrics, AppLocalizations l10n) {
    final recommendations = <String>[];
    final comparison = metrics.compareRates();
    final goal = metrics.goal;

    // Recommendations based on progress status
    if (comparison.isBehind) {
      final deficit = (comparison.requiredRate - comparison.currentRate).abs();
      final unit = goal.unit == WeightUnit.lbs ? 'lbs' : 'kg';
      final deficitDisplay = goal.unit == WeightUnit.lbs
          ? (deficit * 2.20462).toStringAsFixed(2)
          : deficit.toStringAsFixed(2);

      if (goal.type == GoalType.loss) {
        recommendations.add(
          l10n.recommendationBehindLoss(deficitDisplay, unit),
        );
        recommendations.add(
          l10n.recommendationSmallChanges,
        );
      } else if (goal.type == GoalType.gain) {
        recommendations.add(
          l10n.recommendationBehindGain(deficitDisplay, unit),
        );
        recommendations.add(
          l10n.recommendationTrackMeals,
        );
      }
    } else if (comparison.isAhead) {
      recommendations.add(
        l10n.recommendationAhead,
      );
    } else if (comparison.isOnTrack) {
      recommendations.add(
        l10n.recommendationOnTrack,
      );
    }

    // Recommendations based on progress percentage
    final progress = metrics.progressByWeight;
    if (progress >= 0.75 && progress < 1.0) {
      recommendations.add(
        l10n.recommendationFinalStretch,
      );
    } else if (progress >= 0.5 && progress < 0.75) {
      recommendations.add(
        l10n.recommendationHalfway,
      );
    } else if (progress < 0.25) {
      recommendations.add(
        l10n.recommendationGettingStarted,
      );
    }

    // Recommendations based on volatility
    final entries = metrics.entries;
    if (entries.length >= 7) {
      final recentWeights = entries
          .sublist(entries.length - 7)
          .map((e) => e.weight)
          .toList();
      final volatility = _calculateVolatility(recentWeights);
      
      if (volatility > 0.5) {
        recommendations.add(
          l10n.recommendationVolatility,
        );
      }
    }

    // General motivational recommendations
    if (recommendations.isEmpty) {
      recommendations.add(
        l10n.recommendationGeneral,
      );
    }

    return recommendations;
  }

  /// Calculate volatility (standard deviation) of recent weights
  static double _calculateVolatility(List<double> weights) {
    if (weights.isEmpty) return 0.0;
    
    final mean = weights.reduce((a, b) => a + b) / weights.length;
    final variance = weights
        .map((w) => (w - mean) * (w - mean))
        .reduce((a, b) => a + b) / weights.length;
    
    return variance > 0 ? variance : 0.0;
  }

  /// Get encouragement message based on progress
  static String getEncouragementMessage(ProgressMetrics metrics, AppLocalizations l10n) {
    final comparison = metrics.compareRates();
    final progress = metrics.progressByWeight;

    if (progress >= 1.0) {
      return l10n.encouragementGoalReached;
    } else if (comparison.isAhead) {
      return l10n.encouragementAhead;
    } else if (comparison.isOnTrack) {
      return l10n.encouragementOnTrack;
    } else if (progress >= 0.75) {
      return l10n.encouragementClose;
    } else if (progress >= 0.5) {
      return l10n.encouragementGreatProgress;
    } else {
      return l10n.encouragementEveryStep;
    }
  }
}
