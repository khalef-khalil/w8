/// Résultat d'une validation
class ValidationResult {
  final bool isValid;
  final bool isWarning;
  final String? message;
  final bool requiresConfirmation;

  const ValidationResult.success()
      : isValid = true,
        isWarning = false,
        message = null,
        requiresConfirmation = false;

  const ValidationResult.error(this.message)
      : isValid = false,
        isWarning = false,
        requiresConfirmation = false;

  ValidationResult.warning(
    this.message, {
    this.requiresConfirmation = false,
  })  : isValid = true,
        isWarning = true;

  /// Afficher un message approprié pour l'utilisateur
  String get displayMessage {
    if (isError) {
      return message ?? 'Erreur de validation';
    }
    if (isWarning) {
      return message ?? 'Avertissement';
    }
    return '';
  }

  bool get isError => !isValid;
}
