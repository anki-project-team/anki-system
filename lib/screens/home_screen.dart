import 'package:flutter/material.dart';

class HomeDashboardScreen extends StatelessWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'IHK AP1 Prep',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 22),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 2. BEGRÜSSUNG ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'GUTEN MORGEN, KAI',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  letterSpacing: 0.8,
                ),
              ),
            ),

            // ── 3. HERO CARD ──
            _buildHeroCard(),

            const SizedBox(height: 8),

            // ── 4. MODUL CARD ──
            _buildModulCard(),

            // ── 5–7. PADDED CONTENT ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildFortschrittCard(),
                  _buildDecksSection(),
                  _buildFooter(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 3. HERO CARD
  // ════════════════════════════════════════════════════════════
  Widget _buildHeroCard() {
    return Container(
      color: const Color(0xFF162447),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Meistere deine\nAP1 Prüfung,\nKarte für Karte.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Beständigkeit ist der Schlüssel zum Erfolg.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Orange Pill-Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\u26A1 AKTIVE SERIE \u00B7 12 Tage Folge',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 4. MODUL CARD
  // ════════════════════════════════════════════════════════════
  Widget _buildModulCard() {
    return Container(
      color: const Color(0xFF1e3a5f),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'HEUTE LERNEN',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8813A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'AP1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Tägliche Wiederholung',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Netzwerke \u00B7 Betriebssysteme \u00B7 IT-Sicherheit \u00B7 Datenschutz',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8813A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Lernen starten \u2192',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Text(
                '\u23F1 19 Min. Sitzung',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.40),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 5. FORTSCHRITTS-CARD
  // ════════════════════════════════════════════════════════════
  Widget _buildFortschrittCard() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF0F1F3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Täglicher Fortschritt',
            style: TextStyle(
              color: Color(0xFF1a1a2e),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          // Karten wiederholt Zeile
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Karten wiederholt',
                style: TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
              Text(
                '45 / 60',
                style: TextStyle(
                  color: Color(0xFF1a1a2e),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Fortschrittsbalken
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.75,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
            ),
          ),
          const SizedBox(height: 12),
          // Gelbe Info-Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Tagesziel: Fast geschafft! 60% erreicht.',
              style: TextStyle(
                color: Color(0xFF92400E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Alle Statistiken Link
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Alle Statistiken \u2192',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════
  // 6. ZULETZT GELERNTE DECKS
  // ════════════════════════════════════════════════════════════
  Widget _buildDecksSection() {
    final decks = [
      _DeckItem('\uD83D\uDD17', const Color(0xFFDBEAFE), 'Hardware & Vernetzung', 42),
      _DeckItem('\uD83D\uDCBB', const Color(0xFFF3E8FF), 'Programmierung', 45),
      _DeckItem('\uD83D\uDEE1', const Color(0xFFFEF3C7), 'IT-Sicherheit', 41),
    ];

    return Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Zuletzt gelernte Decks',
                  style: TextStyle(
                    color: Color(0xFF1a1a2e),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Alle Sammlungen',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Deck-Liste
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF0F1F3)),
            ),
            child: Column(
              children: List.generate(decks.length, (i) {
                final deck = decks[i];
                return Column(
                  children: [
                    if (i > 0)
                      const Divider(
                          height: 0.5, thickness: 0.5, color: Color(0xFFF3F4F6)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      child: Row(
                        children: [
                          // Farbiges Icon-Box
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: deck.bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                deck.emoji,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deck.name,
                                  style: const TextStyle(
                                    color: Color(0xFF1a1a2e),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${deck.mastery}% Meisterschaft',
                                  style: const TextStyle(
                                    color: Color(0xFF9CA3AF),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Jetzt lernen
                          Text(
                            'Jetzt lernen \u2192',
                            style: TextStyle(
                              color: Colors.blue.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      );
  }

  // ════════════════════════════════════════════════════════════
  // 7. FOOTER LINKS
  // ════════════════════════════════════════════════════════════
  Widget _buildFooter() {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E7EB)),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Impressum \u00B7 Datenschutz \u00B7 Cookie-Einstellungen',
            style: TextStyle(
              color: Color(0xFFB0B0B0),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

class _DeckItem {
  final String emoji;
  final Color bgColor;
  final String name;
  final int mastery;

  const _DeckItem(this.emoji, this.bgColor, this.name, this.mastery);
}
