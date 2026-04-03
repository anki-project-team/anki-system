// lib/main.dart
// Vollständige main.dart — einfach austauschen.
// Enthält: Firebase Init, Routing, Nested Navigator, BottomNav

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';

// Screens
import 'screens/splash_screen.dart';
import 'widgets/auth_wrapper.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/decks_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/free_trial_screen.dart';
import 'screens/flashcard_answer_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/simulator_start_screen.dart';
import 'screens/simulator_question_screen.dart';
import 'screens/simulator_result_screen.dart';
import 'screens/impressum_screen.dart';
import 'screens/datenschutz_screen.dart';
import 'screens/cookie_settings_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/purchase_screen.dart';

// ─── Design Tokens (global verfügbar) ───────────────────
const kBgColor     = Color(0xFF162447);
const kAccentColor = Color(0xFFE8813A);
const kCardColor   = Color(0xFF1e3a5f);
const kDarkColor   = Color(0xFF1a2744);
const kLightBg     = Color(0xFFF5F5F5);

// ════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const LearnFactoryApp());
}

// ════════════════════════════════════════════════════════
class LearnFactoryApp extends StatelessWidget {
  const LearnFactoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn-Factory — IHK AP1',
      debugShowCheckedModeBanner: false,

      // ── Theme ─────────────────────────────────────────
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: kAccentColor,
          surface: kBgColor,
        ),
        scaffoldBackgroundColor: kBgColor,
        fontFamily: 'Inter',
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
            TargetPlatform.linux:   CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS:   CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),

      // ── Start ─────────────────────────────────────────
      
      // → /onboarding  (erster Start / nicht eingeloggt)
      // → /main        (eingeloggt)
      home: const AuthWrapper(),

      // ── Routen ────────────────────────────────────────
      routes: {
        // Onboarding & Auth
        '/onboarding': (ctx) => const OnboardingScreen(),
        '/login':      (ctx) => const LoginScreen(),
        '/purchase':   (ctx) => const PurchaseScreen(),
        '/free-trial': (ctx) => const FreeTrialScreen(),

        // Haupt-App mit BottomNav (Nested Navigator)
        '/main':       (ctx) => const MainShell(),

        // Direkt-Routen (innerhalb MainShell via push)
        '/settings':         (ctx) => const SettingsScreen(),
        '/profile':          (ctx) => const ProfileScreen(),
        '/impressum':        (ctx) => const ImpressumScreen(),
        '/datenschutz':      (ctx) => const DatenschutzScreen(),
        '/cookie-settings':  (ctx) => const CookieSettingsScreen(),
        '/calendar':         (ctx) => const CalendarScreen(),
        '/simulator':        (ctx) => const SimulatorStartScreen(),
        '/simulator/question': (ctx) => const SimulatorQuestionScreen(),
        '/simulator/result':   (ctx) => const SimulatorResultScreen(),
      },
    );
  }
}

// ════════════════════════════════════════════════════════
// SPLASH SCREEN LOGIK
// Entscheidet nach Firebase-Init wohin navigiert wird.
// Ersetze splash_screen.dart oder nutze diese Logik dort.
// ════════════════════════════════════════════════════════
//
// In splash_screen.dart:
//
// @override
// void initState() {
//   super.initState();
//   _navigate();
// }
//
// Future<void> _navigate() async {
//   await Future.delayed(const Duration(seconds: 2));
//   final user = FirebaseAuth.instance.currentUser;
//   if (!mounted) return;
//   if (user != null) {
//     Navigator.of(context).pushReplacementNamed('/main');
//   } else {
//     Navigator.of(context).pushReplacementNamed('/onboarding');
//   }
// }

// ════════════════════════════════════════════════════════
// MAIN SCAFFOLD — Nested Navigator + Bottom Navigation
// ════════════════════════════════════════════════════════
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  // Jeder Tab hat seinen eigenen Navigator-Key
  final List<GlobalKey<NavigatorState>> _navKeys = [
    GlobalKey<NavigatorState>(), // Home
    GlobalKey<NavigatorState>(), // Lernen
    GlobalKey<NavigatorState>(), // Statistik
  ];

  // Die 3 Tab-Root-Screens
  final List<Widget> _rootScreens = const [
    HomeScreen(),
    DecksScreen(),
    StatisticsScreen(),
  ];

  // Android-Back-Button: erst im Tab zurück, dann App schließen
  Future<bool> _onWillPop() async {
    final nav = _navKeys[_currentIndex].currentState;
    if (nav != null && nav.canPop()) {
      nav.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: kBgColor,
        body: IndexedStack(
          index: _currentIndex,
          children: List.generate(3, (i) {
            return Navigator(
              key: _navKeys[i],
              onGenerateRoute: (settings) {
                return MaterialPageRoute(
                  builder: (_) => _rootScreens[i],
                );
              },
            );
          }),
        ),
        bottomNavigationBar: _BottomNav(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// BOTTOM NAVIGATION BAR
// ════════════════════════════════════════════════════════
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgColor,
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: '🏠', label: 'Home',      index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: '📚', label: 'Lernen',    index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: '📊', label: 'Statistik', index: 2, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    final color = isActive ? kAccentColor : Colors.white.withOpacity(0.45);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Aktiver Indikator oben
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: isActive ? 36 : 0,
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: kAccentColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
