import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/profile_storage_service.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../home/viewmodels/home_viewmodel.dart';

/// Activity multiplier for TDEE (Mifflin-St Jeor BMR × activity).
double activityMultiplier(int index) {
  const values = [1.2, 1.375, 1.55, 1.725, 1.9];
  return values[index.clamp(0, values.length - 1)];
}

/// BMR Mifflin-St Jeor: weight kg, height cm, age years, isMale.
double bmrMifflinStJeor(double weightKg, double heightCm, int ageYears, bool isMale) {
  if (isMale) {
    return 10 * weightKg + 6.25 * heightCm - 5 * ageYears + 5;
  }
  return 10 * weightKg + 6.25 * heightCm - 5 * ageYears - 161;
}

/// Maintenance calories (TDEE) screen with optional intake → weight projection.
class MaintenanceCaloriesScreen extends ConsumerStatefulWidget {
  const MaintenanceCaloriesScreen({super.key});

  @override
  ConsumerState<MaintenanceCaloriesScreen> createState() =>
      _MaintenanceCaloriesScreenState();
}

class _MaintenanceCaloriesScreenState
    extends ConsumerState<MaintenanceCaloriesScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();
  final _dailyIntakeController = TextEditingController();
  final _weeksController = TextEditingController(text: '4');
  String? _gender;
  int _activityIndex = 0;

  @override
  void initState() {
    super.initState();
    final p = ProfileStorageService.getProfile();
    if (p.heightCm != null) _heightController.text = p.heightCm!.toStringAsFixed(0);
    if (p.gender != null) _gender = p.gender;
    if (p.ageYears != null) _ageController.text = p.ageYears.toString();
    final state = ref.read(homeViewModelProvider);
    state.maybeWhen(
      data: (d) {
        if (d.progress.currentWeight != null) {
          _weightController.text =
              d.progress.currentWeight!.toStringAsFixed(1);
        }
      },
      orElse: () {},
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    _dailyIntakeController.dispose();
    _weeksController.dispose();
    super.dispose();
  }

  double? _weight() {
    final v = double.tryParse(_weightController.text.trim());
    return (v != null && v > 0 && v < 300) ? v : null;
  }

  double? _height() {
    final v = double.tryParse(_heightController.text.trim());
    return (v != null && v >= 100 && v <= 250) ? v : null;
  }

  int? _age() {
    final v = int.tryParse(_ageController.text.trim());
    return (v != null && v >= 15 && v <= 120) ? v : null;
  }

  int? _weeks() {
    final v = int.tryParse(_weeksController.text.trim());
    return (v != null && v >= 1 && v <= 52) ? v : null;
  }

  int? _dailyIntake() {
    final v = int.tryParse(_dailyIntakeController.text.trim());
    return (v != null && v > 0 && v < 10000) ? v : null;
  }

  double? _tdee() {
    final w = _weight();
    final h = _height();
    final a = _age();
    if (w == null || h == null || a == null || _gender == null) return null;
    final bmr = bmrMifflinStJeor(w, h, a, _gender! == 'male');
    return bmr * activityMultiplier(_activityIndex);
  }

  /// Projected weight change: surplus/deficit vs TDEE.
  /// (intake - tdee) * days / 7700 → positive = gain, negative = loss.
  double? _projectedWeightChange() {
    final tdee = _tdee();
    final intake = _dailyIntake();
    final weeks = _weeks();
    if (tdee == null || intake == null || weeks == null) return null;
    final surplusPerDay = intake - tdee;
    final totalSurplusKcal = surplusPerDay * (weeks * 7);
    return totalSurplusKcal / 7700;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final tdee = _tdee();
    final projectedChange = _projectedWeightChange();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.maintenanceTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).padding.bottom + 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.maintenanceDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.weight, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                hintText: 'kg',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(l10n.heightCm, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _heightController,
              decoration: InputDecoration(
                hintText: l10n.heightHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(l10n.ageYears, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                hintText: '25',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text(l10n.gender, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _OptionChip(
                    label: l10n.male,
                    selected: _gender == 'male',
                    onTap: () => setState(() => _gender = 'male'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OptionChip(
                    label: l10n.female,
                    selected: _gender == 'female',
                    onTap: () => setState(() => _gender = 'female'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(l10n.activityLevel, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: _activityIndex,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.activitySedentary)),
                DropdownMenuItem(value: 1, child: Text(l10n.activityLight)),
                DropdownMenuItem(value: 2, child: Text(l10n.activityModerate)),
                DropdownMenuItem(value: 3, child: Text(l10n.activityActive)),
                DropdownMenuItem(value: 4, child: Text(l10n.activityVeryActive)),
              ],
              onChanged: (v) => setState(() => _activityIndex = v ?? 0),
            ),
            const SizedBox(height: 24),
            if (tdee != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.maintenanceTdee,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.maintenanceTdeeResult(tdee.round().toString()),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.dailyIntake,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dailyIntakeController,
                decoration: InputDecoration(
                  hintText: l10n.dailyIntakeHint,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              Text(l10n.periodWeeks, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weeksController,
                decoration: const InputDecoration(
                  hintText: '4',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (_) => setState(() {}),
              ),
              if (projectedChange != null) ...[
                const SizedBox(height: 16),
                Card(
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.projectedChange,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          projectedChange >= 0
                              ? '≈ +${projectedChange.toStringAsFixed(1)} kg over ${_weeks() ?? 0} weeks'
                              : '≈ ${projectedChange.toStringAsFixed(1)} kg over ${_weeks() ?? 0} weeks',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? theme.colorScheme.primary : theme.colorScheme.outline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: selected ? theme.colorScheme.primaryContainer : null,
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: selected ? FontWeight.w600 : null,
              color: selected ? theme.colorScheme.onPrimaryContainer : null,
            ),
          ),
        ),
      ),
    );
  }
}
