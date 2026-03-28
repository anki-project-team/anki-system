import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/firestore_service.dart';

/// Farbkodierung für Kalender-Tage basierend auf fälligen Karten
Color borderColorForCount(int count) {
  if (count <= 5) return const Color(0xFF81C784); // grün
  if (count <= 15) return const Color(0xFFE8813A); // orange
  return const Color(0xFFE57373); // rot
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _selectedDay;
  List<CardModel> _allCards = [];
  final _firestore = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await _firestore.getAllCards('demo-user', 'default');
    setState(() => _allCards = cards);
  }

  /// Zählt fällige Karten für einen bestimmten Tag
  int _dueCountForDay(DateTime day) {
    return _allCards.where((c) {
      return c.dueDate.year == day.year &&
          c.dueDate.month == day.month &&
          c.dueDate.day == day.day;
    }).length;
  }

  /// Reviews in den letzten N Tagen
  int _reviewsInLastDays(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _allCards
        .where((c) => c.reviewCount > 0 && c.dueDate.isAfter(cutoff))
        .fold(0, (sum, c) => sum + c.reviewCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        title: const Text(
          'Kalender',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildMonthHeader(),
            const SizedBox(height: 16),
            _buildWeekdayHeaders(),
            const SizedBox(height: 8),
            _buildCalendarGrid(),
            const SizedBox(height: 24),
            _buildLegend(),
            const SizedBox(height: 24),
            _buildStatsBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    const months = [
      'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni',
      'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => setState(() {
            _currentMonth =
                DateTime(_currentMonth.year, _currentMonth.month - 1);
          }),
        ),
        Text(
          '${months[_currentMonth.month - 1]} ${_currentMonth.year}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: () => setState(() {
            _currentMonth =
                DateTime(_currentMonth.year, _currentMonth.month + 1);
          }),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return Row(
      children: days
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    // Montag = 1, also offset = firstDay.weekday - 1
    final startOffset = firstDay.weekday - 1;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rows, (row) {
        return Row(
          children: List.generate(7, (col) {
            final index = row * 7 + col;
            final dayNum = index - startOffset + 1;

            if (index < startOffset || dayNum > daysInMonth) {
              return const Expanded(child: SizedBox(height: 44));
            }

            final day = DateTime(
                _currentMonth.year, _currentMonth.month, dayNum);
            final today = DateTime.now();
            final isToday = day.year == today.year &&
                day.month == today.month &&
                day.day == today.day;
            final isSelected = _selectedDay != null &&
                day.year == _selectedDay!.year &&
                day.month == _selectedDay!.month &&
                day.day == _selectedDay!.day;
            final dueCount = _dueCountForDay(day);

            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday
                        ? const Color(0xFFE8813A)
                        : isSelected
                            ? const Color(0xFFE8813A).withValues(alpha: 0.3)
                            : const Color(0xFF1e3a5f),
                    border: dueCount > 0 && !isToday
                        ? Border.all(
                            color: borderColorForCount(dueCount),
                            width: 2,
                          )
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$dayNum',
                      style: TextStyle(
                        color: isToday ? Colors.white : Colors.white70,
                        fontSize: 14,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }


  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem(const Color(0xFF81C784), '1–5 Karten'),
        _legendItem(const Color(0xFFE8813A), '6–15 Karten'),
        _legendItem(const Color(0xFFE57373), '16+ Karten'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            color: Colors.transparent,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    final weekReviews = _reviewsInLastDays(7);
    final monthReviews = _reviewsInLastDays(30);
    final totalReviews = _allCards.fold(0, (sum, c) => sum + c.reviewCount);
    final retention = totalReviews > 0
        ? (_allCards
                .where((c) => c.state == 'review')
                .length /
            _allCards.length *
            100)
            .round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a5f),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('Diese Woche', '$weekReviews'),
          _statDivider(),
          _statItem('Dieser Monat', '$monthReviews'),
          _statDivider(),
          _statItem('Retention', '$retention%'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE8813A),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }

  Widget _statDivider() {
    return Container(width: 1, height: 36, color: Colors.white12);
  }
}
