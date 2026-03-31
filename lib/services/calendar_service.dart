import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarService {
  static const _setupDoneKey = 'calendar_setup_done';

  static Future<bool> isSetupDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_setupDoneKey) ?? false;
  }

  static Future<void> markSetupDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_setupDoneKey, true);
  }

  /// Google Kalender-Link öffnen mit täglichem Lern-Reminder
  static Future<void> openGoogleCalendar() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 7, 30);
    final end = start.add(const Duration(minutes: 30));

    String _fmt(DateTime d) =>
        '${d.year}${_pad(d.month)}${_pad(d.day)}T${_pad(d.hour)}${_pad(d.minute)}00';

    final uri = Uri.parse(
      'https://calendar.google.com/calendar/render?action=TEMPLATE'
      '&text=AP1+Lernzeit+%F0%9F%93%9A'
      '&details=T%C3%A4glich+30+Min+Flashcards+lernen+%E2%80%93+Learn-Factory'
      '&dates=${_fmt(start)}/${_fmt(end)}'
      '&recur=RRULE:FREQ=DAILY'
      '&ctz=Europe/Berlin',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// ICS-Datei als Download-Link öffnen
  static Future<void> downloadICS() async {
    final ics = '''BEGIN:VCALENDAR
VERSION:2.0
PRODID:-//Learn-Factory//AP1 Prep//DE
BEGIN:VEVENT
DTSTART;TZID=Europe/Berlin:${_todayFormatted()}T073000
DTEND;TZID=Europe/Berlin:${_todayFormatted()}T080000
RRULE:FREQ=DAILY
SUMMARY:AP1 Lernzeit 📚
DESCRIPTION:Täglich 30 Min Flashcards lernen – Learn-Factory
END:VEVENT
END:VCALENDAR''';

    final uri = Uri.dataFromString(ics,
        mimeType: 'text/calendar', encoding: null);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  static String _todayFormatted() {
    final now = DateTime.now();
    return '${now.year}${_pad(now.month)}${_pad(now.day)}';
  }

  static String _pad(int n) => n.toString().padLeft(2, '0');
}
