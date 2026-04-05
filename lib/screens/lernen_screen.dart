// lib/screens/lernen_screen.dart
// Screen 02 — Lernkarten-Decks (Wireframe Dark Navy + bestehende Logik)

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/data/ap1_karten.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/screens/lern_session_screen.dart';
import 'package:ihk_ap1_prep/screens/statistik_screen.dart';
import 'package:ihk_ap1_prep/services/premium_service.dart';
import 'package:ihk_ap1_prep/screens/upgrade_screen.dart';
import 'package:ihk_ap1_prep/main.dart';

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

  void _startDeck(BuildContext context, List<CardModel> cards, String name) {
    if (cards.isEmpty) return;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => LernSessionScreen(
          cards: cards,
          deckName: name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCards = alleAP1Decks.fold(
        0, (sum, deck) => sum + (deck['karten'] as List).length);

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: kAccentColor))
            : RefreshIndicator(
                color: kAccentColor,
                backgroundColor: kCardColor,
                onRefresh: () async => _checkPremium(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(),
                      _buildHeroBanner(totalCards),
                      const SizedBox(height: 16),
                      _buildSectionHeader(),
                      const SizedBox(height: 8),
                      ...alleAP1Decks.asMap().entries.map((entry) {
                        final i = entry.key;
                        final deck = entry.value;
                        final locked = i >= 5 && !_isPremium;
                        return _buildDeckCard(
                          deck: deck,
                          locked: locked,
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // APP BAR
  // ══════════════════════════════════════════════════════
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: kAccentColor, borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text('LF', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 8),
          const Text('IHK AP1 Vorbereitung',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          Icon(Icons.settings_outlined, color: Colors.white.withOpacity(0.4), size: 22),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // HERO BANNER
  // ══════════════════════════════════════════════════════
  Widget _buildHeroBanner(int totalCards) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kAccentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('AKTUELLER FORTSCHRITT',
                  style: TextStyle(color: kAccentColor, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            ),
            const SizedBox(height: 12),

            // Headline
            RichText(
              text: const TextSpan(children: [
                TextSpan(text: 'Meistere die IHK\nAP1 Prüfung\n',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                TextSpan(text: 'Karte für Karte.',
                    style: TextStyle(color: kAccentColor, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
              ]),
            ),
            const SizedBox(height: 4),
            Text('Strukturierte Vorbereitung nach dem offiziellen Prüfungsrahmenplan.',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
            const SizedBox(height: 16),

            // Action Buttons
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    final allCards = alleAP1Decks
                        .expand((deck) => deck['karten'] as List<CardModel>)
                        .toList();
                    _startDeck(context, allCards, 'Tägliche Wiederholung');
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text('Tägliche Wiederholung',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (_) => const StatistikScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text('Statistik ansehen',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ),
            ]),
            const SizedBox(height: 16),

            // 4 Stats Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: kBgColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    final isStreak = label.contains('STREAK');
    return Column(children: [
      Text(value,
          style: TextStyle(
              color: isStreak ? kAccentColor : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold)),
      const SizedBox(height: 2),
      Text(label,
          style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 9, letterSpacing: 0.5, fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _divider() {
    return Container(width: 1, height: 28, color: Colors.white.withOpacity(0.1));
  }

  // ══════════════════════════════════════════════════════
  // SECTION HEADER
  // ══════════════════════════════════════════════════════
  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Lernkarten-Decks',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          Text('${alleAP1Decks.length} Decks',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // DECK CARD
  // ══════════════════════════════════════════════════════
  Widget _buildDeckCard({
    required Map<String, dynamic> deck,
    bool locked = false,
  }) {
    final name = deck['name'] as String;
    final icon = deck['icon'] as String;
    final cards = deck['karten'] as List<CardModel>;
    final cardCount = cards.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Icon + Name
            Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: kAccentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text(icon, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        // NEU Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B82F6).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('NEU',
                              style: TextStyle(color: Color(0xFF3B82F6), fontSize: 9, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(name,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ]),
                    ],
                  ),
                ),
                if (locked)
                  Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.3), size: 18),
              ],
            ),
            const SizedBox(height: 14),

            // Bottom: Stats + Button
            Row(
              children: [
                _deckStat('$cardCount', 'Karten'),
                const SizedBox(width: 16),
                _deckStat('0', 'Gelernt'),
                const Spacer(),

                // Jetzt lernen / Upgraden Button
                ElevatedButton.icon(
                  onPressed: locked
                      ? () => Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(builder: (_) => const UpgradeScreen()),
                          )
                      : (cards.isNotEmpty
                          ? () => _startDeck(context, cards, name)
                          : null),
                  icon: locked
                      ? const Icon(Icons.lock_outline, size: 14)
                      : const SizedBox.shrink(),
                  label: Text(locked ? 'Upgraden' : 'Jetzt lernen',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: locked ? kAccentColor : kAccentColor,
                    disabledBackgroundColor: kCardColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Widget _deckStat(String value, String label) {
    return Row(children: [
      Text(value,
          style: const TextStyle(color: kAccentColor, fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(width: 4),
      Text(label,
          style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11)),
    ]);
  }
}
