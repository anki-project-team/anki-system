// lib/screens/onboarding_screen.dart
// Austauschbar: einfach Datei ersetzen, keine weiteren Änderungen nötig.
// Navigation nach Onboarding → HomeScreen oder FreeTrialScreen.

import 'package:flutter/material.dart';

// ─── Design Tokens ──────────────────────────────────────
const _bgColor     = Color(0xFF162447);
const _accentColor = Color(0xFFE8813A);
const _cardColor   = Color(0xFF1e3a5f);
const _darkColor   = Color(0xFF1a2744);
const _greenColor  = Color(0xFF32CD32);

// ─── Daten ──────────────────────────────────────────────
const _itBerufe = [
  ('FIAE',  'Anwendungsentwicklung'),
  ('FISI',  'Systemintegration'),
  ('FIADA', 'Daten- & Prozessanalyse'),
  ('FIDV',  'Digitale Vernetzung'),
  ('ITSE',  'IT-System-Elektroniker'),
];

const _kmBerufe = [
  ('KSM',  'IT-System-Management'),
  ('KDM',  'Digitalisierungsmanagement'),
];

const _fsrsFeatures = [
  'Optimale Wiederholungszeitpunkte',
  'Passt sich deinem Lerntempo an',
  '200+ Karten zu allen AP1-Themen',
  'Bis zu 90 % weniger Lernzeit',
  'Wissenschaftlich belegt (Ebbinghaus)',
];

// ════════════════════════════════════════════════════════
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    // Direkt zu Screen 3 (Upgrade/Start)
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _startFree() {
    // TODO: Navigation zur kostenlosen Testversion (10 Karten)
    Navigator.of(context).pushReplacementNamed('/free-trial');
  }

  void _buyFullVersion() {
    // TODO: In-App-Purchase oder Digistore24 WebView
    Navigator.of(context).pushReplacementNamed('/purchase');
  }

  void _login() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────
            _TopBar(onSkip: _skip),

            // ── Pages ────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _Page1(),
                  _Page2(),
                  _Page3(
                    onStartFree: _startFree,
                    onBuyFull: _buyFullVersion,
                  ),
                ],
              ),
            ),

            // ── Dots ─────────────────────────────────────
            _DotIndicator(current: _currentPage, total: 3),
            const SizedBox(height: 16),

            // ── Buttons ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _currentPage < 2
                  ? _PrimaryButton(
                      label: 'Weiter →',
                      onTap: _nextPage,
                    )
                  : Column(
                      children: [
                        _PrimaryButton(
                          label: 'Kostenlos starten →',
                          onTap: _startFree,
                        ),
                        const SizedBox(height: 10),
                        _OutlineButton(
                          label: 'Vollversion kaufen — 29,90 €',
                          onTap: _buyFullVersion,
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 16),

            // ── Login Link ───────────────────────────────
            GestureDetector(
              onTap: _login,
              child: const Text(
                'Bereits registriert?',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _login,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: _cardColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '⇒  Einloggen  (Vollversion bereits gekauft)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// TOP BAR
// ════════════════════════════════════════════════════════
class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;
  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Text('LF',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Text('Learn-Factory',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSkip,
            child: const Text('Überspringen',
              style: TextStyle(color: Colors.white60, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// PAGE 1 — AP1-Fokus
// ════════════════════════════════════════════════════════
class _Page1 extends StatelessWidget {
  const _Page1();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Icon
          Container(
            width: 76, height: 76,
            decoration: BoxDecoration(
              color: _cardColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text('🎯', style: TextStyle(fontSize: 34)),
          ),
          const SizedBox(height: 12),
          // Badge
          _Badge(label: 'NUR FÜR IHK AP1'),
          const SizedBox(height: 16),
          // Headline
          const Text(
            'Speziell für\ndeine AP1-Prüfung.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          // Berufsbilder Box
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: const Text(
                    'Berufsbilder mit IHK AP1',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 8),

                // IT-Berufe
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 6),
                  child: Text('IT-Berufe',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ..._itBerufe.map((b) => _BerufRow(kuerzel: b.$1, name: b.$2)),

                const SizedBox(height: 4),
                const Divider(color: Colors.white12, height: 1, indent: 16),
                const SizedBox(height: 6),

                // Kaufmännisch
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 6),
                  child: Text('Kaufmännisch',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                ..._kmBerufe.map((b) => _BerufRow(kuerzel: b.$1, name: b.$2)),
                const SizedBox(height: 14),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// PAGE 2 — Lerne smarter
// ════════════════════════════════════════════════════════
class _Page2 extends StatelessWidget {
  const _Page2();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(color: _cardColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text('🧠', style: TextStyle(fontSize: 40)),
          ),
          const SizedBox(height: 12),
          _Badge(label: 'FSRS 4.5 ALGORITHMUS'),
          const SizedBox(height: 16),
          const Text(
            'Lerne smarter,\nnicht länger.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                  child: const Text(
                    'Der modernste Spaced-Repetition-Algorithmus',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(color: Colors.white12, height: 1),
                const SizedBox(height: 6),
                ..._fsrsFeatures.map((f) => _CheckRow(text: f)),
                const SizedBox(height: 12),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// PAGE 3 — Jetzt starten / Upgrade
// ════════════════════════════════════════════════════════
class _Page3 extends StatelessWidget {
  final VoidCallback onStartFree;
  final VoidCallback onBuyFull;
  const _Page3({required this.onStartFree, required this.onBuyFull});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(color: _cardColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text('🚀', style: TextStyle(fontSize: 40)),
          ),
          const SizedBox(height: 12),
          _Badge(label: 'KOSTENLOS STARTEN'),
          const SizedBox(height: 16),
          const Text(
            'Deine Bestnoten-\nVorbereitung.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 16),

          // ── Gratis Box ──────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // linker grüner Streifen
                  Container(width: 4, color: _greenColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gratis testen',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('10 Karten  ·  Kein Login  ·  Sofort starten',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          const Text('✓  Netzwerktechnik-Karten inklusive',
                            style: TextStyle(color: _greenColor, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ── Vollversion Box ─────────────────────────
          Container(
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.hardEdge,
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(width: 4, color: _accentColor),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Vollversion',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: _accentColor,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Text('29,90 €',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text('Einmalig  ·  Kein Abo  ·  Dauerhaft',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          _AccentCheck('200+ Karten  ·  Alle Themen'),
                          _AccentCheck('FSRS · Prüfungssimulator · Kalender'),
                          _AccentCheck('DSGVO-konform  ·  EU-Server'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// SHARED WIDGETS
// ════════════════════════════════════════════════════════

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: _accentColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _accentColor),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: _accentColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _BerufRow extends StatelessWidget {
  final String kuerzel;
  final String name;
  const _BerufRow({required this.kuerzel, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Row(
        children: [
          Container(
            width: 54, height: 24,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _accentColor),
            ),
            alignment: Alignment.center,
            child: Text(kuerzel,
              style: const TextStyle(
                color: _accentColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
      child: Row(
        children: [
          const Text('✓ ',
            style: TextStyle(
              color: _accentColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentCheck extends StatelessWidget {
  final String text;
  const _AccentCheck(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        children: [
          const Text('✓  ',
            style: TextStyle(color: _accentColor, fontSize: 11),
          ),
          Expanded(
            child: Text(text,
              style: const TextStyle(color: _accentColor, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _DotIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? _accentColor : Colors.white30,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: _accentColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label,
          style: const TextStyle(
            color: _accentColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
