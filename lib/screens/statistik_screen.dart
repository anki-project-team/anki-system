import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ihk_ap1_prep/services/premium_service.dart';
import 'package:ihk_ap1_prep/widgets/premium_lock.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});
  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  int _gesamtKarten = 113;
  int _gelerntGesamt = 0;
  double _retention = 0.0;
  int _gelerntHeute = 0;
  Map<String, int> _kartenProTag = {};
  bool _loading = true;
  bool _showTage = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    final progress = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('progress')
        .get();

    final now = DateTime.now();
    int gelerntGesamt = progress.docs.length;
    int gelerntHeute = 0;
    int gut = 0;
    Map<String, int> proTag = {};

    for (final doc in progress.docs) {
      final data = doc.data();
      final lastReview =
          (data['lastReview'] as Timestamp?)?.toDate();
      final rating = (data['reviewCount'] ?? 0) as int;
      if (lastReview != null) {
        if (lastReview.day == now.day &&
            lastReview.month == now.month) gelerntHeute++;
        final key = '${lastReview.day}.${lastReview.month}';
        proTag[key] = (proTag[key] ?? 0) + 1;
        if (rating >= 3) gut++;
      }
    }

    setState(() {
      _gelerntGesamt = gelerntGesamt;
      _gelerntHeute = gelerntHeute;
      _retention =
          gelerntGesamt > 0 ? (gut / gelerntGesamt * 100) : 0;
      _kartenProTag = proTag;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        title: const Text('IHK AP1 Prep',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        centerTitle: true,
        actions: [],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color(0xFFE8813A)))
          : FutureBuilder<bool>(
              future: PremiumService.isPremium(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFE8813A)),
                  );
                }
                if (snapshot.data == false) {
                  return PremiumLock(
                    featureName: 'Statistik & Auswertung',
                    child: _buildStatistikContent(),
                  );
                }
                return _buildStatistikContent();
              },
            ),
    );
  }

  Widget _buildStatistikContent() {
    return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text('Akademische Leistung',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827))),
                  const SizedBox(height: 4),
                  const Text(
                      'Fortschritt bei der Prüfungsvorbereitung',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280))),
                  const SizedBox(height: 20),

                  // GROSSE Box oben — Gesamtanzahl
                  _statBox(
                    label: 'GESAMTANZAHL KARTEN',
                    value: _gesamtKarten.toString(),
                    sub: '+$_gelerntHeute diese Woche',
                    subColor: const Color(0xFF22C55E),
                    valueFontSize: 40,
                  ),
                  const SizedBox(height: 10),

                  // Zwei Boxen nebeneinander
                  Row(
                    children: [
                      // Gelernt
                      Expanded(
                        child: _statBox(
                          label: 'GELERNT',
                          value: _gelerntGesamt.toString(),
                          sub:
                              '${_gesamtKarten > 0 ? (_gelerntGesamt / _gesamtKarten * 100).toStringAsFixed(1) : 0}%',
                          subColor:
                              const Color(0xFF6B7280),
                          valueFontSize: 32,
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Bestandsquote — gelblich
                      Expanded(
                        child: _statBox(
                          label: 'BESTANDSQUOTE',
                          value:
                              '${_retention.toStringAsFixed(1)}%',
                          sub: 'Ziel: 90%',
                          subColor:
                              const Color(0xFF92400E),
                          valueFontSize: 32,
                          valueColor:
                              const Color(0xFFE8813A),
                          bgColor:
                              const Color(0xFFFEF9C3),
                          borderColor:
                              const Color(0xFFFDE68A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Künftige Fälligkeiten
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                                'Künftige Fälligkeiten',
                                style: TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                    fontSize: 15,
                                    color:
                                        Color(0xFF111827))),
                            _toggleChip(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildBarChart(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Kartentypen
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text('Kartentypen',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFF111827))),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CustomPaint(
                                painter: _DonutPainter(
                                  values: [
                                    (_gelerntGesamt * 0.7)
                                        .toDouble(),
                                    (_gelerntGesamt * 0.3)
                                        .toDouble(),
                                    (_gesamtKarten -
                                            _gelerntGesamt)
                                        .toDouble(),
                                  ],
                                  colors: [
                                    const Color(0xFF22C55E),
                                    const Color(0xFFE8813A),
                                    const Color(0xFF3B82F6),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _gesamtKarten.toString(),
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(
                                            0xFF162447)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _legendItem(
                                      'Gelernt',
                                      '${_gesamtKarten > 0 ? (_gelerntGesamt / _gesamtKarten * 100).toStringAsFixed(0) : 0}%',
                                      const Color(
                                          0xFF22C55E)),
                                  const SizedBox(height: 12),
                                  _legendItem('Lernend', '25%',
                                      const Color(
                                          0xFFE8813A)),
                                  const SizedBox(height: 12),
                                  _legendItem(
                                      'Neu',
                                      '${_gesamtKarten > 0 ? ((_gesamtKarten - _gelerntGesamt) / _gesamtKarten * 100).toStringAsFixed(0) : 100}%',
                                      const Color(
                                          0xFF3B82F6)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sicherheitsgrad
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text('Sicherheitsgrad',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color(0xFF111827))),
                        const SizedBox(height: 16),
                        _sicherheitRow(
                            'HARDWARE', 0.82, 'Gut'),
                        _sicherheitRow(
                            'NETZWERK', 0.65, 'Mittel'),
                        _sicherheitRow(
                            'IT-SICHERHEIT', 0.45, 'Niedrig'),
                        _sicherheitRow(
                            'PROJEKTMANAGEMENT', 0.71, 'Gut'),
                        _sicherheitRow('SOFTWAREENTWICKLUNG',
                            0.38, 'Niedrig'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
  }

  Widget _statBox({
    required String label,
    required String value,
    required String sub,
    required Color subColor,
    required double valueFontSize,
    Color valueColor = const Color(0xFF111827),
    Color bgColor = const Color(0xFFF9FAFB),
    Color borderColor = const Color(0xFFE5E7EB),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                  height: 1.1)),
          const SizedBox(height: 4),
          Text(sub,
              style: TextStyle(
                  fontSize: 12,
                  color: subColor,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _sectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: child,
    );
  }

  Widget _toggleChip() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _chipBtn('Tag', _showTage,
              () => setState(() => _showTage = true)),
          _chipBtn('31 T.', !_showTage,
              () => setState(() => _showTage = false)),
        ],
      ),
    );
  }

  Widget _chipBtn(
      String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF162447)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color:
                    active ? Colors.white : Colors.grey[500])),
      ),
    );
  }

  Widget _buildBarChart() {
    final days = List.generate(
        7,
        (i) =>
            DateTime.now().subtract(Duration(days: 6 - i)));
    final vals = days.map((d) {
      final key = '${d.day}.${d.month}';
      return (_kartenProTag[key] ?? 0).toDouble();
    }).toList();
    final maxVal = vals.reduce((a, b) => a > b ? a : b);
    final displayMax = maxVal < 1 ? 1.0 : maxVal;

    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (i) {
          final d = days[i];
          final count = vals[i];
          final h =
              (count / displayMax * 70).clamp(4.0, 70.0);
          final isToday = d.day == DateTime.now().day;
          return Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (count > 0)
                    Text(
                      count.toInt().toString(),
                      style: TextStyle(
                          fontSize: 10,
                          color: isToday
                              ? const Color(0xFFE8813A)
                              : const Color(0xFF162447),
                          fontWeight: FontWeight.w600),
                    ),
                  const SizedBox(height: 3),
                  Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: isToday
                          ? const Color(0xFFE8813A)
                          : const Color(0xFF162447)
                              .withOpacity(0.7),
                      borderRadius:
                          BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    [
                      'Mo',
                      'Di',
                      'Mi',
                      'Do',
                      'Fr',
                      'Sa',
                      'So'
                    ][d.weekday - 1],
                    style: TextStyle(
                        fontSize: 11,
                        color: isToday
                            ? const Color(0xFFE8813A)
                            : Colors.grey[400],
                        fontWeight: isToday
                            ? FontWeight.w600
                            : FontWeight.normal),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _legendItem(
      String label, String value, Color color) {
    return Row(
      children: [
        Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF374151))),
        const Spacer(),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color)),
      ],
    );
  }

  Widget _sicherheitRow(
      String label, double value, String grade) {
    final color = value >= 0.7
        ? const Color(0xFF22C55E)
        : value >= 0.5
            ? const Color(0xFFE8813A)
            : const Color(0xFFEF4444);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      letterSpacing: 0.3,
                      fontWeight: FontWeight.w500)),
              Text(grade,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color)),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor:
                  AlwaysStoppedAnimation<Color>(color),
              minHeight: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  _DonutPainter({required this.values, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (a, b) => a + b);
    if (total == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 20.0;
    double startAngle = -3.14159265 / 2;

    for (int i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweepAngle =
          (values[i] / total) * 2 * 3.14159265;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(
            center: center,
            radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle - 0.04,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => false;
}
