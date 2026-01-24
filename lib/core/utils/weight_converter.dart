import '../models/goal_configuration.dart';

/// Converts between kg (storage) and lbs (display) per user preference.
class WeightConverter {
  static const double kgToLbsFactor = 2.20462;

  static double toLbs(double kg) => kg * kgToLbsFactor;
  static double toKg(double lbs) => lbs / kgToLbsFactor;

  /// Convert from storage (kg) for display. Returns same value if unit is kg.
  static double forDisplay(double kg, WeightUnit unit) {
    return unit == WeightUnit.lbs ? toLbs(kg) : kg;
  }

  /// Convert from user input to storage (kg). Input is in [unit].
  static double forStorage(double value, WeightUnit unit) {
    return unit == WeightUnit.lbs ? toKg(value) : value;
  }
}
