import 'package:flutter/material.dart';

/// Reusable empty state widget with motivational design
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.actionLabel,
    this.onAction,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or icon
            if (illustration != null)
              illustration!
            else
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            const SizedBox(height: 24),
            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state for when there are no weight entries
class NoEntriesEmptyState extends StatelessWidget {
  final VoidCallback? onAddWeight;

  const NoEntriesEmptyState({
    super.key,
    this.onAddWeight,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'Start Your Journey',
      message: 'Track your weight to see your progress over time. Every entry brings you closer to your goal!',
      icon: Icons.scale_rounded,
      actionLabel: 'Add Your First Weight',
      onAction: onAddWeight,
      illustration: _buildIllustration(context),
    );
  }

  Widget _buildIllustration(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
          child: Icon(
            Icons.trending_up_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(context, 0.3),
            const SizedBox(width: 8),
            _buildDot(context, 0.5),
            const SizedBox(width: 8),
            _buildDot(context, 0.7),
          ],
        ),
      ],
    );
  }

  Widget _buildDot(BuildContext context, double size) {
    return Container(
      width: 40 * size,
      height: 40 * size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
      ),
    );
  }
}

/// Empty state for when there's no goal set
class NoGoalEmptyState extends StatelessWidget {
  final VoidCallback? onSetGoal;

  const NoGoalEmptyState({
    super.key,
    this.onSetGoal,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'Set Your Goal',
      message: 'Define your weight goal to track your progress and stay motivated on your journey!',
      icon: Icons.flag_rounded,
      actionLabel: 'Set Goal',
      onAction: onSetGoal,
    );
  }
}

/// Empty state for history screen
class NoHistoryEmptyState extends StatelessWidget {
  final VoidCallback? onAddWeight;

  const NoHistoryEmptyState({
    super.key,
    this.onAddWeight,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'No History Yet',
      message: 'Start tracking your weight to build your history. Consistency is key to success!',
      icon: Icons.history_rounded,
      actionLabel: 'Add Weight Entry',
      onAction: onAddWeight,
    );
  }
}

/// Empty state for insights screen
class NoInsightsEmptyState extends StatelessWidget {
  const NoInsightsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: 'Building Insights',
      message: 'Keep tracking your weight! Once you have enough data, we\'ll show you personalized insights and trends.',
      icon: Icons.insights_rounded,
    );
  }
}
