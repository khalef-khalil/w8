import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodels/home_viewmodel.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/weight_converter.dart';

/// Estimation calculator: weight → date, or date → weight, using current rate.
class EstimationCalculatorScreen extends ConsumerStatefulWidget {
  const EstimationCalculatorScreen({super.key});

  @override
  ConsumerState<EstimationCalculatorScreen> createState() =>
      _EstimationCalculatorScreenState();
}

class _EstimationCalculatorScreenState
    extends ConsumerState<EstimationCalculatorScreen> {
  final _targetWeightController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _targetWeightController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(now.year + 5, 12, 31),
      locale: locale,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.estimationCalculatorTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: homeState.when(
        data: (state) {
          final metrics = state.metrics;
          final unit = state.goalConfig?.unit ?? WeightUnit.kg;
          final unitStr = unit == WeightUnit.lbs ? l10n.lbsUnit : l10n.kgUnit;
          final canEstimate = metrics != null && state.entries.length >= 2;
          final rate = metrics?.currentRatePerWeek ?? 0.0;
          final currentWeight = metrics?.currentWeight;
          final rateDisplay = canEstimate && rate != 0
              ? '${rate >= 0 ? '+' : ''}${WeightConverter.forDisplay(rate.abs(), unit).toStringAsFixed(2)} $unitStr'
              : '—';

          if (!canEstimate) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.estimationCalculatorDescription,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.estimationCalculatorNeedData,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Weight → date
          final targetWeightText = _targetWeightController.text;
          final targetWeightValue = double.tryParse(targetWeightText);
          DateTime? estimatedDate;
          String? weightToDateMessage;
          if (targetWeightValue != null && currentWeight != null) {
            final targetKg = WeightConverter.forStorage(targetWeightValue, unit);
            final remaining = targetKg - currentWeight;
            if (rate == 0) {
              weightToDateMessage = l10n.estimationWeightToDateNoRate;
            } else if (remaining == 0) {
              estimatedDate = DateTime.now();
            } else {
              final sameDirection = (rate > 0 && remaining > 0) ||
                  (rate < 0 && remaining < 0);
              if (sameDirection) {
                final weeks = remaining / rate;
                final days = (weeks * 7).round();
                estimatedDate = metrics.calculationDate
                    .add(Duration(days: days));
              } else {
                weightToDateMessage = l10n.estimationWeightToDateInvalid;
              }
            }
          }

          // Date → weight
          double? estimatedWeight;
          String? dateToWeightMessage;
          if (_selectedDate != null && currentWeight != null) {
            final now = DateTime.now();
            if (_selectedDate!.isBefore(DateTime(now.year, now.month, now.day))) {
              dateToWeightMessage = l10n.estimationDateToWeightPast;
            } else {
              final daysFromNow =
                  _selectedDate!.difference(now).inDays;
              final weeksFromNow = daysFromNow / 7.0;
              final projected = metrics.projectedWeight(weeksFromNow.round());
              if (projected != null) {
                estimatedWeight = projected;
              }
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.estimationCalculatorDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    l10n.estimationCurrentRate(rateDisplay),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer,
                        ),
                  ),
                ),
                const SizedBox(height: 24),
                // When will I reach this weight?
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.estimationWeightToDate,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _targetWeightController,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            hintText: l10n.estimationWeightToDateHint,
                            suffixText: unitStr,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        if (weightToDateMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            weightToDateMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                        if (estimatedDate != null && weightToDateMessage == null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.estimationWeightToDateResult(
                                      DateFormat.yMMMMd(
                                              Localizations.localeOf(context)
                                                  .toString())
                                          .format(estimatedDate),
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // What will my weight be by this date?
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.estimationDateToWeight,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _pickDate,
                          icon: const Icon(Icons.calendar_month_rounded),
                          label: Text(
                            _selectedDate == null
                                ? l10n.estimationDateToWeightPick
                                : DateFormat.yMMMMd(
                                        Localizations.localeOf(context)
                                            .toString())
                                    .format(_selectedDate!),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                        if (dateToWeightMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            dateToWeightMessage,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ],
                        if (estimatedWeight != null &&
                            dateToWeightMessage == null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.monitor_weight_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.estimationDateToWeightResult(
                                      '${WeightConverter.forDisplay(estimatedWeight, unit).toStringAsFixed(2)} $unitStr',
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.l10n.errorLoading),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.read(homeViewModelProvider.notifier).refresh(),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
