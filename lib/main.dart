import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/card_model.dart';
import 'screens/flashcard_question_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const IHKApp());
}

class IHKApp extends StatelessWidget {
  const IHKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHK AP1 Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE8813A),
          surface: Color(0xFF162447),
        ),
        scaffoldBackgroundColor: const Color(0xFF162447),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Ein NavigatorKey pro Tab
  final _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        // Zuerst innerhalb des aktiven Tabs zur\u00fcck navigieren
        final currentNav = _navigatorKeys[_currentIndex].currentState;
        if (currentNav != null && currentNav.canPop()) {
          currentNav.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTabNavigator(0, const DashboardScreen()),
            _buildTabNavigator(1, const LernenScreen()),
            _buildTabNavigator(2, const StatistikScreen()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF162447),
          selectedItemColor: const Color(0xFFE8813A),
          unselectedItemColor: Colors.white38,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) {
              // Gleicher Tab getippt: zur\u00fcck zum Root des Tabs
              _navigatorKeys[index].currentState?.popUntil(
                (route) => route.isFirst,
              );
            } else {
              setState(() => _currentIndex = index);
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.school), label: 'Lernen'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Statistik',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigator(int index, Widget root) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => root,
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, color: Color(0xFFE8813A), size: 80),
          SizedBox(height: 24),
          Text(
            'Meistere deine Pr\u00fcfung\nmit System.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'FSRS 4.5 \u00b7 Push-Notifications \u00b7 6-Monats-Plan',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class LernenScreen extends StatelessWidget {
  const LernenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlashcardQuestionScreen(
                card: CardModel(
                  id: 'test-001',
                  question: 'Was ist die Funktion von DHCP?',
                  shortAnswer:
                      'DHCP weist Ger\u00e4ten im Netzwerk automatisch '
                      'IP-Adressen, Subnetzmasken, Gateway und DNS-Server '
                      'zu \u2013 ohne manuelle Konfiguration.',
                  longAnswer:
                      'DHCP steht f\u00fcr Dynamic Host Configuration Protocol. '
                      'Der Prozess l\u00e4uft in vier Schritten ab (DORA):\n\n'
                      '1. Discover \u2013 Client sendet Broadcast ins Netz\n'
                      '2. Offer \u2013 Server bietet IP-Adresse an\n'
                      '3. Request \u2013 Client akzeptiert das Angebot\n'
                      '4. Acknowledge \u2013 Server best\u00e4tigt die Zuweisung\n\n'
                      'Typische Ports: UDP 67 (Server) / UDP 68 (Client). '
                      'Die IP-Adresse wird als Lease vergeben und muss '
                      'regelm\u00e4\u00dfig erneuert werden.',
                  url: 'https://de.wikipedia.org/wiki/DHCP',
                  hashtags: [
                    '#Netzwerk',
                    '#DHCP',
                    '#IP-Adressierung',
                    '#TCP-IP',
                    '#Protokolle',
                    '#AP1',
                  ],
                ),
                currentCard: 3,
                totalCards: 5,
                onRating: (rating) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Bewertung: $rating \u2014 N\u00e4chste Wiederholung geplant'),
                      backgroundColor: const Color(0xFFE8813A),
                    ),
                  );
                },
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE8813A),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Lernen starten',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class StatistikScreen extends StatelessWidget {
  const StatistikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '\ud83d\udcca Statistik',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
