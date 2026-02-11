import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/extensions/l10n_context.dart';

/// Tools hub: Projections, BMI Calculator, Maintenance Calories.
/// When [asTabContent] is true, only the body is built (for use in bottom nav).
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key, this.asTabContent = false});

  final bool asTabContent;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final bottomPadding = MediaQuery.of(context).padding.bottom + 32;
    final body = SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.toolsDescription,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            _ToolCard(
              icon: Icons.trending_up_rounded,
              title: l10n.toolProjections,
              subtitle: l10n.toolProjectionsDesc,
              onTap: () => context.push('/tools/projections'),
            ),
            const SizedBox(height: 12),
            _ToolCard(
              icon: Icons.monitor_weight_rounded,
              title: l10n.toolBmi,
              subtitle: l10n.toolBmiDesc,
              onTap: () => context.push('/tools/bmi'),
            ),
            const SizedBox(height: 12),
            _ToolCard(
              icon: Icons.local_fire_department_rounded,
              title: l10n.toolMaintenanceCalories,
              subtitle: l10n.toolMaintenanceCaloriesDesc,
              onTap: () => context.push('/tools/calories'),
            ),
          ],
        ),
      );

    if (asTabContent) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.toolsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: body,
    );
  }
}

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
