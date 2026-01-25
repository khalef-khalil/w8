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
import '../../../core/services/achievement_service.dart';
import '../../../core/models/progress_metrics.dart';
import '../../../core/models/achievement.dart';
import '../../../core/models/weight_entry_tags.dart';
import '../../../core/widgets/celebration_overlay.dart';
import '../../../core/widgets/success_animation.dart';
import '../../../core/widgets/error_boundary.dart';
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
  bool _showContextSection = false;
  WeightEntryTags _tags = WeightEntryTags.empty();
  final TextEditingController _notesController = TextEditingController();

  bool get _isEdit => widget.entryToEdit != null;

  @override
  void initState() {
    super.initState();
    // Initialize tags from existing entry if editing
    if (_isEdit && widget.entryToEdit?.tags != null) {
      _tags = widget.entryToEdit!.tags!;
      _notesController.text = _tags.notes ?? '';
      _showContextSection = !_tags.isEmpty;
    }
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
    _notesController.dispose();
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

    // Build tags if context section was used
    WeightEntryTags? entryTags;
    if (_showContextSection && !_tags.isEmpty) {
      entryTags = _tags.copyWith(notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim());
    } else if (_notesController.text.trim().isNotEmpty) {
      entryTags = WeightEntryTags(notes: _notesController.text.trim());
    }

    final entry = WeightEntry(
      date: dateTime,
      weight: weight,
      tags: entryTags?.isEmpty == false ? entryTags : null,
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

    try {
      final success = original != null
          ? await viewModel.updateWeightEntry(original, entry)
          : await viewModel.saveWeightEntry(entry);

      if (!mounted) return;

      if (success) {
        // Check for celebrations and achievements
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

      // Check for new achievements
      final newAchievements = await AchievementService.checkAchievements(
        entries: entries,
        metrics: metrics,
        goalConfig: goalConfig,
      );

      // Show success feedback
      if (!mounted) return;
      
      // Handle errors gracefully
      if (!mounted) return;
      
      // If there's a celebration or achievement, show it
      if (celebrations.isNotEmpty || newAchievements.isNotEmpty) {
        // Strong haptic feedback for celebrations/achievements
        HapticFeedback.heavyImpact();
        setState(() {
          // Prioritize achievements over celebrations
          if (newAchievements.isNotEmpty) {
            // Show achievement celebration (we'll use celebration overlay for achievements too)
            final achievementType = _achievementTypeToCelebrationType(newAchievements.first.type);
            if (achievementType != null) {
              _pendingCelebration = achievementType;
            } else if (celebrations.isNotEmpty) {
              _pendingCelebration = celebrations.first;
            }
          } else if (celebrations.isNotEmpty) {
            _pendingCelebration = celebrations.first;
          }
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
    } catch (e, stackTrace) {
      // Handle errors gracefully
      if (!mounted) return;
      ErrorHandler.handleError(
        context,
        e,
        stackTrace: stackTrace,
        message: context.l10n.errorSaving,
        onRetry: _saveWeight,
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

  CelebrationType? _achievementTypeToCelebrationType(AchievementType achievementType) {
    switch (achievementType) {
      case AchievementType.firstEntry:
        return CelebrationType.firstEntry;
      case AchievementType.streak7Days:
        return CelebrationType.streak7Days;
      case AchievementType.streak30Days:
        return CelebrationType.streak30Days;
      case AchievementType.streak100Days:
        return CelebrationType.streak100Days;
      case AchievementType.progress25Percent:
        return CelebrationType.progress25Percent;
      case AchievementType.progress50Percent:
        return CelebrationType.progress50Percent;
      case AchievementType.progress75Percent:
        return CelebrationType.progress75Percent;
      case AchievementType.goalReached:
        return CelebrationType.goalReached;
      default:
        return null;
    }
  }

  Widget _buildMainContent(BuildContext context) {
    final saveState = ref.watch(addWeightViewModelProvider);
    final isLoading = saveState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_isEdit) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
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
                
                // Context tracking section (collapsible)
                Card(
                  child: ExpansionTile(
                    leading: Icon(
                      Icons.info_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(context.l10n.addContext),
                    subtitle: Text(context.l10n.addContextDescription),
                    initiallyExpanded: _showContextSection,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _showContextSection = expanded;
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Sleep quality
                            Text(
                              context.l10n.sleepQuality,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            _buildRatingSelector(
                              context,
                              value: _tags.sleepQuality,
                              onChanged: (value) {
                                setState(() {
                                  _tags = _tags.copyWith(sleepQuality: value);
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Stress level
                            Text(
                              context.l10n.stressLevel,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            _buildRatingSelector(
                              context,
                              value: _tags.stressLevel,
                              onChanged: (value) {
                                setState(() {
                                  _tags = _tags.copyWith(stressLevel: value);
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Exercise
                            Row(
                              children: [
                                Checkbox(
                                  value: _tags.exercised ?? false,
                                  onChanged: (value) {
                                    setState(() {
                                      _tags = _tags.copyWith(exercised: value);
                                    });
                                  },
                                ),
                                Text(context.l10n.exercisedToday),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Meal timing
                            Text(
                              context.l10n.mealTiming,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _tags.mealTiming,
                              decoration: InputDecoration(
                                hintText: context.l10n.selectMealTiming,
                              ),
                              items: [
                                DropdownMenuItem(value: 'before_breakfast', child: Text(context.l10n.beforeBreakfast)),
                                DropdownMenuItem(value: 'after_breakfast', child: Text(context.l10n.afterBreakfast)),
                                DropdownMenuItem(value: 'before_lunch', child: Text(context.l10n.beforeLunch)),
                                DropdownMenuItem(value: 'after_lunch', child: Text(context.l10n.afterLunch)),
                                DropdownMenuItem(value: 'before_dinner', child: Text(context.l10n.beforeDinner)),
                                DropdownMenuItem(value: 'after_dinner', child: Text(context.l10n.afterDinner)),
                                DropdownMenuItem(value: 'other', child: Text(context.l10n.other)),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _tags = _tags.copyWith(mealTiming: value);
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            // Notes
                            TextFormField(
                              controller: _notesController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: context.l10n.notes,
                                hintText: context.l10n.notesHint,
                                prefixIcon: const Icon(Icons.note_outlined),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                Semantics(
                  label: context.l10n.save,
                  button: true,
                  enabled: !isLoading,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _saveWeight,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(0, 44), // Ensure minimum touch target
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSelector(BuildContext context, {int? value, required ValueChanged<int?> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        final rating = index + 1;
        final isSelected = value == rating;
        return InkWell(
          onTap: () => onChanged(isSelected ? null : rating),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                '$rating',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
