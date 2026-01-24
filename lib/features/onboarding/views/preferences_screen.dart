import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/week_start_day_labels.dart';

class PreferencesScreen extends ConsumerWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.preferencesTitle),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.personalizeExperience,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.configurePreferences,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(context, context.l10n.weightUnit),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOptionCard(
                      context,
                      context.l10n.kilograms,
                      WeightUnit.kg,
                      state.unit == WeightUnit.kg,
                      (value) => ref
                          .read(onboardingViewModelProvider.notifier)
                          .setUnit(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildOptionCard(
                      context,
                      context.l10n.pounds,
                      WeightUnit.lbs,
                      state.unit == WeightUnit.lbs,
                      (value) => ref
                          .read(onboardingViewModelProvider.notifier)
                          .setUnit(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(context, context.l10n.weekStartsOn),
              const SizedBox(height: 12),
              DropdownButtonFormField<WeekStartDay>(
                value: state.weekStartDay ?? WeekStartDay.monday,
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
                    ref
                        .read(onboardingViewModelProvider.notifier)
                        .setWeekStartDay(value);
                  }
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/onboarding/first-entry'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(context.l10n.continueButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildOptionCard<T>(
    BuildContext context,
    String label,
    T value,
    bool isSelected,
    void Function(T) onTap,
  ) {
    return InkWell(
      onTap: () => onTap(value),
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
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
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
