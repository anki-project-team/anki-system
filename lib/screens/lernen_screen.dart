import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/data/ap1_karten.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/screens/flashcard_question_screen.dart';

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

  String _deckIcon(String name) {
    if (name.contains('Netzwerk')) return '🔗';
    if (name.contains('Hardware')) return '💻';
    if (name.contains('Sicherheit')) return '🛡';
    if (name.contains('Datenschutz')) return '🔒';
    if (name.contains('Projekt')) return '📋';
    if (name.contains('Software')) return '⚙';
    if (name.contains('Betrieb')) return '🖥';
    if (name.contains('Wirtschaft')) return '💰';
    if (name.contains('Marketing')) return '📢';
    if (name.contains('Team')) return '👥';
    if (name.contains('Vertrag') || name.contains('Verträge')) return '📄';
    if (name.contains('Change')) return '🔄';
    if (name.contains('Multimedia')) return '🎬';
    if (name.contains('Internet')) return '🌐';
    if (name.contains('Qualität')) return '✅';
    if (name.contains('Märkte') || name.contains('Bedarfe')) return '📊';
    if (name.contains('Kunden') || name.contains('Präsentation')) return '🎤';
    if (name.contains('Angebot')) return '📝';
    if (name.contains('Leistung')) return '📦';
    if (name.contains('Methoden')) return '🧩';
    return '📚';
  }

  Color _deckColor(String name) {
    if (name.contains('Netzwerk')) return const Color(0xFFDBEAFE);
    if (name.contains('Hardware')) return const Color(0xFFDCFCE7);
    if (name.contains('Sicherheit')) return const Color(0xFFFEE2E2);
    if (name.contains('Datenschutz')) return const Color(0xFFFEF3C7);
    if (name.contains('Projekt')) return const Color(0xFFF3E8FF);
    if (name.contains('Software')) return const Color(0xFFE0F2FE);
    return const Color(0xFFF1F5F9);
  }

  @override
  Widget build(BuildContext context) {
    final totalCards =
        alleAP1Decks.values.fold(0, (sum, list) => sum + list.length);

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
                            onPressed: () {
                              final allCards = alleAP1Decks.values
                                  .expand((list) => list)
                                  .toList();
                              _startDeck(context, allCards);
                            },
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
                        _statItem('$totalCards', 'DUE'),
                        _divider(),
                        _statItem('${alleAP1Decks.length}', 'DECKS'),
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
                Text('${alleAP1Decks.length} Decks',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(height: 10),

            // Alle 21 Decks aus alleAP1Decks
            ...alleAP1Decks.entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _deckCard(
                    context: context,
                    icon: _deckIcon(entry.key),
                    iconBg: _deckColor(entry.key),
                    title: entry.key,
                    subtitle: '${entry.value.length} Karten',
                    due: entry.value.length,
                    learning: 0,
                    cards: entry.value,
                  ),
                )),
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
                    _miniStat(due.toString(), 'Karten'),
                    const SizedBox(width: 16),
                    _miniStat(learning.toString(), 'Gelernt'),
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
