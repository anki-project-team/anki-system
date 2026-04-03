import 'package:cloud_firestore/cloud_firestore.dart';
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
    String? customTitle,
    String? customBody,
  }) async {
    if (dueCardCount == 0 && customTitle == null) return;

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
      customTitle ?? 'IHK AP1 Prep',
      customBody ?? getNotificationBody(dueCardCount),
      _nextInstanceOfTime(hour, minute),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Personalisierte Notification mit fälligen Deck-Namen
  static Future<void> scheduleDailyLearningReminder(String userId) async {
    final progress = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('progress')
        .where('dueDate', isLessThanOrEqualTo: Timestamp.now())
        .get();

    final dueCount = progress.docs.length;

    final dueDecks = <String>{};
    for (final doc in progress.docs) {
      final cardId = doc.id;
      final deckName = cardId.split('Karten-').first;
      dueDecks.add(_formatDeckName(deckName));
    }

    final deckText = dueDecks.isEmpty
        ? 'Alle Karten wiederholt!'
        : dueDecks.take(3).join(', ');

    final title = dueCount > 0
        ? 'Heute $dueCount Karten fällig 🎯'
        : 'Gut gemacht! 🎉';

    final body = dueCount > 0
        ? 'Themen: $deckText'
        : 'Alle Karten für heute wiederholt.';

    await scheduleDailyReminder(
      hour: 7,
      minute: 30,
      dueCardCount: dueCount,
      customTitle: title,
      customBody: body,
    );
  }

  static String _formatDeckName(String varName) {
    return varName
        .replaceAll('_', ' ')
        .replaceAll('ae', 'ä')
        .replaceAll('oe', 'ö')
        .replaceAll('ue', 'ü');
  }

  /// Nächsten Zeitpunkt berechnen (heute oder morgen)
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    tz.initializeTimeZones();
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Notification-Body generieren
  static String getNotificationBody(int dueCardCount) {
    return 'Heute $dueCardCount Karten fällig — Jetzt lernen 🎯';
  }

  /// Alle Notifications löschen
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
