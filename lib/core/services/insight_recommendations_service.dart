import '../models/progress_metrics.dart';
import '../models/goal_configuration.dart';

/// Service for generating actionable recommendations based on progress
class InsightRecommendationsService {
  /// Get actionable recommendations based on current progress
  static List<String> getRecommendations(ProgressMetrics metrics) {
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
          'You\'re ${deficitDisplay} $unit/week behind target. '
          'Consider reviewing your nutrition and activity levels.',
        );
        recommendations.add(
          'Small changes add up: try adding 10-15 minutes of daily activity '
          'or reducing portion sizes slightly.',
        );
      } else if (goal.type == GoalType.gain) {
        recommendations.add(
          'You\'re ${deficitDisplay} $unit/week behind target. '
          'Make sure you\'re eating enough calories and protein.',
        );
        recommendations.add(
          'Consider tracking your meals to ensure you\'re meeting your caloric goals.',
        );
      }
    } else if (comparison.isAhead) {
      recommendations.add(
        'Great progress! You\'re ahead of schedule. '
        'Keep up the consistent tracking and maintain your current approach.',
      );
    } else if (comparison.isOnTrack) {
      recommendations.add(
        'You\'re right on track! Maintain your current routine - it\'s working well.',
      );
    }

    // Recommendations based on progress percentage
    final progress = metrics.progressByWeight;
    if (progress >= 0.75 && progress < 1.0) {
      recommendations.add(
        'You\'re in the final stretch! Stay consistent - you\'re almost there!',
      );
    } else if (progress >= 0.5 && progress < 0.75) {
      recommendations.add(
        'You\'re more than halfway there! Keep the momentum going.',
      );
    } else if (progress < 0.25) {
      recommendations.add(
        'You\'re just getting started. Focus on building consistent habits - '
        'the results will follow!',
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
          'Your weight is fluctuating quite a bit. This is normal! '
          'Try weighing at the same time each day for more consistent readings.',
        );
      }
    }

    // General motivational recommendations
    if (recommendations.isEmpty) {
      recommendations.add(
        'Keep tracking consistently! Every entry helps you understand your progress better.',
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
  static String getEncouragementMessage(ProgressMetrics metrics) {
    final comparison = metrics.compareRates();
    final progress = metrics.progressByWeight;

    if (progress >= 1.0) {
      return '🎉 Congratulations! You\'ve reached your goal!';
    } else if (comparison.isAhead) {
      return 'You\'re doing amazing! Keep up the great work!';
    } else if (comparison.isOnTrack) {
      return 'You\'re right on track! Consistency is key.';
    } else if (progress >= 0.75) {
      return 'You\'re so close! Keep pushing forward!';
    } else if (progress >= 0.5) {
      return 'You\'re making great progress! Keep going!';
    } else {
      return 'Every step counts! You\'re building great habits!';
    }
  }
}
