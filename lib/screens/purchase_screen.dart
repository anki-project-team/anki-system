// lib/screens/purchase_screen.dart
// Digistore24 Purchase Flow
// WebView (in-app) mit url_launcher als Fallback
//
// SETUP: Ersetze DEIN_PRODUKT_ID mit deiner echten Digistore24 Produkt-ID
// Produkt anlegen: https://www.digistore24.com → Produkte → Neu

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Digistore24 Konfiguration ───────────────────────────

const String _kDigistoreProductId = '681920';
const String _kAppBaseUrl         = 'https://ihk-ap1-prep.web.app';
const String _kSuccessPath        = '/purchase-success';
const String _kCancelPath         = '/purchase-cancel';

const _bgColor     = Color(0xFF162447);
const _accentColor = Color(0xFFE8813A);
const _cardColor   = Color(0xFF1e3a5f);
const _darkColor   = Color(0xFF1a2744);
const _greenColor  = Color(0xFF32CD32);
const _WHITE       = Colors.white;

// ════════════════════════════════════════════════════════
class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  String get _checkoutUrl {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? 'guest';
    return 'https://www.digistore24.com/product/$_kDigistoreProductId'
        '?uid=$uid'
        '&return_url=${Uri.encodeComponent('$_kAppBaseUrl$_kSuccessPath?uid=$uid')}'
        '&cancel_url=${Uri.encodeComponent('$_kAppBaseUrl$_kCancelPath')}';
  }

  Future<void> _openCheckout() async {
    final uri = Uri.parse(_checkoutUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Browser konnte nicht geoeffnet werden.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white70, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text('Vollversion freischalten',
                    style: TextStyle(
                      color: _WHITE,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Hero ──────────────────────────────
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: _accentColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: _accentColor, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🚀',
                          style: TextStyle(fontSize: 36)),
                    ),
                    const SizedBox(height: 16),
                    const Text('Learn-Factory Vollversion',
                      style: TextStyle(
                        color: _WHITE,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('29,90',
                          style: TextStyle(
                            color: _accentColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(' €',
                            style: TextStyle(
                              color: _accentColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Text('Einmalig · Kein Abo · Dauerhaft',
                      style: TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Feature Liste ─────────────────────
              _FeatureList(),
              const SizedBox(height: 24),

              // ── Vergleich: Gratis vs. Vollversion ─
              _ComparisonCard(),
              const SizedBox(height: 28),

              // ── Hauptbutton: Jetzt kaufen ─────────
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _openCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Jetzt kaufen — 29,90 €',
                        style: TextStyle(
                          color: _WHITE,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.lock_open, color: _WHITE, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── Trust Badges ──────────────────────
              _TrustBadges(),
              const SizedBox(height: 24),

              // ── Affiliate Hinweis ─────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Text('🤝', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Affiliate-Programm',
                            style: TextStyle(
                              color: _WHITE,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'IT-Ausbilder & Lehrer können Learn-Factory empfehlen '
                            'und Provision verdienen.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// FEATURE LISTE
// ════════════════════════════════════════════════════════
class _FeatureList extends StatelessWidget {
  const _FeatureList();

  @override
  Widget build(BuildContext context) {
    final features = [
      ('📚', '200+ Lernkarten', 'Alle AP1-Themen vollständig'),
      ('🧠', 'FSRS 4.5 Algorithmus', 'Optimale Wiederholungen'),
      ('🎓', 'Prüfungssimulator', 'Unter echten Bedingungen üben'),
      ('📅', 'Lernkalender', 'Fälligkeiten im Überblick'),
      ('📊', 'Statistiken', 'Retention & Lernfortschritt'),
      ('🔒', 'DSGVO-konform', 'Daten nur auf EU-Servern'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: features.asMap().entries.map((entry) {
          final i = entry.key;
          final f = entry.value;
          return Column(
            children: [
              if (i > 0)
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(f.$1, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(f.$2,
                            style: const TextStyle(
                              color: _WHITE,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(f.$3,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: _greenColor, size: 20),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// VERGLEICH KARTE
// ════════════════════════════════════════════════════════
class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _darkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Center(
                    child: Text('Gratis',
                      style: TextStyle(
                          color: Colors.white54, fontSize: 12)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _accentColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Vollversion',
                        style: TextStyle(
                          color: _WHITE,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
          // Rows
          ...[
            ('Lernkarten', '10', '200+'),
            ('Themen', '1', 'Alle'),
            ('FSRS Algorithmus', '✓', '✓'),
            ('Prüfungssimulator', '✗', '✓'),
            ('Statistiken', 'Basis', 'Vollständig'),
            ('Preis', 'Gratis', '29,90 €'),
          ].map((row) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(row.$1,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(row.$2,
                          style: TextStyle(
                            color: row.$2 == '✗'
                                ? Colors.red.shade300
                                : Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(row.$3,
                          style: const TextStyle(
                            color: _accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.05)),
            ],
          )),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// TRUST BADGES
// ════════════════════════════════════════════════════════
class _TrustBadges extends StatelessWidget {
  const _TrustBadges();

  @override
  Widget build(BuildContext context) {
    final badges = [
      ('🔒', 'SSL-verschlüsselt'),
      ('🇩🇪', 'Deutsches Recht'),
      ('↩️', '14 Tage Rückgabe'),
      ('🏦', 'Digistore24'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: badges.map((b) => Column(
        children: [
          Text(b.$1, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(b.$2,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      )).toList(),
    );
  }
}
