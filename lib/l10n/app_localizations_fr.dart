// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Suivi de Poids';

  @override
  String get addWeight => 'Ajouter Poids';

  @override
  String get weightTracking => 'Suivi de Poids';

  @override
  String get retry => 'Réessayer';

  @override
  String get errorLoading => 'Erreur lors du chargement';

  @override
  String get startTrackingPrompt => 'Commencez à suivre votre poids';

  @override
  String get addFirstWeighIn => 'Ajoutez votre première pesée pour commencer';

  @override
  String get currentWeight => 'Poids Actuel';

  @override
  String get progressToGoal => 'Progrès vers l\'objectif (+15kg)';

  @override
  String get start => 'Départ';

  @override
  String get goal => 'Objectif';

  @override
  String get weeks => 'Semaines';

  @override
  String get medians => 'Médianes';

  @override
  String get notEnoughData => 'Pas assez de données';

  @override
  String get addWeighInsForChart => 'Ajoutez des pesées pour voir le graphique';

  @override
  String get weeklyEvolution => 'Évolution Hebdomadaire (Médiane)';

  @override
  String get recentWeighIns => 'Dernières Pesées';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get save => 'Enregistrer';

  @override
  String get weightSaved => 'Poids enregistré avec succès';

  @override
  String get validationError => 'Erreur de validation';

  @override
  String get warning => 'Avertissement';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get weightKg => 'Poids (kg)';

  @override
  String get weightLbs => 'Poids (lbs)';

  @override
  String get weightHint => 'Ex: 70.50';

  @override
  String get targetWeightHint => 'Ex: 85.00';

  @override
  String errorWithMessage(String message) {
    return 'Erreur : $message';
  }

  @override
  String get pleaseEnterWeight => 'Veuillez entrer un poids';

  @override
  String get pleaseEnterValidWeight =>
      'Veuillez entrer un poids valide (0-300 kg)';

  @override
  String get pleaseEnterValidWeightLbs =>
      'Veuillez entrer un poids valide (0–660 lbs)';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get register => 'Enregistrer';

  @override
  String get welcomeTitle => 'Bienvenue dans w8';

  @override
  String get welcomeSubtitle =>
      'Ton compagnon pour suivre ta progression de poids. Gagne 15kg en 6 mois ou définis ton propre objectif.';

  @override
  String get featureMedianTitle => 'Médiane hebdomadaire';

  @override
  String get featureMedianDesc =>
      'Calcule automatiquement la médiane pour lisser les fluctuations.';

  @override
  String get featureSmartTitle => 'Suivi intelligent';

  @override
  String get featureSmartDesc => 'Détecte les anomalies et valide tes données.';

  @override
  String get featureProgressTitle => 'Progression claire';

  @override
  String get featureProgressDesc =>
      'Vois où tu en es par rapport à ton objectif.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get languageTitle => 'Choisis ta langue';

  @override
  String get languageSubtitle =>
      'L\'app utilisera cette langue. Tu pourras la modifier plus tard dans les paramètres.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get goalConfigTitle => 'Configuration de l\'objectif';

  @override
  String get whatIsYourGoal => 'Quel est ton objectif ?';

  @override
  String get configureGoal => 'Configure ton objectif personnalisé';

  @override
  String get goalType => 'Type d\'objectif';

  @override
  String get gain => 'Gagner';

  @override
  String get lose => 'Perdre';

  @override
  String get maintain => 'Maintenir';

  @override
  String get initialWeightKg => 'Poids initial (kg)';

  @override
  String get targetWeightKg => 'Poids cible (kg)';

  @override
  String get goalStartDate => 'Date de début de l\'objectif';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get durationMonths => 'Durée (mois)';

  @override
  String get durationHint => 'Ex: 6';

  @override
  String get continueButton => 'Continuer';

  @override
  String get goalSummary => 'Résumé de ton objectif';

  @override
  String goalSummaryFromTo(String initial, String target, int months) {
    return 'Passer de ${initial}kg à ${target}kg en $months mois';
  }

  @override
  String perMonth(String rate) {
    return '≈ $rate kg/mois';
  }

  @override
  String get enterInitialWeight => 'Entrez un poids initial';

  @override
  String get enterTargetWeight => 'Entrez un poids cible';

  @override
  String get enterDuration => 'Entrez une durée';

  @override
  String get invalidWeight => 'Poids invalide (0-500 kg)';

  @override
  String get invalidDuration => 'Durée invalide (1-24 mois)';

  @override
  String get targetMustBeGreater =>
      'Le poids cible doit être supérieur au poids initial.';

  @override
  String get targetMustBeLess =>
      'Le poids cible doit être inférieur au poids initial.';

  @override
  String get errorSaving => 'Erreur lors de la sauvegarde';

  @override
  String get invalidData => 'Données invalides';

  @override
  String get selectGoalType => 'Sélectionne un type d\'objectif';

  @override
  String get invalidGoalStartDate => 'Date de début invalide';

  @override
  String get preferencesTitle => 'Préférences';

  @override
  String get personalizeExperience => 'Personnalise ton expérience';

  @override
  String get configurePreferences =>
      'Configure tes préférences pour une expérience optimale';

  @override
  String get weightUnit => 'Unité de poids';

  @override
  String get kilograms => 'Kilogrammes (kg)';

  @override
  String get pounds => 'Livres (lbs)';

  @override
  String get weekStartsOn => 'Début de semaine';

  @override
  String get monday => 'Lundi';

  @override
  String get tuesday => 'Mardi';

  @override
  String get wednesday => 'Mercredi';

  @override
  String get thursday => 'Jeudi';

  @override
  String get friday => 'Vendredi';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get firstWeighInTitle => 'Première pesée';

  @override
  String get addFirstWeighInTitle => 'Ajoute ta première pesée';

  @override
  String yourGoalIs(String initial, String target, int months) {
    return 'Ton objectif : ${initial}kg → ${target}kg en $months mois';
  }

  @override
  String initialWeightConfigured(String weight) {
    return 'Poids initial configuré : ${weight}kg';
  }

  @override
  String get weightVeryDifferent =>
      'Poids très différent du poids initial. Vérifiez votre saisie.';

  @override
  String get finishAndStart => 'Terminer et commencer';

  @override
  String get insights => 'Insights';

  @override
  String get ahead => 'En avance';

  @override
  String get behind => 'En retard';

  @override
  String get onTrack => 'Sur la bonne voie';

  @override
  String daysAhead(int count) {
    return '$count jours d\'avance';
  }

  @override
  String daysBehind(int count) {
    return '$count jours de retard';
  }

  @override
  String get keepItUp => 'Continue comme ça !';

  @override
  String get speedOfProgress => 'Vitesse de progression';

  @override
  String get current => 'Actuelle';

  @override
  String get required => 'Requise';

  @override
  String get kgPerWeek => 'kg/semaine';

  @override
  String percentOfRequired(String percent) {
    return '$percent% de la vitesse requise';
  }

  @override
  String get prediction => 'Prédiction';

  @override
  String goalReachedInDays(int count) {
    return 'Objectif atteint dans $count jours';
  }

  @override
  String estimatedDate(String date) {
    return 'Date estimée : $date';
  }

  @override
  String daysAfterExpected(int count) {
    return '$count jours après la date prévue';
  }

  @override
  String daysBeforeExpected(int count) {
    return '$count jours avant la date prévue';
  }

  @override
  String get progressVsTime => 'Progression : Temps vs Poids';

  @override
  String get timeProgress => 'Progression temporelle';

  @override
  String get timeElapsed => 'Temps écoulé';

  @override
  String get weightProgress => 'Progression poids';

  @override
  String get actualChange => 'Gain/perte réel';

  @override
  String aheadByPercent(String percent) {
    return 'En avance de $percent%';
  }

  @override
  String behindByPercent(String percent) {
    return 'En retard de $percent%';
  }

  @override
  String get perfectlySynced => 'Parfaitement synchronisé avec l\'objectif';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get progressTitle => 'Progression';

  @override
  String get historyTitle => 'Historique';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get navHome => 'Accueil';

  @override
  String get navProgress => 'Progression';

  @override
  String get navHistory => 'Historique';

  @override
  String get navInsights => 'Insights';

  @override
  String get navSettings => 'Paramètres';

  @override
  String get navOverview => 'Vue d\'ensemble';

  @override
  String get overviewTitle => 'Vue d\'ensemble';

  @override
  String get monthsUnit => 'mois';

  @override
  String get kgUnit => 'kg';

  @override
  String get lbsUnit => 'lbs';

  @override
  String get lbsPerWeek => 'lbs/semaine';

  @override
  String get progressLabel => 'Progression';

  @override
  String weightToGo(String value) {
    return '$value kg à prendre';
  }

  @override
  String weightToLose(String value) {
    return '$value kg à perdre';
  }

  @override
  String get weightToGoLabel => 'À prendre';

  @override
  String get weightToLoseLabel => 'À perdre';

  @override
  String weeksLeft(int count) {
    return '$count semaines restantes';
  }

  @override
  String get weeksLeftLabel => 'Semaines restantes';

  @override
  String get goalWeight => 'Poids objectif';

  @override
  String get chartGoalLine => 'Objectif';

  @override
  String get chartStartLine => 'Départ';

  @override
  String get edit => 'Modifier';

  @override
  String get delete => 'Supprimer';

  @override
  String get editWeight => 'Modifier la pesée';

  @override
  String get deleteEntryTitle => 'Supprimer cette pesée ?';

  @override
  String get deleteEntryMessage => 'Cette action est irréversible.';

  @override
  String get entryDeleted => 'Pesée supprimée';

  @override
  String get weightUpdated => 'Pesée mise à jour';

  @override
  String get dataManagement => 'Gestion des données';

  @override
  String get exportData => 'Exporter les données';

  @override
  String get exportDataDescription =>
      'Exporter tes données de poids au format CSV ou JSON';

  @override
  String get exportAsCSV => 'Exporter en CSV';

  @override
  String get exportAsCSVDescription =>
      'Format valeurs séparées par des virgules, facile à ouvrir dans Excel';

  @override
  String get exportAsJSON => 'Exporter en JSON';

  @override
  String get exportAsJSONDescription =>
      'Format JSON avec toutes les données incluant la configuration de l\'objectif';

  @override
  String get exportDataReady => 'Tes données sont prêtes à être copiées :';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get dataCopiedToClipboard => 'Données copiées dans le presse-papiers';

  @override
  String get errorExporting => 'Erreur lors de l\'exportation';

  @override
  String get close => 'Fermer';

  @override
  String get currentStreak => 'Série actuelle';

  @override
  String daysInARow(int count) {
    return '$count jours d\'affilée';
  }

  @override
  String longestStreak(int count) {
    return 'Record : $count jours';
  }

  @override
  String get makingProgress => 'En progression';

  @override
  String get justChecking => 'Vérification';

  @override
  String get yesContinue => 'Oui, continuer';

  @override
  String get weightSavedSuccess => 'Parfait ! Poids enregistré avec succès';

  @override
  String get weightUpdatedSuccess =>
      'Mis à jour ! Ton entrée a été sauvegardée';

  @override
  String get editGoal => 'Modifier l\'objectif';

  @override
  String get editYourGoal => 'Modifier ton objectif';

  @override
  String get editGoalDescription =>
      'Mettre à jour les paramètres de ton objectif';

  @override
  String get goalManagement => 'Gestion de l\'objectif';

  @override
  String get goalUpdated => 'Objectif mis à jour avec succès';

  @override
  String get initialWeightLbs => 'Poids initial (lbs)';

  @override
  String get targetWeightLbs => 'Poids cible (lbs)';

  @override
  String get reminders => 'Rappels';

  @override
  String get enableReminders => 'Activer les rappels quotidiens';

  @override
  String get enableRemindersDescription =>
      'Recevoir une notification pour enregistrer ton poids';

  @override
  String get reminderTime => 'Heure du rappel';

  @override
  String get notificationPermissionRequired =>
      'La permission de notification est requise pour activer les rappels';

  @override
  String get notSet => 'Non défini';

  @override
  String get achievements => 'Succès';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked sur $total débloqués';
  }

  @override
  String get noAchievementsYet =>
      'Continue à suivre pour débloquer des succès !';

  @override
  String get viewAllAchievements => 'Voir tout';

  @override
  String get addContext => 'Ajouter du contexte (optionnel)';

  @override
  String get addContextDescription =>
      'Suivre les facteurs qui peuvent affecter ton poids';

  @override
  String get sleepQuality => 'Qualité du sommeil';

  @override
  String get stressLevel => 'Niveau de stress';

  @override
  String get exercisedToday => 'Exercice aujourd\'hui';

  @override
  String get mealTiming => 'Moment du repas';

  @override
  String get selectMealTiming => 'Sélectionne quand tu t\'es pesé';

  @override
  String get beforeBreakfast => 'Avant le petit-déjeuner';

  @override
  String get afterBreakfast => 'Après le petit-déjeuner';

  @override
  String get beforeLunch => 'Avant le déjeuner';

  @override
  String get afterLunch => 'Après le déjeuner';

  @override
  String get beforeDinner => 'Avant le dîner';

  @override
  String get afterDinner => 'Après le dîner';

  @override
  String get other => 'Autre';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Ajoute des notes supplémentaires...';

  @override
  String get patternInsights => 'Insights de patterns';

  @override
  String get tryThis => 'Essaie ceci';

  @override
  String get learnMore => 'En savoir plus';

  @override
  String get gotIt => 'Compris';

  @override
  String get tipsAndEducation => 'Conseils et éducation';

  @override
  String get recommendations => 'Recommandations';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get lightTheme => 'Clair';

  @override
  String get darkTheme => 'Sombre';

  @override
  String get systemTheme => 'Système';

  @override
  String get selectTheme => 'Sélectionner le thème';

  @override
  String get timeRange => 'Période';

  @override
  String get last4Weeks => '4 dernières semaines';

  @override
  String get last3Months => '3 derniers mois';

  @override
  String get last6Months => '6 derniers mois';

  @override
  String get allTime => 'Tout';

  @override
  String get zoomedIn => 'Zoom activé';

  @override
  String get resetZoom => 'Réinitialiser';

  @override
  String get dataPoints => 'points de données';

  @override
  String get midpoint => 'Milieu';

  @override
  String get latest => 'Dernier';

  @override
  String get loadMore => 'Charger plus';
}
