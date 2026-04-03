import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/data/ap1_karten.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/screens/flashcard_question_screen.dart';
import 'package:ihk_ap1_prep/screens/statistik_screen.dart';
import 'package:ihk_ap1_prep/services/premium_service.dart';
import 'package:ihk_ap1_prep/screens/upgrade_screen.dart';

class LernkartenDecksScreen extends StatefulWidget {
  const LernkartenDecksScreen({super.key});

  @override
  State<LernkartenDecksScreen> createState() => _LernkartenDecksScreenState();
}

class _LernkartenDecksScreenState extends State<LernkartenDecksScreen> {
  bool _isPremium = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkPremium();
  }

  Future<void> _checkPremium() async {
    final user = FirebaseAuth.instance.currentUser;
    final premium = user != null
        ? await PremiumService().checkPremiumStatus(user.uid)
        : false;
    setState(() {
      _isPremium = premium;
      _loading = false;
    });
  }

  void _startDeck(BuildContext context, List<CardModel> cards) {
    if (cards.isEmpty) return;

    int currentIndex = 0;

    void showNext() {
      if (currentIndex >= cards.length) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lernsitzung abgeschlossen! 🎉'),
            backgroundColor: Color(0xFFE8813A),
          ),
        );
        return;
      }

      final card = cards[currentIndex];
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => FlashcardQuestionScreen(
            card: card,
            currentCard: currentIndex + 1,
            totalCards: cards.length,
            onRating: (rating, updatedCard) {
              currentIndex++;
              Navigator.of(ctx).pop();
              showNext();
            },
          ),
        ),
      );
    }

    showNext();
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
    final totalCards = alleAP1Decks.fold(
        0, (sum, deck) => sum + (deck['karten'] as List).length);

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
              color: Colors.white.withValues(alpha: 0.15),
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
                          color: Colors.white.withValues(alpha: 0.18),
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
                              final allCards = alleAP1Decks
                                  .expand((deck) =>
                                      deck['karten'] as List<CardModel>)
                                  .toList();
                              _startDeck(context, allCards);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.35)),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const StatistikScreen(),
                                ),
                              );
                            },
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

            // Alle Decks — ab Index 5 nur für Premium
            ...alleAP1Decks.asMap().entries.map((entry) {
              final i = entry.key;
              final deck = entry.value;
              final locked = i >= 5 && !_isPremium;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _deckCard(
                  context: context,
                  icon: deck['icon'] as String,
                  iconBg: _deckColor(deck['name'] as String),
                  title: deck['name'] as String,
                  subtitle: '${(deck['karten'] as List).length} Karten',
                  due: (deck['karten'] as List).length,
                  learning: 0,
                  cards: deck['karten'] as List<CardModel>,
                  locked: locked,
                ),
              );
            }),
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
                color: Colors.white.withValues(alpha: 0.55),
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
    bool locked = false,
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
                ElevatedButton.icon(
                  onPressed: locked
                      ? () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const UpgradeScreen()))
                      : (cards.isNotEmpty
                          ? () => _startDeck(context, cards)
                          : null),
                  icon: locked
                      ? const Icon(Icons.lock_outline, size: 14)
                      : const SizedBox.shrink(),
                  label: Text(locked ? 'Upgraden' : 'Jetzt lernen',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: locked
                        ? const Color(0xFFE8813A)
                        : const Color(0xFF162447),
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
