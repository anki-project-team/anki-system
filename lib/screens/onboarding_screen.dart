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

  final List<_OPage> _pages = [
    _OPage(
      emoji: '🎯',
      badge: 'IHK AP1 PRÜFUNGSVORBEREITUNG',
      title: 'Bestnotengarantie\nfür IT-Berufe.',
      subtitle:
          'Speziell entwickelt für:\n\nFachinformatiker Anwendungsentwicklung · Systemintegration\nDaten- & Prozessanalyse · Digitale Vernetzung · Cyberabwehr\nKaufmann IT-Systemmanagement · Digitalisierungsmanagement',
    ),
    _OPage(
      emoji: '🧠',
      badge: 'LERNEN DER ZUKUNFT',
      title: 'Der Algorithmus\nlernt mit dir.',
      subtitle:
          'FSRS 4.5 — der modernste Lernalgorithmus der Welt.\n\nEr analysiert dein Wissen und zeigt dir genau die richtige Karte zum optimalen Zeitpunkt. Nicht früher. Nicht später.',
    ),
    _OPage(
      emoji: '🏆',
      badge: 'BESTNOTEN-VORBEREITUNG',
      title: 'Nicht bestehen.\nGlänzen.',
      subtitle:
          'Während andere hoffen, weißt du.\n\nMit 450+ echten IHK-Prüfungsfragen, ausführlichen Erklärungen, Prüfungssimulator und personalisierten Lernplänen — für Bestnoten vorbereitet.',
    ),
    _OPage(
      emoji: '🔔',
      badge: 'TÄGLICH 15 MINUTEN',
      title: 'Das System\narbeitet für dich.',
      subtitle:
          'Jeden Morgen um 07:30 Uhr zeigt dir Learn-Factory genau was du heute lernen musst.\n\n15 Minuten täglich reichen — wenn du zum richtigen Zeitpunkt das Richtige lernst.',
    ),
    _OPage(
      emoji: '🚀',
      badge: 'JETZT KOSTENLOS STARTEN',
      title: 'Erlebe\nLernen der Zukunft.',
      subtitle: 'Kein Login. Kein Risiko.\nStarte direkt und überzeuge dich selbst.',
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
            // Top Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 16, 0),
              child: Row(
                children: [
                  Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1e3a5f),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFFE8813A).withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('LF', style: TextStyle(
                            color: Colors.white, fontSize: 12,
                            fontWeight: FontWeight.bold)),
                        Container(width: 14, height: 1.5,
                            color: const Color(0xFFE8813A)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('Learn-Factory', style: TextStyle(
                      color: Colors.white, fontSize: 14,
                      fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _goToLast,
                      child: Text('Überspringen',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 12)),
                    ),
                ],
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

            // Dots + Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_pages.length, (i) =>
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _currentPage ? 22 : 7,
                      height: 7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: i == _currentPage
                            ? const Color(0xFFE8813A)
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity, height: 52,
                  child: ElevatedButton(
                    onPressed: _currentPage < _pages.length - 1
                        ? _nextPage
                        : _startTrial,
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
                          : '10 Karten gratis testen — kein Login',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen())),
                  child: Text('Schon registriert? Einloggen →',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withOpacity(0.25))),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Emoji Box
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                  color: const Color(0xFFE8813A).withOpacity(0.25),
                  width: 1.5),
            ),
            child: Center(child: Text(page.emoji,
                style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(height: 20),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFFE8813A).withOpacity(0.35)),
            ),
            child: Text(page.badge,
                style: const TextStyle(
                    color: Color(0xFFE8813A), fontSize: 10,
                    fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          ),
          const SizedBox(height: 18),

          // Titel
          Text(page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontSize: 28,
                  fontWeight: FontWeight.bold, height: 1.3)),
          const SizedBox(height: 14),

          // Subtitle
          Text(page.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 14, height: 1.7)),

          if (page.isLast) ...[
            const SizedBox(height: 24),
            _berufsbilderChips(),
            const SizedBox(height: 20),
            _howItWorks(),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _berufsbilderChips() {
    final berufe = [
      'FIAE', 'FISI', 'FIDP', 'FIDV', 'FICA',
      'IT-Systemmanagement', 'Digitalisierungsmanagement',
    ];
    return Column(
      children: [
        Text('Alle IT-Berufsbilder mit IHK AP1',
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 10, letterSpacing: 0.6,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6, runSpacing: 6,
          children: berufe.map((b) => Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withOpacity(0.12)),
            ),
            child: Text(b, style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 11, fontWeight: FontWeight.w500)),
          )).toList(),
        ),
      ],
    );
  }

  Widget _howItWorks() {
    final steps = [
      ('1', '10 Karten gratis', 'Kein Login nötig', true),
      ('2', 'Kostenlos registrieren', '20 weitere Karten', true),
      ('3', 'App Light — 9,99 €', '50 Top-Karten', false),
      ('4', 'App Deluxe — 19,99 €', '450+ Karten + Simulator', false),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a5f),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dein Weg zur Bestnote',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 10, letterSpacing: 0.8,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...steps.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                  color: s.$4
                      ? const Color(0xFF22C55E).withOpacity(0.2)
                      : const Color(0xFFE8813A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(child: Text(s.$1,
                    style: TextStyle(
                        color: s.$4
                            ? const Color(0xFF22C55E)
                            : const Color(0xFFE8813A),
                        fontSize: 11,
                        fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(s.$2, style: const TextStyle(
                        color: Colors.white, fontSize: 12,
                        fontWeight: FontWeight.w600)),
                    Text(s.$3, style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
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

  void _nextPage() => _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut);

  void _goToLast() => _controller.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut);

  void _startTrial() => Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const FreeTrialScreen()));
}

class _OPage {
  final String emoji, badge, title, subtitle;
  final bool isLast;
  const _OPage({
    required this.emoji, required this.badge,
    required this.title, required this.subtitle,
    this.isLast = false,
  });
}
