import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Tracker'**
  String get appTitle;

  /// No description provided for @addWeight.
  ///
  /// In en, this message translates to:
  /// **'Add Weight'**
  String get addWeight;

  /// No description provided for @weightTracking.
  ///
  /// In en, this message translates to:
  /// **'Weight Tracking'**
  String get weightTracking;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading'**
  String get errorLoading;

  /// No description provided for @startTrackingPrompt.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your weight'**
  String get startTrackingPrompt;

  /// No description provided for @addFirstWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Add your first weigh-in to get started'**
  String get addFirstWeighIn;

  /// No description provided for @currentWeight.
  ///
  /// In en, this message translates to:
  /// **'Current Weight'**
  String get currentWeight;

  /// No description provided for @progressToGoal.
  ///
  /// In en, this message translates to:
  /// **'Progress to goal (+15kg)'**
  String get progressToGoal;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get goal;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get weeks;

  /// No description provided for @medians.
  ///
  /// In en, this message translates to:
  /// **'Medians'**
  String get medians;

  /// No description provided for @notEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data'**
  String get notEnoughData;

  /// No description provided for @addWeighInsForChart.
  ///
  /// In en, this message translates to:
  /// **'Add weigh-ins to see the chart'**
  String get addWeighInsForChart;

  /// No description provided for @weeklyEvolution.
  ///
  /// In en, this message translates to:
  /// **'Weekly Evolution (Median)'**
  String get weeklyEvolution;

  /// No description provided for @recentWeighIns.
  ///
  /// In en, this message translates to:
  /// **'Recent Weigh-ins'**
  String get recentWeighIns;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @weightSaved.
  ///
  /// In en, this message translates to:
  /// **'Weight saved successfully'**
  String get weightSaved;

  /// No description provided for @validationError.
  ///
  /// In en, this message translates to:
  /// **'Validation error'**
  String get validationError;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @weightLbs.
  ///
  /// In en, this message translates to:
  /// **'Weight (lbs)'**
  String get weightLbs;

  /// No description provided for @weightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 70.50'**
  String get weightHint;

  /// No description provided for @targetWeightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 85.00'**
  String get targetWeightHint;

  /// No description provided for @errorWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @pleaseEnterWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a weight'**
  String get pleaseEnterWeight;

  /// No description provided for @pleaseEnterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight (0–300 kg)'**
  String get pleaseEnterValidWeight;

  /// No description provided for @pleaseEnterValidWeightLbs.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight (0–660 lbs)'**
  String get pleaseEnterValidWeightLbs;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to w8'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your companion for tracking weight progress. Gain 15kg in 6 months or set your own goal.'**
  String get welcomeSubtitle;

  /// No description provided for @featureMedianTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly median'**
  String get featureMedianTitle;

  /// No description provided for @featureMedianDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically computes the median to smooth fluctuations.'**
  String get featureMedianDesc;

  /// No description provided for @featureSmartTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart tracking'**
  String get featureSmartTitle;

  /// No description provided for @featureSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Detects anomalies and validates your data.'**
  String get featureSmartDesc;

  /// No description provided for @featureProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear progress'**
  String get featureProgressTitle;

  /// No description provided for @featureProgressDesc.
  ///
  /// In en, this message translates to:
  /// **'See where you stand relative to your goal.'**
  String get featureProgressDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The app will use this language. You can change it later in settings.'**
  String get languageSubtitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @goalConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal configuration'**
  String get goalConfigTitle;

  /// No description provided for @whatIsYourGoal.
  ///
  /// In en, this message translates to:
  /// **'What\'s your goal?'**
  String get whatIsYourGoal;

  /// No description provided for @configureGoal.
  ///
  /// In en, this message translates to:
  /// **'Configure your personal goal'**
  String get configureGoal;

  /// No description provided for @goalType.
  ///
  /// In en, this message translates to:
  /// **'Goal type'**
  String get goalType;

  /// No description provided for @gain.
  ///
  /// In en, this message translates to:
  /// **'Gain'**
  String get gain;

  /// No description provided for @lose.
  ///
  /// In en, this message translates to:
  /// **'Lose'**
  String get lose;

  /// No description provided for @maintain.
  ///
  /// In en, this message translates to:
  /// **'Maintain'**
  String get maintain;

  /// No description provided for @initialWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Initial weight (kg)'**
  String get initialWeightKg;

  /// No description provided for @targetWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Target weight (kg)'**
  String get targetWeightKg;

  /// No description provided for @goalStartDate.
  ///
  /// In en, this message translates to:
  /// **'Goal start date'**
  String get goalStartDate;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @durationMonths.
  ///
  /// In en, this message translates to:
  /// **'Duration (months)'**
  String get durationMonths;

  /// No description provided for @durationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 6'**
  String get durationHint;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @goalSummary.
  ///
  /// In en, this message translates to:
  /// **'Your goal summary'**
  String get goalSummary;

  /// No description provided for @goalSummaryFromTo.
  ///
  /// In en, this message translates to:
  /// **'From {initial}kg to {target}kg in {months} months'**
  String goalSummaryFromTo(String initial, String target, int months);

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'≈ {rate} kg/month'**
  String perMonth(String rate);

  /// No description provided for @enterInitialWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter an initial weight'**
  String get enterInitialWeight;

  /// No description provided for @enterTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter a target weight'**
  String get enterTargetWeight;

  /// No description provided for @enterDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter a duration'**
  String get enterDuration;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Invalid weight (0–500 kg)'**
  String get invalidWeight;

  /// No description provided for @invalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Invalid duration (1–24 months)'**
  String get invalidDuration;

  /// No description provided for @targetMustBeGreater.
  ///
  /// In en, this message translates to:
  /// **'Target weight must be greater than initial weight for gain goals.'**
  String get targetMustBeGreater;

  /// No description provided for @targetMustBeLess.
  ///
  /// In en, this message translates to:
  /// **'Target weight must be less than initial weight for loss goals.'**
  String get targetMustBeLess;

  /// No description provided for @errorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving entry. Please try again.'**
  String get errorSaving;

  /// No description provided for @invalidData.
  ///
  /// In en, this message translates to:
  /// **'Invalid data'**
  String get invalidData;

  /// No description provided for @selectGoalType.
  ///
  /// In en, this message translates to:
  /// **'Select a goal type'**
  String get selectGoalType;

  /// No description provided for @invalidGoalStartDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid start date'**
  String get invalidGoalStartDate;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @personalizeExperience.
  ///
  /// In en, this message translates to:
  /// **'Personalize your experience'**
  String get personalizeExperience;

  /// No description provided for @configurePreferences.
  ///
  /// In en, this message translates to:
  /// **'Configure your preferences for the best experience'**
  String get configurePreferences;

  /// No description provided for @weightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight unit'**
  String get weightUnit;

  /// No description provided for @kilograms.
  ///
  /// In en, this message translates to:
  /// **'Kilograms (kg)'**
  String get kilograms;

  /// No description provided for @pounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds (lbs)'**
  String get pounds;

  /// No description provided for @weekStartsOn.
  ///
  /// In en, this message translates to:
  /// **'Week starts on'**
  String get weekStartsOn;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @firstWeighInTitle.
  ///
  /// In en, this message translates to:
  /// **'First weigh-in'**
  String get firstWeighInTitle;

  /// No description provided for @addFirstWeighInTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first weigh-in'**
  String get addFirstWeighInTitle;

  /// No description provided for @yourGoalIs.
  ///
  /// In en, this message translates to:
  /// **'Your goal: {initial}kg → {target}kg in {months} months'**
  String yourGoalIs(String initial, String target, int months);

  /// No description provided for @initialWeightConfigured.
  ///
  /// In en, this message translates to:
  /// **'Initial weight configured: {weight}kg'**
  String initialWeightConfigured(String weight);

  /// No description provided for @weightVeryDifferent.
  ///
  /// In en, this message translates to:
  /// **'Weight very different from configured initial. Please check.'**
  String get weightVeryDifferent;

  /// No description provided for @finishAndStart.
  ///
  /// In en, this message translates to:
  /// **'Finish and start'**
  String get finishAndStart;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @ahead.
  ///
  /// In en, this message translates to:
  /// **'Ahead'**
  String get ahead;

  /// No description provided for @behind.
  ///
  /// In en, this message translates to:
  /// **'Behind'**
  String get behind;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get onTrack;

  /// No description provided for @daysAhead.
  ///
  /// In en, this message translates to:
  /// **'{count} days ahead'**
  String daysAhead(int count);

  /// No description provided for @daysBehind.
  ///
  /// In en, this message translates to:
  /// **'{count} days behind'**
  String daysBehind(int count);

  /// No description provided for @keepItUp.
  ///
  /// In en, this message translates to:
  /// **'Keep it up!'**
  String get keepItUp;

  /// No description provided for @speedOfProgress.
  ///
  /// In en, this message translates to:
  /// **'Speed of progress'**
  String get speedOfProgress;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get current;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @kgPerWeek.
  ///
  /// In en, this message translates to:
  /// **'kg/week'**
  String get kgPerWeek;

  /// No description provided for @percentOfRequired.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of required speed'**
  String percentOfRequired(String percent);

  /// No description provided for @prediction.
  ///
  /// In en, this message translates to:
  /// **'Prediction'**
  String get prediction;

  /// No description provided for @goalReachedInDays.
  ///
  /// In en, this message translates to:
  /// **'Goal reached in {count} days'**
  String goalReachedInDays(int count);

  /// No description provided for @estimatedDate.
  ///
  /// In en, this message translates to:
  /// **'Estimated date: {date}'**
  String estimatedDate(String date);

  /// No description provided for @daysAfterExpected.
  ///
  /// In en, this message translates to:
  /// **'{count} days after expected'**
  String daysAfterExpected(int count);

  /// No description provided for @daysBeforeExpected.
  ///
  /// In en, this message translates to:
  /// **'{count} days before expected'**
  String daysBeforeExpected(int count);

  /// No description provided for @progressVsTime.
  ///
  /// In en, this message translates to:
  /// **'Progress: Time vs Weight'**
  String get progressVsTime;

  /// No description provided for @timeProgress.
  ///
  /// In en, this message translates to:
  /// **'Time progress'**
  String get timeProgress;

  /// No description provided for @timeElapsed.
  ///
  /// In en, this message translates to:
  /// **'Time elapsed'**
  String get timeElapsed;

  /// No description provided for @weightProgress.
  ///
  /// In en, this message translates to:
  /// **'Weight progress'**
  String get weightProgress;

  /// No description provided for @actualChange.
  ///
  /// In en, this message translates to:
  /// **'Actual change'**
  String get actualChange;

  /// No description provided for @aheadByPercent.
  ///
  /// In en, this message translates to:
  /// **'Ahead by {percent}%'**
  String aheadByPercent(String percent);

  /// No description provided for @behindByPercent.
  ///
  /// In en, this message translates to:
  /// **'Behind by {percent}%'**
  String behindByPercent(String percent);

  /// No description provided for @perfectlySynced.
  ///
  /// In en, this message translates to:
  /// **'Perfectly in sync with your goal'**
  String get perfectlySynced;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @navInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get navInsights;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @overviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overviewTitle;

  /// No description provided for @monthsUnit.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get monthsUnit;

  /// No description provided for @kgUnit.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get kgUnit;

  /// No description provided for @lbsUnit.
  ///
  /// In en, this message translates to:
  /// **'lbs'**
  String get lbsUnit;

  /// No description provided for @lbsPerWeek.
  ///
  /// In en, this message translates to:
  /// **'lbs/week'**
  String get lbsPerWeek;

  /// No description provided for @progressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressLabel;

  /// No description provided for @weightToGo.
  ///
  /// In en, this message translates to:
  /// **'{value} kg to go'**
  String weightToGo(String value);

  /// No description provided for @weightToLose.
  ///
  /// In en, this message translates to:
  /// **'{value} kg to lose'**
  String weightToLose(String value);

  /// No description provided for @weightToGoLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight to go'**
  String get weightToGoLabel;

  /// No description provided for @weightToLoseLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight to lose'**
  String get weightToLoseLabel;

  /// No description provided for @weeksLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} weeks left'**
  String weeksLeft(int count);

  /// No description provided for @weeksLeftLabel.
  ///
  /// In en, this message translates to:
  /// **'Weeks left'**
  String get weeksLeftLabel;

  /// No description provided for @goalWeight.
  ///
  /// In en, this message translates to:
  /// **'Goal weight'**
  String get goalWeight;

  /// No description provided for @chartGoalLine.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get chartGoalLine;

  /// No description provided for @chartStartLine.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get chartStartLine;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editWeight.
  ///
  /// In en, this message translates to:
  /// **'Edit weight'**
  String get editWeight;

  /// No description provided for @deleteEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete weigh-in?'**
  String get deleteEntryTitle;

  /// No description provided for @deleteEntryMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteEntryMessage;

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in deleted'**
  String get entryDeleted;

  /// No description provided for @weightUpdated.
  ///
  /// In en, this message translates to:
  /// **'Weigh-in updated'**
  String get weightUpdated;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Export your weight data to CSV or JSON format'**
  String get exportDataDescription;

  /// No description provided for @exportAsCSV.
  ///
  /// In en, this message translates to:
  /// **'Export as CSV'**
  String get exportAsCSV;

  /// No description provided for @exportAsCSVDescription.
  ///
  /// In en, this message translates to:
  /// **'Comma-separated values format, easy to open in Excel'**
  String get exportAsCSVDescription;

  /// No description provided for @exportAsJSON.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get exportAsJSON;

  /// No description provided for @exportAsJSONDescription.
  ///
  /// In en, this message translates to:
  /// **'JSON format with all data including goal configuration'**
  String get exportAsJSONDescription;

  /// No description provided for @exportDataReady.
  ///
  /// In en, this message translates to:
  /// **'Your data is ready to copy:'**
  String get exportDataReady;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to Clipboard'**
  String get copyToClipboard;

  /// No description provided for @dataCopiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Data copied to clipboard'**
  String get dataCopiedToClipboard;

  /// No description provided for @errorExporting.
  ///
  /// In en, this message translates to:
  /// **'Error exporting data'**
  String get errorExporting;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @daysInARow.
  ///
  /// In en, this message translates to:
  /// **'{count} days in a row'**
  String daysInARow(int count);

  /// No description provided for @longestStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest: {count} days'**
  String longestStreak(int count);

  /// No description provided for @makingProgress.
  ///
  /// In en, this message translates to:
  /// **'Making progress'**
  String get makingProgress;

  /// No description provided for @justChecking.
  ///
  /// In en, this message translates to:
  /// **'Just checking'**
  String get justChecking;

  /// No description provided for @yesContinue.
  ///
  /// In en, this message translates to:
  /// **'Yes, continue'**
  String get yesContinue;

  /// No description provided for @weightSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Great! Weight saved successfully'**
  String get weightSavedSuccess;

  /// No description provided for @weightUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated! Your entry has been saved'**
  String get weightUpdatedSuccess;

  /// No description provided for @editGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Goal'**
  String get editGoal;

  /// No description provided for @editYourGoal.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Goal'**
  String get editYourGoal;

  /// No description provided for @editGoalDescription.
  ///
  /// In en, this message translates to:
  /// **'Update your goal settings'**
  String get editGoalDescription;

  /// No description provided for @goalManagement.
  ///
  /// In en, this message translates to:
  /// **'Goal Management'**
  String get goalManagement;

  /// No description provided for @goalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Goal updated successfully'**
  String get goalUpdated;

  /// No description provided for @initialWeightLbs.
  ///
  /// In en, this message translates to:
  /// **'Initial weight (lbs)'**
  String get initialWeightLbs;

  /// No description provided for @targetWeightLbs.
  ///
  /// In en, this message translates to:
  /// **'Target weight (lbs)'**
  String get targetWeightLbs;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @enableReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable Daily Reminders'**
  String get enableReminders;

  /// No description provided for @enableRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified to track your weight'**
  String get enableRemindersDescription;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permission is required to enable reminders'**
  String get notificationPermissionRequired;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementsProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} unlocked'**
  String achievementsProgress(int unlocked, int total);

  /// No description provided for @noAchievementsYet.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking to unlock achievements!'**
  String get noAchievementsYet;

  /// No description provided for @viewAllAchievements.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllAchievements;

  /// No description provided for @addContext.
  ///
  /// In en, this message translates to:
  /// **'Add Context (Optional)'**
  String get addContext;

  /// No description provided for @addContextDescription.
  ///
  /// In en, this message translates to:
  /// **'Track factors that might affect your weight'**
  String get addContextDescription;

  /// No description provided for @sleepQuality.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality'**
  String get sleepQuality;

  /// No description provided for @stressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level'**
  String get stressLevel;

  /// No description provided for @exercisedToday.
  ///
  /// In en, this message translates to:
  /// **'Exercised Today'**
  String get exercisedToday;

  /// No description provided for @mealTiming.
  ///
  /// In en, this message translates to:
  /// **'Meal Timing'**
  String get mealTiming;

  /// No description provided for @selectMealTiming.
  ///
  /// In en, this message translates to:
  /// **'Select when you weighed'**
  String get selectMealTiming;

  /// No description provided for @beforeBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Before Breakfast'**
  String get beforeBreakfast;

  /// No description provided for @afterBreakfast.
  ///
  /// In en, this message translates to:
  /// **'After Breakfast'**
  String get afterBreakfast;

  /// No description provided for @beforeLunch.
  ///
  /// In en, this message translates to:
  /// **'Before Lunch'**
  String get beforeLunch;

  /// No description provided for @afterLunch.
  ///
  /// In en, this message translates to:
  /// **'After Lunch'**
  String get afterLunch;

  /// No description provided for @beforeDinner.
  ///
  /// In en, this message translates to:
  /// **'Before Dinner'**
  String get beforeDinner;

  /// No description provided for @afterDinner.
  ///
  /// In en, this message translates to:
  /// **'After Dinner'**
  String get afterDinner;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Add any additional notes...'**
  String get notesHint;

  /// No description provided for @patternInsights.
  ///
  /// In en, this message translates to:
  /// **'Pattern Insights'**
  String get patternInsights;

  /// No description provided for @tryThis.
  ///
  /// In en, this message translates to:
  /// **'Try this'**
  String get tryThis;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @tipsAndEducation.
  ///
  /// In en, this message translates to:
  /// **'Tips & Education'**
  String get tipsAndEducation;

  /// No description provided for @tipsAndEducationDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn about weight tracking and best practices'**
  String get tipsAndEducationDescription;

  /// No description provided for @allAchievements.
  ///
  /// In en, this message translates to:
  /// **'All Achievements'**
  String get allAchievements;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @timeRange.
  ///
  /// In en, this message translates to:
  /// **'Time range'**
  String get timeRange;

  /// No description provided for @last4Weeks.
  ///
  /// In en, this message translates to:
  /// **'Last 4 weeks'**
  String get last4Weeks;

  /// No description provided for @last3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 months'**
  String get last3Months;

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 months'**
  String get last6Months;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @zoomedIn.
  ///
  /// In en, this message translates to:
  /// **'Zoomed in'**
  String get zoomedIn;

  /// No description provided for @resetZoom.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetZoom;

  /// No description provided for @dataPoints.
  ///
  /// In en, this message translates to:
  /// **'data points'**
  String get dataPoints;

  /// No description provided for @midpoint.
  ///
  /// In en, this message translates to:
  /// **'Midpoint'**
  String get midpoint;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get errorOccurred;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @errorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting entry. Please try again.'**
  String get errorDeleting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
