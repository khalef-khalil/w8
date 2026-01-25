import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/weekly_chart_card.dart';
import '../widgets/insights_card.dart';
import '../widgets/progress_comparison_card.dart';
import '../../../core/widgets/animated_progress_bar.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/services/pattern_recognition_service.dart';
import '../../../core/models/pattern_insight.dart';
import '../../../models/weight_entry.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/models/progress_metrics.dart';
import '../../../core/utils/weight_converter.dart';

/// Overview screen: combines Home, Progress, and Insights into one comprehensive view
class OverviewScreen extends ConsumerWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return homeState.when(
      data: (state) => RefreshIndicator(
        onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Streak card (if there are entries)
              if (state.entries.isNotEmpty) ...[
                _buildStreakCard(context, state),
                const SizedBox(height: 20),
              ],
              // Progress overview card
              _buildProgressCard(context, state),
              const SizedBox(height: 20),
              // Goal vs Actual (if we have data)
              if (state.progress.currentWeight != null && 
                  state.progress.targetWeight != null) ...[
                _buildGoalVsActual(context, state),
                const SizedBox(height: 20),
              ],
              // On-track banner (if we have enough data)
              if (state.metrics != null && state.entries.length >= 2) ...[
                _buildOnTrackBanner(context, state.metrics!),
                const SizedBox(height: 20),
              ],
              // Stats row
              if (state.progress.currentWeight != null) ...[
                _buildStatsRow(context, state),
                const SizedBox(height: 24),
              ],
              // Weekly chart
              WeeklyChartCard(
                entries: state.entries,
                initialWeight: state.progress.initialWeight,
                targetWeight: state.progress.targetWeight,
                unit: state.goalConfig?.unit ?? WeightUnit.kg,
                weekStartsOn:
                    state.goalConfig?.weekStartDay ?? WeekStartDay.monday,
              ),
              // Insights (if we have enough data)
              if (state.metrics != null && state.entries.length >= 2) ...[
                const SizedBox(height: 24),
                InsightsCard(metrics: state.metrics!),
                const SizedBox(height: 24),
                ProgressComparisonCard(metrics: state.metrics!),
                // Pattern insights (if we have context data)
                if (state.entries.any((e) => e.tags != null && !e.tags!.isEmpty)) ...[
                  const SizedBox(height: 24),
                  _buildPatternInsights(context, state.entries),
                ],
              ],
            ],
          ),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.errorLoading,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
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

  Widget _buildStreakCard(BuildContext context, HomeState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.currentStreak,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.daysInARow(state.currentStreak),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  if (state.longestStreak > state.currentStreak) ...[
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.longestStreak(state.longestStreak),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    HomeState state,
  ) {
    final progress = state.progress;
    if (progress.currentWeight == null) {
      return NoEntriesEmptyState(
        onAddWeight: () => context.go('/add-weight'),
      );
    }

    final unit = state.goalConfig?.unit ?? WeightUnit.kg;
    final l10n = context.l10n;
    final unitStr = unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;
    final currentDisplay =
        WeightConverter.forDisplay(progress.currentWeight!, unit);
    final targetDisplay = progress.targetWeight != null
        ? WeightConverter.forDisplay(progress.targetWeight!, unit)
        : null;
    final initialDisplay = progress.initialWeight != null
        ? WeightConverter.forDisplay(progress.initialWeight!, unit)
        : null;
    final gainedDisplay = WeightConverter.forDisplay(
      progress.weightGained,
      unit,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.l10n.currentWeight,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${currentDisplay.toStringAsFixed(2)} $unitStr',
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.trending_up_rounded,
                    size: 32,
                    color:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.progressToGoal,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            AnimatedProgressBar(
              progress: progress.progress,
              height: 12,
              showMilestones: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${(progress.progress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Flexible(
                  child: Text(
                    '${gainedDisplay.toStringAsFixed(2)} $unitStr / ${targetDisplay != null ? '${targetDisplay.toStringAsFixed(2)} $unitStr' : '—'}',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            if (initialDisplay != null && targetDisplay != null) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: _buildStatItem(
                      context,
                      context.l10n.start,
                      '${initialDisplay.toStringAsFixed(2)} $unitStr',
                      Icons.flag_outlined,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  Flexible(
                    child: _buildStatItem(
                      context,
                      context.l10n.goal,
                      '${targetDisplay.toStringAsFixed(2)} $unitStr',
                      Icons.flag_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGoalVsActual(BuildContext context, HomeState state) {
    final p = state.progress;
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
            AnimatedProgressBar(
              progress: p.progress.clamp(0.0, 1.0),
              height: 8,
              showMilestones: false,
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
      // Use softer language for "behind"
      label = l10n.makingProgress; // More supportive than "behind"
      icon = Icons.trending_up_rounded; // Still positive icon
      color = Colors.amber; // Softer than orange
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

  Widget _buildStatsRow(BuildContext context, HomeState state) {
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

  Widget _buildPatternInsights(BuildContext context, List<WeightEntry> entries) {
    final analysis = PatternRecognitionService.analyzePatterns(entries);

    if (!analysis.hasEnoughData || analysis.insights.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  context.l10n.patternInsights,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...analysis.insights.take(3).map((insight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            insight.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(insight.confidence * 100).toStringAsFixed(0)}%',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      insight.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (insight.suggestion != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSecondaryContainer,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                insight.suggestion!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
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
