import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../../home/widgets/weekly_chart_card.dart';
import '../../../core/models/progress_metrics.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/weight_converter.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      data: (state) {
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(homeViewModelProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGoalVsActual(context, state),
                const SizedBox(height: 20),
                if (state.metrics != null && state.entries.length >= 2)
                  _buildOnTrackBanner(context, state.metrics!),
                if (state.metrics != null && state.entries.length >= 2)
                  const SizedBox(height: 20),
                _buildStatsRow(context, state),
                const SizedBox(height: 24),
                WeeklyChartCard(
                  entries: state.entries,
                  initialWeight: state.progress.initialWeight,
                  targetWeight: state.progress.targetWeight,
                  unit: state.goalConfig?.unit ?? WeightUnit.kg,
                  weekStartsOn:
                      state.goalConfig?.weekStartDay ?? WeekStartDay.monday,
                ),
              ],
            ),
          ),
        );
      },
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.l10n.errorLoading),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(homeViewModelProvider.notifier).refresh(),
              child: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalVsActual(BuildContext context, dynamic state) {
    final p = state.progress;
    if (p.currentWeight == null || p.targetWeight == null) {
      return const SizedBox.shrink();
    }
    final unit = state.goalConfig?.unit ?? WeightUnit.kg;
    final l10n = context.l10n;
    final unitStr = unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;
    final currentDisplay = WeightConverter.forDisplay(p.currentWeight!, unit);
    final targetDisplay = WeightConverter.forDisplay(p.targetWeight!, unit);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.currentWeight,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currentDisplay.toStringAsFixed(2)} $unitStr',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.goalWeight,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${targetDisplay.toStringAsFixed(2)} $unitStr',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              l10n.progressToGoal,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: p.progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(p.progress * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnTrackBanner(BuildContext context, ProgressMetrics metrics) {
    final comp = metrics.compareRates();
    final l10n = context.l10n;
    String label;
    IconData icon;
    Color color;
    if (comp.isOnTrack) {
      label = l10n.onTrack;
      icon = Icons.check_circle_rounded;
      color = Colors.green;
    } else if (comp.isAhead) {
      label = l10n.ahead;
      icon = Icons.trending_up_rounded;
      color = Colors.green;
    } else {
      label = l10n.behind;
      icon = Icons.trending_down_rounded;
      color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, dynamic state) {
    final p = state.progress;
    final metrics = state.metrics;
    final goalType = metrics?.goal.type ?? GoalType.gain;
    final unit = state.goalConfig?.unit ?? WeightUnit.kg;
    final l10n = context.l10n;
    final unitStr = unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;

    final progressPercent =
        p.currentWeight != null && p.targetWeight != null
            ? (p.progress * 100).toStringAsFixed(1)
            : '0';
    final weeksLeft = (p.totalWeeks - p.weeksElapsed).clamp(0, p.totalWeeks);

    final hasWeightData = p.currentWeight != null && p.targetWeight != null;
    final remainingDisplay = hasWeightData
        ? WeightConverter.forDisplay(
            (p.targetWeight! - p.currentWeight!).abs(),
            unit,
          )
        : null;
    final remainingStr = remainingDisplay != null
        ? '${remainingDisplay.toStringAsFixed(2)} $unitStr'
        : '—';
    final weightLabel = goalType == GoalType.gain
        ? l10n.weightToGoLabel
        : l10n.weightToLoseLabel;
    final weightIcon = goalType == GoalType.gain
        ? Icons.arrow_upward_rounded
        : Icons.arrow_downward_rounded;

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: l10n.progressLabel,
            value: '$progressPercent%',
            icon: Icons.pie_chart_rounded,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: weightLabel,
            value: remainingStr,
            icon: weightIcon,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: l10n.weeksLeftLabel,
            value: '$weeksLeft',
            icon: Icons.calendar_month_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style:
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style:
                  Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
