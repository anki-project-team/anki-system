import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    if (user == null) { setState(() => _loading = false); return; }

    final progress = await FirebaseFirestore.instance
        .collection('users').doc(user.uid)
        .collection('progress').get();

    final now = DateTime.now();
    int gelerntGesamt = progress.docs.length;
    int gelerntHeute = 0;
    int gut = 0;
    Map<String, int> proTag = {};

    for (final doc in progress.docs) {
      final data = doc.data();
      final lastReview = (data['lastReview'] as Timestamp?)?.toDate();
      final rating = (data['reviewCount'] ?? 0) as int;
      if (lastReview != null) {
        if (lastReview.day == now.day && lastReview.month == now.month) {
          gelerntHeute++;
        }
        final key = '${lastReview.day}.${lastReview.month}';
        proTag[key] = (proTag[key] ?? 0) + 1;
        if (rating >= 3) gut++;
      }
    }

    setState(() {
      _gelerntGesamt = gelerntGesamt;
      _gelerntHeute = gelerntHeute;
      _retention = gelerntGesamt > 0 ? (gut / gelerntGesamt * 100) : 0;
      _kartenProTag = proTag;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        title: const Text('Statistik',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600, fontSize: 17)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE8813A)))
          : CustomScrollView(
              slivers: [
                // Dark Header
                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFF162447),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 16,
                        left: 20, right: 20, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Akademische Leistung',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.refresh,
                                  color: Colors.white54, size: 20),
                              onPressed: _loadStats,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        const Text('Fortschritt bei der Prüfungsvorbereitung',
                            style: TextStyle(
                                color: Colors.white54, fontSize: 12)),
                        const SizedBox(height: 24),

                        // Große Stats
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('GESAMTANZAHL KARTEN',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                          letterSpacing: 0.5)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatNumber(_gesamtKarten),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text('+$_gelerntHeute heute',
                                      style: const TextStyle(
                                          color: Color(0xFF22C55E),
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('GELERNT',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                          letterSpacing: 0.5)),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatNumber(_gelerntGesamt),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${_gesamtKarten > 0 ? (_gelerntGesamt / _gesamtKarten * 100).toStringAsFixed(1) : 0}%',
                                    style: const TextStyle(
                                        color: Colors.white54, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Bestandsquote Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1e3a5f),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('BESTANDSQUOTE',
                                  style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      letterSpacing: 0.5)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${_retention.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                        color: Color(0xFFE8813A),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Text('Ziel: 90%',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([

                      // Fälligkeiten Chart
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Künftige Fälligkeiten',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Color(0xFF111827))),
                                _toggleChip(),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildBarChart(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Kartentypen Donut
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Kartentypen',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF111827))),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                // Donut
                                SizedBox(
                                  width: 100, height: 100,
                                  child: CustomPaint(
                                    painter: _DonutPainter(
                                      values: [
                                        _gesamtKarten - _gelerntGesamt.toDouble(),
                                        (_gelerntGesamt * 0.3),
                                        (_gelerntGesamt * 0.7),
                                      ],
                                      colors: const [
                                        Color(0xFF3B82F6),
                                        Color(0xFFE8813A),
                                        Color(0xFF22C55E),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        _formatNumber(_gesamtKarten),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF162447)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                // Legende
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _legendItem('Gelernt',
                                          '${(_gesamtKarten > 0 ? _gelerntGesamt / _gesamtKarten * 100 : 0).toStringAsFixed(0)}%',
                                          const Color(0xFF22C55E)),
                                      const SizedBox(height: 8),
                                      _legendItem('Lernend', '25%',
                                          const Color(0xFFE8813A)),
                                      const SizedBox(height: 8),
                                      _legendItem('Neu',
                                          '${(_gesamtKarten > 0 ? (_gesamtKarten - _gelerntGesamt) / _gesamtKarten * 100 : 100).toStringAsFixed(0)}%',
                                          const Color(0xFF3B82F6)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Sicherheitsgrad
                      _card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sicherheitsgrad',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF111827))),
                            const SizedBox(height: 12),
                            _sicherheitRow('HARDWARE', 0.82, 'Gut'),
                            _sicherheitRow('NETZWERK', 0.65, 'Mittel'),
                            _sicherheitRow('IT-SICHERHEIT', 0.45, 'Niedrig'),
                            _sicherheitRow('PROJEKTMANAGEMENT', 0.71, 'Gut'),
                            _sicherheitRow('SOFTWAREENTWICKLUNG', 0.38, 'Niedrig'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _card({required Widget child}) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );

  Widget _toggleChip() => Container(
    decoration: BoxDecoration(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _chipBtn('1 Tag', _showTage, () => setState(() => _showTage = true)),
        _chipBtn('31 T.', !_showTage, () => setState(() => _showTage = false)),
      ],
    ),
  );

  Widget _chipBtn(String label, bool active, VoidCallback onTap) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF162447) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: active ? Colors.white : Colors.grey)),
      ),
    );

  Widget _buildBarChart() {
    final days = List.generate(7, (i) =>
        DateTime.now().subtract(Duration(days: 6 - i)));
    final maxVal = days
        .map((d) => (_kartenProTag['${d.day}.${d.month}'] ?? 0).toDouble())
        .reduce((a, b) => a > b ? a : b)
        .clamp(1.0, double.infinity);

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: days.map((d) {
          final key = '${d.day}.${d.month}';
          final count = (_kartenProTag[key] ?? 0).toDouble();
          final h = (count / maxVal * 60).clamp(4.0, 60.0);
          final isToday = d.day == DateTime.now().day;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: isToday
                          ? const Color(0xFFE8813A)
                          : const Color(0xFF162447).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ['Mo','Di','Mi','Do','Fr','Sa','So'][d.weekday - 1],
                    style: TextStyle(
                        fontSize: 10,
                        color: isToday
                            ? const Color(0xFFE8813A)
                            : Colors.grey[400]),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _legendItem(String label, String value, Color color) => Row(
    children: [
      Container(width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 13,
          fontWeight: FontWeight.w600, color: color)),
    ],
  );

  Widget _sicherheitRow(String label, double value, String grade) {
    final color = value >= 0.7 ? const Color(0xFF22C55E)
        : value >= 0.5 ? const Color(0xFFE8813A)
        : const Color(0xFFEF4444);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(
                  fontSize: 11, color: Color(0xFF6B7280),
                  letterSpacing: 0.3)),
              Text(grade, style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}.${(n % 1000).toString().padLeft(3, '0')}';
    }
    return n.toString();
  }
}

// Donut Chart Painter
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
    const strokeWidth = 18.0;
    double startAngle = -3.14159 / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * 3.14159;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle, sweepAngle - 0.05, false, paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => false;
}
