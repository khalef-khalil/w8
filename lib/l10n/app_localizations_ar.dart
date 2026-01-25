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
  String get progressToGoal => 'التقدم نحو الهدف (+15 كجم)';

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
  String get durationHint => 'مثال: 6';

  @override
  String get continueButton => 'متابعة';

  @override
  String get goalSummary => 'ملخص هدفك';

  @override
  String goalSummaryFromTo(String initial, String target, int months) {
    return 'من $initial كجم إلى $target كجم في $months أشهر';
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
  String get kilograms => 'كيلوغرامات (كجم)';

  @override
  String get pounds => 'أرطال (رطل)';

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
}
