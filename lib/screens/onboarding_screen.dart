import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/free_trial_screen.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';
import 'package:ihk_ap1_prep/screens/register_screen.dart';
import '../theme/design_tokens.dart';
import 'purchase_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  static const int _total = 3;
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
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8813A),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Center(
                      child: Text(
                        'LF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Learn-Factory',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (!_isLast)
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8813A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Einloggen',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Pages ─────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [_page1(), _page2(), _page3()],
              ),
            ),

            // ── Footer ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _total,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _currentPage ? 20 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: i == _currentPage
                              ? const Color(0xFFE8813A)
                              : Colors.white.withValues(alpha: 0.25),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Hinweis "Bereits gekauft?" nur auf letzter Seite
                  if (_isLast) ...[
                    const Text(
                      'Bereits gekauft?',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],

                  // Haupt-Button
                  Center(
                    child: SizedBox(
                      width: 280,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _isLast
                            ? () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              )
                            : _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8813A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _isLast ? 'Einloggen' : 'Weiter →',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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

  // ── Seite 1 ──────────────────────────────────────────
  Widget _page1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DS.spacingLg),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFF2a4a6f),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🎯', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '7 BERUFSBILDER · EINE APP',
              style: TextStyle(
                color: Color(0xFFE8813A),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Deine AP1-Prüfung.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IT-Berufe',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _berufRow('FIAE', 'Anwendungsentwicklung'),
                    _berufRow('FISI', 'Systemintegration'),
                    _berufRow('FIADA', 'Daten- & Prozessanalyse'),
                    _berufRow('FIDV', 'Digitale Vernetzung'),
                    _berufRow('ITSE', 'IT-System-Elektroniker'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        height: 1,
                      ),
                    ),
                    Text(
                      'Kaufmännisch',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _berufRow('KSM', 'IT-System-Management'),
                    _berufRow('KDM', 'Digitalisierungsmanagement'),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _berufRow(String kuerzel, String name) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: 54,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE8813A), width: 1.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  kuerzel,
                  style: const TextStyle(
                    color: Color(0xFFE8813A),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  // ── Seite 2 — Features kombiniert ──────────────────────
  Widget _page2() {
    Widget featureRow(String title, String subtitle) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 6, height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8813A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(
                    color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );

    return _pageShell(
      emoji: '🏆',
      badge: 'BESTNOTEN-VORBEREITUNG',
      title: 'Bestens vorbereitet.',
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                featureRow('⏱  FSRS 4.5 Algorithmus', '40% weniger Lernzeit'),
                featureRow('🃏  450+ echte IHK-Fragen', 'Kernantwort · Erklärung · Links'),
                featureRow('🎮  Prüfungssimulator', 'Teste wie in der echten Prüfung'),
                featureRow('📊  Statistik & Sicherheitsgrad', 'Sieh wo deine Lücken sind'),
                featureRow('📱  Tägliche Erinnerungen', 'Push-Notification um 07:30 Uhr'),
                featureRow('📅  Lernkalender', 'Deine Fälligkeiten im Überblick'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Seite 3 — Lernpfad wählen ──────────────────────────
  Widget _page3() {
    const kCard = Color(0xFF1e3a5f);
    const kGreen = Color(0xFF22C55E);
    const kOrange = Color(0xFFE8813A);

    Widget featureDot(Color color, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
        ],
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            'Wähle deinen\nLernpfad',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Starte ohne Risiko oder schalte das volle Potenzial frei.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // ── Card 1: Kostenloses Modul ──────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kGreen.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'STARTPAKET',
                    style: TextStyle(
                      color: kGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kostenloses Modul',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Sofort lernen — kein Abo, kein Login nötig.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 14),
                featureDot(kGreen, '1 vollständiges Lernmodul'),
                featureDot(kGreen, 'Basis-Statistiken'),
                featureDot(kGreen, 'Anfängerfreundlich'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: _startTrial,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Kostenlos starten',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ── Card 2: Vollversion ────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: kOrange.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'BELIEBT',
                    style: TextStyle(
                      color: kOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Vollversion 29,99\u20AC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Das ultimative Paket für deinen Lernerfolg. Schalte alle Barrieren frei.',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 14),
                featureDot(kOrange, 'Alle 24 Lernmodule'),
                featureDot(kOrange, 'Professioneller Simulator'),
                featureDot(kOrange, 'Detaillierte AI-Statistiken'),
                featureDot(kOrange, 'Zertifikat bei Abschluss'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PurchaseScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kOrange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Jetzt Kaufen',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Trust-Sektion ──────────────────────────
          const Text(
            'Wissenschaftlich fundiert',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Unser Curriculum basiert auf neuesten Erkenntnissen der Neurowissenschaft für maximale Wiederholungsleistung.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  '98%',
                  style: TextStyle(
                    color: kOrange,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ERFOLGSQUOTE',
                  style: TextStyle(
                    color: kOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1e3a5f).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Bereits gekauft? Einloggen →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _pageShell({
    required String emoji,
    required String badge,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DS.spacingLg),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFF2a4a6f),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE8813A), width: 1.5),
              borderRadius: BorderRadius.circular(20),
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
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          child,
          const Spacer(),
        ],
      ),
    );
  }

  void _nextPage() => _controller.nextPage(
    duration: const Duration(milliseconds: 320),
    curve: Curves.easeInOut,
  );
  void _startTrial() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const FreeTrialScreen()),
  );
}
