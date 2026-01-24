import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../viewmodels/onboarding_viewmodel.dart';
import '../../../core/models/goal_configuration.dart';
import '../../../core/extensions/l10n_context.dart';

class GoalConfigurationScreen extends ConsumerStatefulWidget {
  const GoalConfigurationScreen({super.key});

  @override
  ConsumerState<GoalConfigurationScreen> createState() =>
      _GoalConfigurationScreenState();
}

class _GoalConfigurationScreenState
    extends ConsumerState<GoalConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _initialWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _durationController = TextEditingController(text: '6');

  @override
  void dispose() {
    _initialWeightController.dispose();
    _targetWeightController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialiser avec les valeurs par défaut si disponibles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(onboardingViewModelProvider);
      if (state.initialWeight != null) {
        _initialWeightController.text = state.initialWeight!.toStringAsFixed(2);
      }
      if (state.targetWeight != null) {
        _targetWeightController.text = state.targetWeight!.toStringAsFixed(2);
      }
      if (state.durationMonths != null) {
        _durationController.text = state.durationMonths!.toString();
      }
    });
  }

  Future<void> _selectGoalStartDate() async {
    final state = ref.read(onboardingViewModelProvider);
    final initialDate = state.goalStartDate ?? DateTime.now();

    final locale = Localizations.localeOf(context);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: locale,
      helpText: context.l10n.goalStartDate,
      cancelText: context.l10n.cancel,
      confirmText: context.l10n.confirm,
    );

    if (picked != null) {
      ref.read(onboardingViewModelProvider.notifier).setGoalStartDate(picked);
    }
  }

  void _updateGoalType(GoalType type) {
    ref.read(onboardingViewModelProvider.notifier).setGoalType(type);
    setState(() {});
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = ref.read(onboardingViewModelProvider.notifier);
    final validation = viewModel.validateCurrentStep(1, context.l10n);

    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validation.message ?? context.l10n.invalidData),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Sauvegarder la configuration
    final result = await viewModel.saveGoalConfiguration();

    if (!mounted) return;

    if (!result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? context.l10n.errorSaving),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Continuer vers les préférences
    context.go('/onboarding/preferences');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.goalConfigTitle),
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
                  context.l10n.whatIsYourGoal,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.configureGoal,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),

                // Type d'objectif
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
                      child:                       _buildGoalTypeCard(
                        context,
                        GoalType.gain,
                        context.l10n.gain,
                        Icons.trending_up_rounded,
                        state.goalType == GoalType.gain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGoalTypeCard(
                        context,
                        GoalType.loss,
                        context.l10n.lose,
                        Icons.trending_down_rounded,
                        state.goalType == GoalType.loss,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildGoalTypeCard(
                        context,
                        GoalType.maintain,
                        context.l10n.maintain,
                        Icons.trending_flat_rounded,
                        state.goalType == GoalType.maintain,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Poids initial
                TextFormField(
                  controller: _initialWeightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: context.l10n.initialWeightKg,
                    hintText: context.l10n.weightHint,
                    prefixIcon: const Icon(Icons.monitor_weight_rounded),
                    suffixText: 'kg',
                  ),
                  onChanged: (value) {
                    final weight = double.tryParse(value);
                    if (weight != null) {
                      ref.read(onboardingViewModelProvider.notifier)
                          .setInitialWeight(weight);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterInitialWeight;
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0 || weight > 500) {
                      return context.l10n.invalidWeight;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Poids cible
                TextFormField(
                  controller: _targetWeightController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  decoration: InputDecoration(
                    labelText: context.l10n.targetWeightKg,
                    hintText: context.l10n.targetWeightHint,
                    prefixIcon: const Icon(Icons.flag_rounded),
                    suffixText: 'kg',
                  ),
                  onChanged: (value) {
                    final weight = double.tryParse(value);
                    if (weight != null) {
                      ref.read(onboardingViewModelProvider.notifier)
                          .setTargetWeight(weight);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.l10n.enterTargetWeight;
                    }
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0 || weight > 500) {
                      return context.l10n.invalidWeight;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Date de début
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
                                  state.goalStartDate != null
                                      ? DateFormat.yMMMMEEEEd(Localizations.localeOf(context).toString())
                                          .format(state.goalStartDate!)
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

                // Durée
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
                  onChanged: (value) {
                    final months = int.tryParse(value);
                    if (months != null && months > 0) {
                      ref.read(onboardingViewModelProvider.notifier)
                          .setDurationMonths(months);
                    }
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
                const SizedBox(height: 32),

                // Résumé de l'objectif
                if (state.initialWeight != null &&
                    state.targetWeight != null &&
                    state.durationMonths != null)
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
                            context.l10n.goalSummaryFromTo(
                              state.initialWeight!.toStringAsFixed(2),
                              state.targetWeight!.toStringAsFixed(2),
                              state.durationMonths!,
                            ),
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                ),
                          ),
                          if (state.durationMonths! > 0)
                            Text(
                              context.l10n.perMonth(
                                ((state.targetWeight! - state.initialWeight!) / state.durationMonths!).toStringAsFixed(2),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

                // Bouton continuer
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continue,
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
}
