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
  static const int _total = 4;
  bool get _isLast => _currentPage == _total - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  // LF Logo — orange quadratisch
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8813A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'LF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Learn-Factory',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (!_isLast)
                    GestureDetector(
                      onTap: () => _controller.animateToPage(
                        _total - 1,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      ),
                      child: Text(
                        'Überspringen',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Pages ────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [_page1(), _page2(), _page3(), _page4()],
              ),
            ),

            // ── Footer ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _total,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 22 : 8,
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
                  const SizedBox(height: 16),

                  // Haupt-Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLast ? _startTrial : _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8813A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _isLast ? '10 AP1-Karten gratis starten' : 'Weiter →',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Preis-Chips — nur letzte Seite
                  if (_isLast) ...[
                    Row(
                      children: [
                        _chip('Gratis', '10 Karten', const Color(0xFF22C55E)),
                        const SizedBox(width: 6),
                        _chip('Light', '9,99 €', Colors.white),
                        const SizedBox(width: 6),
                        _chip('Deluxe', '19,99 €', const Color(0xFFE8813A)),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Login Button
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1e3a5f).withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Einloggen  ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '(Vollversion bereits gekauft)',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
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

  // ── Seite 1 — Figma Design nachgebaut ───────────────
  Widget _page1() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          // Emoji in Kreis (wie Figma — rund, dunkelblau)
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF1e3a5f),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🎯', style: TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 16),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              '7 BERUFSBILDER · EINE APP',
              style: TextStyle(
                color: Color(0xFFE8813A),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Titel
          const Text(
            'Deine AP1-Prüfung.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Berufsbilder Card
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1e3a5f),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IT-Berufe Sektion
                  Text(
                    'IT-Berufe',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _berufRow('FIAE', 'Anwendungsentwicklung'),
                  _berufRow('FISI', 'Systemintegration'),
                  _berufRow('FIADA', 'Daten- & Prozessanalyse'),
                  _berufRow('FIDV', 'Digitale Vernetzung'),
                  _berufRow('ITSE', 'IT-System-Elektroniker'),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Divider(
                      color: Colors.white.withOpacity(0.1),
                      height: 1,
                    ),
                  ),

                  // Kaufmännisch Sektion
                  Text(
                    'Kaufmännisch',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _berufRow('KSM', 'IT-System-Management'),
                  _berufRow('KDM', 'Digitalisierungsmanagement'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _berufRow(String kuerzel, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              kuerzel,
              style: const TextStyle(
                color: Color(0xFFE8813A),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  // ── Seite 2 ─────────────────────────────────────────
  Widget _page2() => _pageShell(
    emoji: '🧠',
    badge: 'LERNEN DER ZUKUNFT',
    title: 'Der Algorithmus\nlernt mit dir.',
    child: Column(
      children: [
        const SizedBox(height: 16),
        _infoRow('⏱', 'Richtiger Zeitpunkt', 'Nicht zu früh. Nicht zu spät.'),
        const SizedBox(height: 10),
        _infoRow(
          '📉',
          '40% weniger Lernzeit',
          'Mehr Ergebnis, weniger Aufwand.',
        ),
        const SizedBox(height: 10),
        _infoRow('🔁', 'FSRS 4.5 Algorithmus', 'Wissenschaftlich bewährt.'),
      ],
    ),
  );

  // ── Seite 3 ─────────────────────────────────────────
  Widget _page3() => _pageShell(
    emoji: '🏆',
    badge: 'BESTNOTEN-VORBEREITUNG',
    title: 'Nicht bestehen.\nGlänzen.',
    child: Column(
      children: [
        const SizedBox(height: 16),
        _infoRow(
          '🃏',
          '450+ echte IHK-Fragen',
          'Kernantwort · Erklärung · Links',
        ),
        const SizedBox(height: 10),
        _infoRow('🎮', 'Prüfungssimulator', 'Teste wie in der echten Prüfung.'),
        const SizedBox(height: 10),
        _infoRow(
          '📊',
          'Statistik & Sicherheitsgrad',
          'Sieh wo deine Lücken sind.',
        ),
      ],
    ),
  );

  // ── Seite 4 ─────────────────────────────────────────
  Widget _page4() => _pageShell(
    emoji: '🚀',
    badge: 'KOSTENLOS STARTEN',
    title: 'Jetzt testen.\nKein Risiko.',
    child: Column(
      children: [
        const SizedBox(height: 16),
        _step(
          '1',
          '10 AP1-Karten gratis',
          'Kein Login',
          const Color(0xFF22C55E),
        ),
        const SizedBox(height: 8),
        _step(
          '2',
          'Registrieren',
          '+20 Karten kostenlos',
          const Color(0xFF22C55E),
        ),
        const SizedBox(height: 8),
        _step(
          '3',
          'App Light — 9,99 €',
          '50 Top-Karten · einmalig',
          const Color(0xFFE8813A),
        ),
        const SizedBox(height: 8),
        _step(
          '4',
          'App Deluxe — 19,99 €',
          '450+ Karten + Simulator',
          const Color(0xFFE8813A),
        ),
      ],
    ),
  );

  Widget _pageShell({
    required String emoji,
    required String badge,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Color(0xFF1e3a5f),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                color: Color(0xFFE8813A),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String emoji, String title, String sub) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    decoration: BoxDecoration(
      color: const Color(0xFF1e3a5f),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _step(String nr, String title, String sub, Color color) => Row(
    children: [
      Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            nr,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              sub,
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    ],
  );

  Widget _chip(String label, String value, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: color.withOpacity(0.65), fontSize: 10),
          ),
        ],
      ),
    ),
  );

  void _nextPage() => _controller.nextPage(
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeInOut,
  );
  void _startTrial() => Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const FreeTrialScreen()),
  );
}
