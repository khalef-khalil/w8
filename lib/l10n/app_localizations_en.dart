// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Weight Tracker';

  @override
  String get addWeight => 'Add Weight';

  @override
  String get weightTracking => 'Weight Tracking';

  @override
  String get retry => 'Retry';

  @override
  String get errorLoading => 'Error loading';

  @override
  String get startTrackingPrompt => 'Start tracking your weight';

  @override
  String get addFirstWeighIn => 'Add your first weigh-in to get started';

  @override
  String get currentWeight => 'Current Weight';

  @override
  String get progressToGoal => 'Progress to goal (+15kg)';

  @override
  String get start => 'Start';

  @override
  String get goal => 'Goal';

  @override
  String get weeks => 'Weeks';

  @override
  String get medians => 'Medians';

  @override
  String get notEnoughData => 'Not enough data';

  @override
  String get addWeighInsForChart => 'Add weigh-ins to see the chart';

  @override
  String get weeklyEvolution => 'Weekly Evolution (Median)';

  @override
  String get recentWeighIns => 'Recent Weigh-ins';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get save => 'Save';

  @override
  String get weightSaved => 'Weight saved successfully';

  @override
  String get validationError => 'Validation error';

  @override
  String get warning => 'Warning';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get weightLbs => 'Weight (lbs)';

  @override
  String get weightHint => 'e.g. 70.50';

  @override
  String get targetWeightHint => 'e.g. 85.00';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get pleaseEnterWeight => 'Please enter a weight';

  @override
  String get pleaseEnterValidWeight => 'Please enter a valid weight (0–300 kg)';

  @override
  String get pleaseEnterValidWeightLbs =>
      'Please enter a valid weight (0–660 lbs)';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get register => 'Register';

  @override
  String get welcomeTitle => 'Welcome to w8';

  @override
  String get welcomeSubtitle =>
      'Your companion for tracking weight progress. Gain 15kg in 6 months or set your own goal.';

  @override
  String get featureMedianTitle => 'Weekly median';

  @override
  String get featureMedianDesc =>
      'Automatically computes the median to smooth fluctuations.';

  @override
  String get featureSmartTitle => 'Smart tracking';

  @override
  String get featureSmartDesc => 'Detects anomalies and validates your data.';

  @override
  String get featureProgressTitle => 'Clear progress';

  @override
  String get featureProgressDesc =>
      'See where you stand relative to your goal.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get languageTitle => 'Choose your language';

  @override
  String get languageSubtitle =>
      'The app will use this language. You can change it later in settings.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get goalConfigTitle => 'Goal configuration';

  @override
  String get whatIsYourGoal => 'What\'s your goal?';

  @override
  String get configureGoal => 'Configure your personal goal';

  @override
  String get goalType => 'Goal type';

  @override
  String get gain => 'Gain';

  @override
  String get lose => 'Lose';

  @override
  String get maintain => 'Maintain';

  @override
  String get initialWeightKg => 'Initial weight (kg)';

  @override
  String get targetWeightKg => 'Target weight (kg)';

  @override
  String get goalStartDate => 'Goal start date';

  @override
  String get selectDate => 'Select a date';

  @override
  String get durationMonths => 'Duration (months)';

  @override
  String get durationHint => 'e.g. 6';

  @override
  String get continueButton => 'Continue';

  @override
  String get goalSummary => 'Your goal summary';

  @override
  String goalSummaryFromTo(String initial, String target, int months) {
    return 'From ${initial}kg to ${target}kg in $months months';
  }

  @override
  String perMonth(String rate) {
    return '≈ $rate kg/month';
  }

  @override
  String get enterInitialWeight => 'Enter an initial weight';

  @override
  String get enterTargetWeight => 'Enter a target weight';

  @override
  String get enterDuration => 'Enter a duration';

  @override
  String get invalidWeight => 'Invalid weight (0–500 kg)';

  @override
  String get invalidDuration => 'Invalid duration (1–24 months)';

  @override
  String get targetMustBeGreater =>
      'Target weight must be greater than initial weight for gain goals.';

  @override
  String get targetMustBeLess =>
      'Target weight must be less than initial weight for loss goals.';

  @override
  String get errorSaving => 'Error saving';

  @override
  String get invalidData => 'Invalid data';

  @override
  String get selectGoalType => 'Select a goal type';

  @override
  String get invalidGoalStartDate => 'Invalid start date';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get personalizeExperience => 'Personalize your experience';

  @override
  String get configurePreferences =>
      'Configure your preferences for the best experience';

  @override
  String get weightUnit => 'Weight unit';

  @override
  String get kilograms => 'Kilograms (kg)';

  @override
  String get pounds => 'Pounds (lbs)';

  @override
  String get weekStartsOn => 'Week starts on';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get firstWeighInTitle => 'First weigh-in';

  @override
  String get addFirstWeighInTitle => 'Add your first weigh-in';

  @override
  String yourGoalIs(String initial, String target, int months) {
    return 'Your goal: ${initial}kg → ${target}kg in $months months';
  }

  @override
  String initialWeightConfigured(String weight) {
    return 'Initial weight configured: ${weight}kg';
  }

  @override
  String get weightVeryDifferent =>
      'Weight very different from configured initial. Please check.';

  @override
  String get finishAndStart => 'Finish and start';

  @override
  String get insights => 'Insights';

  @override
  String get ahead => 'Ahead';

  @override
  String get behind => 'Behind';

  @override
  String get onTrack => 'On track';

  @override
  String daysAhead(int count) {
    return '$count days ahead';
  }

  @override
  String daysBehind(int count) {
    return '$count days behind';
  }

  @override
  String get keepItUp => 'Keep it up!';

  @override
  String get speedOfProgress => 'Speed of progress';

  @override
  String get current => 'Current';

  @override
  String get required => 'Required';

  @override
  String get kgPerWeek => 'kg/week';

  @override
  String percentOfRequired(String percent) {
    return '$percent% of required speed';
  }

  @override
  String get prediction => 'Prediction';

  @override
  String goalReachedInDays(int count) {
    return 'Goal reached in $count days';
  }

  @override
  String estimatedDate(String date) {
    return 'Estimated date: $date';
  }

  @override
  String daysAfterExpected(int count) {
    return '$count days after expected';
  }

  @override
  String daysBeforeExpected(int count) {
    return '$count days before expected';
  }

  @override
  String get progressVsTime => 'Progress: Time vs Weight';

  @override
  String get timeProgress => 'Time progress';

  @override
  String get timeElapsed => 'Time elapsed';

  @override
  String get weightProgress => 'Weight progress';

  @override
  String get actualChange => 'Actual change';

  @override
  String aheadByPercent(String percent) {
    return 'Ahead by $percent%';
  }

  @override
  String behindByPercent(String percent) {
    return 'Behind by $percent%';
  }

  @override
  String get perfectlySynced => 'Perfectly in sync with your goal';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get progressTitle => 'Progress';

  @override
  String get historyTitle => 'History';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get navHome => 'Home';

  @override
  String get navProgress => 'Progress';

  @override
  String get navHistory => 'History';

  @override
  String get navInsights => 'Insights';

  @override
  String get navSettings => 'Settings';

  @override
  String get navOverview => 'Overview';

  @override
  String get overviewTitle => 'Overview';

  @override
  String get monthsUnit => 'months';

  @override
  String get kgUnit => 'kg';

  @override
  String get lbsUnit => 'lbs';

  @override
  String get lbsPerWeek => 'lbs/week';

  @override
  String get progressLabel => 'Progress';

  @override
  String weightToGo(String value) {
    return '$value kg to go';
  }

  @override
  String weightToLose(String value) {
    return '$value kg to lose';
  }

  @override
  String get weightToGoLabel => 'Weight to go';

  @override
  String get weightToLoseLabel => 'Weight to lose';

  @override
  String weeksLeft(int count) {
    return '$count weeks left';
  }

  @override
  String get weeksLeftLabel => 'Weeks left';

  @override
  String get goalWeight => 'Goal weight';

  @override
  String get chartGoalLine => 'Goal';

  @override
  String get chartStartLine => 'Start';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get editWeight => 'Edit weight';

  @override
  String get deleteEntryTitle => 'Delete weigh-in?';

  @override
  String get deleteEntryMessage => 'This action cannot be undone.';

  @override
  String get entryDeleted => 'Weigh-in deleted';

  @override
  String get weightUpdated => 'Weigh-in updated';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataDescription =>
      'Export your weight data to CSV or JSON format';

  @override
  String get exportAsCSV => 'Export as CSV';

  @override
  String get exportAsCSVDescription =>
      'Comma-separated values format, easy to open in Excel';

  @override
  String get exportAsJSON => 'Export as JSON';

  @override
  String get exportAsJSONDescription =>
      'JSON format with all data including goal configuration';

  @override
  String get exportDataReady => 'Your data is ready to copy:';

  @override
  String get copyToClipboard => 'Copy to Clipboard';

  @override
  String get dataCopiedToClipboard => 'Data copied to clipboard';

  @override
  String get errorExporting => 'Error exporting data';

  @override
  String get close => 'Close';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String daysInARow(int count) {
    return '$count days in a row';
  }

  @override
  String longestStreak(int count) {
    return 'Longest: $count days';
  }

  @override
  String get makingProgress => 'Making progress';

  @override
  String get justChecking => 'Just checking';

  @override
  String get yesContinue => 'Yes, continue';

  @override
  String get weightSavedSuccess => 'Great! Weight saved successfully';

  @override
  String get weightUpdatedSuccess => 'Updated! Your entry has been saved';

  @override
  String get editGoal => 'Edit Goal';

  @override
  String get editYourGoal => 'Edit Your Goal';

  @override
  String get editGoalDescription => 'Update your goal settings';

  @override
  String get goalManagement => 'Goal Management';

  @override
  String get goalUpdated => 'Goal updated successfully';

  @override
  String get initialWeightLbs => 'Initial weight (lbs)';

  @override
  String get targetWeightLbs => 'Target weight (lbs)';

  @override
  String get reminders => 'Reminders';

  @override
  String get enableReminders => 'Enable Daily Reminders';

  @override
  String get enableRemindersDescription => 'Get notified to track your weight';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String get notificationPermissionRequired =>
      'Notification permission is required to enable reminders';

  @override
  String get notSet => 'Not set';

  @override
  String get achievements => 'Achievements';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked of $total unlocked';
  }

  @override
  String get noAchievementsYet => 'Keep tracking to unlock achievements!';

  @override
  String get viewAllAchievements => 'View All';

  @override
  String get addContext => 'Add Context (Optional)';

  @override
  String get addContextDescription =>
      'Track factors that might affect your weight';

  @override
  String get sleepQuality => 'Sleep Quality';

  @override
  String get stressLevel => 'Stress Level';

  @override
  String get exercisedToday => 'Exercised Today';

  @override
  String get mealTiming => 'Meal Timing';

  @override
  String get selectMealTiming => 'Select when you weighed';

  @override
  String get beforeBreakfast => 'Before Breakfast';

  @override
  String get afterBreakfast => 'After Breakfast';

  @override
  String get beforeLunch => 'Before Lunch';

  @override
  String get afterLunch => 'After Lunch';

  @override
  String get beforeDinner => 'Before Dinner';

  @override
  String get afterDinner => 'After Dinner';

  @override
  String get other => 'Other';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Add any additional notes...';

  @override
  String get patternInsights => 'Pattern Insights';

  @override
  String get tryThis => 'Try this';

  @override
  String get learnMore => 'Learn more';

  @override
  String get gotIt => 'Got it';

  @override
  String get tipsAndEducation => 'Tips & Education';

  @override
  String get recommendations => 'Recommendations';
}
