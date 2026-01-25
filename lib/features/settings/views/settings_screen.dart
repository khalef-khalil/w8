import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../core/services/data_export_service.dart';
import '../../../core/services/reminder_service.dart';
import '../../../core/services/achievement_service.dart';
import '../../../core/models/achievement.dart';
import '../../../core/models/education_content.dart';
import '../../../core/widgets/education_overlay.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/week_start_day_labels.dart';
import '../../home/viewmodels/home_viewmodel.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  GoalConfiguration? _config;
  bool _loading = true;
  bool _reminderEnabled = false;
  TimeOfDay? _reminderTime;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    setState(() {
      _config = GoalStorageService.getGoalConfiguration();
      _reminderEnabled = ReminderService.isReminderEnabled();
      _reminderTime = ReminderService.getReminderTime();
      _loading = false;
    });
  }

  Future<void> _updatePrefs({
    WeightUnit? unit,
    WeekStartDay? weekStartDay,
  }) async {
    final c = _config;
    if (c == null) return;
    try {
      final updated = c.copyWith(
        unit: unit,
        weekStartDay: weekStartDay,
      );
      await GoalStorageService.updateGoalConfiguration(updated);
      setState(() => _config = updated);
      ref.read(homeViewModelProvider.notifier).refresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.l10n.errorSaving}: $e')),
        );
      }
    }
  }

  Future<void> _setLocale(String code) async {
    await ref.read(localeProvider.notifier).setLocale(code);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final config = _config;
    final locale = ref.watch(localeProvider);
    final bottomPadding = MediaQuery.of(context).padding.bottom + 32;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(24, 24, 24, bottomPadding),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.languageTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _OptionCard(
              label: context.l10n.languageEnglish,
              isSelected: locale == 'en',
              onTap: () => _setLocale('en'),
            ),
            const SizedBox(height: 12),
            _OptionCard(
              label: context.l10n.languageFrench,
              isSelected: locale == 'fr',
              onTap: () => _setLocale('fr'),
            ),
            const SizedBox(height: 32),
            if (config != null) ...[
              Text(
                context.l10n.weightUnit,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OptionCard(
                      label: context.l10n.kilograms,
                      isSelected: config.unit == WeightUnit.kg,
                      onTap: () => _updatePrefs(unit: WeightUnit.kg),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OptionCard(
                      label: context.l10n.pounds,
                      isSelected: config.unit == WeightUnit.lbs,
                      onTap: () => _updatePrefs(unit: WeightUnit.lbs),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                context.l10n.weekStartsOn,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<WeekStartDay>(
                value: config.weekStartDay,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                items: WeekStartDay.values
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(weekStartDayLabel(context, d)),
                      ),
                    )
                    .toList(),
                onChanged: (WeekStartDay? value) {
                  if (value != null) {
                    _updatePrefs(weekStartDay: value);
                  }
                },
              ),
              const SizedBox(height: 32),
              // Reminder Section
              Text(
                context.l10n.reminders,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                child: SwitchListTile(
                  title: Text(context.l10n.enableReminders),
                  subtitle: Text(context.l10n.enableRemindersDescription),
                  value: _reminderEnabled,
                  onChanged: (value) async {
                    // Request permissions first
                    final granted = await ReminderService.requestPermissions();
                    if (!granted && value) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.l10n.notificationPermissionRequired),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      return;
                    }
                    
                    await ReminderService.setReminderEnabled(value);
                    setState(() {
                      _reminderEnabled = value;
                    });
                  },
                ),
              ),
              if (_reminderEnabled) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.access_time_rounded),
                    title: Text(context.l10n.reminderTime),
                    subtitle: Text(
                      _reminderTime != null
                          ? _reminderTime!.format(context)
                          : context.l10n.notSet,
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: _reminderTime ?? const TimeOfDay(hour: 9, minute: 0),
                      );
                      if (picked != null) {
                        await ReminderService.setReminderTime(picked);
                        setState(() {
                          _reminderTime = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
              const SizedBox(height: 32),
              // Achievements Section
              Text(
                context.l10n.achievements,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildAchievementsSection(context),
              const SizedBox(height: 32),
              // Goal Management Section
              Text(
                context.l10n.goalManagement,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _DataManagementCard(
                icon: Icons.edit_rounded,
                title: context.l10n.editGoal,
                subtitle: context.l10n.editGoalDescription,
                onTap: () => context.push('/settings/edit-goal').then((_) {
                  // Refresh when returning from edit goal
                  ref.read(homeViewModelProvider.notifier).refresh();
                }),
              ),
              const SizedBox(height: 12),
              // Tips & Education Section
              Text(
                context.l10n.tipsAndEducation,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _buildEducationSection(context),
              const SizedBox(height: 32),
              // Data Management Section
              Text(
                context.l10n.dataManagement,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              _DataManagementCard(
                icon: Icons.download_rounded,
                title: context.l10n.exportData,
                subtitle: context.l10n.exportDataDescription,
                onTap: () => _exportData(context),
              ),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    context.l10n.errorLoading,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
          ],
        ),
    );
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      // Show dialog with export options
      final format = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(ctx.l10n.exportData),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.table_chart_rounded),
                title: Text(ctx.l10n.exportAsCSV),
                subtitle: Text(ctx.l10n.exportAsCSVDescription),
                onTap: () => Navigator.of(ctx).pop('csv'),
              ),
              ListTile(
                leading: const Icon(Icons.code_rounded),
                title: Text(ctx.l10n.exportAsJSON),
                subtitle: Text(ctx.l10n.exportAsJSONDescription),
                onTap: () => Navigator.of(ctx).pop('json'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(ctx.l10n.cancel),
            ),
          ],
        ),
      );

      if (format == null) return;

      String data;
      
      if (format == 'csv') {
        data = await DataExportService.exportToCSV();
      } else {
        data = await DataExportService.exportToJSONString();
      }

      // Show data in dialog for user to copy
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(context.l10n.exportData),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.exportDataReady,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: SelectableText(
                    data,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(context.l10n.close),
            ),
            FilledButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: data));
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.l10n.dataCopiedToClipboard),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(context.l10n.copyToClipboard),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.errorExporting}: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Widget _buildAchievementsSection(BuildContext context) {
    final achievements = AchievementService.getUnlockedAchievements();
    final allTypes = AchievementType.values;
    final unlockedCount = achievements.length;
    final totalCount = allTypes.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.achievementsProgress(unlockedCount, totalCount),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${(unlockedCount / totalCount * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Show unlocked achievements
            if (achievements.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    context.l10n.noAchievementsYet,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: achievements.take(6).map((achievement) {
                  return _AchievementBadge(
                    achievement: achievement,
                    isUnlocked: true,
                  );
                }).toList(),
              ),
            if (achievements.length > 6) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full achievements screen
                },
                child: Text(context.l10n.viewAllAchievements),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducationSection(BuildContext context) {
    final allContent = EducationContentLibrary.getAllContent();
    
    return Column(
      children: allContent.map((content) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Card(
            child: ListTile(
              leading: Icon(
                _getEducationIcon(content.icon),
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(content.title),
              subtitle: Text(
                content.content.split('\n').first,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => EducationOverlay(
                    content: content,
                    onDismiss: () => Navigator.of(ctx).pop(),
                  ),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getEducationIcon(String? iconName) {
    if (iconName == null) return Icons.info_rounded;
    switch (iconName) {
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'check_circle':
        return Icons.check_circle_rounded;
      case 'pause_circle':
        return Icons.pause_circle_rounded;
      case 'insights':
        return Icons.insights_rounded;
      case 'favorite':
        return Icons.favorite_rounded;
      default:
        return Icons.info_rounded;
    }
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement? achievement;
  final AchievementType? type;
  final bool isUnlocked;
  final double progress;

  const _AchievementBadge({
    this.achievement,
    this.type,
    required this.isUnlocked,
    this.progress = 0.0,
  }) : assert(achievement != null || type != null);

  @override
  Widget build(BuildContext context) {
    final title = achievement != null
        ? achievement!.title
        : Achievement.getTitle(type!);
    final icon = achievement != null
        ? achievement!.icon
        : Achievement.getIcon(type!);

    return Tooltip(
      message: title,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isUnlocked
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isUnlocked
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: Icon(
          _getIconData(icon),
          color: isUnlocked
              ? Theme.of(context).colorScheme.onPrimaryContainer
              : Theme.of(context).colorScheme.onSurfaceVariant,
          size: 28,
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    // Map icon names to Material icons
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
}

class _DataManagementCard extends StatelessWidget {
  const _DataManagementCard({
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
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer
                          : null,
                    ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
