import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/card_model.dart';
import 'screens/flashcard_answer_screen.dart';
import 'screens/home_screen.dart';

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

  final List<Widget> _screens = [
    const HomeDashboardScreen(),
    const LernenScreen(),
    const StatistikScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF162447),
        selectedItemColor: const Color(0xFFE8813A),
        unselectedItemColor: Colors.white38,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Lernen'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik',
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
              builder: (_) => FlashcardAnswerScreen(
                card: CardModel(
                  id: 'test-001',
                  question: 'Was ist DHCP?',
                  shortAnswer: 'Automatische IP-Vergabe im Netzwerk',
                  longAnswer:
                      'DHCP steht für Dynamic Host Configuration Protocol. '
                      'Es weist Geräten in einem Netzwerk automatisch '
                      'IP-Adressen, Subnetzmasken, Standardgateways und '
                      'DNS-Server zu. Der DHCP-Server verwaltet einen '
                      'Adresspool und vergibt Adressen per Lease-Verfahren '
                      '(DORA: Discover, Offer, Request, Acknowledge).',
                  url: 'https://de.wikipedia.org/wiki/DHCP',
                  hashtags: ['#DHCP', '#Netzwerk', '#TCP/IP'],
                ),
                onRating: (rating, updatedCard) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bewertung: $rating gespeichert'),
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
          ),
          child: const Text(
            '📚 Karte anzeigen',
            style: TextStyle(color: Colors.white, fontSize: 16),
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
        '📊 Statistik',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
