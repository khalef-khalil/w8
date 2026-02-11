import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../models/user_profile.dart';

/// Persists user profile (height, gender, birth date) in app_settings box.
/// Call after [GoalStorageService.init()] so the settings box is open.
class ProfileStorageService {
  static const _keyHeightCm = 'profile_height_cm';
  static const _keyGender = 'profile_gender';
  static const _keyBirthDate = 'profile_birth_date';

  static Box _getBox() {
    return Hive.box(AppConstants.appSettingsBoxName);
  }

  static UserProfile getProfile() {
    final box = _getBox();
    final height = box.get(_keyHeightCm) as double?;
    final gender = box.get(_keyGender) as String?;
    final birthStr = box.get(_keyBirthDate) as String?;
    DateTime? birthDate;
    if (birthStr != null && birthStr.isNotEmpty) {
      try {
        birthDate = DateTime.parse(birthStr);
      } catch (_) {}
    }
    return UserProfile(heightCm: height, gender: gender, birthDate: birthDate);
  }

  static Future<void> saveProfile(UserProfile profile) async {
    final box = _getBox();
    await box.put(_keyHeightCm, profile.heightCm);
    await box.put(_keyGender, profile.gender);
    await box.put(
      _keyBirthDate,
      profile.birthDate?.toIso8601String(),
    );
  }
}
