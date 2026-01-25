import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../models/user_preferences.dart';

/// Service for managing user preferences
class PreferencesService {
  static const String _prefsKey = 'user_preferences';

  /// Get user preferences
  static UserPreferences getPreferences() {
    try {
      final box = Hive.box(AppConstants.appSettingsBoxName);
      final prefsMap = box.get(_prefsKey);
      if (prefsMap is Map) {
        return UserPreferences.fromMap(Map<String, dynamic>.from(prefsMap));
      }
    } catch (e) {
      // Return defaults if error
    }
    return const UserPreferences();
  }

  /// Save user preferences
  static Future<void> savePreferences(UserPreferences preferences) async {
    try {
      final box = Hive.box(AppConstants.appSettingsBoxName);
      await box.put(_prefsKey, preferences.toMap());
    } catch (e) {
      // Silently fail
    }
  }

  /// Get theme mode
  static ThemeMode getThemeMode() {
    return getPreferences().themeMode;
  }

  /// Set theme mode
  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = getPreferences();
    await savePreferences(prefs.copyWith(themeMode: mode));
  }

  /// Get motivation type
  static MotivationType? getMotivationType() {
    return getPreferences().motivationType;
  }

  /// Set motivation type
  static Future<void> setMotivationType(MotivationType type) async {
    final prefs = getPreferences();
    await savePreferences(prefs.copyWith(motivationType: type));
  }
}
