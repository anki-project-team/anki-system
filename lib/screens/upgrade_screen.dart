import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ihk_ap1_prep/services/premium_service.dart';

// Digistore24 Bestell-Link — nach Produkt-Anlage eintragen
const _vollversionUrl = 'https://www.digistore24.com/product/DEINE_PRODUKT_ID';

class UpgradeScreen extends StatefulWidget {
  const UpgradeScreen({super.key});

  @override
  State<UpgradeScreen> createState() => _UpgradeScreenState();
}

class _UpgradeScreenState extends State<UpgradeScreen> {
  bool _isPremium = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPlan();
  }

  Future<void> _loadPlan() async {
    final premium = await PremiumService.isPremium();
    if (mounted) setState(() {
      _isPremium = premium;
      _loading = false;
    });
  }

  Future<void> _openCheckout() async {
    final uri = Uri.parse(_vollversionUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Vollversion',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(
              color: Color(0xFFE8813A)))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(children: [
                const SizedBox(height: 8),

                // Bereits Premium
                if (_isPremium) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFF22C55E).withOpacity(0.4)),
                    ),
                    child: const Column(children: [
                      Icon(Icons.check_circle,
                          color: Color(0xFF22C55E), size: 48),
                      SizedBox(height: 12),
                      Text('Vollversion aktiv',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Du hast Zugriff auf alle Features.',
                          style: TextStyle(
                              color: Colors.white70, fontSize: 14)),
                    ]),
                  ),
                ] else ...[

                  // Header
                  const Text('Learn-Factory Vollversion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Einmalig zahlen — lebenslang nutzen',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 13)),
                  const SizedBox(height: 28),

                  // Preis-Karte
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1e3a5f),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFFE8813A), width: 2),
                    ),
                    child: Column(children: [
                      // Empfohlen Banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8813A),
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(18)),
                        ),
                        child: const Text('⭐  VOLLVERSION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5)),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(children: [
                          // Preis
                          const Text('29,99 €',
                              style: TextStyle(
                                  color: Color(0xFFE8813A),
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold)),
                          Text('einmalig · lebenslang',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.45),
                                  fontSize: 12)),
                          const SizedBox(height: 20),

                          // Features
                          ...[
                            '450+ echte IHK AP1-Prüfungsfragen',
                            'FSRS-Algorithmus (Lernen der Zukunft)',
                            'Alle Decks — alle 7 Berufsbilder',
                            'Prüfungssimulator',
                            'Statistik & Sicherheitsgrad',
                            'Lernkalender',
                            'Push-Notifications',
                            'Alle zukünftigen Updates',
                          ].map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(children: [
                              const Icon(Icons.check_circle_outline,
                                  color: Color(0xFF22C55E), size: 18),
                              const SizedBox(width: 10),
                              Text(f, style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                            ]),
                          )),
                          const SizedBox(height: 20),

                          // Kauf-Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _openCheckout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE8813A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Jetzt kaufen — 29,99 €',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 20),

                  // Vergleich
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      const Icon(Icons.info_outline,
                          color: Color(0xFFE8813A), size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'U-Form Verlag kostet 20 €/Jahr — ohne App, '
                          'ohne Algorithmus. Learn-Factory: einmalig 29,99 €, '
                          'smarter lernen, besser bestehen.',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                              height: 1.5),
                        ),
                      ),
                    ]),
                  ),
                ],
                const SizedBox(height: 20),
              ]),
            ),
    );
  }
}
