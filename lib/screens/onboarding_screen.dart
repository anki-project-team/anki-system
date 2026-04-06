import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/free_trial_screen.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';
import 'purchase_screen.dart';

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
        child: Column(children: [
          // ── Header ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8813A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('LF', style: TextStyle(
                      color: Colors.white, fontSize: 13,
                      fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Learn-Factory', style: TextStyle(
                  color: Colors.white, fontSize: 15,
                  fontWeight: FontWeight.w600)),
              const Spacer(),
              if (!_isLast)
                GestureDetector(
                  onTap: () => _controller.animateToPage(_total - 1,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut),
                  child: const Text('Überspringen', style: TextStyle(
                      color: Colors.white70, fontSize: 14,
                      fontWeight: FontWeight.w500)),
                ),
            ]),
          ),

          // ── Pages ─────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [_page1(), _page2(), _page3(), _page4()],
            ),
          ),

          // ── Footer ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(children: [
              // Dots
              Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_total, (i) =>
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _currentPage ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i == _currentPage
                            ? const Color(0xFFE8813A)
                            : Colors.white24,
                      ),
                    ))),
              const SizedBox(height: 12),

              // Haupt-Button
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _isLast ? _startTrial : _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8813A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    _isLast ? '10 AP1-Karten gratis starten' : 'Weiter →',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Preis-Chips — nur letzte Seite
              if (_isLast) ...[
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _startTrial,
                      child: _chip('Gratis', '10 Karten testen',
                          const Color(0xFF22C55E)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const PurchaseScreen())),
                      child: _chip('Vollversion', '29,99 € einmalig',
                          const Color(0xFFE8813A)),
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
              ],

              // Login Button
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e3a5f).withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(Icons.arrow_forward,
                        size: 15, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Einloggen  ',
                        style: TextStyle(color: Colors.white,
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('(Vollversion bereits gekauft)',
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12)),
                  ]),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── Seite 1 ──────────────────────────────────────────
  Widget _page1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        const Spacer(flex: 2),

        // Icon Circle — wie Figma: 72px, hellblau
        Container(
          width: 72, height: 72,
          decoration: const BoxDecoration(
            color: Color(0xFF2a4a6f),
            shape: BoxShape.circle,
          ),
          child: const Center(
              child: Text('🎯', style: TextStyle(fontSize: 32))),
        ),
        const SizedBox(height: 10),

        // Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text('7 BERUFSBILDER · EINE APP',
              style: TextStyle(color: Color(0xFFE8813A),
                  fontSize: 11, fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
        ),
        const SizedBox(height: 10),

        // Titel
        const Text('Deine AP1-Prüfung.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,
                fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 14),

        // Berufsbilder Box
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF1e3a5f),
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('IT-Berufe', style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _berufRow('FIAE',  'Anwendungsentwicklung'),
              _berufRow('FISI',  'Systemintegration'),
              _berufRow('FIADA', 'Daten- & Prozessanalyse'),
              _berufRow('FIDV',  'Digitale Vernetzung'),
              _berufRow('ITSE',  'IT-System-Elektroniker'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Divider(
                    color: Colors.white.withOpacity(0.1), height: 1),
              ),
              Text('Kaufmännisch', style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 11, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _berufRow('KSM', 'IT-System-Management'),
              _berufRow('KDM', 'Digitalisierungsmanagement'),
            ],
          ),
        ),

        const Spacer(flex: 3),
      ]),
    );
  }

  Widget _berufRow(String kuerzel, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        SizedBox(
          width: 56,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8813A), width: 1.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(kuerzel, style: const TextStyle(
                  color: Color(0xFFE8813A), fontSize: 10,
                  fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ]),
    );
  }

  // ── Seite 2 ───────────────────────────────────────────
  Widget _page2() => _pageShell(
    emoji: '🧠', badge: 'LERNEN DER ZUKUNFT',
    title: 'Der Algorithmus\nlernt mit dir.',
    child: Column(children: [
      const SizedBox(height: 14),
      _infoRow('⏱', 'Richtiger Zeitpunkt', 'Nicht zu früh. Nicht zu spät.'),
      const SizedBox(height: 8),
      _infoRow('📉', '40% weniger Lernzeit', 'Mehr Ergebnis, weniger Aufwand.'),
      const SizedBox(height: 8),
      _infoRow('🔁', 'FSRS 4.5 Algorithmus', 'Wissenschaftlich bewährt.'),
    ]),
  );

  // ── Seite 3 ───────────────────────────────────────────
  Widget _page3() => _pageShell(
    emoji: '🏆', badge: 'BESTNOTEN-VORBEREITUNG',
    title: 'Nicht bestehen.\nGlänzen.',
    child: Column(children: [
      const SizedBox(height: 14),
      _infoRow('🃏', '450+ echte IHK-Fragen', 'Kernantwort · Erklärung · Links'),
      const SizedBox(height: 8),
      _infoRow('🎮', 'Prüfungssimulator', 'Teste wie in der echten Prüfung.'),
      const SizedBox(height: 8),
      _infoRow('📊', 'Statistik & Sicherheitsgrad', 'Sieh wo deine Lücken sind.'),
    ]),
  );

  // ── Seite 4 — Vollversion 29,99 € ────────────────────
  Widget _page4() => _pageShell(
    emoji: '🚀', badge: 'KOSTENLOS STARTEN',
    title: 'Jetzt testen.\nKein Risiko.',
    child: Column(children: [
      const SizedBox(height: 14),
      _step('1', '10 AP1-Karten gratis', 'Kein Login',
          const Color(0xFF22C55E)),
      const SizedBox(height: 8),
      _step('2', 'Kostenlos registrieren', '+20 weitere Karten',
          const Color(0xFF22C55E)),
      const SizedBox(height: 8),
      _step('3', 'Vollversion — 29,99 €',
          '450+ Karten · Simulator · Statistik',
          const Color(0xFFE8813A)),
    ]),
  );

  // ── Page Shell (Seite 2-4) ────────────────────────────
  Widget _pageShell({
    required String emoji, required String badge,
    required String title, required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        const Spacer(flex: 2),

        Container(
          width: 72, height: 72,
          decoration: const BoxDecoration(
              color: Color(0xFF2a4a6f), shape: BoxShape.circle),
          child: Center(child: Text(emoji,
              style: const TextStyle(fontSize: 32))),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(badge, style: const TextStyle(
              color: Color(0xFFE8813A), fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ),
        const SizedBox(height: 10),

        Text(title, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white,
                fontSize: 24, fontWeight: FontWeight.bold, height: 1.25)),
        child,

        const Spacer(flex: 3),
      ]),
    );
  }

  Widget _infoRow(String emoji, String title, String sub) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF1e3a5f),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 12),
      Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white,
            fontSize: 13, fontWeight: FontWeight.w600)),
        Text(sub, style: TextStyle(
            color: Colors.white.withOpacity(0.5), fontSize: 11)),
      ])),
    ]),
  );

  Widget _step(String nr, String title, String sub, Color color) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
      Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8)),
        child: Center(child: Text(nr, style: TextStyle(
            color: color, fontSize: 13, fontWeight: FontWeight.bold))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white,
              fontSize: 14, fontWeight: FontWeight.w600)),
          Text(sub, style: TextStyle(
              color: Colors.white.withOpacity(0.4), fontSize: 12)),
        ],
      )),
    ]));

  Widget _chip(String label, String value, Color color) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.25)),
    ),
    child: Column(children: [
      Text(label, style: TextStyle(color: color,
          fontSize: 12, fontWeight: FontWeight.w700)),
      Text(value, style: TextStyle(
          color: color.withOpacity(0.65), fontSize: 10)),
    ]),
  );

  void _nextPage() => _controller.nextPage(
      duration: const Duration(milliseconds: 320), curve: Curves.easeInOut);
  void _startTrial() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const FreeTrialScreen()));
}
