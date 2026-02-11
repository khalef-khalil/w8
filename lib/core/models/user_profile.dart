/// User profile data for BMI, TDEE, etc.
class UserProfile {
  final double? heightCm;
  final String? gender; // 'male' | 'female'
  final DateTime? birthDate; // for age in TDEE

  const UserProfile({
    this.heightCm,
    this.gender,
    this.birthDate,
  });

  bool get hasHeight => heightCm != null && heightCm! > 0;
  bool get hasGender => gender != null && gender!.isNotEmpty;
  bool get hasBirthDate => birthDate != null;

  /// Age in years (null if no birth date).
  int? get ageYears {
    if (birthDate == null) return null;
    final now = DateTime.now();
    var age = now.year - birthDate!.year;
    if (now.month < birthDate!.month ||
        (now.month == birthDate!.month && now.day < birthDate!.day)) {
      age--;
    }
    return age;
  }

  UserProfile copyWith({
    double? heightCm,
    String? gender,
    DateTime? birthDate,
  }) {
    return UserProfile(
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
