// lib/screens/impressum_screen.dart
// § 5 TMG — Rechtsgültiges Impressum

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _bgColor     = Color(0xFF162447);
const _cardColor   = Color(0xFF1e3a5f);
const _accentColor = Color(0xFFE8813A);

class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:+4917611741666');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:wilfried.ifland@gmail.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              color: _bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white70, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text('Impressum',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Angaben gemäß § 5 TMG ──────────
                    _Section(
                      title: 'Angaben gemäß § 5 TMG',
                      children: [
                        _InfoRow('Name', 'Wilfried Ifland'),
                        _InfoRow('Anschrift', 'Werstener Dorfstr. 72'),
                        _InfoRow('', '40591 Düsseldorf'),
                      ],
                    ),

                    // ── Kontakt ───────────────────────
                    _Section(
                      title: 'Kontakt',
                      children: [
                        _TappableRow(
                          icon: Icons.phone,
                          label: 'Telefon',
                          value: '+49 176 11741666',
                          onTap: _launchPhone,
                        ),
                        _TappableRow(
                          icon: Icons.email,
                          label: 'E-Mail',
                          value: 'wilfried.ifland@gmail.com',
                          onTap: _launchEmail,
                        ),
                      ],
                    ),

                    // ── Verantwortlich für Inhalt ──────
                    _Section(
                      title: 'Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV',
                      children: [
                        _InfoRow('Name', 'Wilfried Ifland'),
                        _InfoRow('Anschrift', 'Werstener Dorfstr. 72'),
                        _InfoRow('', '40591 Düsseldorf'),
                      ],
                    ),

                    // ── Haftungsausschluss ─────────────
                    _Section(
                      title: 'Haftungsausschluss',
                      children: [
                        _TextBlock(
                          'Die Inhalte dieser App wurden mit größtmöglicher '
                          'Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit '
                          'und Aktualität der Inhalte kann jedoch keine Gewähr '
                          'übernommen werden.',
                        ),
                      ],
                    ),

                    // ── Urheberrecht ───────────────────
                    _Section(
                      title: 'Urheberrecht',
                      children: [
                        _TextBlock(
                          'Die durch den Seitenbetreiber erstellten Inhalte und '
                          'Werke in dieser App unterliegen dem deutschen Urheberrecht. '
                          'Die Vervielfältigung, Bearbeitung, Verbreitung und jede '
                          'Art der Verwertung außerhalb der Grenzen des Urheberrechts '
                          'bedürfen der schriftlichen Zustimmung des jeweiligen '
                          'Autors bzw. Erstellers.',
                        ),
                      ],
                    ),

                    // ── Datenschutz ────────────────────
                    _Section(
                      title: 'Datenschutz',
                      children: [
                        _TextBlock(
                          'Die Nutzung dieser App ist ohne Angabe personenbezogener '
                          'Daten möglich (Gratis-Modus). Bei Registrierung werden '
                          'E-Mail-Adresse und Lernfortschritt auf EU-Servern '
                          '(Frankfurt, Google Cloud europe-west3) gespeichert. '
                          'Weitere Informationen finden Sie in unserer '
                          'Datenschutzerklärung.',
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        '© ${DateTime.now().year} Wilfried Ifland · Learn-Factory',
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// SHARED WIDGETS
// ════════════════════════════════════════════════════════

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              color: _accentColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty)
            SizedBox(
              width: 80,
              child: Text(label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 13,
                ),
              ),
            )
          else
            const SizedBox(width: 80),
          Expanded(
            child: Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TappableRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  const _TappableRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: _accentColor, size: 18),
            const SizedBox(width: 10),
            SizedBox(
              width: 60,
              child: Text(label,
                style: const TextStyle(color: Colors.white54, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                style: const TextStyle(
                  color: _accentColor,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  decorationColor: _accentColor,
                ),
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String text;
  const _TextBlock(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 13,
          height: 1.6,
        ),
      ),
    );
  }
}
