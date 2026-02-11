import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
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
    Locale('ar'),
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

  /// No description provided for @currentWeightTooltipRollingMedian.
  ///
  /// In en, this message translates to:
  /// **'7-day rolling median. Based on weigh-ins in the last 7 days.'**
  String get currentWeightTooltipRollingMedian;

  /// No description provided for @currentWeightTooltipLastWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Based on your last weigh-in (no entries in the last 7 days).'**
  String get currentWeightTooltipLastWeighIn;

  /// No description provided for @currentWeightPeriodLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get currentWeightPeriodLast7Days;

  /// No description provided for @currentWeightPeriodLastWeighIn.
  ///
  /// In en, this message translates to:
  /// **'Last weigh-in'**
  String get currentWeightPeriodLastWeighIn;

  /// No description provided for @progressToGoal.
  ///
  /// In en, this message translates to:
  /// **'Progress to goal'**
  String get progressToGoal;

  /// No description provided for @progressToGoalWithAmount.
  ///
  /// In en, this message translates to:
  /// **'Progress to goal ({amount})'**
  String progressToGoalWithAmount(String amount);

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
  /// **'Weekly Evolution'**
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
  /// **'Smooth trends'**
  String get featureMedianTitle;

  /// No description provided for @featureMedianDesc.
  ///
  /// In en, this message translates to:
  /// **'Your overview uses a 7-day rolling median; charts use weekly medians to smooth fluctuations.'**
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

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

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

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'Extra days'**
  String get durationDays;

  /// No description provided for @durationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 6'**
  String get durationHint;

  /// No description provided for @durationDaysHint.
  ///
  /// In en, this message translates to:
  /// **'0–31'**
  String get durationDaysHint;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysUnit;

  /// No description provided for @goalEndDate.
  ///
  /// In en, this message translates to:
  /// **'Goal End Date'**
  String get goalEndDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select End Date'**
  String get selectEndDate;

  /// No description provided for @useDuration.
  ///
  /// In en, this message translates to:
  /// **'Use Duration'**
  String get useDuration;

  /// No description provided for @useEndDate.
  ///
  /// In en, this message translates to:
  /// **'Use End Date'**
  String get useEndDate;

  /// No description provided for @calculatedEndDate.
  ///
  /// In en, this message translates to:
  /// **'Calculated End Date'**
  String get calculatedEndDate;

  /// No description provided for @calculatedDuration.
  ///
  /// In en, this message translates to:
  /// **'Calculated Duration'**
  String get calculatedDuration;

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

  /// No description provided for @goalSummaryFromToWithDays.
  ///
  /// In en, this message translates to:
  /// **'From {initial}kg to {target}kg in {months} months and {days} days'**
  String goalSummaryFromToWithDays(
      String initial, String target, int months, int days);

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
  /// **'Kilograms'**
  String get kilograms;

  /// No description provided for @pounds.
  ///
  /// In en, this message translates to:
  /// **'Pounds'**
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
  /// **'Remaining'**
  String get weightToGoLabel;

  /// No description provided for @weightToLoseLabel.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
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

  /// No description provided for @estimationCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Projections'**
  String get estimationCalculatorTitle;

  /// No description provided for @estimationCalculatorDescription.
  ///
  /// In en, this message translates to:
  /// **'Uses your current rate to estimate when you\'ll reach a weight, or what weight to expect by a date.'**
  String get estimationCalculatorDescription;

  /// No description provided for @estimationCalculatorNeedData.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 weigh-ins to use the estimation calculator.'**
  String get estimationCalculatorNeedData;

  /// No description provided for @estimationCurrentRate.
  ///
  /// In en, this message translates to:
  /// **'Current rate: {rate} per week'**
  String estimationCurrentRate(String rate);

  /// No description provided for @estimationWeightToDate.
  ///
  /// In en, this message translates to:
  /// **'When will I reach this weight?'**
  String get estimationWeightToDate;

  /// No description provided for @estimationWeightToDateHint.
  ///
  /// In en, this message translates to:
  /// **'Enter target weight'**
  String get estimationWeightToDateHint;

  /// No description provided for @estimationWeightToDateResult.
  ///
  /// In en, this message translates to:
  /// **'Estimated date: {date}'**
  String estimationWeightToDateResult(String date);

  /// No description provided for @estimationWeightToDateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight in the right direction (gain: above current; loss: below current).'**
  String get estimationWeightToDateInvalid;

  /// No description provided for @estimationWeightToDateNoRate.
  ///
  /// In en, this message translates to:
  /// **'Current rate is zero; add more data to estimate.'**
  String get estimationWeightToDateNoRate;

  /// No description provided for @estimationDateToWeight.
  ///
  /// In en, this message translates to:
  /// **'What will my weight be by this date?'**
  String get estimationDateToWeight;

  /// No description provided for @estimationDateToWeightPick.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get estimationDateToWeightPick;

  /// No description provided for @estimationDateToWeightResult.
  ///
  /// In en, this message translates to:
  /// **'Estimated weight: {weight}'**
  String estimationDateToWeightResult(String weight);

  /// No description provided for @estimationDateToWeightPast.
  ///
  /// In en, this message translates to:
  /// **'Pick a future date.'**
  String get estimationDateToWeightPast;

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

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked: {date}'**
  String achievementUnlocked(String date);

  /// No description provided for @achievementJourneyStarted.
  ///
  /// In en, this message translates to:
  /// **'Journey Started'**
  String get achievementJourneyStarted;

  /// No description provided for @achievementJourneyStartedDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'ve started your weight tracking journey!'**
  String get achievementJourneyStartedDesc;

  /// No description provided for @achievementWeekWarrior.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get achievementWeekWarrior;

  /// No description provided for @achievementWeekWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracked your weight for 7 days in a row!'**
  String get achievementWeekWarriorDesc;

  /// No description provided for @achievementMonthlyMaster.
  ///
  /// In en, this message translates to:
  /// **'Monthly Master'**
  String get achievementMonthlyMaster;

  /// No description provided for @achievementMonthlyMasterDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracked your weight for 30 days in a row!'**
  String get achievementMonthlyMasterDesc;

  /// No description provided for @achievementCenturyChampion.
  ///
  /// In en, this message translates to:
  /// **'Century Champion'**
  String get achievementCenturyChampion;

  /// No description provided for @achievementCenturyChampionDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracked your weight for 100 days in a row!'**
  String get achievementCenturyChampionDesc;

  /// No description provided for @achievementQuarterComplete.
  ///
  /// In en, this message translates to:
  /// **'Quarter Complete'**
  String get achievementQuarterComplete;

  /// No description provided for @achievementQuarterCompleteDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re 25% of the way to your goal!'**
  String get achievementQuarterCompleteDesc;

  /// No description provided for @achievementHalfwayHero.
  ///
  /// In en, this message translates to:
  /// **'Halfway Hero'**
  String get achievementHalfwayHero;

  /// No description provided for @achievementHalfwayHeroDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re halfway to your goal!'**
  String get achievementHalfwayHeroDesc;

  /// No description provided for @achievementAlmostThere.
  ///
  /// In en, this message translates to:
  /// **'Almost There'**
  String get achievementAlmostThere;

  /// No description provided for @achievementAlmostThereDesc.
  ///
  /// In en, this message translates to:
  /// **'You\'re 75% of the way to your goal!'**
  String get achievementAlmostThereDesc;

  /// No description provided for @achievementGoalAchieved.
  ///
  /// In en, this message translates to:
  /// **'Goal Achieved'**
  String get achievementGoalAchieved;

  /// No description provided for @achievementGoalAchievedDesc.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You\'ve reached your goal!'**
  String get achievementGoalAchievedDesc;

  /// No description provided for @achievement10DayTracker.
  ///
  /// In en, this message translates to:
  /// **'10 Day Tracker'**
  String get achievement10DayTracker;

  /// No description provided for @achievement10DayTrackerDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracked your weight for 10 days total!'**
  String get achievement10DayTrackerDesc;

  /// No description provided for @achievement30DayTracker.
  ///
  /// In en, this message translates to:
  /// **'30 Day Tracker'**
  String get achievement30DayTracker;

  /// No description provided for @achievement30DayTrackerDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracked your weight for 30 days total!'**
  String get achievement30DayTrackerDesc;

  /// No description provided for @achievement100DayTracker.
  ///
  /// In en, this message translates to:
  /// **'100 Day Tracker'**
  String get achievement100DayTracker;

  /// No description provided for @achievement100DayTrackerDesc.
  ///
  /// In en, this message translates to:
  /// **'Tracked your weight for 100 days total!'**
  String get achievement100DayTrackerDesc;

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

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @awesome.
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome;

  /// No description provided for @celebrationJourneyStarted.
  ///
  /// In en, this message translates to:
  /// **'Journey Started!'**
  String get celebrationJourneyStarted;

  /// No description provided for @celebrationJourneyStartedMessage.
  ///
  /// In en, this message translates to:
  /// **'Great! You\'ve started your journey!'**
  String get celebrationJourneyStartedMessage;

  /// No description provided for @celebration7DayStreak.
  ///
  /// In en, this message translates to:
  /// **'7 Day Streak!'**
  String get celebration7DayStreak;

  /// No description provided for @celebration7DayStreakMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 7 days in a row! You\'re building an amazing habit!'**
  String get celebration7DayStreakMessage;

  /// No description provided for @celebration30DayStreak.
  ///
  /// In en, this message translates to:
  /// **'30 Day Streak!'**
  String get celebration30DayStreak;

  /// No description provided for @celebration30DayStreakMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 30 days! You\'re a tracking superstar!'**
  String get celebration30DayStreakMessage;

  /// No description provided for @celebration100DayStreak.
  ///
  /// In en, this message translates to:
  /// **'100 Day Streak!'**
  String get celebration100DayStreak;

  /// No description provided for @celebration100DayStreakMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 100 days! This is incredible dedication!'**
  String get celebration100DayStreakMessage;

  /// No description provided for @celebration25Percent.
  ///
  /// In en, this message translates to:
  /// **'25% Complete!'**
  String get celebration25Percent;

  /// No description provided for @celebration25PercentMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 You\'re 25% there! Keep going!'**
  String get celebration25PercentMessage;

  /// No description provided for @celebration50Percent.
  ///
  /// In en, this message translates to:
  /// **'Halfway There!'**
  String get celebration50Percent;

  /// No description provided for @celebration50PercentMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 Halfway there! You\'re doing amazing!'**
  String get celebration50PercentMessage;

  /// No description provided for @celebration75Percent.
  ///
  /// In en, this message translates to:
  /// **'75% Complete!'**
  String get celebration75Percent;

  /// No description provided for @celebration75PercentMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 75% complete! You\'re almost there!'**
  String get celebration75PercentMessage;

  /// No description provided for @celebrationGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal Achieved!'**
  String get celebrationGoalReached;

  /// No description provided for @celebrationGoalReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations! You\'ve reached your goal!'**
  String get celebrationGoalReachedMessage;

  /// No description provided for @emptyStateStartJourney.
  ///
  /// In en, this message translates to:
  /// **'Start Your Journey'**
  String get emptyStateStartJourney;

  /// No description provided for @emptyStateStartJourneyMessage.
  ///
  /// In en, this message translates to:
  /// **'Track your weight to see your progress over time. Every entry brings you closer to your goal!'**
  String get emptyStateStartJourneyMessage;

  /// No description provided for @emptyStateAddFirstWeight.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Weight'**
  String get emptyStateAddFirstWeight;

  /// No description provided for @emptyStateSetGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Your Goal'**
  String get emptyStateSetGoal;

  /// No description provided for @emptyStateSetGoalMessage.
  ///
  /// In en, this message translates to:
  /// **'Define your weight goal to track your progress and stay motivated on your journey!'**
  String get emptyStateSetGoalMessage;

  /// No description provided for @emptyStateNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No History Yet'**
  String get emptyStateNoHistory;

  /// No description provided for @emptyStateNoHistoryMessage.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your weight to build your history. Consistency is key to success!'**
  String get emptyStateNoHistoryMessage;

  /// No description provided for @emptyStateAddWeightEntry.
  ///
  /// In en, this message translates to:
  /// **'Add Weight Entry'**
  String get emptyStateAddWeightEntry;

  /// No description provided for @emptyStateBuildingInsights.
  ///
  /// In en, this message translates to:
  /// **'Building Insights'**
  String get emptyStateBuildingInsights;

  /// No description provided for @emptyStateBuildingInsightsMessage.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking your weight! Once you have enough data, we\'ll show you personalized insights and trends.'**
  String get emptyStateBuildingInsightsMessage;

  /// No description provided for @insightsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Insights Coming Soon'**
  String get insightsComingSoon;

  /// No description provided for @insightsComingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Track your weight for 7 days to unlock insights and progression analysis.'**
  String get insightsComingSoonMessage;

  /// No description provided for @insightsDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String insightsDaysRemaining(int days);

  /// No description provided for @recommendationBehindLoss.
  ///
  /// In en, this message translates to:
  /// **'You\'re {deficit} {unit}/week behind target. Consider reviewing your nutrition and activity levels.'**
  String recommendationBehindLoss(String deficit, String unit);

  /// No description provided for @recommendationSmallChanges.
  ///
  /// In en, this message translates to:
  /// **'Small changes add up: try adding 10-15 minutes of daily activity or reducing portion sizes slightly.'**
  String get recommendationSmallChanges;

  /// No description provided for @recommendationBehindGain.
  ///
  /// In en, this message translates to:
  /// **'You\'re {deficit} {unit}/week behind target. Make sure you\'re eating enough calories and protein.'**
  String recommendationBehindGain(String deficit, String unit);

  /// No description provided for @recommendationTrackMeals.
  ///
  /// In en, this message translates to:
  /// **'Consider tracking your meals to ensure you\'re meeting your caloric goals.'**
  String get recommendationTrackMeals;

  /// No description provided for @recommendationAhead.
  ///
  /// In en, this message translates to:
  /// **'Great progress! You\'re ahead of schedule. Keep up the consistent tracking and maintain your current approach.'**
  String get recommendationAhead;

  /// No description provided for @recommendationOnTrack.
  ///
  /// In en, this message translates to:
  /// **'You\'re right on track! Maintain your current routine - it\'s working well.'**
  String get recommendationOnTrack;

  /// No description provided for @recommendationFinalStretch.
  ///
  /// In en, this message translates to:
  /// **'You\'re in the final stretch! Stay consistent - you\'re almost there!'**
  String get recommendationFinalStretch;

  /// No description provided for @recommendationHalfway.
  ///
  /// In en, this message translates to:
  /// **'You\'re more than halfway there! Keep the momentum going.'**
  String get recommendationHalfway;

  /// No description provided for @recommendationGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'You\'re just getting started. Focus on building consistent habits - the results will follow!'**
  String get recommendationGettingStarted;

  /// No description provided for @recommendationVolatility.
  ///
  /// In en, this message translates to:
  /// **'Your weight is fluctuating quite a bit. This is normal! Try weighing at the same time each day for more consistent readings.'**
  String get recommendationVolatility;

  /// No description provided for @recommendationGeneral.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking consistently! Every entry helps you understand your progress better.'**
  String get recommendationGeneral;

  /// No description provided for @encouragementGoalReached.
  ///
  /// In en, this message translates to:
  /// **'🎉 Congratulations! You\'ve reached your goal!'**
  String get encouragementGoalReached;

  /// No description provided for @encouragementAhead.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing amazing! Keep up the great work!'**
  String get encouragementAhead;

  /// No description provided for @encouragementOnTrack.
  ///
  /// In en, this message translates to:
  /// **'You\'re right on track! Consistency is key.'**
  String get encouragementOnTrack;

  /// No description provided for @encouragementClose.
  ///
  /// In en, this message translates to:
  /// **'You\'re so close! Keep pushing forward!'**
  String get encouragementClose;

  /// No description provided for @encouragementGreatProgress.
  ///
  /// In en, this message translates to:
  /// **'You\'re making great progress! Keep going!'**
  String get encouragementGreatProgress;

  /// No description provided for @encouragementEveryStep.
  ///
  /// In en, this message translates to:
  /// **'Every step counts! You\'re building great habits!'**
  String get encouragementEveryStep;

  /// No description provided for @patternSleepQualityImpact.
  ///
  /// In en, this message translates to:
  /// **'Sleep Quality Impact'**
  String get patternSleepQualityImpact;

  /// No description provided for @patternSleepQualityDescription.
  ///
  /// In en, this message translates to:
  /// **'You tend to {action} more weight when you sleep {quality} ({rating}/5). When sleep quality is {worstRating}/5, your weight changes by {change} kg/day on average.'**
  String patternSleepQualityDescription(String action, String quality,
      int rating, int worstRating, String change);

  /// No description provided for @patternSleepQualitySimilar.
  ///
  /// In en, this message translates to:
  /// **'Your weight changes are similar regardless of sleep quality.'**
  String get patternSleepQualitySimilar;

  /// No description provided for @patternSleepQualitySuggestionGood.
  ///
  /// In en, this message translates to:
  /// **'Try to maintain good sleep habits ({rating}/5) for better weight management.'**
  String patternSleepQualitySuggestionGood(int rating);

  /// No description provided for @patternSleepQualitySuggestionImprove.
  ///
  /// In en, this message translates to:
  /// **'Consider improving your sleep quality - it may help with your weight goals.'**
  String get patternSleepQualitySuggestionImprove;

  /// No description provided for @patternStressLevelImpact.
  ///
  /// In en, this message translates to:
  /// **'Stress Level Impact'**
  String get patternStressLevelImpact;

  /// No description provided for @patternStressLevelDescription.
  ///
  /// In en, this message translates to:
  /// **'When stress is {level} ({rating}/5), your weight changes by {change} kg/day on average. Higher stress ({highRating}/5) shows {highChange} kg/day.'**
  String patternStressLevelDescription(String level, int rating, String change,
      int highRating, String highChange);

  /// No description provided for @patternStressLevelSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Managing stress levels may help with your weight goals.'**
  String get patternStressLevelSuggestion;

  /// No description provided for @patternStressLevelSuggestionFavorable.
  ///
  /// In en, this message translates to:
  /// **'Your weight changes are more favorable when stress is lower.'**
  String get patternStressLevelSuggestionFavorable;

  /// No description provided for @patternExerciseImpact.
  ///
  /// In en, this message translates to:
  /// **'Exercise Impact'**
  String get patternExerciseImpact;

  /// No description provided for @patternExerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'On days you exercise, your weight changes by {withExercise} kg/day on average, compared to {withoutExercise} kg/day when you don\'t exercise.'**
  String patternExerciseDescription(
      String withExercise, String withoutExercise);

  /// No description provided for @patternExerciseDescriptionAlt.
  ///
  /// In en, this message translates to:
  /// **'Exercise days show {withExercise} kg/day change vs {withoutExercise} kg/day on rest days.'**
  String patternExerciseDescriptionAlt(
      String withExercise, String withoutExercise);

  /// No description provided for @patternExerciseSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Keep up the exercise! It appears to be helping with your weight goals.'**
  String get patternExerciseSuggestion;

  /// No description provided for @patternExerciseSuggestionConsistent.
  ///
  /// In en, this message translates to:
  /// **'Consider maintaining a consistent exercise routine.'**
  String get patternExerciseSuggestionConsistent;

  /// No description provided for @patternMealTimingPattern.
  ///
  /// In en, this message translates to:
  /// **'Meal Timing Pattern'**
  String get patternMealTimingPattern;

  /// No description provided for @patternMealTimingDescription.
  ///
  /// In en, this message translates to:
  /// **'Your weight changes are most favorable when weighing {timing}. Average change: {change} kg/day.'**
  String patternMealTimingDescription(String timing, String change);

  /// No description provided for @patternMealTimingSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Try to weigh yourself at consistent times ({timing}) for more accurate tracking.'**
  String patternMealTimingSuggestion(String timing);

  /// No description provided for @patternSleepWell.
  ///
  /// In en, this message translates to:
  /// **'well'**
  String get patternSleepWell;

  /// No description provided for @patternSleepPoorly.
  ///
  /// In en, this message translates to:
  /// **'poorly'**
  String get patternSleepPoorly;

  /// No description provided for @patternStressLow.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get patternStressLow;

  /// No description provided for @patternStressHigh.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get patternStressHigh;

  /// No description provided for @patternLose.
  ///
  /// In en, this message translates to:
  /// **'lose'**
  String get patternLose;

  /// No description provided for @patternGain.
  ///
  /// In en, this message translates to:
  /// **'gain'**
  String get patternGain;

  /// No description provided for @validationWeightGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Please enter a weight greater than 0'**
  String get validationWeightGreaterThanZero;

  /// No description provided for @validationWeightLessThanMax.
  ///
  /// In en, this message translates to:
  /// **'Please enter a weight less than {max}'**
  String validationWeightLessThanMax(String max);

  /// No description provided for @validationUnusuallyLargeChange.
  ///
  /// In en, this message translates to:
  /// **'This weight change seems unusually large. Please double-check your entry.'**
  String get validationUnusuallyLargeChange;

  /// No description provided for @validationSignificantChange.
  ///
  /// In en, this message translates to:
  /// **'This is a significant change from your last entry. Is everything okay? You can still save it.'**
  String get validationSignificantChange;

  /// No description provided for @validationDifferentFromInitial.
  ///
  /// In en, this message translates to:
  /// **'This weight is quite different from your initial weight. Is this correct?'**
  String get validationDifferentFromInitial;

  /// No description provided for @validationGainingWhileLosing.
  ///
  /// In en, this message translates to:
  /// **'You\'re gaining weight while your goal is to lose. That\'s okay—setbacks happen. Do you want to continue?'**
  String get validationGainingWhileLosing;

  /// No description provided for @validationLosingWhileGaining.
  ///
  /// In en, this message translates to:
  /// **'You\'re losing weight while your goal is to gain. That\'s okay—setbacks happen. Do you want to continue?'**
  String get validationLosingWhileGaining;

  /// No description provided for @validationMovingAwayFromGoal.
  ///
  /// In en, this message translates to:
  /// **'You\'re moving away from your goal. This might be normal (fluctuations, life events). Is this correct?'**
  String get validationMovingAwayFromGoal;

  /// No description provided for @validationUnusualWeight.
  ///
  /// In en, this message translates to:
  /// **'This weight seems unusual compared to your recent entries. Is everything okay?'**
  String get validationUnusualWeight;

  /// No description provided for @statusOnTrack.
  ///
  /// In en, this message translates to:
  /// **'You\'re right on track! Keep up the great work!'**
  String get statusOnTrack;

  /// No description provided for @statusAheadWithDays.
  ///
  /// In en, this message translates to:
  /// **'You\'re ahead of schedule! {days} days ahead'**
  String statusAheadWithDays(int days);

  /// No description provided for @statusAhead.
  ///
  /// In en, this message translates to:
  /// **'You\'re ahead of schedule! Great job!'**
  String get statusAhead;

  /// No description provided for @statusBehind.
  ///
  /// In en, this message translates to:
  /// **'You\'re making progress! A bit slower than planned, but you\'re still moving toward your goal.'**
  String get statusBehind;

  /// No description provided for @statusBehindSimple.
  ///
  /// In en, this message translates to:
  /// **'You\'re making progress! Keep going!'**
  String get statusBehindSimple;

  /// No description provided for @statusKeepTracking.
  ///
  /// In en, this message translates to:
  /// **'Keep tracking to see your progress!'**
  String get statusKeepTracking;

  /// No description provided for @predictionOnTrack.
  ///
  /// In en, this message translates to:
  /// **'You\'re on track to reach your goal around the planned date!'**
  String get predictionOnTrack;

  /// No description provided for @predictionAfterTarget.
  ///
  /// In en, this message translates to:
  /// **'At your current rate, you\'ll reach your goal about {days} days after your target date. That\'s okay—progress is progress!'**
  String predictionAfterTarget(int days);

  /// No description provided for @predictionBeforeTarget.
  ///
  /// In en, this message translates to:
  /// **'At your current rate, you\'ll reach your goal about {days} days before your target date. Great job!'**
  String predictionBeforeTarget(int days);

  /// No description provided for @streakStartTracking.
  ///
  /// In en, this message translates to:
  /// **'Start tracking to build your streak!'**
  String get streakStartTracking;

  /// No description provided for @streakGreatStart.
  ///
  /// In en, this message translates to:
  /// **'Great start! Keep it going!'**
  String get streakGreatStart;

  /// No description provided for @streakDaysBuilding.
  ///
  /// In en, this message translates to:
  /// **'{days} days in a row! You\'re building a great habit!'**
  String streakDaysBuilding(int days);

  /// No description provided for @streakDaysAmazing.
  ///
  /// In en, this message translates to:
  /// **'{days} days in a row! You\'re doing amazing!'**
  String streakDaysAmazing(int days);

  /// No description provided for @streakDaysIncredible.
  ///
  /// In en, this message translates to:
  /// **'{days} days in a row! This is incredible!'**
  String streakDaysIncredible(int days);

  /// No description provided for @streakDaysChampion.
  ///
  /// In en, this message translates to:
  /// **'{days} days in a row! You\'re a tracking champion!'**
  String streakDaysChampion(int days);

  /// No description provided for @educationWhyFluctuatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Weight Fluctuates Daily'**
  String get educationWhyFluctuatesTitle;

  /// No description provided for @educationWhyFluctuatesContent.
  ///
  /// In en, this message translates to:
  /// **'Your weight naturally fluctuates throughout the day and week. This is completely normal! Factors include:\n\n• Water retention (can vary by 1-2 kg)\n• Food and digestion\n• Sleep quality and duration\n• Hormonal changes\n• Exercise and muscle recovery\n\nThat\'s why we use a 7-day rolling median for your current weight and weekly medians in charts - they smooth out daily noise and show your true progress.'**
  String get educationWhyFluctuatesContent;

  /// No description provided for @educationWeeklyMediansTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Smooth Your Data'**
  String get educationWeeklyMediansTitle;

  /// No description provided for @educationWeeklyMediansContent.
  ///
  /// In en, this message translates to:
  /// **'Your current weight on the overview is a 7-day rolling median: the median of all weigh-ins in the last 7 days (or your last weigh-in if none in that window). This keeps the number responsive and robust to outliers.\n\nCharts use weekly medians: we take the median weight for each full week (Mon–Sun). That gives a stable trend over time. For example: if you weigh 70kg, 71kg, 70.5kg, 70.2kg, and 70.8kg in a week, the median is 70.5kg - a more stable number than any single day.'**
  String get educationWeeklyMediansContent;

  /// No description provided for @educationBestPracticesTitle.
  ///
  /// In en, this message translates to:
  /// **'Best Practices for Tracking'**
  String get educationBestPracticesTitle;

  /// No description provided for @educationBestPracticesContent.
  ///
  /// In en, this message translates to:
  /// **'For the most accurate tracking:\n\n• Weigh at the same time each day (morning is best)\n• Use the same scale\n• Weigh before eating or drinking\n• Weigh after using the bathroom\n• Wear similar clothing (or none)\n\nConsistency is more important than perfection!'**
  String get educationBestPracticesContent;

  /// No description provided for @educationPlateausTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding Plateaus'**
  String get educationPlateausTitle;

  /// No description provided for @educationPlateausContent.
  ///
  /// In en, this message translates to:
  /// **'Weight plateaus are completely normal and not a sign of failure!\n\nYour body may:\n• Retain water during muscle recovery\n• Adjust metabolism\n• Redistribute weight (fat loss, muscle gain)\n\nIf you\'re following your plan, trust the process. Plateaus often break after a few weeks. Focus on consistency over speed.'**
  String get educationPlateausContent;

  /// No description provided for @educationContextTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Why Track Context?'**
  String get educationContextTrackingTitle;

  /// No description provided for @educationContextTrackingContent.
  ///
  /// In en, this message translates to:
  /// **'Tracking context (sleep, stress, exercise, meal timing) helps you understand patterns.\n\nYou might discover:\n• Better sleep = better weight management\n• High stress affects your progress\n• Exercise timing matters\n• Meal timing impacts daily weight\n\nThese insights help you make informed decisions about your journey.'**
  String get educationContextTrackingContent;

  /// No description provided for @educationStayingMotivatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Staying Motivated'**
  String get educationStayingMotivatedTitle;

  /// No description provided for @educationStayingMotivatedContent.
  ///
  /// In en, this message translates to:
  /// **'Weight tracking is a marathon, not a sprint.\n\nRemember:\n• Progress isn\'t always linear\n• Small daily actions compound over time\n• Setbacks are part of the journey\n• Celebrate non-scale victories too\n\nFocus on building sustainable habits. Every day you track is a win!'**
  String get educationStayingMotivatedContent;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsTitle;

  /// No description provided for @toolsDescription.
  ///
  /// In en, this message translates to:
  /// **'Calculators and utilities for your weight journey'**
  String get toolsDescription;

  /// No description provided for @toolProjections.
  ///
  /// In en, this message translates to:
  /// **'Projections'**
  String get toolProjections;

  /// No description provided for @toolProjectionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Estimate when you\'ll reach a weight or what weight to expect by a date'**
  String get toolProjectionsDesc;

  /// No description provided for @toolBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get toolBmi;

  /// No description provided for @toolBmiDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your Body Mass Index and see where you stand'**
  String get toolBmiDesc;

  /// No description provided for @toolMaintenanceCalories.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Calories'**
  String get toolMaintenanceCalories;

  /// No description provided for @toolMaintenanceCaloriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Your daily energy expenditure and how intake affects weight over time'**
  String get toolMaintenanceCaloriesDesc;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileDescription.
  ///
  /// In en, this message translates to:
  /// **'Your info for BMI and calorie tools'**
  String get profileDescription;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @heightHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 175'**
  String get heightHint;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get birthDate;

  /// No description provided for @birthDateHint.
  ///
  /// In en, this message translates to:
  /// **'For age in calorie calculator'**
  String get birthDateHint;

  /// No description provided for @saveToProfile.
  ///
  /// In en, this message translates to:
  /// **'Save to profile'**
  String get saveToProfile;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get openSettings;

  /// No description provided for @openSettingsDesc.
  ///
  /// In en, this message translates to:
  /// **'Theme, language, reminders, goal, export'**
  String get openSettingsDesc;

  /// No description provided for @bmiTitle.
  ///
  /// In en, this message translates to:
  /// **'BMI Calculator'**
  String get bmiTitle;

  /// No description provided for @bmiDescription.
  ///
  /// In en, this message translates to:
  /// **'Body Mass Index from your height and weight. Use profile data or enter below.'**
  String get bmiDescription;

  /// No description provided for @bmiUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get bmiUnderweight;

  /// No description provided for @bmiNormal.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get bmiNormal;

  /// No description provided for @bmiOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get bmiOverweight;

  /// No description provided for @bmiObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get bmiObese;

  /// No description provided for @bmiSevereThinness.
  ///
  /// In en, this message translates to:
  /// **'Severe thinness'**
  String get bmiSevereThinness;

  /// No description provided for @bmiModerateThinness.
  ///
  /// In en, this message translates to:
  /// **'Moderate thinness'**
  String get bmiModerateThinness;

  /// No description provided for @bmiMildThinness.
  ///
  /// In en, this message translates to:
  /// **'Mild thinness'**
  String get bmiMildThinness;

  /// No description provided for @bmiObeseClass1.
  ///
  /// In en, this message translates to:
  /// **'Obese Class I'**
  String get bmiObeseClass1;

  /// No description provided for @bmiObeseClass2.
  ///
  /// In en, this message translates to:
  /// **'Obese Class II'**
  String get bmiObeseClass2;

  /// No description provided for @bmiObeseClass3.
  ///
  /// In en, this message translates to:
  /// **'Obese Class III'**
  String get bmiObeseClass3;

  /// No description provided for @yourBmi.
  ///
  /// In en, this message translates to:
  /// **'Your BMI'**
  String get yourBmi;

  /// No description provided for @enterHeightAndWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter height and weight (or set them in Profile)'**
  String get enterHeightAndWeight;

  /// No description provided for @useCurrentWeight.
  ///
  /// In en, this message translates to:
  /// **'Use current weight from tracking'**
  String get useCurrentWeight;

  /// No description provided for @weightForBmi.
  ///
  /// In en, this message translates to:
  /// **'Weight for BMI'**
  String get weightForBmi;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Calories'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Estimated daily energy expenditure (TDEE) and how your intake affects weight.'**
  String get maintenanceDescription;

  /// No description provided for @maintenanceTdee.
  ///
  /// In en, this message translates to:
  /// **'Maintenance (TDEE)'**
  String get maintenanceTdee;

  /// No description provided for @maintenanceTdeeResult.
  ///
  /// In en, this message translates to:
  /// **'About {calories} kcal/day'**
  String maintenanceTdeeResult(String calories);

  /// No description provided for @dailyIntake.
  ///
  /// In en, this message translates to:
  /// **'Daily intake (kcal)'**
  String get dailyIntake;

  /// No description provided for @dailyIntakeHint.
  ///
  /// In en, this message translates to:
  /// **'Optional: see effect on weight'**
  String get dailyIntakeHint;

  /// No description provided for @periodWeeks.
  ///
  /// In en, this message translates to:
  /// **'Period (weeks)'**
  String get periodWeeks;

  /// No description provided for @projectedChange.
  ///
  /// In en, this message translates to:
  /// **'Projected change'**
  String get projectedChange;

  /// No description provided for @activityLevel.
  ///
  /// In en, this message translates to:
  /// **'Activity level'**
  String get activityLevel;

  /// No description provided for @activitySedentary.
  ///
  /// In en, this message translates to:
  /// **'Sedentary (little or no exercise)'**
  String get activitySedentary;

  /// No description provided for @activityLight.
  ///
  /// In en, this message translates to:
  /// **'Light (1–3 days/week)'**
  String get activityLight;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate (3–5 days/week)'**
  String get activityModerate;

  /// No description provided for @activityActive.
  ///
  /// In en, this message translates to:
  /// **'Active (6–7 days/week)'**
  String get activityActive;

  /// No description provided for @activityVeryActive.
  ///
  /// In en, this message translates to:
  /// **'Very active (intense daily)'**
  String get activityVeryActive;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @ageYears.
  ///
  /// In en, this message translates to:
  /// **'Age (years)'**
  String get ageYears;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
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
