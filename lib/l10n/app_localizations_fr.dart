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
  String get currentWeightTooltipRollingMedian =>
      'Médiane glissante sur 7 jours. Basée sur les pesées des 7 derniers jours.';

  @override
  String get currentWeightTooltipLastWeighIn =>
      'Basé sur ta dernière pesée (aucune entrée dans les 7 derniers jours).';

  @override
  String get currentWeightPeriodLast7Days => '7 derniers jours';

  @override
  String get currentWeightPeriodLastWeighIn => 'Dernière pesée';

  @override
  String get progressToGoal => 'Progrès vers l\'objectif';

  @override
  String progressToGoalWithAmount(String amount) {
    return 'Progrès vers l\'objectif ($amount)';
  }

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
  String get weeklyEvolution => 'Évolution hebdomadaire';

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
  String get featureMedianTitle => 'Tendances lissées';

  @override
  String get featureMedianDesc =>
      'L\'aperçu utilise une médiane glissante sur 7 jours ; les graphiques utilisent les médianes hebdomadaires pour lisser les fluctuations.';

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
  String get languageArabic => 'العربية';

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
  String get durationDays => 'Jours en plus';

  @override
  String get durationHint => 'Ex: 6';

  @override
  String get durationDaysHint => '0–31';

  @override
  String get daysUnit => 'jours';

  @override
  String get goalEndDate => 'Date de fin de l\'objectif';

  @override
  String get selectEndDate => 'Sélectionner la date de fin';

  @override
  String get useDuration => 'Utiliser la durée';

  @override
  String get useEndDate => 'Utiliser la date de fin';

  @override
  String get calculatedEndDate => 'Date de fin calculée';

  @override
  String get calculatedDuration => 'Durée calculée';

  @override
  String get continueButton => 'Continuer';

  @override
  String get goalSummary => 'Résumé de ton objectif';

  @override
  String goalSummaryFromTo(String initial, String target, int months) {
    return 'Passer de ${initial}kg à ${target}kg en $months mois';
  }

  @override
  String goalSummaryFromToWithDays(
      String initial, String target, int months, int days) {
    return 'Passer de ${initial}kg à ${target}kg en $months mois et $days jours';
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
  String get errorSaving =>
      'Erreur lors de l\'enregistrement. Veuillez réessayer.';

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
  String get kilograms => 'Kilogrammes';

  @override
  String get pounds => 'Livres';

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
  String get kgPerWeek => 'kg/S';

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
  String get weightToGoLabel => 'Restant';

  @override
  String get weightToLoseLabel => 'Restant';

  @override
  String weeksLeft(int count) {
    return '$count semaines restantes';
  }

  @override
  String get weeksLeftLabel => 'Semaines restantes';

  @override
  String get goalWeight => 'Poids objectif';

  @override
  String get estimationCalculatorTitle => 'Projections';

  @override
  String get estimationCalculatorDescription =>
      'Utilise votre rythme actuel pour estimer quand vous atteindrez un poids, ou le poids attendu à une date.';

  @override
  String get estimationCalculatorNeedData =>
      'Ajoutez au moins 2 pesées pour utiliser le calculateur d\'estimation.';

  @override
  String estimationCurrentRate(String rate) {
    return 'Rythme actuel : $rate par semaine';
  }

  @override
  String get estimationWeightToDate => 'Quand vais-je atteindre ce poids ?';

  @override
  String get estimationWeightToDateHint => 'Saisir le poids cible';

  @override
  String estimationWeightToDateResult(String date) {
    return 'Date estimée : $date';
  }

  @override
  String get estimationWeightToDateInvalid =>
      'Saisissez un poids dans la bonne direction (prise : au-dessus du actuel ; perte : en dessous).';

  @override
  String get estimationWeightToDateNoRate =>
      'Le rythme actuel est nul ; ajoutez des données pour estimer.';

  @override
  String get estimationDateToWeight => 'Quel sera mon poids à cette date ?';

  @override
  String get estimationDateToWeightPick => 'Choisir une date';

  @override
  String estimationDateToWeightResult(String weight) {
    return 'Poids estimé : $weight';
  }

  @override
  String get estimationDateToWeightPast => 'Choisissez une date future.';

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
  String achievementUnlocked(String date) {
    return 'Débloqué : $date';
  }

  @override
  String get achievementJourneyStarted => 'Voyage commencé';

  @override
  String get achievementJourneyStartedDesc =>
      'Tu as commencé ton voyage de suivi de poids !';

  @override
  String get achievementWeekWarrior => 'Guerrier de la semaine';

  @override
  String get achievementWeekWarriorDesc =>
      'Tu as suivi ton poids pendant 7 jours d\'affilée !';

  @override
  String get achievementMonthlyMaster => 'Maître mensuel';

  @override
  String get achievementMonthlyMasterDesc =>
      'Tu as suivi ton poids pendant 30 jours d\'affilée !';

  @override
  String get achievementCenturyChampion => 'Champion du siècle';

  @override
  String get achievementCenturyChampionDesc =>
      'Tu as suivi ton poids pendant 100 jours d\'affilée !';

  @override
  String get achievementQuarterComplete => 'Quart terminé';

  @override
  String get achievementQuarterCompleteDesc => 'Tu es à 25% de ton objectif !';

  @override
  String get achievementHalfwayHero => 'Héros à mi-chemin';

  @override
  String get achievementHalfwayHeroDesc =>
      'Tu es à mi-chemin de ton objectif !';

  @override
  String get achievementAlmostThere => 'Presque là';

  @override
  String get achievementAlmostThereDesc => 'Tu es à 75% de ton objectif !';

  @override
  String get achievementGoalAchieved => 'Objectif atteint';

  @override
  String get achievementGoalAchievedDesc =>
      'Félicitations ! Tu as atteint ton objectif !';

  @override
  String get achievement10DayTracker => 'Suiveur de 10 jours';

  @override
  String get achievement10DayTrackerDesc =>
      'Tu as suivi ton poids pendant 10 jours au total !';

  @override
  String get achievement30DayTracker => 'Suiveur de 30 jours';

  @override
  String get achievement30DayTrackerDesc =>
      'Tu as suivi ton poids pendant 30 jours au total !';

  @override
  String get achievement100DayTracker => 'Suiveur de 100 jours';

  @override
  String get achievement100DayTrackerDesc =>
      'Tu as suivi ton poids pendant 100 jours au total !';

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
  String get tipsAndEducationDescription =>
      'Apprendre sur le suivi du poids et les meilleures pratiques';

  @override
  String get allAchievements => 'Tous les succès';

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

  @override
  String get somethingWentWrong => 'Une erreur s\'est produite';

  @override
  String get errorOccurred => 'Une erreur s\'est produite. Veuillez réessayer.';

  @override
  String get goBack => 'Retour';

  @override
  String get errorDeleting =>
      'Erreur lors de la suppression. Veuillez réessayer.';

  @override
  String get back => 'Retour';

  @override
  String get awesome => 'Génial !';

  @override
  String get celebrationJourneyStarted => 'Journey Started!';

  @override
  String get celebrationJourneyStartedMessage =>
      'Great! You\'ve started your journey!';

  @override
  String get celebration7DayStreak => '7 Day Streak!';

  @override
  String get celebration7DayStreakMessage =>
      '🎉 7 days in a row! You\'re building an amazing habit!';

  @override
  String get celebration30DayStreak => '30 Day Streak!';

  @override
  String get celebration30DayStreakMessage =>
      '🎉 30 days! You\'re a tracking superstar!';

  @override
  String get celebration100DayStreak => '100 Day Streak!';

  @override
  String get celebration100DayStreakMessage =>
      '🎉 100 days! This is incredible dedication!';

  @override
  String get celebration25Percent => '25% Complete!';

  @override
  String get celebration25PercentMessage => '🎉 You\'re 25% there! Keep going!';

  @override
  String get celebration50Percent => 'Halfway There!';

  @override
  String get celebration50PercentMessage =>
      '🎉 Halfway there! You\'re doing amazing!';

  @override
  String get celebration75Percent => '75% Complete!';

  @override
  String get celebration75PercentMessage =>
      '🎉 75% complete! You\'re almost there!';

  @override
  String get celebrationGoalReached => 'Goal Achieved!';

  @override
  String get celebrationGoalReachedMessage =>
      '🎉 Congratulations! You\'ve reached your goal!';

  @override
  String get emptyStateStartJourney => 'Start Your Journey';

  @override
  String get emptyStateStartJourneyMessage =>
      'Track your weight to see your progress over time. Every entry brings you closer to your goal!';

  @override
  String get emptyStateAddFirstWeight => 'Add Your First Weight';

  @override
  String get emptyStateSetGoal => 'Set Your Goal';

  @override
  String get emptyStateSetGoalMessage =>
      'Define your weight goal to track your progress and stay motivated on your journey!';

  @override
  String get emptyStateNoHistory => 'No History Yet';

  @override
  String get emptyStateNoHistoryMessage =>
      'Start tracking your weight to build your history. Consistency is key to success!';

  @override
  String get emptyStateAddWeightEntry => 'Add Weight Entry';

  @override
  String get emptyStateBuildingInsights => 'Building Insights';

  @override
  String get emptyStateBuildingInsightsMessage =>
      'Keep tracking your weight! Once you have enough data, we\'ll show you personalized insights and trends.';

  @override
  String get insightsComingSoon => 'Insights à venir';

  @override
  String get insightsComingSoonMessage =>
      'Suis ton poids pendant 7 jours pour débloquer les insights et l\'analyse de progression.';

  @override
  String insightsDaysRemaining(int days) {
    return '$days jours restants';
  }

  @override
  String recommendationBehindLoss(String deficit, String unit) {
    return 'Tu es $deficit $unit/semaine en retard sur l\'objectif. Considère revoir ta nutrition et tes niveaux d\'activité.';
  }

  @override
  String get recommendationSmallChanges =>
      'Les petits changements s\'accumulent : essaie d\'ajouter 10-15 minutes d\'activité quotidienne ou de réduire légèrement les portions.';

  @override
  String recommendationBehindGain(String deficit, String unit) {
    return 'Tu es $deficit $unit/semaine en retard sur l\'objectif. Assure-toi de manger assez de calories et de protéines.';
  }

  @override
  String get recommendationTrackMeals =>
      'Considère suivre tes repas pour t\'assurer de rencontrer tes objectifs caloriques.';

  @override
  String get recommendationAhead =>
      'Super progrès ! Tu es en avance. Continue le suivi cohérent et maintiens ton approche actuelle.';

  @override
  String get recommendationOnTrack =>
      'Tu es sur la bonne voie ! Maintiens ta routine actuelle - ça fonctionne bien.';

  @override
  String get recommendationFinalStretch =>
      'Tu es dans la dernière ligne droite ! Reste cohérent - tu y es presque !';

  @override
  String get recommendationHalfway =>
      'Tu es plus qu\'à mi-chemin ! Garde l\'élan.';

  @override
  String get recommendationGettingStarted =>
      'Tu commences juste. Concentre-toi sur la construction d\'habitudes cohérentes - les résultats suivront !';

  @override
  String get recommendationVolatility =>
      'Ton poids fluctue beaucoup. C\'est normal ! Essaie de te peser à la même heure chaque jour pour des lectures plus cohérentes.';

  @override
  String get recommendationGeneral =>
      'Continue à suivre régulièrement ! Chaque entrée t\'aide à mieux comprendre ta progression.';

  @override
  String get encouragementGoalReached =>
      '🎉 Félicitations ! Tu as atteint ton objectif !';

  @override
  String get encouragementAhead =>
      'Tu fais du super travail ! Continue comme ça !';

  @override
  String get encouragementOnTrack =>
      'Tu es sur la bonne voie ! La cohérence est la clé.';

  @override
  String get encouragementClose => 'Tu es si proche ! Continue d\'avancer !';

  @override
  String get encouragementGreatProgress =>
      'Tu fais de super progrès ! Continue !';

  @override
  String get encouragementEveryStep =>
      'Chaque pas compte ! Tu construis de grandes habitudes !';

  @override
  String get patternSleepQualityImpact => 'Impact de la qualité du sommeil';

  @override
  String patternSleepQualityDescription(String action, String quality,
      int rating, int worstRating, String change) {
    return 'Tu tends à $action plus de poids quand tu dors $quality ($rating/5). Quand la qualité du sommeil est $worstRating/5, ton poids change de $change kg/jour en moyenne.';
  }

  @override
  String get patternSleepQualitySimilar =>
      'Tes changements de poids sont similaires quelle que soit la qualité du sommeil.';

  @override
  String patternSleepQualitySuggestionGood(int rating) {
    return 'Essaie de maintenir de bonnes habitudes de sommeil ($rating/5) pour une meilleure gestion du poids.';
  }

  @override
  String get patternSleepQualitySuggestionImprove =>
      'Considère améliorer ta qualité de sommeil - cela peut aider avec tes objectifs de poids.';

  @override
  String get patternStressLevelImpact => 'Impact du niveau de stress';

  @override
  String patternStressLevelDescription(String level, int rating, String change,
      int highRating, String highChange) {
    return 'Quand le stress est $level ($rating/5), ton poids change de $change kg/jour en moyenne. Un stress plus élevé ($highRating/5) montre $highChange kg/jour.';
  }

  @override
  String get patternStressLevelSuggestion =>
      'Gérer les niveaux de stress peut aider avec tes objectifs de poids.';

  @override
  String get patternStressLevelSuggestionFavorable =>
      'Tes changements de poids sont plus favorables quand le stress est plus bas.';

  @override
  String get patternExerciseImpact => 'Impact de l\'exercice';

  @override
  String patternExerciseDescription(
      String withExercise, String withoutExercise) {
    return 'Les jours où tu fais de l\'exercice, ton poids change de $withExercise kg/jour en moyenne, comparé à $withoutExercise kg/jour quand tu ne fais pas d\'exercice.';
  }

  @override
  String patternExerciseDescriptionAlt(
      String withExercise, String withoutExercise) {
    return 'Les jours d\'exercice montrent $withExercise kg/jour de changement vs $withoutExercise kg/jour les jours de repos.';
  }

  @override
  String get patternExerciseSuggestion =>
      'Continue l\'exercice ! Il semble aider avec tes objectifs de poids.';

  @override
  String get patternExerciseSuggestionConsistent =>
      'Considère maintenir une routine d\'exercice cohérente.';

  @override
  String get patternMealTimingPattern => 'Modèle de timing des repas';

  @override
  String patternMealTimingDescription(String timing, String change) {
    return 'Tes changements de poids sont les plus favorables quand tu te pèses $timing. Changement moyen : $change kg/jour.';
  }

  @override
  String patternMealTimingSuggestion(String timing) {
    return 'Essaie de te peser à des heures cohérentes ($timing) pour un suivi plus précis.';
  }

  @override
  String get patternSleepWell => 'bien';

  @override
  String get patternSleepPoorly => 'mal';

  @override
  String get patternStressLow => 'bas';

  @override
  String get patternStressHigh => 'élevé';

  @override
  String get patternLose => 'perdre';

  @override
  String get patternGain => 'gagner';

  @override
  String get validationWeightGreaterThanZero =>
      'Veuillez entrer un poids supérieur à 0';

  @override
  String validationWeightLessThanMax(String max) {
    return 'Veuillez entrer un poids inférieur à $max';
  }

  @override
  String get validationUnusuallyLargeChange =>
      'Ce changement de poids semble inhabituellement important. Veuillez vérifier votre saisie.';

  @override
  String get validationSignificantChange =>
      'C\'est un changement significatif par rapport à votre dernière entrée. Tout va bien ? Vous pouvez toujours l\'enregistrer.';

  @override
  String get validationDifferentFromInitial =>
      'Ce poids est très différent de votre poids initial. Est-ce correct ?';

  @override
  String get validationGainingWhileLosing =>
      'Tu prends du poids alors que ton objectif est de perdre. Ce n\'est pas grave - les revers arrivent. Veux-tu continuer ?';

  @override
  String get validationLosingWhileGaining =>
      'Tu perds du poids alors que ton objectif est de gagner. Ce n\'est pas grave - les revers arrivent. Veux-tu continuer ?';

  @override
  String get validationMovingAwayFromGoal =>
      'Tu t\'éloignes de ton objectif. Cela peut être normal (fluctuations, événements de la vie). Est-ce correct ?';

  @override
  String get validationUnusualWeight =>
      'Ce poids semble inhabituel par rapport à tes entrées récentes. Tout va bien ?';

  @override
  String get statusOnTrack => 'Tu es sur la bonne voie ! Continue comme ça !';

  @override
  String statusAheadWithDays(int days) {
    return 'Tu es en avance ! $days jours d\'avance';
  }

  @override
  String get statusAhead => 'Tu es en avance ! Super travail !';

  @override
  String get statusBehind =>
      'Tu fais des progrès ! Un peu plus lentement que prévu, mais tu continues vers ton objectif.';

  @override
  String get statusBehindSimple => 'Tu fais des progrès ! Continue !';

  @override
  String get statusKeepTracking =>
      'Continue à suivre pour voir ta progression !';

  @override
  String get predictionOnTrack =>
      'Tu es sur la bonne voie pour atteindre ton objectif autour de la date prévue !';

  @override
  String predictionAfterTarget(int days) {
    return 'À ton rythme actuel, tu atteindras ton objectif environ $days jours après ta date cible. Ce n\'est pas grave - le progrès est le progrès !';
  }

  @override
  String predictionBeforeTarget(int days) {
    return 'À ton rythme actuel, tu atteindras ton objectif environ $days jours avant ta date cible. Super travail !';
  }

  @override
  String get streakStartTracking =>
      'Commence à suivre pour construire ta série !';

  @override
  String get streakGreatStart => 'Super début ! Continue !';

  @override
  String streakDaysBuilding(int days) {
    return '$days jours d\'affilée ! Tu construis une grande habitude !';
  }

  @override
  String streakDaysAmazing(int days) {
    return '$days jours d\'affilée ! Tu fais du super travail !';
  }

  @override
  String streakDaysIncredible(int days) {
    return '$days jours d\'affilée ! C\'est incroyable !';
  }

  @override
  String streakDaysChampion(int days) {
    return '$days jours d\'affilée ! Tu es un champion du suivi !';
  }

  @override
  String get educationWhyFluctuatesTitle =>
      'Pourquoi le poids fluctue quotidiennement';

  @override
  String get educationWhyFluctuatesContent =>
      'Ton poids fluctue naturellement tout au long de la journée et de la semaine. C\'est complètement normal ! Les facteurs incluent :\n\n• Rétention d\'eau (peut varier de 1-2 kg)\n• Nourriture et digestion\n• Qualité et durée du sommeil\n• Changements hormonaux\n• Exercice et récupération musculaire\n\nC\'est pourquoi nous utilisons une médiane glissante sur 7 jours pour ton poids actuel et les médianes hebdomadaires dans les graphiques - elles lissent le bruit quotidien et montrent ton vrai progrès.';

  @override
  String get educationWeeklyMediansTitle => 'Comment on lisse tes données';

  @override
  String get educationWeeklyMediansContent =>
      'Ton poids actuel sur l\'aperçu est une médiane glissante sur 7 jours : la médiane de toutes les pesées des 7 derniers jours (ou ta dernière pesée si aucune dans cette fenêtre). Cela garde le nombre réactif et robuste aux valeurs aberrantes.\n\nLes graphiques utilisent les médianes hebdomadaires : on prend le poids médian pour chaque semaine complète (lun.–dim.). Cela donne une tendance stable dans le temps. Par exemple : si tu pèses 70kg, 71kg, 70.5kg, 70.2kg et 70.8kg en une semaine, la médiane est 70.5kg - un nombre plus stable qu\'un seul jour.';

  @override
  String get educationBestPracticesTitle =>
      'Meilleures pratiques pour le suivi';

  @override
  String get educationBestPracticesContent =>
      'Pour le suivi le plus précis :\n\n• Pèse-toi à la même heure chaque jour (le matin est le meilleur)\n• Utilise la même balance\n• Pèse-toi avant de manger ou de boire\n• Pèse-toi après être allé aux toilettes\n• Porte des vêtements similaires (ou aucun)\n\nLa cohérence est plus importante que la perfection !';

  @override
  String get educationPlateausTitle => 'Comprendre les plateaux';

  @override
  String get educationPlateausContent =>
      'Les plateaux de poids sont complètement normaux et ne sont pas un signe d\'échec !\n\nTon corps peut :\n• Retenir de l\'eau pendant la récupération musculaire\n• Ajuster le métabolisme\n• Redistribuer le poids (perte de graisse, gain musculaire)\n\nSi tu suis ton plan, fais confiance au processus. Les plateaux se brisent souvent après quelques semaines. Concentre-toi sur la cohérence plutôt que la vitesse.';

  @override
  String get educationContextTrackingTitle => 'Pourquoi suivre le contexte ?';

  @override
  String get educationContextTrackingContent =>
      'Suivre le contexte (sommeil, stress, exercice, timing des repas) t\'aide à comprendre les modèles.\n\nTu pourrais découvrir :\n• Meilleur sommeil = meilleure gestion du poids\n• Le stress élevé affecte ta progression\n• Le timing de l\'exercice compte\n• Le timing des repas impacte le poids quotidien\n\nCes insights t\'aident à prendre des décisions éclairées sur ton voyage.';

  @override
  String get educationStayingMotivatedTitle => 'Rester motivé';

  @override
  String get educationStayingMotivatedContent =>
      'Le suivi du poids est un marathon, pas un sprint.\n\nRappelle-toi :\n• Le progrès n\'est pas toujours linéaire\n• Les petites actions quotidiennes s\'accumulent avec le temps\n• Les revers font partie du voyage\n• Célèbre aussi les victoires non-échelle\n\nConcentre-toi sur la construction d\'habitudes durables. Chaque jour que tu suis est une victoire !';

  @override
  String get toolsTitle => 'Outils';

  @override
  String get toolsDescription =>
      'Calculateurs et utilitaires pour ton suivi poids';

  @override
  String get toolProjections => 'Projections';

  @override
  String get toolProjectionsDesc =>
      'Estime quand tu atteindras un poids ou le poids attendu à une date';

  @override
  String get toolBmi => 'Calculateur IMC';

  @override
  String get toolBmiDesc => 'Vérifie ton indice de masse corporelle';

  @override
  String get toolMaintenanceCalories => 'Calories de maintien';

  @override
  String get toolMaintenanceCaloriesDesc =>
      'Ta dépense énergétique quotidienne et l\'effet de l\'apport sur le poids';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileDescription => 'Tes infos pour IMC et calories';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get height => 'Taille';

  @override
  String get heightCm => 'Taille (cm)';

  @override
  String get heightHint => 'ex. 175';

  @override
  String get gender => 'Genre';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get birthDate => 'Date de naissance';

  @override
  String get birthDateHint => 'Pour l\'âge dans le calculateur de calories';

  @override
  String get saveToProfile => 'Enregistrer dans le profil';

  @override
  String get profileSaved => 'Profil enregistré';

  @override
  String get openSettings => 'Paramètres';

  @override
  String get openSettingsDesc => 'Thème, langue, rappels, objectif, export';

  @override
  String get bmiTitle => 'Calculateur IMC';

  @override
  String get bmiDescription =>
      'Indice de masse corporelle à partir de ta taille et poids.';

  @override
  String get bmiUnderweight => 'Insuffisance pondérale';

  @override
  String get bmiNormal => 'Normal';

  @override
  String get bmiOverweight => 'Surpoids';

  @override
  String get bmiObese => 'Obésité';

  @override
  String get bmiSevereThinness => 'Maigreur sévère';

  @override
  String get bmiModerateThinness => 'Maigreur modérée';

  @override
  String get bmiMildThinness => 'Maigreur légère';

  @override
  String get bmiObeseClass1 => 'Obésité classe I';

  @override
  String get bmiObeseClass2 => 'Obésité classe II';

  @override
  String get bmiObeseClass3 => 'Obésité classe III';

  @override
  String get yourBmi => 'Ton IMC';

  @override
  String get enterHeightAndWeight =>
      'Saisis taille et poids (ou définis-les dans le profil)';

  @override
  String get useCurrentWeight => 'Utiliser le poids actuel du suivi';

  @override
  String get weightForBmi => 'Poids pour l\'IMC';

  @override
  String get maintenanceTitle => 'Calories de maintien';

  @override
  String get maintenanceDescription =>
      'Dépense énergétique quotidienne estimée (TDEE) et effet de l\'apport sur le poids.';

  @override
  String get maintenanceTdee => 'Maintien (TDEE)';

  @override
  String maintenanceTdeeResult(String calories) {
    return 'Environ $calories kcal/jour';
  }

  @override
  String get dailyIntake => 'Apport quotidien (kcal)';

  @override
  String get dailyIntakeHint => 'Optionnel : voir l\'effet sur le poids';

  @override
  String get periodWeeks => 'Période (semaines)';

  @override
  String get projectedChange => 'Changement projeté';

  @override
  String get activityLevel => 'Niveau d\'activité';

  @override
  String get activitySedentary => 'Sédentaire (peu ou pas d\'exercice)';

  @override
  String get activityLight => 'Léger (1–3 j/sem)';

  @override
  String get activityModerate => 'Modéré (3–5 j/sem)';

  @override
  String get activityActive => 'Actif (6–7 j/sem)';

  @override
  String get activityVeryActive => 'Très actif (intense quotidien)';

  @override
  String get age => 'Âge';

  @override
  String get ageYears => 'Âge (années)';

  @override
  String get weight => 'Poids';

  @override
  String get navProfile => 'Profil';
}
