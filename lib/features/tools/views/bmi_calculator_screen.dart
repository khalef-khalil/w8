import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/profile_storage_service.dart';
import '../../../core/extensions/l10n_context.dart';
import '../../home/viewmodels/home_viewmodel.dart';
import '../widgets/bmi_gauge.dart';

/// BMI calculator: uses profile height/weight or inputs; shows gauge + BMI and category.
class BmiCalculatorScreen extends ConsumerStatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  ConsumerState<BmiCalculatorScreen> createState() =>
      _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends ConsumerState<BmiCalculatorScreen> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _useCurrentWeight = true;
  bool _saveToProfile = false;

  @override
  void initState() {
    super.initState();
    final p = ProfileStorageService.getProfile();
    if (p.heightCm != null) {
      _heightController.text = p.heightCm!.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  double? _getHeightCm() {
    final s = _heightController.text.trim();
    if (s.isEmpty) return null;
    final v = double.tryParse(s);
    if (v == null || v < 100 || v > 250) return null;
    return v;
  }

  double? _getWeightKg() {
    if (_useCurrentWeight) {
      final state = ref.read(homeViewModelProvider);
      return state.maybeWhen(
        data: (d) => d.progress.currentWeight,
        orElse: () => null,
      );
    }
    final s = _weightController.text.trim();
    if (s.isEmpty) return null;
    final v = double.tryParse(s);
    if (v == null || v <= 0) return null;
    return v;
  }

  double? _computeBmi() {
    final h = _getHeightCm();
    final w = _getWeightKg();
    if (h == null || w == null || h <= 0) return null;
    final heightM = h / 100;
    return w / (heightM * heightM);
  }

  String _bmiCategory(double bmi) {
    if (bmi < 16) return context.l10n.bmiSevereThinness;
    if (bmi < 17) return context.l10n.bmiModerateThinness;
    if (bmi < 18.5) return context.l10n.bmiMildThinness;
    if (bmi < 25) return context.l10n.bmiNormal;
    if (bmi < 30) return context.l10n.bmiOverweight;
    if (bmi < 35) return context.l10n.bmiObeseClass1;
    if (bmi < 40) return context.l10n.bmiObeseClass2;
    return context.l10n.bmiObeseClass3;
  }

  Future<void> _saveProfileIfRequested() async {
    if (!_saveToProfile) return;
    final h = _getHeightCm();
    if (h == null) return;
    final p = ProfileStorageService.getProfile();
    await ProfileStorageService.saveProfile(
      p.copyWith(heightCm: h),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final profile = ProfileStorageService.getProfile();
    final hasProfileHeight = profile.hasHeight;
    final bmi = _computeBmi();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bmiTitle),
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
              l10n.bmiDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            if (bmi != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 88),
                child: Center(
                  child: BmiGauge(
                    bmiValue: bmi,
                    categoryText: _bmiCategory(bmi),
                    size: 260,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            Text(
              l10n.heightCm,
              style: theme.textTheme.labelLarge,
            ),
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
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _useCurrentWeight,
              onChanged: (v) => setState(() {
                _useCurrentWeight = v ?? true;
                if (!_useCurrentWeight) {
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
              }),
              title: Text(l10n.useCurrentWeight),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            if (!_useCurrentWeight) ...[
              Text(
                l10n.weightForBmi,
                style: theme.textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  hintText: 'kg',
                  border: const OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                ],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
            ],
            if (!hasProfileHeight) ...[
              CheckboxListTile(
                value: _saveToProfile,
                onChanged: (v) => setState(() => _saveToProfile = v ?? false),
                title: Text(l10n.saveToProfile),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (_saveToProfile)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FilledButton(
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final message = l10n.profileSaved;
                      await _saveProfileIfRequested();
                      if (!mounted) return;
                      messenger.showSnackBar(SnackBar(content: Text(message)));
                    },
                    child: Text(l10n.save),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
