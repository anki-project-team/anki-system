import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/free_trial_screen.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingPage> _pages = [
    _OnboardingPage(
      emoji: '🎯',
      title: 'Lerne smarter,\nnicht länger.',
      subtitle:
          'Learn-Factory nutzt den FSRS-Algorithmus — er zeigt dir genau die Karte, die du gerade am meisten brauchst.',
      highlight: 'Wissenschaftlich bewährt',
    ),
    _OnboardingPage(
      emoji: '🃏',
      title: 'Echte IHK AP1\nPrüfungsfragen.',
      subtitle:
          'Alle 450+ Karten stammen aus echten IHK-Prüfungen. Mit Kernantwort, Erklärung, Links und Hashtags.',
      highlight: 'Kein Schüler-Content',
    ),
    _OnboardingPage(
      emoji: '🔔',
      title: 'Täglich erinnert.\nNie wieder vergessen.',
      subtitle:
          'Jeden Morgen um 07:30 Uhr zeigt dir die App welche Karten heute dran sind. 15 Minuten reichen.',
      highlight: 'Push-Notification 07:30',
    ),
    _OnboardingPage(
      emoji: '🚀',
      title: 'Jetzt kostenlos\n10 Karten testen.',
      subtitle:
          'Kein Login nötig. Starte direkt und erlebe wie Learn-Factory funktioniert — dann entscheide.',
      highlight: 'Kostenlos starten',
      isLast: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button oben rechts
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
                child: _currentPage < _pages.length - 1
                    ? TextButton(
                        onPressed: _goToLast,
                        child: Text('Überspringen',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13)),
                      )
                    : const SizedBox(height: 36),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _buildPage(_pages[i]),
              ),
            ),

            // Dots + Button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: i == _currentPage
                              ? const Color(0xFFE8813A)
                              : Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Haupt-Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _currentPage < _pages.length - 1
                          ? _nextPage
                          : _startFreeTrial,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8813A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage < _pages.length - 1
                            ? 'Weiter →'
                            : 'Kostenlos starten — 10 Karten gratis',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Login Link
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                    ),
                    child: Text(
                      'Schon registriert? Einloggen →',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              Colors.white.withOpacity(0.3)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Emoji in Box
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFE8813A).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(page.emoji,
                  style: const TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 32),

          // Highlight Badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFE8813A).withOpacity(0.3)),
            ),
            child: Text(
              page.highlight,
              style: const TextStyle(
                  color: Color(0xFFE8813A),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4),
            ),
          ),
          const SizedBox(height: 20),

          // Titel
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withOpacity(0.65),
                fontSize: 15,
                height: 1.6),
          ),

          // Letzte Seite: So funktioniert's
          if (page.isLast) ...[
            const SizedBox(height: 32),
            _howItWorks(),
          ],
        ],
      ),
    );
  }

  Widget _howItWorks() {
    final steps = [
      ('1', '10 Karten gratis spielen', 'Kein Login'),
      ('2', 'Kostenlos registrieren', '20 weitere Karten'),
      ('3', 'App Light oder Deluxe', 'Alle 450+ Karten'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a5f),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'So funktioniert\'s',
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
                letterSpacing: 0.6,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...steps.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8813A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(s.$1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(s.$2,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w600)),
                        Text(s.$3,
                            style: TextStyle(
                                color: Colors.white
                                    .withOpacity(0.45),
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ]),
              )),
        ],
      ),
    );
  }

  void _nextPage() {
    _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut);
  }

  void _goToLast() {
    _controller.animateToPage(
        _pages.length - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut);
  }

  void _startFreeTrial() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (_) => const FreeTrialScreen()),
    );
  }
}

class _OnboardingPage {
  final String emoji;
  final String title;
  final String subtitle;
  final String highlight;
  final bool isLast;

  const _OnboardingPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.highlight,
    this.isLast = false,
  });
}
