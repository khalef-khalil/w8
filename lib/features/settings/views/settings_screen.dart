import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/services/goal_storage_service.dart';
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

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  void _loadConfig() {
    setState(() {
      _config = GoalStorageService.getGoalConfiguration();
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
