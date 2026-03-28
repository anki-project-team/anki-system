import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Plugin initialisieren
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  /// Tägliche Erinnerung planen
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required int dueCardCount,
  }) async {
    if (dueCardCount == 0) return;

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder',
      'Tägliche Erinnerung',
      channelDescription: 'Erinnerung an fällige Lernkarten',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      0,
      'IHK AP1 Prep',
      'Heute $dueCardCount Karten fällig — Jetzt lernen 🎯',
      _nextInstanceOfTime(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Nächsten Zeitpunkt berechnen (heute oder morgen)
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Alle Notifications löschen
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
