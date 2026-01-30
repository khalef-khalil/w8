import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/utils/weight_converter.dart';
import '../../home/viewmodels/home_viewmodel.dart';

class EditGoalScreen extends ConsumerStatefulWidget {
  const EditGoalScreen({super.key});

  @override
  ConsumerState<EditGoalScreen> createState() => _EditGoalScreenState();
}

enum _DurationMode { duration, endDate }

class _EditGoalScreenState extends ConsumerState<EditGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _initialWeightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _durationController;
  late final TextEditingController _durationDaysController;

  GoalConfiguration? _currentConfig;
  GoalType? _selectedGoalType;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  _DurationMode _durationMode = _DurationMode.duration;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentGoal();
  }

  void _loadCurrentGoal() {
    final config = GoalStorageService.getGoalConfiguration();
    setState(() {
      _currentConfig = config;
      _selectedGoalType = config?.type ?? GoalType.gain;
      _selectedStartDate = config?.goalStartDate ?? DateTime.now();
      if (config != null) {
        if (config.goalEndDateOverride != null) {
          _selectedEndDate = config.goalEndDateOverride;
          _durationMode = _DurationMode.endDate;
          final pair = _calendarMonthsAndDaysBetween(config.goalStartDate, config.goalEndDate);
          if (pair != null) {
            _durationController = TextEditingController(text: pair.$1.toString());
            _durationDaysController = TextEditingController(text: pair.$2.toString());
          } else {
            final totalDays = config.goalEndDate.difference(config.goalStartDate).inDays;
            _durationController = TextEditingController(text: (totalDays ~/ 30).toString());
            _durationDaysController = TextEditingController(text: (totalDays % 30).toString());
          }
        } else {
          _selectedEndDate = config.goalEndDate;
          _durationMode = _DurationMode.duration;
          _durationController = TextEditingController(text: config.durationMonths.toString());
          _durationDaysController = TextEditingController(text: config.durationDays.toString());
        }
        final unit = config.unit;
        _initialWeightController = TextEditingController(
          text: WeightConverter.forDisplay(config.initialWeight, unit)
              .toStringAsFixed(2),
        );
        _targetWeightController = TextEditingController(
          text: WeightConverter.forDisplay(config.targetWeight, unit)
              .toStringAsFixed(2),
        );
      } else {
        _initialWeightController = TextEditingController();
        _targetWeightController = TextEditingController();
        _durationController = TextEditingController();
        _durationDaysController = TextEditingController(text: '0');
      }
      _loading = false;
    });
  }

  @override
  void dispose() {
    _initialWeightController.dispose();
    _targetWeightController.dispose();
    _durationController.dispose();
    _durationDaysController.dispose();
    super.dispose();
  }

  Future<void> _selectGoalStartDate() async {
    final locale = Localizations.localeOf(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: locale,
      helpText: context.l10n.goalStartDate,
      cancelText: context.l10n.cancel,
      confirmText: context.l10n.confirm,
    );

    if (picked != null) {
      setState(() {
        _selectedStartDate = picked;
        if (_durationMode == _DurationMode.duration) {
          _selectedEndDate = _calculateEndDateFromDuration();
        }
      });
    }
  }

  Future<void> _selectGoalEndDate() async {
    final locale = Localizations.localeOf(context);
    final startDate = _selectedStartDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? startDate.add(const Duration(days: 180)),
      firstDate: startDate.add(const Duration(days: 30)),
      lastDate: startDate.add(const Duration(days: 730)),
      locale: locale,
      helpText: context.l10n.goalEndDate,
      cancelText: context.l10n.cancel,
      confirmText: context.l10n.confirm,
    );

    if (picked != null) {
      setState(() {
        _selectedEndDate = picked;
        if (startDate.isBefore(picked)) {
          final pair = _calendarMonthsAndDaysBetween(startDate, picked);
          if (pair != null) {
            _durationController.text = pair.$1.toString();
            _durationDaysController.text = pair.$2.toString();
          }
        }
      });
    }
  }

  /// Inverse of duration → end date: (months, days) such that
  /// start + M calendar months + D days = end. Keeps mode switching round-trip consistent.
  (int months, int days)? _calendarMonthsAndDaysBetween(DateTime start, DateTime end) {
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);
    if (!endDate.isAfter(startDate)) return null;
    int months = 0;
    for (int m = 1; m <= 24; m++) {
      final candidate = DateTime(startDate.year, startDate.month + m, startDate.day);
      if (candidate.isAfter(endDate)) break;
      months = m;
    }
    final afterMonths = DateTime(startDate.year, startDate.month + months, startDate.day);
    final days = endDate.difference(afterMonths).inDays;
    if (days < 0 || days > 31) return null;
    return (months, days);
  }

  /// Returns (months, days) for display when using end date. Uses calendar months so switching modes is round-trip consistent.
  (int months, int days)? _getDurationMonthsAndDaysFromEndDate() {
    if (_selectedStartDate == null || _selectedEndDate == null) return null;
    return _calendarMonthsAndDaysBetween(_selectedStartDate!, _selectedEndDate!);
  }

  int? _calculateDurationMonthsFromEndDate() {
    final pair = _getDurationMonthsAndDaysFromEndDate();
    return pair?.$1;
  }

  DateTime? _calculateEndDateFromDuration() {
    if (_selectedStartDate == null || _durationController.text.isEmpty) return null;
    final months = int.tryParse(_durationController.text);
    final days = int.tryParse(_durationDaysController.text) ?? 0;
    if (months == null || months < 1 || months > 24) return null;
    if (days < 0 || days > 31) return null;
    final afterMonths = DateTime(
      _selectedStartDate!.year,
      _selectedStartDate!.month + months,
      _selectedStartDate!.day,
    );
    return afterMonths.add(Duration(days: days));
  }

  void _updateGoalType(GoalType type) {
    setState(() {
      _selectedGoalType = type;
    });
  }

  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final config = _currentConfig;
    if (config == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errorLoading),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    final unit = config.unit;
    final initialWeight = WeightConverter.forStorage(
      double.parse(_initialWeightController.text),
      unit,
    );
    final targetWeight = WeightConverter.forStorage(
      double.parse(_targetWeightController.text),
      unit,
    );
    int durationMonths;
    int durationDays;
    DateTime? goalEndDateOverride;
    if (_durationMode == _DurationMode.duration) {
      if (_durationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.enterDuration),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      durationMonths = int.parse(_durationController.text);
      if (durationMonths < 1 || durationMonths > 24) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.invalidDuration),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      durationDays = int.tryParse(_durationDaysController.text) ?? 0;
      if (durationDays < 0 || durationDays > 31) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.invalidDuration),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      goalEndDateOverride = null;
    } else {
      if (_selectedEndDate == null || !_selectedEndDate!.isAfter(_selectedStartDate ?? DateTime(0))) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.invalidDuration),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      goalEndDateOverride = _selectedEndDate;
      final pair = _calendarMonthsAndDaysBetween(_selectedStartDate!, _selectedEndDate!);
      if (pair == null || pair.$1 < 1 || pair.$1 > 24 || pair.$2 < 0 || pair.$2 > 31) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.invalidDuration),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      durationMonths = pair.$1;
      durationDays = pair.$2;
    }

    final updatedConfig = GoalConfiguration(
      initialWeight: initialWeight,
      targetWeight: targetWeight,
      goalStartDate: _selectedStartDate ?? config.goalStartDate,
      durationMonths: durationMonths,
      durationDays: durationDays,
      goalEndDateOverride: goalEndDateOverride,
      type: _selectedGoalType ?? config.type,
      unit: config.unit,
      weekStartDay: config.weekStartDay,
    );

    final validation = updatedConfig.validate();
    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation.message ?? context.l10n.invalidData),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    try {
      await GoalStorageService.updateGoalConfiguration(updatedConfig);
      ref.read(homeViewModelProvider.notifier).refresh();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: DefaultTextStyle(
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            child: Text(context.l10n.goalUpdated),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${context.l10n.errorSaving}: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _currentConfig == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final config = _currentConfig!;
    final unit = config.unit;
    final unitStr = unit == WeightUnit.lbs ? context.l10n.lbsUnit : context.l10n.kgUnit;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.editGoal),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.editYourGoal,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.editGoalDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),

                // Goal type
                Text(
                  context.l10n.goalType,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildGoalTypeCard(
                        context,
                        GoalType.gain,
                        context.l10n.gain,
                        Icons.trending_up_rounded,
                        _selectedGoalType == GoalType.gain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGoalTypeCard(
                        context,
                        GoalType.loss,
                        context.l10n.lose,
                        Icons.trending_down_rounded,
                        _selectedGoalType == GoalType.loss,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGoalTypeCard(
                        context,
                        GoalType.maintain,
                        context.l10n.maintain,
                        Icons.trending_flat_rounded,
                        _selectedGoalType == GoalType.maintain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Initial weight
                TextFormField(
                  controller: _initialWeightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: unit == WeightUnit.lbs
                        ? context.l10n.initialWeightLbs
                        : context.l10n.initialWeightKg,
                    hintText: context.l10n.weightHint,
                    prefixIcon: const Icon(Icons.monitor_weight_rounded),
                    suffixText: unitStr,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterInitialWeight;
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return context.l10n.invalidWeight;
                    }
                    final maxVal = unit == WeightUnit.lbs ? 1100.0 : 500.0;
                    if (weight > maxVal) {
                      return context.l10n.invalidWeight;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Target weight
                TextFormField(
                  controller: _targetWeightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: unit == WeightUnit.lbs
                        ? context.l10n.targetWeightLbs
                        : context.l10n.targetWeightKg,
                    hintText: context.l10n.targetWeightHint,
                    prefixIcon: const Icon(Icons.flag_rounded),
                    suffixText: unitStr,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterTargetWeight;
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0) {
                      return context.l10n.invalidWeight;
                    }
                    final maxVal = unit == WeightUnit.lbs ? 1100.0 : 500.0;
                    if (weight > maxVal) {
                      return context.l10n.invalidWeight;
                    }
                    if (_selectedGoalType == GoalType.gain) {
                      final initial = double.tryParse(_initialWeightController.text);
                      if (initial != null && weight <= initial) {
                        return context.l10n.targetMustBeGreater;
                      }
                    }
                    if (_selectedGoalType == GoalType.loss) {
                      final initial = double.tryParse(_initialWeightController.text);
                      if (initial != null && weight >= initial) {
                        return context.l10n.targetMustBeLess;
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Start date
                Card(
                  child: InkWell(
                    onTap: _selectGoalStartDate,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.goalStartDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _selectedStartDate != null
                                      ? DateFormat.yMMMMEEEEd(
                                          Localizations.localeOf(context).toString())
                                          .format(_selectedStartDate!)
                                      : context.l10n.selectDate,
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                ),
                const SizedBox(height: 24),

                // Duration or End Date selection
                Text(
                  context.l10n.durationMonths,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildModeCard(
                        context,
                        _DurationMode.duration,
                        context.l10n.useDuration,
                        Icons.calendar_month_rounded,
                        _durationMode == _DurationMode.duration,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModeCard(
                        context,
                        _DurationMode.endDate,
                        context.l10n.useEndDate,
                        Icons.event_rounded,
                        _durationMode == _DurationMode.endDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Duration input (when duration mode)
                if (_durationMode == _DurationMode.duration) ...[
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: InputDecoration(
                      labelText: context.l10n.durationMonths,
                      hintText: context.l10n.durationHint,
                      prefixIcon: const Icon(Icons.calendar_month_rounded),
                      suffixText: context.l10n.monthsUnit,
                    ),
                    onChanged: (_) {
                      setState(() {
                        _selectedEndDate = _calculateEndDateFromDuration();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.l10n.enterDuration;
                      }
                      final months = int.tryParse(value);
                      if (months == null || months < 1 || months > 24) {
                        return context.l10n.invalidDuration;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _durationDaysController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: InputDecoration(
                      labelText: context.l10n.durationDays,
                      hintText: context.l10n.durationDaysHint,
                      prefixIcon: const Icon(Icons.today_rounded),
                      suffixText: context.l10n.daysUnit,
                    ),
                    onChanged: (_) {
                      setState(() {
                        _selectedEndDate = _calculateEndDateFromDuration();
                      });
                    },
                    validator: (value) {
                      final days = int.tryParse(value ?? '');
                      if (days != null && (days < 0 || days > 31)) {
                        return context.l10n.invalidDuration;
                      }
                      return null;
                    },
                  ),
                  if (_selectedEndDate != null) ...[
                    const SizedBox(height: 12),
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '${context.l10n.calculatedEndDate}: ${DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString()).format(_selectedEndDate!)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],

                // End date picker (when end date mode)
                if (_durationMode == _DurationMode.endDate) ...[
                  Card(
                    child: InkWell(
                      onTap: _selectGoalEndDate,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.event_rounded,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.goalEndDate,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedEndDate != null
                                        ? DateFormat.yMMMMEEEEd(
                                            Localizations.localeOf(context).toString())
                                            .format(_selectedEndDate!)
                                        : context.l10n.selectEndDate,
                                    style: Theme.of(context).textTheme.bodyLarge,
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
                  ),
                  if (_selectedEndDate != null) ...[
                    const SizedBox(height: 12),
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 20,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Builder(
                                builder: (context) {
                                  final pair = _getDurationMonthsAndDaysFromEndDate();
                                  final durationStr = pair == null
                                      ? '—'
                                      : pair.$2 > 0
                                          ? '${pair.$1} ${context.l10n.monthsUnit}, ${pair.$2} ${context.l10n.daysUnit}'
                                          : '${pair.$1} ${context.l10n.monthsUnit}';
                                  return Text(
                                    '${context.l10n.calculatedDuration}: $durationStr',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
                const SizedBox(height: 32),

                // Summary
                if (_initialWeightController.text.isNotEmpty &&
                    _targetWeightController.text.isNotEmpty &&
                    ((_durationMode == _DurationMode.duration && _durationController.text.isNotEmpty) ||
                     (_durationMode == _DurationMode.endDate && _selectedEndDate != null)))
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.l10n.goalSummary,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            () {
                              final months = int.tryParse(_durationController.text) ?? 0;
                              final days = int.tryParse(_durationDaysController.text) ?? 0;
                              return days > 0
                                  ? context.l10n.goalSummaryFromToWithDays(
                                      _initialWeightController.text,
                                      _targetWeightController.text,
                                      months,
                                      days,
                                    )
                                  : context.l10n.goalSummaryFromTo(
                                      _initialWeightController.text,
                                      _targetWeightController.text,
                                      months,
                                    );
                            }(),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveGoal,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(context.l10n.save),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTypeCard(
    BuildContext context,
    GoalType type,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => _updateGoalType(type),
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
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context,
    _DurationMode mode,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _durationMode = mode;
          if (mode == _DurationMode.duration && _selectedEndDate != null) {
            final pair = _getDurationMonthsAndDaysFromEndDate();
            if (pair != null) {
              _durationController.text = pair.$1.toString();
              _durationDaysController.text = pair.$2.toString();
            }
          } else if (mode == _DurationMode.endDate && _durationController.text.isNotEmpty) {
            _selectedEndDate = _calculateEndDateFromDuration();
          }
        });
      },
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
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : null,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
