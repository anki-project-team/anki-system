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
  int _gelerntHeute = 0;
  double _retention = 0.0;
  int _streak = 0;
  Map<String, int> _kartenProTag = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final progress = await FirebaseFirestore.instance
        .collection('users').doc(user.uid)
        .collection('progress').get();

    final now = DateTime.now();
    int gelerntHeute = 0;
    int gut = 0;
    Map<String, int> proTag = {};

    for (final doc in progress.docs) {
      final data = doc.data();
      final lastReview = (data['lastReview'] as Timestamp?)?.toDate();
      final rating = data['reviewCount'] ?? 0;

      if (lastReview != null) {
        if (lastReview.day == now.day && lastReview.month == now.month) {
          gelerntHeute++;
        }
        final key = '${lastReview.day}.${lastReview.month}';
        proTag[key] = (proTag[key] ?? 0) + 1;
        if (rating >= 3) gut++;
      }
    }

    final total = progress.docs.length;
    setState(() {
      _gelerntHeute = gelerntHeute;
      _retention = total > 0 ? (gut / total * 100) : 0;
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
          ? const Center(child: CircularProgressIndicator(
              color: Color(0xFFE8813A)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 3 Stat Cards
                  Row(
                    children: [
                      _statCard('Gesamt', '$_gesamtKarten',
                          'Karten', const Color(0xFFDBEAFE),
                          const Color(0xFF1E40AF)),
                      const SizedBox(width: 8),
                      _statCard('Heute', '$_gelerntHeute',
                          'Gelernt', const Color(0xFFD1FAE5),
                          const Color(0xFF065F46)),
                      const SizedBox(width: 8),
                      _statCard('Retention',
                          '${_retention.toStringAsFixed(1)}%',
                          'Ø Score', const Color(0xFFFEF3C7),
                          const Color(0xFF92400E)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Aktivitäts-Chart
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Aktivität letzte 7 Tage',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF111827))),
                          const SizedBox(height: 16),
                          _buildBarChart(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Deck-Fortschritt
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Deck-Fortschritt',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF111827))),
                          const SizedBox(height: 12),
                          _progressRow('Hardware', 0.65),
                          _progressRow('Netzwerktechnik', 0.45),
                          _progressRow('IT-Sicherheit', 0.30),
                          _progressRow('Projektmanagement', 0.55),
                          _progressRow('Softwareentwicklung', 0.20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Kartentypen Donut
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Kartentypen',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF111827))),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _typeItem('Neu', '89',
                                  const Color(0xFF3B82F6)),
                              _typeItem('Lernen', '12',
                                  const Color(0xFFE8813A)),
                              _typeItem('Review', '8',
                                  const Color(0xFF22C55E)),
                              _typeItem('Wieder', '4',
                                  const Color(0xFFEF4444)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value,
      String sub, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(
                fontSize: 11, color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold,
                color: textColor)),
            Text(sub, style: TextStyle(
                fontSize: 10, color: textColor.withOpacity(0.6))),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final days = List.generate(7, (i) {
      final d = DateTime.now().subtract(Duration(days: 6 - i));
      return d;
    });
    final maxVal = 10.0;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: days.map((d) {
        final key = '${d.day}.${d.month}';
        final count = (_kartenProTag[key] ?? 0).toDouble();
        final h = count > 0 ? (count / maxVal * 80).clamp(8.0, 80.0) : 4.0;
        final isToday = d.day == DateTime.now().day;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                Container(
                  height: h,
                  decoration: BoxDecoration(
                    color: isToday
                        ? const Color(0xFFE8813A)
                        : const Color(0xFF162447),
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
                          : Colors.grey[500]),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _progressRow(String name, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(
                  fontSize: 12, color: Color(0xFF374151))),
              Text('${(value * 100).round()}%',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: Color(0xFF162447))),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF162447)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeItem(String label, String count, Color color) {
    return Column(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(count, style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold,
                color: color)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
            fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}
