import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/models/progress_metrics.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/services/insight_recommendations_service.dart';
import '../../../core/utils/weight_converter.dart';

/// Widget affichant les insights avancés
class InsightsCard extends StatelessWidget {
  final ProgressMetrics metrics;

  const InsightsCard({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final comparison = metrics.compareRates();
    final predictedDate = metrics.predictGoalDate();

    return Card(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.insights,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Statut de progression
            _buildStatusSection(context, comparison),
            const SizedBox(height: 16),

            // Vitesse actuelle vs requise
            _buildRateComparison(context, comparison),
            const SizedBox(height: 16),

            // Prédiction de date
            if (predictedDate != null)
              _buildPredictionSection(context, predictedDate, comparison),
            
            // Actionable recommendations
            const SizedBox(height: 16),
            _buildRecommendationsSection(context),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, ComparisonResult comparison) {
    String statusText;
    IconData statusIcon;
    Color statusColor;

    if (comparison.isAhead) {
      statusText = context.l10n.ahead;
      statusIcon = Icons.trending_up_rounded;
      statusColor = Colors.green;
    } else if (comparison.isBehind) {
      statusText = context.l10n.behind;
      statusIcon = Icons.trending_down_rounded;
      statusColor = Colors.orange;
    } else {
      statusText = context.l10n.onTrack;
      statusIcon = Icons.check_circle_rounded;
      statusColor = Theme.of(context).colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 32,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                ),
                const SizedBox(height: 4),
                if (comparison.isAhead)
                  Text(
                    context.l10n.daysAhead(comparison.daysAhead()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                        ),
                  )
                else if (comparison.isBehind)
                  Text(
                    context.l10n.daysBehind(comparison.daysBehind()),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                        ),
                  )
                else
                  Text(
                    context.l10n.keepItUp,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: statusColor,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateComparison(BuildContext context, ComparisonResult comparison) {
    final unit = metrics.goal.unit;
    final isLbs = unit == WeightUnit.lbs;
    final currentRate = comparison.currentRate;
    final requiredRate = comparison.requiredRate;
    final currentDisplay = isLbs
        ? WeightConverter.toLbs(currentRate)
        : currentRate;
    final requiredDisplay = isLbs
        ? WeightConverter.toLbs(requiredRate)
        : requiredRate;
    final ratio = comparison.ratio;
    final rateUnit = isLbs ? context.l10n.lbsPerWeek : context.l10n.kgPerWeek;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.speedOfProgress,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRateItem(
                context,
                context.l10n.current,
                '${currentDisplay >= 0 ? '+' : ''}${currentDisplay.toStringAsFixed(2)}',
                rateUnit,
                Icons.speed_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRateItem(
                context,
                context.l10n.required,
                '${requiredDisplay >= 0 ? '+' : ''}${requiredDisplay.toStringAsFixed(2)}',
                rateUnit,
                Icons.flag_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Barre de progression de la vitesse
        Directionality(
          textDirection: Directionality.of(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.5), // Max à 150% pour ne pas dépasser
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                ratio >= 1.0
                    ? Colors.green
                    : (ratio >= 0.9 ? Colors.orange : Colors.red),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.percentOfRequired((ratio * 100).toStringAsFixed(0)),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _buildRateItem(
    BuildContext context,
    String label,
    String value,
    String unit,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionSection(
    BuildContext context,
    DateTime predictedDate,
    ComparisonResult comparison,
  ) {
    final now = DateTime.now();
    final daysUntilGoal = predictedDate.difference(now).inDays;
    final goalEndDate = metrics.goal.goalEndDate;
    final daysDifference = predictedDate.difference(goalEndDate).inDays;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.prediction,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.goalReachedInDays(daysUntilGoal > 0 ? daysUntilGoal : 0),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.estimatedDate(_formatDate(context, predictedDate)),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          if (daysDifference.abs() > 7)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                daysDifference > 0
                    ? context.l10n.daysAfterExpected(daysDifference)
                    : context.l10n.daysBeforeExpected(daysDifference.abs()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: daysDifference > 0
                          ? Colors.orange
                          : Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMMd(locale).format(date);
  }

  Widget _buildRecommendationsSection(BuildContext context) {
    final recommendations = InsightRecommendationsService.getRecommendations(metrics, context.l10n);
    final encouragement = InsightRecommendationsService.getEncouragementMessage(metrics, context.l10n);

    if (recommendations.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: Theme.of(context).colorScheme.tertiary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.recommendations,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Encouragement message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  size: 20,
                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    encouragement,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Actionable recommendations
          ...recommendations.take(2).map((recommendation) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      recommendation,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
