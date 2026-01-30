// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'تتبع الوزن';

  @override
  String get addWeight => 'إضافة وزن';

  @override
  String get weightTracking => 'تتبع الوزن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get errorLoading => 'خطأ في التحميل';

  @override
  String get startTrackingPrompt => 'ابدأ بتتبع وزنك';

  @override
  String get addFirstWeighIn => 'أضف أول قياس وزن للبدء';

  @override
  String get currentWeight => 'الوزن الحالي';

  @override
  String get progressToGoal => 'التقدم نحو الهدف';

  @override
  String progressToGoalWithAmount(String amount) {
    return 'التقدم نحو الهدف ($amount)';
  }

  @override
  String get start => 'البداية';

  @override
  String get goal => 'الهدف';

  @override
  String get weeks => 'أسابيع';

  @override
  String get medians => 'متوسطات';

  @override
  String get notEnoughData => 'لا توجد بيانات كافية';

  @override
  String get addWeighInsForChart => 'أضف قياسات الوزن لرؤية الرسم البياني';

  @override
  String get weeklyEvolution => 'التطور الأسبوعي (المتوسط)';

  @override
  String get recentWeighIns => 'قياسات الوزن الأخيرة';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get save => 'حفظ';

  @override
  String get weightSaved => 'تم حفظ الوزن بنجاح';

  @override
  String get validationError => 'خطأ في التحقق';

  @override
  String get warning => 'تحذير';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirm => 'تأكيد';

  @override
  String get weightKg => 'الوزن (كجم)';

  @override
  String get weightLbs => 'الوزن (رطل)';

  @override
  String get weightHint => 'مثال: 70.50';

  @override
  String get targetWeightHint => 'مثال: 85.00';

  @override
  String errorWithMessage(String message) {
    return 'خطأ: $message';
  }

  @override
  String get pleaseEnterWeight => 'يرجى إدخال وزن';

  @override
  String get pleaseEnterValidWeight => 'يرجى إدخال وزن صحيح (0-300 كجم)';

  @override
  String get pleaseEnterValidWeightLbs => 'يرجى إدخال وزن صحيح (0-660 رطل)';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get register => 'تسجيل';

  @override
  String get welcomeTitle => 'مرحباً بك في w8';

  @override
  String get welcomeSubtitle =>
      'رفيقك لتتبع تقدم وزنك. اكتسب 15 كجم في 6 أشهر أو حدد هدفك الخاص.';

  @override
  String get featureMedianTitle => 'المتوسط الأسبوعي';

  @override
  String get featureMedianDesc => 'يحسب المتوسط تلقائياً لتخفيف التقلبات.';

  @override
  String get featureSmartTitle => 'تتبع ذكي';

  @override
  String get featureSmartDesc => 'يكتشف الشذوذات ويحقق من بياناتك.';

  @override
  String get featureProgressTitle => 'تقدم واضح';

  @override
  String get featureProgressDesc => 'انظر أين أنت بالنسبة لهدفك.';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get languageTitle => 'اختر لغتك';

  @override
  String get languageSubtitle =>
      'سيستخدم التطبيق هذه اللغة. يمكنك تغييرها لاحقاً في الإعدادات.';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageArabic => 'العربية';

  @override
  String get goalConfigTitle => 'تكوين الهدف';

  @override
  String get whatIsYourGoal => 'ما هو هدفك؟';

  @override
  String get configureGoal => 'قم بتكوين هدفك الشخصي';

  @override
  String get goalType => 'نوع الهدف';

  @override
  String get gain => 'زيادة';

  @override
  String get lose => 'فقدان';

  @override
  String get maintain => 'الحفاظ';

  @override
  String get initialWeightKg => 'الوزن الأولي (كجم)';

  @override
  String get targetWeightKg => 'الوزن المستهدف (كجم)';

  @override
  String get goalStartDate => 'تاريخ بداية الهدف';

  @override
  String get selectDate => 'اختر تاريخاً';

  @override
  String get durationMonths => 'المدة (أشهر)';

  @override
  String get durationDays => 'أيام إضافية';

  @override
  String get durationHint => 'مثال: 6';

  @override
  String get durationDaysHint => '0–31';

  @override
  String get daysUnit => 'أيام';

  @override
  String get goalEndDate => 'تاريخ نهاية الهدف';

  @override
  String get selectEndDate => 'اختر تاريخ النهاية';

  @override
  String get useDuration => 'استخدم المدة';

  @override
  String get useEndDate => 'استخدم تاريخ النهاية';

  @override
  String get calculatedEndDate => 'تاريخ النهاية المحسوب';

  @override
  String get calculatedDuration => 'المدة المحسوبة';

  @override
  String get continueButton => 'متابعة';

  @override
  String get goalSummary => 'ملخص هدفك';

  @override
  String goalSummaryFromTo(String initial, String target, int months) {
    return 'من $initial كجم إلى $target كجم في $months أشهر';
  }

  @override
  String goalSummaryFromToWithDays(
      String initial, String target, int months, int days) {
    return 'من $initial كجم إلى $target كجم في $months أشهر و $days أيام';
  }

  @override
  String perMonth(String rate) {
    return '≈ $rate كجم/شهر';
  }

  @override
  String get enterInitialWeight => 'أدخل وزناً أولياً';

  @override
  String get enterTargetWeight => 'أدخل وزناً مستهدفاً';

  @override
  String get enterDuration => 'أدخل مدة';

  @override
  String get invalidWeight => 'وزن غير صحيح (0-500 كجم)';

  @override
  String get invalidDuration => 'مدة غير صحيحة (1-24 شهراً)';

  @override
  String get targetMustBeGreater =>
      'يجب أن يكون الوزن المستهدف أكبر من الوزن الأولي لأهداف الزيادة.';

  @override
  String get targetMustBeLess =>
      'يجب أن يكون الوزن المستهدف أقل من الوزن الأولي لأهداف الفقدان.';

  @override
  String get errorSaving => 'خطأ في حفظ الإدخال. يرجى المحاولة مرة أخرى.';

  @override
  String get invalidData => 'بيانات غير صحيحة';

  @override
  String get selectGoalType => 'اختر نوع الهدف';

  @override
  String get invalidGoalStartDate => 'تاريخ بداية غير صحيح';

  @override
  String get preferencesTitle => 'التفضيلات';

  @override
  String get personalizeExperience => 'خصص تجربتك';

  @override
  String get configurePreferences => 'قم بتكوين تفضيلاتك للحصول على أفضل تجربة';

  @override
  String get weightUnit => 'وحدة الوزن';

  @override
  String get kilograms => 'كيلوغرامات';

  @override
  String get pounds => 'أرطال';

  @override
  String get weekStartsOn => 'يبدأ الأسبوع في';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get saturday => 'السبت';

  @override
  String get sunday => 'الأحد';

  @override
  String get firstWeighInTitle => 'أول قياس وزن';

  @override
  String get addFirstWeighInTitle => 'أضف أول قياس وزن';

  @override
  String yourGoalIs(String initial, String target, int months) {
    return 'هدفك: $initial كجم → $target كجم في $months أشهر';
  }

  @override
  String initialWeightConfigured(String weight) {
    return 'الوزن الأولي المكون: $weight كجم';
  }

  @override
  String get weightVeryDifferent =>
      'الوزن مختلف جداً عن الوزن الأولي المكون. يرجى التحقق.';

  @override
  String get finishAndStart => 'إنهاء والبدء';

  @override
  String get insights => 'رؤى';

  @override
  String get ahead => 'متقدم';

  @override
  String get behind => 'متأخر';

  @override
  String get onTrack => 'على المسار الصحيح';

  @override
  String daysAhead(int count) {
    return 'متقدم $count أيام';
  }

  @override
  String daysBehind(int count) {
    return 'متأخر $count أيام';
  }

  @override
  String get keepItUp => 'استمر!';

  @override
  String get speedOfProgress => 'سرعة التقدم';

  @override
  String get current => 'الحالي';

  @override
  String get required => 'المطلوب';

  @override
  String get kgPerWeek => 'كجم/أسبوع';

  @override
  String percentOfRequired(String percent) {
    return '$percent% من السرعة المطلوبة';
  }

  @override
  String get prediction => 'التنبؤ';

  @override
  String goalReachedInDays(int count) {
    return 'سيتم الوصول للهدف في $count أيام';
  }

  @override
  String estimatedDate(String date) {
    return 'التاريخ المقدر: $date';
  }

  @override
  String daysAfterExpected(int count) {
    return '$count أيام بعد المتوقع';
  }

  @override
  String daysBeforeExpected(int count) {
    return '$count أيام قبل المتوقع';
  }

  @override
  String get progressVsTime => 'التقدم: الوقت مقابل الوزن';

  @override
  String get timeProgress => 'تقدم الوقت';

  @override
  String get timeElapsed => 'الوقت المنقضي';

  @override
  String get weightProgress => 'تقدم الوزن';

  @override
  String get actualChange => 'التغيير الفعلي';

  @override
  String aheadByPercent(String percent) {
    return 'متقدم بنسبة $percent%';
  }

  @override
  String behindByPercent(String percent) {
    return 'متأخر بنسبة $percent%';
  }

  @override
  String get perfectlySynced => 'متزامن تماماً مع هدفك';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get progressTitle => 'التقدم';

  @override
  String get historyTitle => 'السجل';

  @override
  String get insightsTitle => 'الرؤى';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navProgress => 'التقدم';

  @override
  String get navHistory => 'السجل';

  @override
  String get navInsights => 'الرؤى';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get navOverview => 'نظرة عامة';

  @override
  String get overviewTitle => 'نظرة عامة';

  @override
  String get monthsUnit => 'أشهر';

  @override
  String get kgUnit => 'كجم';

  @override
  String get lbsUnit => 'رطل';

  @override
  String get lbsPerWeek => 'رطل/أسبوع';

  @override
  String get progressLabel => 'التقدم';

  @override
  String weightToGo(String value) {
    return '$value كجم متبقية';
  }

  @override
  String weightToLose(String value) {
    return '$value كجم للفقدان';
  }

  @override
  String get weightToGoLabel => 'الوزن المتبقي';

  @override
  String get weightToLoseLabel => 'الوزن للفقدان';

  @override
  String weeksLeft(int count) {
    return 'متبقي $count أسابيع';
  }

  @override
  String get weeksLeftLabel => 'الأسابيع المتبقية';

  @override
  String get goalWeight => 'الوزن المستهدف';

  @override
  String get estimationCalculatorTitle => 'التوقعات';

  @override
  String get estimationCalculatorDescription =>
      'تستخدم معدلك الحالي لتقدير متى تصل إلى وزن معين، أو الوزن المتوقع في تاريخ معين.';

  @override
  String get estimationCalculatorNeedData =>
      'أضف وزنين على الأقل لاستخدام حاسبة التقدير.';

  @override
  String estimationCurrentRate(String rate) {
    return 'المعدل الحالي: $rate في الأسبوع';
  }

  @override
  String get estimationWeightToDate => 'متى سأصل إلى هذا الوزن؟';

  @override
  String get estimationWeightToDateHint => 'أدخل الوزن المستهدف';

  @override
  String estimationWeightToDateResult(String date) {
    return 'التاريخ المتوقع: $date';
  }

  @override
  String get estimationWeightToDateInvalid =>
      'أدخل وزناً في الاتجاه الصحيح (زيادة: أعلى من الحالي؛ خسارة: أقل من الحالي).';

  @override
  String get estimationWeightToDateNoRate =>
      'المعدل الحالي صفر؛ أضف المزيد من البيانات للتقدير.';

  @override
  String get estimationDateToWeight => 'ما الوزن المتوقع في هذا التاريخ؟';

  @override
  String get estimationDateToWeightPick => 'اختر تاريخاً';

  @override
  String estimationDateToWeightResult(String weight) {
    return 'الوزن المتوقع: $weight';
  }

  @override
  String get estimationDateToWeightPast => 'اختر تاريخاً مستقبلياً.';

  @override
  String get chartGoalLine => 'الهدف';

  @override
  String get chartStartLine => 'البداية';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get editWeight => 'تعديل الوزن';

  @override
  String get deleteEntryTitle => 'حذف قياس الوزن؟';

  @override
  String get deleteEntryMessage => 'لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get entryDeleted => 'تم حذف قياس الوزن';

  @override
  String get weightUpdated => 'تم تحديث قياس الوزن';

  @override
  String get dataManagement => 'إدارة البيانات';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get exportDataDescription =>
      'قم بتصدير بيانات وزنك بتنسيق CSV أو JSON';

  @override
  String get exportAsCSV => 'تصدير كـ CSV';

  @override
  String get exportAsCSVDescription =>
      'تنسيق قيم مفصولة بفواصل، سهل الفتح في Excel';

  @override
  String get exportAsJSON => 'تصدير كـ JSON';

  @override
  String get exportAsJSONDescription =>
      'تنسيق JSON مع جميع البيانات بما في ذلك تكوين الهدف';

  @override
  String get exportDataReady => 'بياناتك جاهزة للنسخ:';

  @override
  String get copyToClipboard => 'نسخ إلى الحافظة';

  @override
  String get dataCopiedToClipboard => 'تم نسخ البيانات إلى الحافظة';

  @override
  String get errorExporting => 'خطأ في التصدير';

  @override
  String get close => 'إغلاق';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String daysInARow(int count) {
    return '$count أيام متتالية';
  }

  @override
  String longestStreak(int count) {
    return 'الأطول: $count أيام';
  }

  @override
  String get makingProgress => 'إحراز تقدم';

  @override
  String get justChecking => 'التحقق فقط';

  @override
  String get yesContinue => 'نعم، متابعة';

  @override
  String get weightSavedSuccess => 'رائع! تم حفظ الوزن بنجاح';

  @override
  String get weightUpdatedSuccess => 'تم التحديث! تم حفظ إدخالك';

  @override
  String get editGoal => 'تعديل الهدف';

  @override
  String get editYourGoal => 'عدل هدفك';

  @override
  String get editGoalDescription => 'قم بتحديث إعدادات هدفك';

  @override
  String get goalManagement => 'إدارة الهدف';

  @override
  String get goalUpdated => 'تم تحديث الهدف بنجاح';

  @override
  String get initialWeightLbs => 'الوزن الأولي (رطل)';

  @override
  String get targetWeightLbs => 'الوزن المستهدف (رطل)';

  @override
  String get reminders => 'التذكيرات';

  @override
  String get enableReminders => 'تفعيل التذكيرات اليومية';

  @override
  String get enableRemindersDescription => 'احصل على إشعار لتتبع وزنك';

  @override
  String get reminderTime => 'وقت التذكير';

  @override
  String get notificationPermissionRequired =>
      'إذن الإشعارات مطلوب لتفعيل التذكيرات';

  @override
  String get notSet => 'غير محدد';

  @override
  String get achievements => 'الإنجازات';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked من $total مفتوحة';
  }

  @override
  String get noAchievementsYet => 'استمر في التتبع لفتح الإنجازات!';

  @override
  String get viewAllAchievements => 'عرض الكل';

  @override
  String achievementUnlocked(String date) {
    return 'مفتوح: $date';
  }

  @override
  String get achievementJourneyStarted => 'بدأت الرحلة';

  @override
  String get achievementJourneyStartedDesc => 'لقد بدأت رحلة تتبع وزنك!';

  @override
  String get achievementWeekWarrior => 'محارب الأسبوع';

  @override
  String get achievementWeekWarriorDesc =>
      'لقد تتبعت وزنك لمدة 7 أيام متتالية!';

  @override
  String get achievementMonthlyMaster => 'سيد الشهر';

  @override
  String get achievementMonthlyMasterDesc =>
      'لقد تتبعت وزنك لمدة 30 يوماً متتالية!';

  @override
  String get achievementCenturyChampion => 'بطل المئة';

  @override
  String get achievementCenturyChampionDesc =>
      'لقد تتبعت وزنك لمدة 100 يوم متتالية!';

  @override
  String get achievementQuarterComplete => 'ربع مكتمل';

  @override
  String get achievementQuarterCompleteDesc => 'أنت عند 25% من هدفك!';

  @override
  String get achievementHalfwayHero => 'بطل منتصف الطريق';

  @override
  String get achievementHalfwayHeroDesc => 'أنت في منتصف الطريق إلى هدفك!';

  @override
  String get achievementAlmostThere => 'تقريباً هناك';

  @override
  String get achievementAlmostThereDesc => 'أنت عند 75% من هدفك!';

  @override
  String get achievementGoalAchieved => 'تم تحقيق الهدف';

  @override
  String get achievementGoalAchievedDesc => 'تهانينا! لقد حققت هدفك!';

  @override
  String get achievement10DayTracker => 'متتبع 10 أيام';

  @override
  String get achievement10DayTrackerDesc =>
      'لقد تتبعت وزنك لمدة 10 أيام إجمالاً!';

  @override
  String get achievement30DayTracker => 'متتبع 30 يوماً';

  @override
  String get achievement30DayTrackerDesc =>
      'لقد تتبعت وزنك لمدة 30 يوماً إجمالاً!';

  @override
  String get achievement100DayTracker => 'متتبع 100 يوم';

  @override
  String get achievement100DayTrackerDesc =>
      'لقد تتبعت وزنك لمدة 100 يوم إجمالاً!';

  @override
  String get addContext => 'إضافة سياق (اختياري)';

  @override
  String get addContextDescription => 'تتبع العوامل التي قد تؤثر على وزنك';

  @override
  String get sleepQuality => 'جودة النوم';

  @override
  String get stressLevel => 'مستوى التوتر';

  @override
  String get exercisedToday => 'تم التمرين اليوم';

  @override
  String get mealTiming => 'توقيت الوجبة';

  @override
  String get selectMealTiming => 'اختر متى قمت بالوزن';

  @override
  String get beforeBreakfast => 'قبل الإفطار';

  @override
  String get afterBreakfast => 'بعد الإفطار';

  @override
  String get beforeLunch => 'قبل الغداء';

  @override
  String get afterLunch => 'بعد الغداء';

  @override
  String get beforeDinner => 'قبل العشاء';

  @override
  String get afterDinner => 'بعد العشاء';

  @override
  String get other => 'أخرى';

  @override
  String get notes => 'ملاحظات';

  @override
  String get notesHint => 'أضف أي ملاحظات إضافية...';

  @override
  String get patternInsights => 'رؤى الأنماط';

  @override
  String get tryThis => 'جرب هذا';

  @override
  String get learnMore => 'تعلم المزيد';

  @override
  String get gotIt => 'فهمت';

  @override
  String get tipsAndEducation => 'نصائح وتعليم';

  @override
  String get tipsAndEducationDescription =>
      'تعلم عن تتبع الوزن وأفضل الممارسات';

  @override
  String get allAchievements => 'جميع الإنجازات';

  @override
  String get recommendations => 'التوصيات';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'المظهر';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'النظام';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get timeRange => 'النطاق الزمني';

  @override
  String get last4Weeks => 'آخر 4 أسابيع';

  @override
  String get last3Months => 'آخر 3 أشهر';

  @override
  String get last6Months => 'آخر 6 أشهر';

  @override
  String get allTime => 'كل الوقت';

  @override
  String get zoomedIn => 'مكبر';

  @override
  String get resetZoom => 'إعادة تعيين';

  @override
  String get dataPoints => 'نقاط البيانات';

  @override
  String get midpoint => 'النقطة الوسطى';

  @override
  String get latest => 'الأحدث';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get errorOccurred => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get goBack => 'العودة';

  @override
  String get errorDeleting => 'خطأ في حذف الإدخال. يرجى المحاولة مرة أخرى.';

  @override
  String get back => 'رجوع';

  @override
  String get awesome => 'رائع!';

  @override
  String get celebrationJourneyStarted => 'بدأت الرحلة!';

  @override
  String get celebrationJourneyStartedMessage => 'رائع! لقد بدأت رحلتك!';

  @override
  String get celebration7DayStreak => 'سلسلة 7 أيام!';

  @override
  String get celebration7DayStreakMessage =>
      '🎉 7 أيام متتالية! أنت تبني عادة رائعة!';

  @override
  String get celebration30DayStreak => 'سلسلة 30 يوماً!';

  @override
  String get celebration30DayStreakMessage => '🎉 30 يوماً! أنت نجم في التتبع!';

  @override
  String get celebration100DayStreak => 'سلسلة 100 يوم!';

  @override
  String get celebration100DayStreakMessage => '🎉 100 يوم! هذا تفانٍ لا يصدق!';

  @override
  String get celebration25Percent => '25% مكتمل!';

  @override
  String get celebration25PercentMessage => '🎉 أنت عند 25%! استمر!';

  @override
  String get celebration50Percent => 'في منتصف الطريق!';

  @override
  String get celebration50PercentMessage =>
      '🎉 في منتصف الطريق! أنت تقوم بعمل رائع!';

  @override
  String get celebration75Percent => '75% مكتمل!';

  @override
  String get celebration75PercentMessage => '🎉 75% مكتمل! أنت على وشك الوصول!';

  @override
  String get celebrationGoalReached => 'تم تحقيق الهدف!';

  @override
  String get celebrationGoalReachedMessage => '🎉 تهانينا! لقد حققت هدفك!';

  @override
  String get emptyStateStartJourney => 'ابدأ رحلتك';

  @override
  String get emptyStateStartJourneyMessage =>
      'تتبع وزنك لرؤية تقدمك مع مرور الوقت. كل إدخال يقربك من هدفك!';

  @override
  String get emptyStateAddFirstWeight => 'أضف وزنك الأول';

  @override
  String get emptyStateSetGoal => 'حدد هدفك';

  @override
  String get emptyStateSetGoalMessage =>
      'حدد هدف وزنك لتتبع تقدمك والبقاء متحفزاً في رحلتك!';

  @override
  String get emptyStateNoHistory => 'لا يوجد سجل بعد';

  @override
  String get emptyStateNoHistoryMessage =>
      'ابدأ بتتبع وزنك لبناء سجلك. الاتساق هو مفتاح النجاح!';

  @override
  String get emptyStateAddWeightEntry => 'إضافة إدخال وزن';

  @override
  String get emptyStateBuildingInsights => 'بناء الرؤى';

  @override
  String get emptyStateBuildingInsightsMessage =>
      'استمر في تتبع وزنك! بمجرد أن يكون لديك بيانات كافية، سنعرض لك رؤى واتجاهات مخصصة.';

  @override
  String get insightsComingSoon => 'الرؤى قادمة قريباً';

  @override
  String get insightsComingSoonMessage =>
      'تتبع وزنك لمدة 7 أيام لفتح الرؤى وتحليل التقدم.';

  @override
  String insightsDaysRemaining(int days) {
    return 'متبقي $days أيام';
  }

  @override
  String recommendationBehindLoss(String deficit, String unit) {
    return 'أنت متأخر $deficit $unit/أسبوع عن الهدف. فكر في مراجعة تغذيتك ومستويات نشاطك.';
  }

  @override
  String get recommendationSmallChanges =>
      'التغييرات الصغيرة تتراكم: جرب إضافة 10-15 دقيقة من النشاط اليومي أو تقليل أحجام الوجبات قليلاً.';

  @override
  String recommendationBehindGain(String deficit, String unit) {
    return 'أنت متأخر $deficit $unit/أسبوع عن الهدف. تأكد من أنك تأكل سعرات حرارية وبروتين كافيين.';
  }

  @override
  String get recommendationTrackMeals =>
      'فكر في تتبع وجباتك لضمان تحقيق أهدافك من السعرات الحرارية.';

  @override
  String get recommendationAhead =>
      'تقدم رائع! أنت متقدم على الجدول. استمر في التتبع المتسق وحافظ على نهجك الحالي.';

  @override
  String get recommendationOnTrack =>
      'أنت على المسار الصحيح! حافظ على روتينك الحالي - إنه يعمل بشكل جيد.';

  @override
  String get recommendationFinalStretch =>
      'أنت في المرحلة الأخيرة! ابق متسقاً - أنت على وشك الوصول!';

  @override
  String get recommendationHalfway =>
      'أنت تجاوزت منتصف الطريق! حافظ على الزخم.';

  @override
  String get recommendationGettingStarted =>
      'أنت للتو بدأت. ركز على بناء عادات متسقة - النتائج ستتبع!';

  @override
  String get recommendationVolatility =>
      'وزنك يتقلب كثيراً. هذا طبيعي! جرب الوزن في نفس الوقت كل يوم للحصول على قراءات أكثر اتساقاً.';

  @override
  String get recommendationGeneral =>
      'استمر في التتبع بانتظام! كل إدخال يساعدك على فهم تقدمك بشكل أفضل.';

  @override
  String get encouragementGoalReached => '🎉 تهانينا! لقد حققت هدفك!';

  @override
  String get encouragementAhead => 'أنت تقوم بعمل رائع! استمر في العمل الجيد!';

  @override
  String get encouragementOnTrack =>
      'أنت على المسار الصحيح! الاتساق هو المفتاح.';

  @override
  String get encouragementClose => 'أنت قريب جداً! استمر في المضي قدماً!';

  @override
  String get encouragementGreatProgress => 'أنت تحرز تقدماً رائعاً! استمر!';

  @override
  String get encouragementEveryStep => 'كل خطوة مهمة! أنت تبني عادات رائعة!';

  @override
  String get patternSleepQualityImpact => 'تأثير جودة النوم';

  @override
  String patternSleepQualityDescription(String action, String quality,
      int rating, int worstRating, String change) {
    return 'تميل إلى $action المزيد من الوزن عندما تنام $quality ($rating/5). عندما تكون جودة النوم $worstRating/5، يتغير وزنك بمقدار $change كجم/يوم في المتوسط.';
  }

  @override
  String get patternSleepQualitySimilar =>
      'تغييرات وزنك متشابهة بغض النظر عن جودة النوم.';

  @override
  String patternSleepQualitySuggestionGood(int rating) {
    return 'حاول الحفاظ على عادات نوم جيدة ($rating/5) لإدارة أفضل للوزن.';
  }

  @override
  String get patternSleepQualitySuggestionImprove =>
      'فكر في تحسين جودة نومك - قد يساعد في أهداف وزنك.';

  @override
  String get patternStressLevelImpact => 'تأثير مستوى التوتر';

  @override
  String patternStressLevelDescription(String level, int rating, String change,
      int highRating, String highChange) {
    return 'عندما يكون التوتر $level ($rating/5)، يتغير وزنك بمقدار $change كجم/يوم في المتوسط. التوتر الأعلى ($highRating/5) يظهر $highChange كجم/يوم.';
  }

  @override
  String get patternStressLevelSuggestion =>
      'إدارة مستويات التوتر قد تساعد في أهداف وزنك.';

  @override
  String get patternStressLevelSuggestionFavorable =>
      'تغييرات وزنك أكثر ملاءمة عندما يكون التوتر أقل.';

  @override
  String get patternExerciseImpact => 'تأثير التمرين';

  @override
  String patternExerciseDescription(
      String withExercise, String withoutExercise) {
    return 'في الأيام التي تمارس فيها التمرين، يتغير وزنك بمقدار $withExercise كجم/يوم في المتوسط، مقارنة بـ $withoutExercise كجم/يوم عندما لا تمارس التمرين.';
  }

  @override
  String patternExerciseDescriptionAlt(
      String withExercise, String withoutExercise) {
    return 'أيام التمرين تظهر $withExercise كجم/يوم تغيير مقابل $withoutExercise كجم/يوم في أيام الراحة.';
  }

  @override
  String get patternExerciseSuggestion =>
      'استمر في التمرين! يبدو أنه يساعد في أهداف وزنك.';

  @override
  String get patternExerciseSuggestionConsistent =>
      'فكر في الحفاظ على روتين تمرين متسق.';

  @override
  String get patternMealTimingPattern => 'نمط توقيت الوجبة';

  @override
  String patternMealTimingDescription(String timing, String change) {
    return 'تغييرات وزنك الأكثر ملاءمة عند الوزن $timing. متوسط التغيير: $change كجم/يوم.';
  }

  @override
  String patternMealTimingSuggestion(String timing) {
    return 'حاول وزن نفسك في أوقات متسقة ($timing) لتتبع أكثر دقة.';
  }

  @override
  String get patternSleepWell => 'جيداً';

  @override
  String get patternSleepPoorly => 'سيئاً';

  @override
  String get patternStressLow => 'منخفض';

  @override
  String get patternStressHigh => 'مرتفع';

  @override
  String get patternLose => 'فقدان';

  @override
  String get patternGain => 'زيادة';

  @override
  String get validationWeightGreaterThanZero => 'يرجى إدخال وزن أكبر من 0';

  @override
  String validationWeightLessThanMax(String max) {
    return 'يرجى إدخال وزن أقل من $max';
  }

  @override
  String get validationUnusuallyLargeChange =>
      'يبدو أن هذا التغيير في الوزن كبير بشكل غير عادي. يرجى التحقق مرة أخرى من إدخالك.';

  @override
  String get validationSignificantChange =>
      'هذا تغيير كبير من إدخالك الأخير. هل كل شيء على ما يرام؟ لا يزال بإمكانك حفظه.';

  @override
  String get validationDifferentFromInitial =>
      'هذا الوزن مختلف جداً عن وزنك الأولي. هل هذا صحيح؟';

  @override
  String get validationGainingWhileLosing =>
      'أنت تكتسب وزناً بينما هدفك هو الفقدان. لا بأس - النكسات تحدث. هل تريد المتابعة؟';

  @override
  String get validationLosingWhileGaining =>
      'أنت تفقد وزناً بينما هدفك هو الزيادة. لا بأس - النكسات تحدث. هل تريد المتابعة؟';

  @override
  String get validationMovingAwayFromGoal =>
      'أنت تبتعد عن هدفك. قد يكون هذا طبيعياً (تقلبات، أحداث الحياة). هل هذا صحيح؟';

  @override
  String get validationUnusualWeight =>
      'يبدو أن هذا الوزن غير عادي مقارنة بإدخالاتك الأخيرة. هل كل شيء على ما يرام؟';

  @override
  String get statusOnTrack => 'أنت على المسار الصحيح! استمر في العمل الجيد!';

  @override
  String statusAheadWithDays(int days) {
    return 'أنت متقدم! متقدم $days أيام';
  }

  @override
  String get statusAhead => 'أنت متقدم! عمل رائع!';

  @override
  String get statusBehind =>
      'أنت تحرز تقدماً! أبطأ قليلاً من المخطط، لكنك لا تزال تتحرك نحو هدفك.';

  @override
  String get statusBehindSimple => 'أنت تحرز تقدماً! استمر!';

  @override
  String get statusKeepTracking => 'استمر في التتبع لرؤية تقدمك!';

  @override
  String get predictionOnTrack =>
      'أنت على المسار الصحيح للوصول إلى هدفك حول التاريخ المخطط!';

  @override
  String predictionAfterTarget(int days) {
    return 'بمعدلك الحالي، ستصل إلى هدفك بعد حوالي $days يوماً من تاريخك المستهدف. لا بأس - التقدم هو التقدم!';
  }

  @override
  String predictionBeforeTarget(int days) {
    return 'بمعدلك الحالي، ستصل إلى هدفك قبل حوالي $days يوماً من تاريخك المستهدف. عمل رائع!';
  }

  @override
  String get streakStartTracking => 'ابدأ التتبع لبناء سلسلتك!';

  @override
  String get streakGreatStart => 'بداية رائعة! استمر!';

  @override
  String streakDaysBuilding(int days) {
    return '$days أيام متتالية! أنت تبني عادة رائعة!';
  }

  @override
  String streakDaysAmazing(int days) {
    return '$days أيام متتالية! أنت تقوم بعمل رائع!';
  }

  @override
  String streakDaysIncredible(int days) {
    return '$days أيام متتالية! هذا لا يصدق!';
  }

  @override
  String streakDaysChampion(int days) {
    return '$days أيام متتالية! أنت بطل في التتبع!';
  }

  @override
  String get educationWhyFluctuatesTitle => 'لماذا يتقلب الوزن يومياً';

  @override
  String get educationWhyFluctuatesContent =>
      'وزنك يتقلب بشكل طبيعي طوال اليوم والأسبوع. هذا طبيعي تماماً! العوامل تشمل:\n\n• احتباس الماء (يمكن أن يختلف من 1-2 كجم)\n• الطعام والهضم\n• جودة ومدة النوم\n• التغيرات الهرمونية\n• التمرين واستعادة العضلات\n\nلهذا السبب نستخدم المتوسطات الأسبوعية - فهي تنعم الضوضاء اليومية وتظهر تقدمك الحقيقي.';

  @override
  String get educationWeeklyMediansTitle => 'كيف تعمل المتوسطات الأسبوعية';

  @override
  String get educationWeeklyMediansContent =>
      'المتوسطات الأسبوعية تساعدك على رؤية تقدمك الحقيقي عن طريق تقليل الضوضاء اليومية.\n\nبدلاً من التركيز على التغييرات يوم بيوم، نحسب متوسط الوزن لكل أسبوع. هذا يعطيك صورة أوضح لاتجاهك العام.\n\nعلى سبيل المثال: إذا كنت تزن 70 كجم، 71 كجم، 70.5 كجم، 70.2 كجم، و 70.8 كجم في أسبوع، المتوسط هو 70.5 كجم - رقم أكثر استقراراً من أي يوم واحد.';

  @override
  String get educationBestPracticesTitle => 'أفضل الممارسات للتتبع';

  @override
  String get educationBestPracticesContent =>
      'للتتبع الأكثر دقة:\n\n• وزن نفسك في نفس الوقت كل يوم (الصباح هو الأفضل)\n• استخدم نفس الميزان\n• وزن نفسك قبل الأكل أو الشرب\n• وزن نفسك بعد استخدام الحمام\n• ارتدِ ملابس متشابهة (أو لا شيء)\n\nالاتساق أهم من الكمال!';

  @override
  String get educationPlateausTitle => 'فهم الهضاب';

  @override
  String get educationPlateausContent =>
      'هضاب الوزن طبيعية تماماً وليست علامة على الفشل!\n\nجسمك قد:\n• يحتفظ بالماء أثناء استعادة العضلات\n• يعدل الأيض\n• يعيد توزيع الوزن (فقدان الدهون، اكتساب العضلات)\n\nإذا كنت تتبع خطتك، ثق بالعملية. الهضاب غالباً ما تنكسر بعد بضعة أسابيع. ركز على الاتساق على السرعة.';

  @override
  String get educationContextTrackingTitle => 'لماذا تتبع السياق؟';

  @override
  String get educationContextTrackingContent =>
      'تتبع السياق (النوم، التوتر، التمرين، توقيت الوجبة) يساعدك على فهم الأنماط.\n\nقد تكتشف:\n• نوم أفضل = إدارة أفضل للوزن\n• التوتر العالي يؤثر على تقدمك\n• توقيت التمرين مهم\n• توقيت الوجبة يؤثر على الوزن اليومي\n\nهذه الرؤى تساعدك على اتخاذ قرارات مستنيرة حول رحلتك.';

  @override
  String get educationStayingMotivatedTitle => 'البقاء متحفزاً';

  @override
  String get educationStayingMotivatedContent =>
      'تتبع الوزن هو ماراثون، وليس سباقاً.\n\nتذكر:\n• التقدم ليس دائماً خطياً\n• الإجراءات اليومية الصغيرة تتراكم مع مرور الوقت\n• النكسات جزء من الرحلة\n• احتفل أيضاً بانتصارات غير الميزان\n\nركز على بناء عادات مستدامة. كل يوم تتتبع فيه هو انتصار!';
}
