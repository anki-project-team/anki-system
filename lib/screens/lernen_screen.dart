import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/screens/flashcard_question_screen.dart';

final List<CardModel> hardwareDeckkarten = [
  CardModel(
    id: 'hw-001',
    question: 'Was ist die Funktion von DHCP?',
    shortAnswer:
        'DHCP weist Geräten automatisch IP-Adressen, Subnetzmasken, Gateway und DNS-Server zu.',
    longAnswer:
        'DHCP (Dynamic Host Configuration Protocol) läuft nach dem DORA-Prinzip ab:\n\n'
        '1. Discover – Client sendet Broadcast\n'
        '2. Offer – Server bietet IP an\n'
        '3. Request – Client akzeptiert\n'
        '4. Acknowledge – Server bestätigt\n\n'
        'Ports: UDP 67 (Server) / UDP 68 (Client)',
    url: 'https://de.wikipedia.org/wiki/DHCP',
    hashtags: ['#Netzwerk', '#DHCP', '#IP-Adressierung', '#TCP-IP', '#AP1'],
  ),
  CardModel(
    id: 'hw-002',
    question: 'Welche Schichten hat das OSI-Modell?',
    shortAnswer:
        '7 Schichten: Bitübertragung, Sicherung, Vermittlung, Transport, Sitzung, Darstellung, Anwendung.',
    longAnswer:
        '1. Physical – Kabel, WLAN\n'
        '2. Data Link – MAC-Adressen\n'
        '3. Network – IP-Routing\n'
        '4. Transport – TCP/UDP\n'
        '5. Session – Sitzungsverwaltung\n'
        '6. Presentation – Verschlüsselung\n'
        '7. Application – HTTP, FTP, SMTP',
    url: 'https://de.wikipedia.org/wiki/OSI-Modell',
    hashtags: ['#Netzwerk', '#OSI', '#Protokolle', '#AP1'],
  ),
  CardModel(
    id: 'hw-003',
    question: 'Was ist der Unterschied zwischen TCP und UDP?',
    shortAnswer:
        'TCP ist verbindungsorientiert und zuverlässig. UDP ist verbindungslos und schneller.',
    longAnswer:
        'TCP: 3-Way-Handshake, Fehlerkorrektur, für HTTP/FTP.\n\n'
        'UDP: kein Verbindungsaufbau, für DNS/VoIP/Streaming.',
    url: 'https://de.wikipedia.org/wiki/Transmission_Control_Protocol',
    hashtags: ['#Netzwerk', '#TCP', '#UDP', '#Protokolle', '#AP1'],
  ),
];

class LernkartenDecksScreen extends StatelessWidget {
  const LernkartenDecksScreen({super.key});

  void _startDeck(BuildContext context, List<CardModel> cards) {
    if (cards.isEmpty) return;

    void go(BuildContext ctx, int i) {
      if (i >= cards.length) {
        Navigator.popUntil(ctx, (r) => r.isFirst);
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('Lernsitzung abgeschlossen! 🎉'),
          backgroundColor: Color(0xFFE8813A),
        ));
        return;
      }
      Navigator.push(
        ctx,
        MaterialPageRoute(
          builder: (_) => FlashcardQuestionScreen(
            card: cards[i],
            currentCard: i + 1,
            totalCards: cards.length,
            onRating: (rating, updatedCard) {
              Navigator.pop(ctx);
              go(ctx, i + 1);
            },
          ),
        ),
      );
    }

    go(context, 0);
  }

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
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _startDeck(context, hardwareDeckkarten),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withOpacity(0.35)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem(
                            '${hardwareDeckkarten.length}', 'DUE'),
                        _divider(),
                        _statItem('3', 'LERNEN'),
                        _divider(),
                        _statItem('0', 'FÄLLIG'),
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

            // Deck 1 — Hardware & Vernetzung (mit echten Karten)
            _deckCard(
              context: context,
              icon: '🔗',
              iconBg: const Color(0xFFDBEAFE),
              title: 'Hardware & Vernetzung',
              subtitle: 'OSI-Modell, Protokolle',
              due: hardwareDeckkarten.length,
              learning: 0,
              cards: hardwareDeckkarten,
            ),
            const SizedBox(height: 8),

            // Deck 2 — Programmiergrundlagen (noch keine Karten)
            _deckCard(
              context: context,
              icon: '💻',
              iconBg: const Color(0xFFF3E8FF),
              title: 'Programmiergrundlagen',
              subtitle: 'Algorithmen, Datenstrukturen',
              due: 24,
              learning: 18,
              cards: const [],
            ),
            const SizedBox(height: 8),

            // Deck 3 — IT-Sicherheit (noch keine Karten)
            _deckCard(
              context: context,
              icon: '🛡',
              iconBg: const Color(0xFFFEF3C7),
              title: 'IT-Sicherheit',
              subtitle: 'DSGVO, Cyber, Verschlüsselung',
              due: 0,
              learning: 16,
              cards: const [],
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
        width: 1,
        height: 28,
        color: Colors.white.withOpacity(0.15));
  }

  Widget _deckCard({
    required BuildContext context,
    required String icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required int due,
    required int learning,
    required List<CardModel> cards,
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
                  onPressed: cards.isNotEmpty
                      ? () => _startDeck(context, cards)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF162447),
                    disabledBackgroundColor: const Color(0xFFCBD5E1),
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
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
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
