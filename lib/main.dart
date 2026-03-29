import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/card_model.dart';
import 'screens/flashcard_question_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lernen_screen.dart';
import 'services/notification_service.dart';
import 'services/firestore_service.dart';
import 'widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  _scheduleDailyNotification();
  runApp(const IHKApp());
}

void _scheduleDailyNotification() async {
  final firestore = FirestoreService();
  final dueCards = await firestore.getDueCards('demo-user', 'default');
  await NotificationService.scheduleDailyReminder(
    hour: 18,
    minute: 0,
    dueCardCount: dueCards.length,
  );
}

class IHKApp extends StatelessWidget {
  const IHKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHK AP1 Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE8813A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const AuthWrapper(authenticatedScreen: MainShell()),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

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
        final currentNav = _navigatorKeys[_currentIndex].currentState;
        if (currentNav != null && currentNav.canPop()) {
          currentNav.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildTab(0, const HomeDashboardScreen()),
            _buildTab(1, const LernkartenDecksScreen()),
            _buildTab(2, const CalendarScreen()),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF162447),
          unselectedItemColor: const Color(0xFFB0B0B0),
          selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == _currentIndex) {
              _navigatorKeys[index].currentState?.popUntil(
                (route) => route.isFirst,
              );
            } else {
              setState(() => _currentIndex = index);
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Lernen'),
            BottomNavigationBarItem(
                icon: Icon(Icons.trending_up), label: 'Statistik'),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, Widget root) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => root,
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
                      'DHCP weist Geraeten im Netzwerk automatisch '
                      'IP-Adressen, Subnetzmasken, Gateway und DNS-Server '
                      'zu ohne manuelle Konfiguration.',
                  longAnswer:
                      'DHCP steht fuer Dynamic Host Configuration Protocol. '
                      'Der Prozess laeuft in vier Schritten ab (DORA):\n\n'
                      '1. Discover - Client sendet Broadcast ins Netz\n'
                      '2. Offer - Server bietet IP-Adresse an\n'
                      '3. Request - Client akzeptiert das Angebot\n'
                      '4. Acknowledge - Server bestaetigt die Zuweisung\n\n'
                      'Typische Ports: UDP 67 (Server) / UDP 68 (Client).',
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
                onRating: (rating, updatedCard) {
                  Navigator.pop(context);
                  final days = updatedCard.dueDate
                      .difference(DateTime.now())
                      .inDays;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Bewertung: $rating - Naechste Wiederholung in $days Tagen'),
                      backgroundColor: const Color(0xFFE8813A),
                    ),
                  );
                },
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE8813A),
            padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
