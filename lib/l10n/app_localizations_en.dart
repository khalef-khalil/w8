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
  String get languageArabic => 'العربية';

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
  String get errorSaving => 'Error saving entry. Please try again.';

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
  String achievementUnlocked(String date) {
    return 'Unlocked: $date';
  }

  @override
  String get achievementJourneyStarted => 'Journey Started';

  @override
  String get achievementJourneyStartedDesc =>
      'You\'ve started your weight tracking journey!';

  @override
  String get achievementWeekWarrior => 'Week Warrior';

  @override
  String get achievementWeekWarriorDesc =>
      'Tracked your weight for 7 days in a row!';

  @override
  String get achievementMonthlyMaster => 'Monthly Master';

  @override
  String get achievementMonthlyMasterDesc =>
      'Tracked your weight for 30 days in a row!';

  @override
  String get achievementCenturyChampion => 'Century Champion';

  @override
  String get achievementCenturyChampionDesc =>
      'Tracked your weight for 100 days in a row!';

  @override
  String get achievementQuarterComplete => 'Quarter Complete';

  @override
  String get achievementQuarterCompleteDesc =>
      'You\'re 25% of the way to your goal!';

  @override
  String get achievementHalfwayHero => 'Halfway Hero';

  @override
  String get achievementHalfwayHeroDesc => 'You\'re halfway to your goal!';

  @override
  String get achievementAlmostThere => 'Almost There';

  @override
  String get achievementAlmostThereDesc =>
      'You\'re 75% of the way to your goal!';

  @override
  String get achievementGoalAchieved => 'Goal Achieved';

  @override
  String get achievementGoalAchievedDesc =>
      'Congratulations! You\'ve reached your goal!';

  @override
  String get achievement10DayTracker => '10 Day Tracker';

  @override
  String get achievement10DayTrackerDesc =>
      'Tracked your weight for 10 days total!';

  @override
  String get achievement30DayTracker => '30 Day Tracker';

  @override
  String get achievement30DayTrackerDesc =>
      'Tracked your weight for 30 days total!';

  @override
  String get achievement100DayTracker => '100 Day Tracker';

  @override
  String get achievement100DayTrackerDesc =>
      'Tracked your weight for 100 days total!';

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
  String get tipsAndEducationDescription =>
      'Learn about weight tracking and best practices';

  @override
  String get allAchievements => 'All Achievements';

  @override
  String get recommendations => 'Recommendations';

  @override
  String get appearance => 'Appearance';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get timeRange => 'Time range';

  @override
  String get last4Weeks => 'Last 4 weeks';

  @override
  String get last3Months => 'Last 3 months';

  @override
  String get last6Months => 'Last 6 months';

  @override
  String get allTime => 'All time';

  @override
  String get zoomedIn => 'Zoomed in';

  @override
  String get resetZoom => 'Reset';

  @override
  String get dataPoints => 'data points';

  @override
  String get midpoint => 'Midpoint';

  @override
  String get latest => 'Latest';

  @override
  String get loadMore => 'Load more';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get errorOccurred => 'An error occurred. Please try again.';

  @override
  String get goBack => 'Go back';

  @override
  String get errorDeleting => 'Error deleting entry. Please try again.';

  @override
  String get back => 'Back';

  @override
  String get awesome => 'Awesome!';

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
  String recommendationBehindLoss(String deficit, String unit) {
    return 'You\'re $deficit $unit/week behind target. Consider reviewing your nutrition and activity levels.';
  }

  @override
  String get recommendationSmallChanges =>
      'Small changes add up: try adding 10-15 minutes of daily activity or reducing portion sizes slightly.';

  @override
  String recommendationBehindGain(String deficit, String unit) {
    return 'You\'re $deficit $unit/week behind target. Make sure you\'re eating enough calories and protein.';
  }

  @override
  String get recommendationTrackMeals =>
      'Consider tracking your meals to ensure you\'re meeting your caloric goals.';

  @override
  String get recommendationAhead =>
      'Great progress! You\'re ahead of schedule. Keep up the consistent tracking and maintain your current approach.';

  @override
  String get recommendationOnTrack =>
      'You\'re right on track! Maintain your current routine - it\'s working well.';

  @override
  String get recommendationFinalStretch =>
      'You\'re in the final stretch! Stay consistent - you\'re almost there!';

  @override
  String get recommendationHalfway =>
      'You\'re more than halfway there! Keep the momentum going.';

  @override
  String get recommendationGettingStarted =>
      'You\'re just getting started. Focus on building consistent habits - the results will follow!';

  @override
  String get recommendationVolatility =>
      'Your weight is fluctuating quite a bit. This is normal! Try weighing at the same time each day for more consistent readings.';

  @override
  String get recommendationGeneral =>
      'Keep tracking consistently! Every entry helps you understand your progress better.';

  @override
  String get encouragementGoalReached =>
      '🎉 Congratulations! You\'ve reached your goal!';

  @override
  String get encouragementAhead =>
      'You\'re doing amazing! Keep up the great work!';

  @override
  String get encouragementOnTrack =>
      'You\'re right on track! Consistency is key.';

  @override
  String get encouragementClose => 'You\'re so close! Keep pushing forward!';

  @override
  String get encouragementGreatProgress =>
      'You\'re making great progress! Keep going!';

  @override
  String get encouragementEveryStep =>
      'Every step counts! You\'re building great habits!';

  @override
  String get patternSleepQualityImpact => 'Sleep Quality Impact';

  @override
  String patternSleepQualityDescription(String action, String quality,
      int rating, int worstRating, String change) {
    return 'You tend to $action more weight when you sleep $quality ($rating/5). When sleep quality is $worstRating/5, your weight changes by $change kg/day on average.';
  }

  @override
  String get patternSleepQualitySimilar =>
      'Your weight changes are similar regardless of sleep quality.';

  @override
  String patternSleepQualitySuggestionGood(int rating) {
    return 'Try to maintain good sleep habits ($rating/5) for better weight management.';
  }

  @override
  String get patternSleepQualitySuggestionImprove =>
      'Consider improving your sleep quality - it may help with your weight goals.';

  @override
  String get patternStressLevelImpact => 'Stress Level Impact';

  @override
  String patternStressLevelDescription(String level, int rating, String change,
      int highRating, String highChange) {
    return 'When stress is $level ($rating/5), your weight changes by $change kg/day on average. Higher stress ($highRating/5) shows $highChange kg/day.';
  }

  @override
  String get patternStressLevelSuggestion =>
      'Managing stress levels may help with your weight goals.';

  @override
  String get patternStressLevelSuggestionFavorable =>
      'Your weight changes are more favorable when stress is lower.';

  @override
  String get patternExerciseImpact => 'Exercise Impact';

  @override
  String patternExerciseDescription(
      String withExercise, String withoutExercise) {
    return 'On days you exercise, your weight changes by $withExercise kg/day on average, compared to $withoutExercise kg/day when you don\'t exercise.';
  }

  @override
  String patternExerciseDescriptionAlt(
      String withExercise, String withoutExercise) {
    return 'Exercise days show $withExercise kg/day change vs $withoutExercise kg/day on rest days.';
  }

  @override
  String get patternExerciseSuggestion =>
      'Keep up the exercise! It appears to be helping with your weight goals.';

  @override
  String get patternExerciseSuggestionConsistent =>
      'Consider maintaining a consistent exercise routine.';

  @override
  String get patternMealTimingPattern => 'Meal Timing Pattern';

  @override
  String patternMealTimingDescription(String timing, String change) {
    return 'Your weight changes are most favorable when weighing $timing. Average change: $change kg/day.';
  }

  @override
  String patternMealTimingSuggestion(String timing) {
    return 'Try to weigh yourself at consistent times ($timing) for more accurate tracking.';
  }

  @override
  String get patternSleepWell => 'well';

  @override
  String get patternSleepPoorly => 'poorly';

  @override
  String get patternStressLow => 'low';

  @override
  String get patternStressHigh => 'high';

  @override
  String get patternLose => 'lose';

  @override
  String get patternGain => 'gain';

  @override
  String get validationWeightGreaterThanZero =>
      'Please enter a weight greater than 0';

  @override
  String validationWeightLessThanMax(String max) {
    return 'Please enter a weight less than $max';
  }

  @override
  String get validationUnusuallyLargeChange =>
      'This weight change seems unusually large. Please double-check your entry.';

  @override
  String get validationSignificantChange =>
      'This is a significant change from your last entry. Is everything okay? You can still save it.';

  @override
  String get validationDifferentFromInitial =>
      'This weight is quite different from your initial weight. Is this correct?';

  @override
  String get validationGainingWhileLosing =>
      'You\'re gaining weight while your goal is to lose. That\'s okay—setbacks happen. Do you want to continue?';

  @override
  String get validationLosingWhileGaining =>
      'You\'re losing weight while your goal is to gain. That\'s okay—setbacks happen. Do you want to continue?';

  @override
  String get validationMovingAwayFromGoal =>
      'You\'re moving away from your goal. This might be normal (fluctuations, life events). Is this correct?';

  @override
  String get validationUnusualWeight =>
      'This weight seems unusual compared to your recent entries. Is everything okay?';

  @override
  String get statusOnTrack => 'You\'re right on track! Keep up the great work!';

  @override
  String statusAheadWithDays(int days) {
    return 'You\'re ahead of schedule! $days days ahead';
  }

  @override
  String get statusAhead => 'You\'re ahead of schedule! Great job!';

  @override
  String get statusBehind =>
      'You\'re making progress! A bit slower than planned, but you\'re still moving toward your goal.';

  @override
  String get statusBehindSimple => 'You\'re making progress! Keep going!';

  @override
  String get statusKeepTracking => 'Keep tracking to see your progress!';

  @override
  String get predictionOnTrack =>
      'You\'re on track to reach your goal around the planned date!';

  @override
  String predictionAfterTarget(int days) {
    return 'At your current rate, you\'ll reach your goal about $days days after your target date. That\'s okay—progress is progress!';
  }

  @override
  String predictionBeforeTarget(int days) {
    return 'At your current rate, you\'ll reach your goal about $days days before your target date. Great job!';
  }

  @override
  String get streakStartTracking => 'Start tracking to build your streak!';

  @override
  String get streakGreatStart => 'Great start! Keep it going!';

  @override
  String streakDaysBuilding(int days) {
    return '$days days in a row! You\'re building a great habit!';
  }

  @override
  String streakDaysAmazing(int days) {
    return '$days days in a row! You\'re doing amazing!';
  }

  @override
  String streakDaysIncredible(int days) {
    return '$days days in a row! This is incredible!';
  }

  @override
  String streakDaysChampion(int days) {
    return '$days days in a row! You\'re a tracking champion!';
  }

  @override
  String get educationWhyFluctuatesTitle => 'Why Weight Fluctuates Daily';

  @override
  String get educationWhyFluctuatesContent =>
      'Your weight naturally fluctuates throughout the day and week. This is completely normal! Factors include:\n\n• Water retention (can vary by 1-2 kg)\n• Food and digestion\n• Sleep quality and duration\n• Hormonal changes\n• Exercise and muscle recovery\n\nThat\'s why we use weekly medians - they smooth out daily noise and show your true progress.';

  @override
  String get educationWeeklyMediansTitle => 'How Weekly Medians Work';

  @override
  String get educationWeeklyMediansContent =>
      'Weekly medians help you see your real progress by reducing daily noise.\n\nInstead of focusing on day-to-day changes, we calculate the median weight for each week. This gives you a clearer picture of your overall trend.\n\nFor example: If you weigh 70kg, 71kg, 70.5kg, 70.2kg, and 70.8kg in a week, the median is 70.5kg - a more stable number than any single day.';

  @override
  String get educationBestPracticesTitle => 'Best Practices for Tracking';

  @override
  String get educationBestPracticesContent =>
      'For the most accurate tracking:\n\n• Weigh at the same time each day (morning is best)\n• Use the same scale\n• Weigh before eating or drinking\n• Weigh after using the bathroom\n• Wear similar clothing (or none)\n\nConsistency is more important than perfection!';

  @override
  String get educationPlateausTitle => 'Understanding Plateaus';

  @override
  String get educationPlateausContent =>
      'Weight plateaus are completely normal and not a sign of failure!\n\nYour body may:\n• Retain water during muscle recovery\n• Adjust metabolism\n• Redistribute weight (fat loss, muscle gain)\n\nIf you\'re following your plan, trust the process. Plateaus often break after a few weeks. Focus on consistency over speed.';

  @override
  String get educationContextTrackingTitle => 'Why Track Context?';

  @override
  String get educationContextTrackingContent =>
      'Tracking context (sleep, stress, exercise, meal timing) helps you understand patterns.\n\nYou might discover:\n• Better sleep = better weight management\n• High stress affects your progress\n• Exercise timing matters\n• Meal timing impacts daily weight\n\nThese insights help you make informed decisions about your journey.';

  @override
  String get educationStayingMotivatedTitle => 'Staying Motivated';

  @override
  String get educationStayingMotivatedContent =>
      'Weight tracking is a marathon, not a sprint.\n\nRemember:\n• Progress isn\'t always linear\n• Small daily actions compound over time\n• Setbacks are part of the journey\n• Celebrate non-scale victories too\n\nFocus on building sustainable habits. Every day you track is a win!';
}
