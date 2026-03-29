import 'package:flutter/material.dart';

class LernkartenDecksScreen extends StatelessWidget {
  const LernkartenDecksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        title: const Text('IHK AP1 Vorbereitung',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
            child: const Icon(Icons.settings_outlined,
                color: Colors.white, size: 18),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Progress Card
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: const Color(0xFF162447),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(4)),
                      child: const Text('AKTUELLER FORTSCHRITT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                        'Meistere die IHK\nAP1 Prüfung\nKarte für Karte.',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.25)),
                    const SizedBox(height: 12),
                    // Two Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.35)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            child: const Text('Tägliche Wiederholung',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE8813A),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              elevation: 0,
                            ),
                            child: const Text('Statistik ansehen',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('124', 'DUE'),
                        _divider(),
                        _statItem('42', 'LERNEN'),
                        _divider(),
                        _statItem('18', 'FÄLLIG'),
                        _divider(),
                        _statItem('14 🔥', 'STREAK'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Decks Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lernkarten-Decks',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xFF111827))),
                Text('+ Deck importieren',
                    style: TextStyle(
                        fontSize: 12, color: Colors.blue[600])),
              ],
            ),
            const SizedBox(height: 10),

            // Deck Cards
            _deckCard(
              icon: '🔗',
              iconBg: const Color(0xFFDBEAFE),
              title: 'Hardware & Vernetzung',
              subtitle: 'OSI-Modell, Protokolle',
              due: 85,
              learning: 14,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _deckCard(
              icon: '💻',
              iconBg: const Color(0xFFF3E8FF),
              title: 'Programmiergrundlagen',
              subtitle: 'Algorithmen, Datenstrukturen',
              due: 24,
              learning: 18,
              onTap: () {},
            ),
            const SizedBox(height: 8),
            _deckCard(
              icon: '🛡',
              iconBg: const Color(0xFFFEF3C7),
              title: 'IT-Sicherheit',
              subtitle: 'DSGVO, Cyber, Verschlüsselung',
              due: 0,
              learning: 16,
              onTap: () {},
              dueLabelOverride: 'NC',
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                fontSize: 9,
                color: Colors.white.withOpacity(0.55),
                letterSpacing: 0.5)),
      ],
    );
  }

  Widget _divider() {
    return Container(
        width: 1, height: 28, color: Colors.white.withOpacity(0.15));
  }

  Widget _deckCard({
    required String icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required int due,
    required int learning,
    required VoidCallback onTap,
    String? dueLabelOverride,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(8)),
                  child: Center(
                      child: Text(icon,
                          style: const TextStyle(fontSize: 18))),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            borderRadius: BorderRadius.circular(3)),
                        child: const Text('NEU',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E40AF),
                                letterSpacing: 0.4)),
                      ),
                      const SizedBox(height: 3),
                      Text(title,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827))),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _miniStat(
                        dueLabelOverride ?? due.toString(), 'Due'),
                    const SizedBox(width: 16),
                    _miniStat(learning.toString(), 'Lernen'),
                  ],
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF162447),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    elevation: 0,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Jetzt lernen',
                      style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827))),
        Text(label,
            style: const TextStyle(
                fontSize: 10, color: Color(0xFF9CA3AF))),
      ],
    );
  }
}
