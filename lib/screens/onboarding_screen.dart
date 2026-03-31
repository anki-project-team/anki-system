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
      badge: 'NUR FÜR IHK AP1',
      title: 'Speziell für\ndeine AP1-Prüfung.',
      // Kein subtitle auf Seite 1 — macht Platz für die Detail-Box
      detail:
          'Alle Berufsbilder mit IHK Abschlussprüfung Teil 1:\n\n'
          '• Fachinformatiker Anwendungsentwicklung (FIAE)\n'
          '• Fachinformatiker Systemintegration (FISI)\n'
          '• Fachinformatiker Daten- & Prozessanalyse (FIDP)\n'
          '• Fachinformatiker Digitale Vernetzung (FIDV)\n'
          '• Fachinformatiker Cyberabwehr (FICA)\n'
          '• Kaufmann IT-Systemmanagement\n'
          '• Kaufmann Digitalisierungsmanagement',
    ),
    _OPage(
      emoji: '🧠',
      badge: 'LERNEN DER ZUKUNFT',
      title: 'Der Algorithmus\nlernt mit dir.',
      subtitle: 'FSRS 4.5 — der modernste\nLernalgorithmus der Welt.',
      detail:
          'Er analysiert kontinuierlich dein Wissen\n'
          'und zeigt dir genau die richtige Karte\n'
          'zum optimalen Zeitpunkt.\n\n'
          'Nicht früher. Nicht später.\n'
          '40% weniger Lernzeit — mehr Retention.',
    ),
    _OPage(
      emoji: '🏆',
      badge: 'SPEZIELLE BESTNOTEN-VORBEREITUNG',
      title: 'Nicht bestehen.\nGlänzen.',
      subtitle: 'Während andere hoffen, weißt du.',
      detail:
          '450+ echte IHK AP1-Prüfungsfragen\n'
          'mit ausführlichen Erklärungen,\n'
          'Prüfungssimulator und\n'
          'personalisierten Lernplänen.\n\n'
          'Jede Karte mit Kernantwort,\n'
          'Erklärung, Links und Hashtags.',
    ),
    _OPage(
      emoji: '🔔',
      badge: 'TÄGLICH 15 MINUTEN',
      title: 'Das System\narbeitet für dich.',
      subtitle: 'Lernen wann es am effektivsten ist —\nnicht wann du Zeit hast.',
      detail:
          'Jeden Morgen um 07:30 Uhr\n'
          'zeigt dir Learn-Factory genau,\n'
          'welche AP1-Karten heute dran sind.\n\n'
          '15 Minuten täglich reichen.\n'
          'Konsequent bis zur Prüfung.',
    ),
    _OPage(
      emoji: '🚀',
      badge: 'JETZT STARTEN',
      title: 'Erlebe\nLernen der Zukunft.',
      subtitle: 'Kein Login. Kein Risiko.\nStarte mit 10 AP1-Karten gratis.',
      isLast: true,
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: SafeArea(
        child: Column(
          children: [
            // Top Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 0),
              child: Row(children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e3a5f),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                        color: const Color(0xFFE8813A).withOpacity(0.3)),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('LF',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                        Container(
                            width: 16,
                            height: 2,
                            color: const Color(0xFFE8813A)),
                      ]),
                ),
                const SizedBox(width: 10),
                const Text('Learn-Factory',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                if (!_isLastPage)
                  TextButton(
                    onPressed: _goToLast,
                    child: Text('Überspringen',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12)),
                  ),
              ]),
            ),

            // Pages — scrollbar pro Seite
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) =>
                    setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _buildPage(_pages[i]),
              ),
            ),

            // Unterer Bereich
            Container(
              color: const Color(0xFF0f1d38),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(children: [
                // Dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin:
                          const EdgeInsets.symmetric(horizontal: 3),
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
                const SizedBox(height: 16),

                // Haupt-Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed:
                        _isLastPage ? _startTrial : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE8813A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      _isLastPage
                          ? '10 AP1-Karten gratis — kein Login nötig'
                          : 'Weiter →',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Preis-Chips — NUR auf letzter Seite
                if (_isLastPage) ...[
                  Row(children: [
                    _preisBox('🎁 Gratis', '10 Karten\nKein Login',
                        const Color(0xFF22C55E), true),
                    const SizedBox(width: 6),
                    _preisBox('⚡ Light', '9,99 € einmalig\n50 Karten',
                        Colors.white, false),
                    const SizedBox(width: 6),
                    _preisBox('👑 Deluxe',
                        '19,99 € einmalig\n450+ Karten',
                        const Color(0xFFE8813A), false),
                  ]),
                  const SizedBox(height: 14),
                ],

                // Divider
                Row(children: [
                  Expanded(
                      child: Divider(
                          color: Colors.white.withOpacity(0.1),
                          thickness: 0.5)),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('Bereits registriert?',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13)),
                  ),
                  Expanded(
                      child: Divider(
                          color: Colors.white.withOpacity(0.1),
                          thickness: 0.5)),
                ]),
                const SizedBox(height: 10),

                // Login Button
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen())),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white.withOpacity(0.15)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login_outlined,
                              size: 18,
                              color:
                                  Colors.white.withOpacity(0.6)),
                          const SizedBox(width: 8),
                          Text.rich(TextSpan(
                            style: TextStyle(
                                color:
                                    Colors.white.withOpacity(0.6),
                                fontSize: 14),
                            children: [
                              const TextSpan(text: 'Einloggen '),
                              TextSpan(
                                text:
                                    '(Light oder Deluxe bereits gekauft)',
                                style: TextStyle(
                                    color: Colors.white
                                        .withOpacity(0.35),
                                    fontSize: 12),
                              ),
                            ],
                          )),
                        ]),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preisBox(
      String label, String info, Color color, bool isFree) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(isFree ? 0.12 : 0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(info,
                  style: TextStyle(
                      color: color.withOpacity(0.7),
                      fontSize: 10,
                      height: 1.4)),
            ]),
      ),
    );
  }

  // ── Seite — jetzt SingleChildScrollView für Mobile ──────
  Widget _buildPage(_OPage page) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Emoji Box
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                  color:
                      const Color(0xFFE8813A).withOpacity(0.25),
                  width: 1.5),
            ),
            child: Center(
                child: Text(page.emoji,
                    style: const TextStyle(fontSize: 42))),
          ),
          const SizedBox(height: 24),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8813A).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color:
                      const Color(0xFFE8813A).withOpacity(0.35)),
            ),
            child: Text(page.badge,
                style: const TextStyle(
                    color: Color(0xFFE8813A),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8)),
          ),
          const SizedBox(height: 24),

          // Titel
          Text(page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 1.25)),

          // Subtitle (nur wenn vorhanden)
          if (page.subtitle != null) ...[
            const SizedBox(height: 16),
            Text(page.subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                    height: 1.6)),
          ],

          // Detail Box
          if (page.detail != null) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF1e3a5f),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: Colors.white.withOpacity(0.08)),
              ),
              child: Text(page.detail!,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.8)),
            ),
          ],

          // How it works — letzte Seite
          if (page.isLast) ...[
            const SizedBox(height: 24),
            _howItWorks(),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _howItWorks() {
    final steps = [
      ('1', '10 AP1-Karten gratis testen', 'Kein Login', true),
      ('2', 'Kostenlos registrieren', '+20 weitere Karten', true),
      ('3', 'App Light — 9,99 €', '50 Top-Karten · einmalig',
          false),
      ('4', 'App Deluxe — 19,99 €',
          '450+ Karten + Simulator', false),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a5f),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dein Weg zur Bestnote',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            ...steps.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Container(
                      width: 26, height: 26,
                      decoration: BoxDecoration(
                        color: s.$4
                            ? const Color(0xFF22C55E)
                                .withOpacity(0.2)
                            : const Color(0xFFE8813A)
                                .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Center(
                          child: Text(s.$1,
                              style: TextStyle(
                                  color: s.$4
                                      ? const Color(0xFF22C55E)
                                      : const Color(0xFFE8813A),
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
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
                                    .withOpacity(0.4),
                                fontSize: 11)),
                      ],
                    )),
                  ]),
                )),
          ]),
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
      MaterialPageRoute(
          builder: (_) => const FreeTrialScreen()));
}

class _OPage {
  final String emoji, badge, title;
  final String? subtitle, detail;
  final bool isLast;
  const _OPage({
    required this.emoji,
    required this.badge,
    required this.title,
    this.subtitle,
    this.detail,
    this.isLast = false,
  });
}
