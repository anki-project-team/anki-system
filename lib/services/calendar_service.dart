import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarService {
  static const _prefKey = 'calendarSetupDone';

  static Future<bool> isSetupDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }

  static Future<void> markSetupDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, true);
  }

  // Datum formatieren für Google Calendar URL
  static String _fmt(DateTime dt) =>
      '${dt.year}'
      '${dt.month.toString().padLeft(2, '0')}'
      '${dt.day.toString().padLeft(2, '0')}'
      'T'
      '${dt.hour.toString().padLeft(2, '0')}'
      '${dt.minute.toString().padLeft(2, '0')}'
      '00';

  // Google Kalender App öffnen (Android Intent)
  // Fallback: Google Kalender Website
  static Future<bool> openGoogleCalendar() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 7, 30);
    final end   = DateTime(now.year, now.month, now.day, 7, 45);

    final title   = Uri.encodeComponent('Learn-Factory: AP1 Lerneinheit 🎯');
    final details = Uri.encodeComponent(
      'Deine täglichen IHK AP1-Lernkarten warten!\n'
      'Nur 15 Minuten täglich — Bestnoten-Vorbereitung.\n\n'
      '👉 https://ihk-ap1-prep.web.app',
    );
    final location = Uri.encodeComponent('https://ihk-ap1-prep.web.app');
    final dates    = '${_fmt(start)}/${_fmt(end)}';

    // Weg 1: Google Kalender App direkt (Android)
    final appUri = Uri.parse(
      'https://www.google.com/calendar/event'
      '?action=TEMPLATE'
      '&text=$title'
      '&dates=$dates'
      '&recur=RRULE%3AFREQ%3DDAILY'
      '&ctz=Europe%2FBerlin'
      '&details=$details'
      '&location=$location',
    );

    // Weg 2: Web-Fallback (öffnet als Website)
    final webUri = Uri.parse(
      'https://calendar.google.com/calendar/render'
      '?action=TEMPLATE'
      '&text=$title'
      '&dates=$dates'
      '&recur=RRULE%3AFREQ%3DDAILY'
      '&ctz=Europe%2FBerlin'
      '&details=$details'
      '&location=$location',
    );

    // Erst App-Link probieren, dann Web-Fallback
    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri,
            mode: LaunchMode.externalNonBrowserApplication);
        await markSetupDone();
        return true;
      }
    } catch (_) {}

    // Web-Fallback
    if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri,
          mode: LaunchMode.externalApplication);
      await markSetupDone();
      return true;
    }

    return false;
  }

  // ICS-Inhalt für Apple Kalender / Outlook
  static String buildIcsContent() {
    final now      = DateTime.now();
    final yyyymmdd =
        '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';

    return 'BEGIN:VCALENDAR\r\n'
        'VERSION:2.0\r\n'
        'PRODID:-//Learn-Factory//IHK AP1 Prep//DE\r\n'
        'CALSCALE:GREGORIAN\r\n'
        'METHOD:PUBLISH\r\n'
        'BEGIN:VEVENT\r\n'
        'SUMMARY:Learn-Factory: AP1 Lerneinheit\r\n'
        'DTSTART;TZID=Europe/Berlin:${yyyymmdd}T073000\r\n'
        'DURATION:PT15M\r\n'
        'RRULE:FREQ=DAILY\r\n'
        'DESCRIPTION:Deine IHK AP1-Lernkarten warten!\\nhttps://ihk-ap1-prep.web.app\r\n'
        'URL:https://ihk-ap1-prep.web.app\r\n'
        'BEGIN:VALARM\r\n'
        'TRIGGER:-PT5M\r\n'
        'ACTION:DISPLAY\r\n'
        'DESCRIPTION:Learn-Factory: Jetzt AP1 lernen!\r\n'
        'END:VALARM\r\n'
        'END:VEVENT\r\n'
        'END:VCALENDAR';
  }

  // ICS Download (Web)
  static Future<void> downloadIcs() async {
    final ics     = buildIcsContent();
    final encoded = Uri.encodeComponent(ics);
    final dataUrl =
        Uri.parse('data:text/calendar;charset=utf-8,$encoded');
    if (await canLaunchUrl(dataUrl)) {
      await launchUrl(dataUrl);
      await markSetupDone();
    }
  }
}
