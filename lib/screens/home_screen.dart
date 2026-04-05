// lib/screens/home_screen.dart
// Screen 01 — Home Dashboard

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/premium_service.dart';
import 'decks_screen.dart';
import 'settings_screen.dart';

const _bgColor     = Color(0xFF162447);
const _accentColor = Color(0xFFE8813A);
const _cardColor   = Color(0xFF1e3a5f);
const _darkColor   = Color(0xFF1a2744);
const _greenColor  = Color(0xFF32CD32);

// ════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _db   = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _premiumService = PremiumService();

  String _userName    = 'Kai';
  bool   _isPremium   = false;
  int    _streak      = 0;
  int    _dueToday    = 0;
  int    _learnedToday = 0;
  int    _dailyGoal   = 60;
  bool   _isLoading   = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // User-Profil laden
      final userDoc = await _db.collection('users').doc(user.uid).get();
      final data = userDoc.data() ?? {};

      // Premium-Status
      final isPremium = await _premiumService.checkPremiumStatus(user.uid);

      // Fällige Karten zählen (alle Decks)
      int totalDue = 0;
      final decks = await _db
          .collection('users').doc(user.uid)
          .collection('decks').get();

      for (final deck in decks.docs) {
        final due = await _db
            .collection('users').doc(user.uid)
            .collection('decks').doc(deck.id)
            .collection('cards')
            .where('dueDate',
                isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
            .count().get();
        totalDue += due.count ?? 0;
      }

      if (mounted) {
        setState(() {
          _userName     = data['displayName'] ??
              user.displayName ??
              user.email?.split('@').first ??
              'Kai';
          _isPremium    = isPremium;
          _streak       = data['streak'] ?? 0;
          _dueToday     = totalDue;
          _learnedToday = data['learnedToday'] ?? 0;
          _dailyGoal    = data['dailyGoal'] ?? 60;
          _isLoading    = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
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
      backgroundColor: _bgColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: _accentColor))
            : RefreshIndicator(
                color: _accentColor,
                backgroundColor: _cardColor,
                onRefresh: _loadDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ────────────────────────
                      _Header(
                        greeting: _greeting,
                        userName: _userName,
                        streak: _streak,
                        dueToday: _dueToday,
                        onSettingsTap: () =>
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            ),
                      ),
                      const SizedBox(height: 20),

                      // ── Täglicher Fortschritt ─────────
                      _DailyProgress(
                        learned: _learnedToday,
                        goal: _dailyGoal,
                      ),
                      const SizedBox(height: 16),

                      // ── Aktuelles Modul ───────────────
                      _CurrentModuleCard(
                        isPremium: _isPremium,
                        onStartLearning: () =>
                            Navigator.of(context).pushNamed('/main'),
                      ),
                      const SizedBox(height: 20),

                      // ── Zuletzt gelernt ───────────────
                      _RecentDecksSection(userId: _auth.currentUser!.uid),
                      const SizedBox(height: 20),

                      // ── Upgrade Banner (nur Gratis) ───
                      if (!_isPremium) ...[
                        _UpgradeBanner(
                          onTap: () =>
                              Navigator.of(context, rootNavigator: true)
                                  .pushNamed('/purchase'),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // ── Quick Stats ───────────────────
                      _QuickStats(userId: _auth.currentUser!.uid),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// HEADER
// ════════════════════════════════════════════════════════
class _Header extends StatelessWidget {
  final String greeting;
  final String userName;
  final int streak;
  final int dueToday;
  final VoidCallback onSettingsTap;

  const _Header({
    required this.greeting,
    required this.userName,
    required this.streak,
    required this.dueToday,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$greeting, $userName 👋',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dueToday > 0
                    ? 'Heute: $dueToday Karte${dueToday == 1 ? '' : 'n'} fällig'
                    : 'Alle Karten erledigt! 🎉',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        // Streak Badge
        if (streak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _accentColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('$streak Tage',
                  style: const TextStyle(
                    color: _accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(width: 8),
        // Settings Icon
        GestureDetector(
          onTap: onSettingsTap,
          child: const Icon(Icons.settings_outlined,
              color: Colors.white38, size: 22),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
// TÄGLICHER FORTSCHRITT
// ════════════════════════════════════════════════════════
class _DailyProgress extends StatelessWidget {
  final int learned;
  final int goal;
  const _DailyProgress({required this.learned, required this.goal});

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (learned / goal).clamp(0.0, 1.0) : 0.0;
    final percent  = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Täglicher Fortschritt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('$learned / $goal Karten',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: _darkColor,
              valueColor: const AlwaysStoppedAnimation<Color>(_accentColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 6),
          Text('$percent% abgeschlossen',
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// AKTUELLES MODUL
// ════════════════════════════════════════════════════════
class _CurrentModuleCard extends StatelessWidget {
  final bool isPremium;
  final VoidCallback onStartLearning;
  const _CurrentModuleCard(
      {required this.isPremium, required this.onStartLearning});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Aktuelles Modul',
            style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🌐 Netzwerktechnik',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isPremium
                          ? '24 Karten · 8 fällig'
                          : '10 Karten · Gratis-Version',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onStartLearning,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  elevation: 0,
                ),
                child: const Text('Lernen →',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// ZULETZT GELERNTE DECKS
// ════════════════════════════════════════════════════════
class _RecentDecksSection extends StatelessWidget {
  final String userId;
  const _RecentDecksSection({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Zuletzt gelernt',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users').doc(userId)
              .collection('decks')
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const _DeckCardShimmer();
            }
            final decks = snapshot.data!.docs;
            if (decks.isEmpty) {
              return const _EmptyDecksHint();
            }
            return Column(
              children: decks.map((deck) {
                final data = deck.data() as Map<String, dynamic>;
                return _DeckCard(
                  icon: data['icon'] ?? '📚',
                  name: data['name'] ?? deck.id,
                  cardCount: data['cardCount'] ?? 0,
                  dueCount: data['dueCount'] ?? 0,
                  onTap: () => Navigator.of(context).pushNamed('/main'),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _DeckCard extends StatelessWidget {
  final String icon;
  final String name;
  final int cardCount;
  final int dueCount;
  final VoidCallback onTap;

  const _DeckCard({
    required this.icon,
    required this.name,
    required this.cardCount,
    required this.dueCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$cardCount Karten · '
                    '${dueCount > 0 ? "$dueCount fällig" : "alle erledigt ✓"}',
                    style: TextStyle(
                      color: dueCount > 0
                          ? Colors.white54
                          : _greenColor.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: Colors.white38, size: 20),
          ],
        ),
      ),
    );
  }
}

class _DeckCardShimmer extends StatelessWidget {
  const _DeckCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (i) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 64,
        decoration: BoxDecoration(
          color: _cardColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
      )),
    );
  }
}

class _EmptyDecksHint extends StatelessWidget {
  const _EmptyDecksHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          children: [
            Text('📚', style: TextStyle(fontSize: 32)),
            SizedBox(height: 8),
            Text('Noch keine Decks vorhanden',
              style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// UPGRADE BANNER (nur für Gratis-Nutzer)
// ════════════════════════════════════════════════════════
class _UpgradeBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _UpgradeBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _accentColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _accentColor),
        ),
        child: Row(
          children: [
            const Text('🚀', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vollversion freischalten',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('200+ Karten · Alle Themen · 29,90 €',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: _accentColor, size: 16),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// QUICK STATS
// ════════════════════════════════════════════════════════
class _QuickStats extends StatelessWidget {
  final String userId;
  const _QuickStats({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        final data = (snapshot.data?.data() as Map<String, dynamic>?) ?? {};
        final totalLearned = data['totalCardsLearned'] ?? 0;
        final retention    = data['retention'] ?? 0.0;
        final streak       = data['streak'] ?? 0;

        final stats = [
          ('📚', '$totalLearned', 'Gesamt'),
          ('🎯', '${(retention * 100).round()}%', 'Retention'),
          ('🔥', '$streak', 'Streak'),
        ];

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: stats.map((s) => SizedBox(
            width: (MediaQuery.of(context).size.width - 40 - 16) / 3,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 14),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(s.$1,
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(s.$2,
                    style: const TextStyle(
                      color: _accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(s.$3,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          )).toList(),
        );
      },
    );
  }
}
