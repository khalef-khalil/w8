import 'package:flutter/material.dart';
import '../../../core/services/achievement_service.dart';
import '../../../core/models/achievement.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../l10n/app_localizations.dart';

/// Page displaying all achievements with progress
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = AchievementService.getUnlockedAchievements();
    final allTypes = AchievementType.values;
    final unlockedCount = achievements.length;
    final totalCount = allTypes.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.achievements),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).padding.bottom + 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.l10n.achievementsProgress(unlockedCount, totalCount),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        Text(
                          '${(unlockedCount / totalCount * 100).toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: unlockedCount / totalCount,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // All achievements grid
            Text(
              context.l10n.allAchievements,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemCount: allTypes.length,
              itemBuilder: (context, index) {
                final type = allTypes[index];
                final achievement = achievements.firstWhere(
                  (a) => a.type == type,
                  orElse: () => Achievement(
                    type: type,
                    unlockedAt: DateTime.now(),
                    title: Achievement.getTitle(type, context.l10n),
                    description: Achievement.getDescription(type, context.l10n),
                    icon: Achievement.getIcon(type),
                  ),
                );
                final isUnlocked = AchievementService.isUnlocked(type);

                return _AchievementCard(
                  achievement: isUnlocked ? achievement : null,
                  type: type,
                  isUnlocked: isUnlocked,
                  l10n: context.l10n,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement? achievement;
  final AchievementType type;
  final bool isUnlocked;
  final AppLocalizations l10n;

  const _AchievementCard({
    this.achievement,
    required this.type,
    required this.isUnlocked,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final title = achievement != null
        ? achievement!.title
        : Achievement.getTitle(type, l10n);
    final description = achievement != null
        ? achievement!.description
        : Achievement.getDescription(type, l10n);
    final icon = achievement != null
        ? achievement!.icon
        : Achievement.getIcon(type);

    return Tooltip(
      message: title,
      child: Card(
        color: isUnlocked
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Row(
                  children: [
                    Icon(
                      _getIconData(icon),
                      color: isUnlocked
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(title),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    if (achievement != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        context.l10n.achievementUnlocked(_formatDate(achievement!.unlockedAt)),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: Text(context.l10n.close),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getIconData(icon),
                  color: isUnlocked
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 40,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.normal,
                        color: isUnlocked
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'flag':
        return Icons.flag_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'whatshot':
        return Icons.whatshot_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'looks_one':
        return Icons.looks_one_rounded;
      case 'looks_two':
        return Icons.looks_two_rounded;
      case 'looks_3':
        return Icons.looks_3_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'verified':
        return Icons.verified_rounded;
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
