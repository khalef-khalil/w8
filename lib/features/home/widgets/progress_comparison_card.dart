import 'package:flutter/material.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/models/progress_metrics.dart';

/// Widget affichant la comparaison progression temps vs poids
class ProgressComparisonCard extends StatelessWidget {
  final ProgressMetrics metrics;

  const ProgressComparisonCard({
    super.key,
    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {
    final progressByTime = metrics.progressByTime;
    final progressByWeight = metrics.progressByWeight;
    final difference = progressByWeight - progressByTime;

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
                  Icons.compare_arrows_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.progressVsTime,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Barres de progression comparées
            _buildProgressBar(
              context,
              context.l10n.timeProgress,
              progressByTime,
              context.l10n.timeElapsed,
              Icons.schedule_rounded,
            ),
            const SizedBox(height: 12),
            _buildProgressBar(
              context,
              context.l10n.weightProgress,
              progressByWeight,
              context.l10n.actualChange,
              Icons.scale_rounded,
            ),
            const SizedBox(height: 16),

            // Analyse de la différence
            if (difference.abs() > 0.05)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (difference > 0
                          ? Colors.green
                          : Colors.orange)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      difference > 0 ? Icons.trending_up : Icons.trending_down,
                      color: difference > 0 ? Colors.green : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        difference > 0
                            ? context.l10n.aheadByPercent((difference * 100).toStringAsFixed(1))
                            : context.l10n.behindByPercent((difference.abs() * 100).toStringAsFixed(1)),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: difference > 0 ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.l10n.perfectlySynced,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(
    BuildContext context,
    String label,
    double progress,
    String description,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Text(
              '${(progress * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
