import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/services/calendar_service.dart';

class CalendarSetupSheet extends StatelessWidget {
  const CalendarSetupSheet({super.key});

  /// Zeigt das Sheet nur einmal (beim ersten Login)
  static Future<void> showIfNeeded(BuildContext context) async {
    final done = await CalendarService.isSetupDone();
    if (done || !context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CalendarSetupSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF162447),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text('⏰', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          const Text(
            'Täglicher Lern-Reminder',
            style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Jeden Tag um 07:30 — 30 Minuten Flashcards.\nDirekt in deinem Kalender.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),

          // Google Kalender
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton.icon(
              onPressed: () async {
                await CalendarService.openGoogleCalendar();
                await CalendarService.markSetupDone();
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Text('📅', style: TextStyle(fontSize: 18)),
              label: const Text('Google Kalender',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8813A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ICS Download (Apple / Outlook)
          SizedBox(
            width: double.infinity, height: 52,
            child: OutlinedButton.icon(
              onPressed: () async {
                await CalendarService.downloadICS();
                await CalendarService.markSetupDone();
                if (context.mounted) Navigator.pop(context);
              },
              icon: const Text('🍎', style: TextStyle(fontSize: 18)),
              label: const Text('Apple / Outlook (.ics)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Überspringen
          GestureDetector(
            onTap: () async {
              await CalendarService.markSetupDone();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(
              'Später einrichten',
              style: TextStyle(
                color: Colors.white.withOpacity(0.35), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
