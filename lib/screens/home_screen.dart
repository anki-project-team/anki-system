import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';
import 'package:ihk_ap1_prep/screens/settings_screen.dart';
import 'package:ihk_ap1_prep/data/ap1_karten.dart';
import 'package:ihk_ap1_prep/screens/flashcard_question_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _firstName = 'Lernender';

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != null) {
      setState(() {
        _firstName = user.displayName!.split(' ').first;
      });
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'GUTEN MORGEN';
    if (hour < 17) return 'GUTEN TAG';
    return 'GUTEN ABEND';
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
        title: const Text(
          'IHK AP1 Prep',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 17),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () async {
              await AuthService().logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Card
            Container(
              color: const Color(0xFF162447),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_getGreeting()}, ${_firstName.toUpperCase()}',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Meistere deine\nAP1 Prüfung,\nKarte für Karte.',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.3),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Beständigkeit ist der Schlüssel zum Erfolg.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Streak Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8813A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('⚡',
                            style: TextStyle(fontSize: 14)),
                        SizedBox(width: 6),
                        Text(
                          'AKTIVE SERIE · 12 Tage Folge',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats Row
                  Row(
                    children: [
                      _statItem('$totalCards', 'DUE'),
                      _divider(),
                      _statItem(
                          '${alleAP1Decks.length}', 'DECKS'),
                      _divider(),
                      _statItem('0', 'FÄLLIG'),
                      _divider(),
                      Row(children: [
                        _statItem('14', 'STREAK'),
                        const SizedBox(width: 4),
                        const Text('🔥',
                            style: TextStyle(fontSize: 14)),
                      ]),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heute lernen Card
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    color: const Color(0xFF1e3a5f),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'HEUTE LERNEN',
                                style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.6),
                                    fontSize: 11,
                                    letterSpacing: 0.8),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFE8813A),
                                  borderRadius:
                                      BorderRadius.circular(4),
                                ),
                                child: const Text('AP1',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight:
                                            FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tägliche Wiederholung',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Netzwerke · Betriebssysteme · IT-Sicherheit · Datenschutz',
                            style: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.5),
                                fontSize: 12),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final deck =
                                        alleAP1Decks.first;
                                    final karten =
                                        deck['karten']
                                            as List;
                                    if (karten.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              FlashcardQuestionScreen(
                                            card: karten[0],
                                            currentCard: 1,
                                            totalCards:
                                                karten.length,
                                            deckName: deck[
                                                'name'] as String,
                                            onRating: (r, c) =>
                                                Navigator.pop(
                                                    context),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFE8813A),
                                    foregroundColor:
                                        Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                8)),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                      'Lernen starten →',
                                      style: TextStyle(
                                          fontWeight:
                                              FontWeight.w600)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Row(children: [
                                Icon(Icons.access_time,
                                    size: 14,
                                    color: Colors.white
                                        .withOpacity(0.5)),
                                const SizedBox(width: 4),
                                Text(
                                  '19 Min. Sitzung',
                                  style: TextStyle(
                                      color: Colors.white
                                          .withOpacity(0.5),
                                      fontSize: 12),
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Täglicher Fortschritt
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text('Täglicher Fortschritt',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF111827))),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Karten wiederholt',
                                  style: TextStyle(
                                      color: Color(0xFF6B7280),
                                      fontSize: 13)),
                              const Text('45 / 60',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF111827))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 0.75,
                              backgroundColor:
                                  Color(0xFFE5E7EB),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Color(0xFF22C55E)),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF9C3),
                              borderRadius:
                                  BorderRadius.circular(8),
                            ),
                            child: const Row(children: [
                              Text('⚡',
                                  style:
                                      TextStyle(fontSize: 14)),
                              SizedBox(width: 6),
                              Text(
                                'Tagesziel: Fast geschafft! 60% erreicht.',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF92400E),
                                    fontWeight:
                                        FontWeight.w500),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero),
                              child: const Text(
                                  'Alle Statistiken →',
                                  style: TextStyle(
                                      color: Color(0xFFE8813A),
                                      fontSize: 13)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Zuletzt gelernte Decks
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Zuletzt gelernte Decks',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color(0xFF111827))),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero),
                        child: const Text('Alle Sammlungen',
                            style: TextStyle(
                                color: Color(0xFFE8813A),
                                fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ...alleAP1Decks.take(3).map((deck) {
                    final name = deck['name'] as String;
                    final icon = deck['icon'] as String;
                    final karten =
                        (deck['karten'] as List).length;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10)),
                      child: ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDBEAFE),
                            borderRadius:
                                BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Text(icon,
                                  style: const TextStyle(
                                      fontSize: 18))),
                        ),
                        title: Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        subtitle: Text(
                          '42% Meisterschaft',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500]),
                        ),
                        trailing: TextButton(
                          onPressed: () {},
                          child: const Text('Jetzt lernen →',
                              style: TextStyle(
                                  color: Color(0xFFE8813A),
                                  fontSize: 12)),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),

                  // Footer
                  Center(
                    child: Text(
                      'Impressum · Datenschutz · Cookie-Einstellungen',
                      style: TextStyle(
                          fontSize: 11, color: Colors.grey[400]),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
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
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 10,
                letterSpacing: 0.5)),
      ],
    );
  }

  Widget _divider() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        width: 1,
        height: 32,
        color: Colors.white.withOpacity(0.15),
      );
}
