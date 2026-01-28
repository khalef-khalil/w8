import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

/// Service for managing daily weight tracking reminders
class ReminderService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  /// Initialize the notification service
  static Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialization settings
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Initialize plugin
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;

    // Reschedule reminders if they were previously enabled
    if (isReminderEnabled()) {
      await rescheduleRemindersIfEnabled();
    }
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification actions
    if (response.actionId == 'snooze') {
      // Snooze for 1 hour
      scheduleSnooze();
    } else if (response.actionId == 'weighed_in') {
      // Mark as weighed in (could track this in storage)
      cancelTodayReminder();
    }
  }

  /// Check if reminders are enabled
  static bool isReminderEnabled() {
    try {
      final box = Hive.box(AppConstants.appSettingsBoxName);
      return box.get('reminder_enabled', defaultValue: false) as bool;
    } catch (e) {
      return false;
    }
  }

  /// Enable or disable reminders
  static Future<void> setReminderEnabled(bool enabled) async {
    final box = Hive.box(AppConstants.appSettingsBoxName);
    await box.put('reminder_enabled', enabled);
    
    if (enabled) {
      await scheduleReminder();
    } else {
      await cancelAllReminders();
    }
  }

  /// Get reminder time (hour and minute)
  static TimeOfDay? getReminderTime() {
    try {
      final box = Hive.box(AppConstants.appSettingsBoxName);
      final hour = box.get('reminder_hour', defaultValue: 9) as int;
      final minute = box.get('reminder_minute', defaultValue: 0) as int;
      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  /// Set reminder time
  static Future<void> setReminderTime(TimeOfDay time) async {
    final box = Hive.box(AppConstants.appSettingsBoxName);
    await box.put('reminder_hour', time.hour);
    await box.put('reminder_minute', time.minute);
    
    if (isReminderEnabled()) {
      await scheduleReminder();
    }
  }

  /// Reschedule reminders if enabled (called on app start)
  static Future<void> rescheduleRemindersIfEnabled() async {
    if (!isReminderEnabled()) {
      return;
    }

    // Check permissions first
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('ReminderService: Notification permission not granted, cannot schedule reminders');
      return;
    }

    await scheduleReminder();
  }

  /// Schedule daily reminder at the specified time
  static Future<void> scheduleReminder() async {
    if (!_initialized) {
      await initialize();
    }

    // Cancel existing reminders first
    await cancelAllReminders();

    if (!isReminderEnabled()) {
      return;
    }

    final time = getReminderTime();
    if (time == null) return;

    // Request permissions before scheduling (Android 13+)
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('ReminderService: Notification permission not granted, cannot schedule reminders');
      return;
    }

    final androidDetails = AndroidNotificationDetails(
      'weight_reminder',
      'Weight Tracking Reminders',
      channelDescription: 'Daily reminders to track your weight',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
      enableVibration: true,
      playSound: true,
      actions: [
        const AndroidNotificationAction(
          'snooze',
          'Snooze',
          showsUserInterface: false,
        ),
        const AndroidNotificationAction(
          'weighed_in',
          'I\'ve weighed in',
          showsUserInterface: false,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Schedule daily notification
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Schedule repeating daily notification
    await _notifications.zonedSchedule(
      0, // Notification ID
      _getReminderTitle(),
      _getReminderBody(),
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule a snooze reminder (1 hour later)
  static Future<void> scheduleSnooze() async {
    if (!_initialized) {
      await initialize();
    }

    final androidDetails = const AndroidNotificationDetails(
      'weight_reminder',
      'Weight Tracking Reminders',
      channelDescription: 'Daily reminders to track your weight',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final scheduledDate = tz.TZDateTime.now(tz.local).add(
      const Duration(hours: 1),
    );

    await _notifications.zonedSchedule(
      1, // Different ID for snooze
      _getReminderTitle(),
      _getReminderBody(),
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel today's reminder (when user marks as weighed in)
  static Future<void> cancelTodayReminder() async {
    await _notifications.cancel(0);
  }

  /// Cancel all reminders
  static Future<void> cancelAllReminders() async {
    await _notifications.cancel(0);
    await _notifications.cancel(1);
  }

  /// Get reminder title
  static String _getReminderTitle() {
    return 'Time to track your weight!';
  }

  /// Get reminder body (encouraging message)
  static String _getReminderBody() {
    final messages = [
      'Don\'t forget to log your weight today!',
      'Keep your streak going! Track your weight now.',
      'Your journey continues! Log your weight.',
      'Consistency is key! Track your weight today.',
      'You\'re doing great! Don\'t forget to log your weight.',
    ];
    
    // Use day of week to vary message
    final dayOfWeek = DateTime.now().weekday;
    return messages[dayOfWeek % messages.length];
  }

  /// Request notification permissions (iOS)
  static Future<bool> requestPermissions() async {
    if (!_initialized) {
      await initialize();
    }

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    
    if (android != null) {
      // Android 13+ requires runtime permission
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS permissions are requested automatically
    return true;
  }
}

