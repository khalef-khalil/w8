import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../core/services/data_export_service.dart';
import '../../../core/services/reminder_service.dart';
import '../../../core/services/achievement_service.dart';
import '../../../core/services/preferences_service.dart';
import '../../../core/models/achievement.dart';
import '../../../core/models/user_preferences.dart';
import '../../../core/providers/theme_provider.dart';
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
  UserPreferences? _preferences;

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
      _preferences = PreferencesService.getPreferences();
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
            // Appearance Section
            Text(
              context.l10n.appearance,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.palette_rounded),
                title: Text(context.l10n.theme),
                subtitle: Text(_getThemeLabel(context, _preferences?.themeMode ?? ThemeMode.system)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showThemeSelector(context),
              ),
            ),
            const SizedBox(height: 32),
            // Language Section
            Text(
              context.l10n.languageTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: locale,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(context.l10n.languageEnglish),
                ),
                DropdownMenuItem(
                  value: 'fr',
                  child: Text(context.l10n.languageFrench),
                ),
                DropdownMenuItem(
                  value: 'ar',
                  child: Text(context.l10n.languageArabic),
                ),
              ],
              onChanged: (String? value) {
                if (value != null) {
                  _setLocale(value);
                }
              },
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
              _DataManagementCard(
                icon: Icons.emoji_events_rounded,
                title: context.l10n.achievements,
                subtitle: context.l10n.achievementsProgress(
                  AchievementService.getUnlockedAchievements().length,
                  AchievementType.values.length,
                ),
                onTap: () => context.push('/settings/achievements'),
              ),
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
              _DataManagementCard(
                icon: Icons.school_rounded,
                title: context.l10n.tipsAndEducation,
                subtitle: context.l10n.tipsAndEducationDescription,
                onTap: () => context.push('/settings/education'),
              ),
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
                    content: DefaultTextStyle(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      child: Text(context.l10n.dataCopiedToClipboard),
                    ),
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


  String _getThemeLabel(BuildContext context, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return context.l10n.lightTheme;
      case ThemeMode.dark:
        return context.l10n.darkTheme;
      case ThemeMode.system:
        return context.l10n.systemTheme;
    }
  }

  Future<void> _showThemeSelector(BuildContext context) async {
    final currentMode = _preferences?.themeMode ?? ThemeMode.system;
    final selected = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ctx.l10n.selectTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeLabel(ctx, mode)),
              value: mode,
              groupValue: currentMode,
              onChanged: (value) => Navigator.of(ctx).pop(value),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null && selected != currentMode) {
      await ref.read(themeProvider.notifier).setThemeMode(selected);
      setState(() {
        _preferences = PreferencesService.getPreferences();
      });
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
