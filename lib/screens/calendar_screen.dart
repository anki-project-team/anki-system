import 'package:flutter/material.dart';
import '../main.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Lernkalender',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lernkalender',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Deine Faelligkeiten der naechsten 30 Tage',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Kalender
            _buildCalendar(now),
            const SizedBox(height: 24),

            // Faellig heute
            Text(
              'FAELLIG HEUTE',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 10),
            _dueRow('\uD83D\uDD17', 'Hardware & Vernetzung', 12),
            const SizedBox(height: 8),
            _dueRow('\uD83D\uDCBB', 'Programmierung', 8),
            const SizedBox(height: 8),
            _dueRow('\uD83D\uDEE1', 'IT-Sicherheit', 5),
            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                _miniStat('Diese Woche', '47'),
                const SizedBox(width: 8),
                _miniStat('Dieser Monat', '183'),
                const SizedBox(width: 8),
                _miniStat('Retention', '94%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(DateTime now) {
    final year = now.year;
    final month = now.month;
    final today = now.day;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    // Monday = 1 in DateTime.weekday; we want 0-based offset for Monday-start
    final firstWeekday = DateTime(year, month, 1).weekday; // 1=Mon .. 7=Sun
    final offset = firstWeekday - 1;

    const dayLabels = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        children: [
          // Month title
          Text(
            _monthName(month) + ' $year',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),

          // Weekday header
          Row(
            children: dayLabels
                .map((d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Day grid
          ..._buildWeeks(daysInMonth, offset, today),
        ],
      ),
    );
  }

  List<Widget> _buildWeeks(int daysInMonth, int offset, int today) {
    final weeks = <Widget>[];
    var day = 1;

    for (var row = 0; row < 6; row++) {
      if (day > daysInMonth) break;
      final cells = <Widget>[];

      for (var col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        if (cellIndex < offset || day > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 36)));
        } else {
          final isToday = day == today;
          final d = day;
          cells.add(Expanded(
            child: Container(
              height: 36,
              decoration: isToday
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kAccentColor, width: 2),
                    )
                  : null,
              child: Center(
                child: Text(
                  '$d',
                  style: TextStyle(
                    color: isToday ? kAccentColor : Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ));
          day++;
        }
      }

      weeks.add(Row(children: cells));
    }

    return weeks;
  }

  String _monthName(int month) {
    const names = [
      'Januar', 'Februar', 'Maerz', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
    ];
    return names[month - 1];
  }

  Widget _dueRow(String emoji, String name, int count) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: kAccentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '$count Karten faellig',
              style: const TextStyle(
                color: kAccentColor,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: kAccentColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
