import 'package:flutter/material.dart';
import '../main.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Akademische Leistung',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Statistischer Ueberblick ueber deinen Fortschritt',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // 3 Stat-Cards
              Row(
                children: [
                  _statCard(
                    value: '2.840',
                    label: 'Gesamtzahl Karten',
                    sub: '+14 diese Woche',
                    highlighted: false,
                  ),
                  const SizedBox(width: 8),
                  _statCard(
                    value: '1.120',
                    label: 'Gelernt',
                    sub: '39,4% Stabilitaet',
                    highlighted: false,
                  ),
                  const SizedBox(width: 8),
                  _statCard(
                    value: '94,2%',
                    label: 'Behaltensquote',
                    sub: 'Ziel: 90%',
                    highlighted: true,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Kuenftige Faelligkeit
              const Text(
                'Kuenftige Faelligkeit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: const Center(
                  child: Text(
                    'Balkendiagramm \u2014 Coming Soon',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kartentypen
              const Text(
                'Kartentypen',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  children: [
                    _typeRow(const Color(0xFF22C55E), 'Gelernt', '40%'),
                    Divider(
                      color: Colors.white.withOpacity(0.06),
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _typeRow(kAccentColor, 'Im Prozess', '25%'),
                    Divider(
                      color: Colors.white.withOpacity(0.06),
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    _typeRow(Colors.grey, 'Neu', '35%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard({
    required String value,
    required String label,
    required String sub,
    required bool highlighted,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: highlighted
              ? kAccentColor.withOpacity(0.12)
              : kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: highlighted
              ? Border.all(color: kAccentColor.withOpacity(0.4))
              : Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: highlighted ? kAccentColor : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sub,
              style: TextStyle(
                color: highlighted
                    ? kAccentColor.withOpacity(0.8)
                    : Colors.white.withOpacity(0.35),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeRow(Color dotColor, String label, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            percent,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
