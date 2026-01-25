import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../viewmodels/add_weight_viewmodel.dart';
import '../../../models/weight_entry.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/services/goal_storage_service.dart';
import '../../../core/services/hive_storage_service.dart';
import '../../../core/services/celebration_service.dart';
import '../../../core/models/progress_metrics.dart';
import '../../../core/widgets/celebration_overlay.dart';
import '../../../core/widgets/success_animation.dart';
import '../../../core/utils/weight_converter.dart';

class AddWeightScreen extends ConsumerStatefulWidget {
  const AddWeightScreen({super.key, this.entryToEdit});

  final WeightEntry? entryToEdit;

  @override
  ConsumerState<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends ConsumerState<AddWeightScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _weightController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late final WeightUnit _unit;
  CelebrationType? _pendingCelebration;

  bool get _isEdit => widget.entryToEdit != null;

  @override
  void initState() {
    super.initState();
    final config = GoalStorageService.getGoalConfiguration();
    _unit = config?.unit ?? WeightUnit.kg;
    final e = widget.entryToEdit;
    if (e != null) {
      final display = WeightConverter.forDisplay(e.weight, _unit);
      _weightController = TextEditingController(
        text: display.toStringAsFixed(2),
      );
      _selectedDate = DateTime(e.date.year, e.date.month, e.date.day);
      _selectedTime = TimeOfDay(hour: e.date.hour, minute: e.date.minute);
    } else {
      _weightController = TextEditingController();
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final locale = Localizations.localeOf(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: locale,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveWeight({bool skipValidation = false}) async {
    // Haptic feedback on save
    HapticFeedback.mediumImpact();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final inputWeight = double.parse(_weightController.text);
    final weight = WeightConverter.forStorage(inputWeight, _unit);
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final entry = WeightEntry(
      date: dateTime,
      weight: weight,
    );

    final viewModel = ref.read(addWeightViewModelProvider.notifier);
    final original = widget.entryToEdit;

    // Validation (add: validateEntry; edit: validateEntryForUpdate)
    if (!skipValidation) {
      final validation = original != null
          ? await viewModel.validateEntryForUpdate(entry, original)
          : await viewModel.validateEntry(entry);

      if (!validation.isValid) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validation.message ?? context.l10n.validationError),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      if (validation.isWarning && validation.requiresConfirmation) {
        if (!mounted) return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded, 
                  color: Theme.of(ctx).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(ctx.l10n.justChecking),
              ],
            ),
            content: Text(validation.message ?? ''),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(ctx.l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(ctx.l10n.yesContinue),
              ),
            ],
          ),
        );
        if (confirmed != true) return;
      }
    }

    final success = original != null
        ? await viewModel.updateWeightEntry(original, entry)
        : await viewModel.saveWeightEntry(entry);

    if (!mounted) return;

    if (success) {
      // Check for celebrations
      final entries = HiveStorageService.getWeightEntries();
      final goalConfig = GoalStorageService.getGoalConfiguration();
      final metrics = goalConfig != null
          ? ProgressMetrics.fromEntries(goalConfig, entries)
          : null;
      
      final celebrations = CelebrationService.checkCelebrations(
        entries: entries,
        metrics: metrics,
        goalConfig: goalConfig,
      );

      // Show success feedback
      if (!mounted) return;
      
      // If there's a celebration, show it instead of snackbar
      if (celebrations.isNotEmpty) {
        // Strong haptic feedback for celebrations
        HapticFeedback.heavyImpact();
        setState(() {
          _pendingCelebration = celebrations.first; // Show first celebration
        });
      } else {
        // Show success snackbar with animation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: SuccessAnimation(size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    original != null
                        ? context.l10n.weightUpdatedSuccess
                        : context.l10n.weightSavedSuccess,
                  ),
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      if (_isEdit) {
        context.pop();
      } else {
        context.go('/');
      }
    } else {
      final error = ref.read(addWeightViewModelProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errorWithMessage(error.error?.toString() ?? '')),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainContent(context),
        // Celebration overlay
        if (_pendingCelebration != null)
          Material(
            color: Colors.black54,
            child: CelebrationOverlay(
              celebrationType: _pendingCelebration!,
              onDismiss: () {
                setState(() {
                  _pendingCelebration = null;
                });
                // Navigate back after celebration (only if not editing)
                if (mounted && !_isEdit) {
                  context.pop();
                }
              },
            ),
          ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    final saveState = ref.watch(addWeightViewModelProvider);
    final isLoading = saveState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_isEdit) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          _isEdit ? context.l10n.editWeight : context.l10n.addWeight,
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Illustration
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.scale_rounded,
                    size: 100,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Champ de poids
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: _unit == WeightUnit.lbs
                        ? context.l10n.weightLbs
                        : context.l10n.weightKg,
                    hintText: context.l10n.weightHint,
                    prefixIcon: const Icon(Icons.monitor_weight_rounded),
                    suffixText: _unit == WeightUnit.lbs
                        ? context.l10n.lbsUnit
                        : context.l10n.kgUnit,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.pleaseEnterWeight;
                    }
                    final w = double.tryParse(value);
                    if (w == null || w <= 0) {
                      return _unit == WeightUnit.lbs
                          ? context.l10n.pleaseEnterValidWeightLbs
                          : context.l10n.pleaseEnterValidWeight;
                    }
                    final maxVal = _unit == WeightUnit.lbs ? 660.0 : 300.0;
                    if (w > maxVal) {
                      return _unit == WeightUnit.lbs
                          ? context.l10n.pleaseEnterValidWeightLbs
                          : context.l10n.pleaseEnterValidWeight;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                // Sélection de date
                Card(
                  child: InkWell(
                    onTap: _selectDate,
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
                                  context.l10n.date,
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
                                  DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString())
                                      .format(_selectedDate),
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
                const SizedBox(height: 12),
                
                // Sélection d'heure
                Card(
                  child: InkWell(
                    onTap: _selectTime,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.l10n.time,
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
                                  _selectedTime.format(context),
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
                const SizedBox(height: 32),
                
                // Bouton d'enregistrement
                ElevatedButton(
                  onPressed: isLoading ? null : _saveWeight,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Text(context.l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
