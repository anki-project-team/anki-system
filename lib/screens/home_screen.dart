// lib/screens/home_screen.dart
// Screen 01 — Home Dashboard (Wireframe-getreu)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/screens/lern_session_screen.dart';
import '../services/module_service.dart';
import '../services/premium_service.dart';
import '../main.dart';
import 'settings_screen.dart';

// ════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _premiumService = PremiumService();
  final _moduleService = ModuleService();
  List<ModuleData> _modules = [];

  String _userName = 'Kai';
  bool _isPremium = false;
  int _streak = 0;
  int _dueToday = 0;
  int _learnedToday = 0;
  int _dailyGoal = 60;
  int _totalCards = 0;
  int _totalLearned = 0;
  double _retention = 0.0;
  bool _isLoading = true;

  // Aktives Modul
  String _currentModule = 'Systemintegration';
  String _currentModuleDesc = 'Netzwerkprotokolle & OSI-Schichtmodell';
  int _sessionMinutes = 19;

  // Decks
  List<Map<String, dynamic>> _recentDecks = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final userDoc = await _db.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? {};

      final isPremium = await _premiumService.checkPremiumStatus(user.uid);

      // Module mit Karten laden
      final modules = await _moduleService.getModulesWithCards();
      ModuleData? activeModule;
      if (modules.isNotEmpty) {
        activeModule = modules.firstWhere(
          (m) => m.cards.isNotEmpty,
          orElse: () => modules.first,
        );
      }

      // Decks laden
      int totalDue = 0;
      List<Map<String, dynamic>> decks = [];
      final decksSnap = await _db
          .collection('users')
          .doc(user.uid)
          .collection('decks')
          .get();

      for (final deck in decksSnap.docs) {
        final deckData = deck.data();
        final due = await _db
            .collection('users')
            .doc(user.uid)
            .collection('decks')
            .doc(deck.id)
            .collection('cards')
            .where('dueDate',
                isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
            .count()
            .get();
        final dueCount = due.count ?? 0;
        totalDue += dueCount;
        decks.add({
          'id': deck.id,
          'name': deckData['name'] ?? deck.id,
          'icon': deckData['icon'] ?? '📚',
          'cardCount': deckData['cardCount'] ?? 0,
          'dueCount': dueCount,
          'mastery': deckData['mastery'] ?? 0.0,
        });
      }

      // Falls keine Decks → Demo-Daten
      if (decks.isEmpty) {
        decks = [
          {'id': 'hw', 'name': 'Hardware & Vernetzung', 'icon': '🔗', 'cardCount': 85, 'dueCount': 14, 'mastery': 0.42},
          {'id': 'prog', 'name': 'Programmiergrundlagen', 'icon': '💻', 'cardCount': 24, 'dueCount': 18, 'mastery': 0.45},
          {'id': 'sec', 'name': 'IT-Sicherheit', 'icon': '🛡', 'cardCount': 18, 'dueCount': 9, 'mastery': 0.41},
        ];
      }

      if (mounted) {
        setState(() {
          _userName = data['displayName'] ??
              user.displayName ??
              user.email?.split('@').first ??
              'Kai';
          _isPremium = isPremium;
          _streak = data['streak'] ?? 0;
          _dueToday = totalDue > 0 ? totalDue : 25;
          _learnedToday = data['learnedToday'] ?? 0;
          _dailyGoal = data['dailyGoal'] ?? 60;
          _totalCards = data['totalCards'] ?? 2840;
          _totalLearned = data['totalCardsLearned'] ?? 0;
          _retention = (data['retention'] ?? 0.0).toDouble();
          _recentDecks = decks.take(3).toList();
          _modules = modules;
          if (activeModule != null) {
            _currentModule = activeModule.name;
            _currentModuleDesc = activeModule.description;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startLearning(List<CardModel> cards, String name) {
    if (cards.isEmpty) return;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => LernSessionScreen(cards: cards, deckName: name),
      ),
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Guten Morgen';
    if (hour < 17) return 'Guten Tag';
    return 'Guten Abend';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: kAccentColor))
            : RefreshIndicator(
                color: kAccentColor,
                backgroundColor: kCardColor,
                onRefresh: _loadDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAppBar(),
                      _buildHeroCard(),
                      const SizedBox(height: 16),
                      _buildCurrentModule(),
                      const SizedBox(height: 16),
                      _buildDailyProgress(),
                      const SizedBox(height: 20),
                      _buildRecentDecks(),
                      const SizedBox(height: 20),
                      _buildQuickStats(),
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
            decoration: BoxDecoration(
              color: kAccentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('LF',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 8),
          const Text('IHK AP1 Prep',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.notifications_outlined, color: Colors.white.withOpacity(0.5), size: 22),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            child: Icon(Icons.settings_outlined, color: Colors.white.withOpacity(0.5), size: 22),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // HERO CARD — "Meistere deine Prüfungen, Karte für Karte."
  // ══════════════════════════════════════════════════════
  Widget _buildHeroCard() {
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
            Text('$_greeting, $_userName',
                style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            RichText(
              text: const TextSpan(children: [
                TextSpan(text: 'Meistere deine Prüfungen,\n',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
                TextSpan(text: 'Karte für Karte.',
                    style: TextStyle(color: kAccentColor, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3)),
              ]),
            ),
            const SizedBox(height: 6),
            Text('Beständigkeit ist der Schlüssel zum Erfolg.',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
            const SizedBox(height: 14),
            Row(
              children: [
                // Streak Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kAccentColor.withOpacity(_streak > 0 ? 0.12 : 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: _streak > 0 ? Border.all(color: kAccentColor.withOpacity(0.4)) : null,
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Text('⚡', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(_streak > 0 ? 'AKTIVE SERIE · $_streak Tage Folge' : 'Starte deine erste Serie',
                        style: const TextStyle(color: kAccentColor, fontSize: 10, fontWeight: FontWeight.w700)),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // AKTUELLES MODUL
  // ══════════════════════════════════════════════════════
  Widget _buildCurrentModule() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kAccentColor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AKTUELLES MODUL',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_currentModule,
                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 3),
                    Text(_currentModuleDesc,
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_modules.isEmpty) return;
                    final activeModule = _modules.firstWhere(
                      (m) => m.cards.isNotEmpty,
                      orElse: () => _modules.first,
                    );
                    _startLearning(activeModule.cards, activeModule.name);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text('Lernen starten →',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.timer_outlined, size: 13, color: Colors.white.withOpacity(0.35)),
              const SizedBox(width: 4),
              Text('$_sessionMinutes Min. Sitzung',
                  style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11)),
            ]),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // TÄGLICHER FORTSCHRITT
  // ══════════════════════════════════════════════════════
  Widget _buildDailyProgress() {
    final progress = _dailyGoal > 0 ? (_learnedToday / _dailyGoal).clamp(0.0, 1.0) : 0.0;
    final percent = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: kCardColor, borderRadius: BorderRadius.circular(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Täglicher Fortschritt',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
              Text('$_learnedToday / $_dailyGoal',
                  style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ]),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: kBgColor,
                valueColor: AlwaysStoppedAnimation(progress >= 0.6 ? const Color(0xFF22C55E) : kAccentColor),
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: (progress >= 0.5 ? const Color(0xFF22C55E) : kAccentColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Text(progress >= 0.5 ? '🎯' : '💪', style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    progress >= 1.0
                        ? 'Tagesziel erreicht! Weiter so!'
                        : progress >= 0.5
                            ? 'Fast geschafft! $percent% erreicht.'
                            : 'Noch $_dueToday Karten fällig heute.',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text('Alle Statistiken ansehen →',
                    style: TextStyle(color: kAccentColor, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // ZULETZT GELERNTE DECKS
  // ══════════════════════════════════════════════════════
  Widget _buildRecentDecks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Zuletzt gelernte Decks',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text('ALLE SAMMLUNGEN',
                    style: TextStyle(color: kAccentColor.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          ..._recentDecks.map(_buildDeckRow),
        ],
      ),
    );
  }

  Widget _buildDeckRow(Map<String, dynamic> deck) {
    final mastery = (deck['mastery'] as num?)?.toDouble() ?? 0.0;
    final masteryPercent = (mastery * 100).round();
    final dueCount = deck['dueCount'] as int? ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: kAccentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(deck['icon'] ?? '📚', style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Flexible(
                  child: Text(deck['name'] ?? '', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 6),
                if (dueCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: kAccentColor.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                    child: Text('$dueCount fällig', style: const TextStyle(color: kAccentColor, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
              ]),
              const SizedBox(height: 4),
              Row(children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(value: mastery.clamp(0.0, 1.0), backgroundColor: kBgColor, valueColor: const AlwaysStoppedAnimation(kAccentColor), minHeight: 4),
                  ),
                ),
                const SizedBox(width: 8),
                Text('$masteryPercent%', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
            ]),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Text('Jetzt lernen →', style: TextStyle(color: kAccentColor, fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // QUICK STATS
  // ══════════════════════════════════════════════════════
  Widget _buildQuickStats() {
    final retentionPercent = (_retention * 100).round();
    final isHighRetention = retentionPercent >= 90;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        _statCard('📚', '$_totalCards', 'Gesamt', null),
        const SizedBox(width: 8),
        _statCard('🎓', '$_totalLearned', 'Gelernt', null),
        const SizedBox(width: 8),
        _statCard('🎯', '$retentionPercent%', 'Retention', isHighRetention ? kAccentColor : null),
      ]),
    );
  }

  Widget _statCard(String emoji, String value, String label, Color? highlight) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: highlight != null ? highlight.withOpacity(0.12) : kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: highlight != null ? Border.all(color: highlight.withOpacity(0.3)) : null,
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(color: highlight ?? kAccentColor, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 11)),
        ]),
      ),
    );
  }
}
