import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/goal_storage_service.dart';

/// Holds the app locale. Defaults to 'en' until user selects in onboarding.
class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super(GoalStorageService.getLocale() ?? 'en');

  /// Persist and switch app locale.
  Future<void> setLocale(String languageCode) async {
    await GoalStorageService.saveLocale(languageCode);
    state = languageCode;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, String>(
  (ref) => LocaleNotifier(),
);
