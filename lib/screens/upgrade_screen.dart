import 'package:flutter/material.dart';

class UpgradeScreen extends StatelessWidget {
  const UpgradeScreen({super.key});

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
        title: const Text('Upgrade',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Header
            const Text('Wähle deinen Plan',
                style: TextStyle(color: Colors.white,
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('Einmalig zahlen — lebenslang nutzen',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13)),
            const SizedBox(height: 28),

            // Light Plan
            _planCard(
              context: context,
              title: 'App Light',
              price: '9,99 €',
              priceLabel: 'einmalig',
              color: const Color(0xFF1e3a5f),
              features: [
                '✅ 50 Karten (5 Top-Decks)',
                '✅ FSRS Algorithmus',
                '✅ Push-Notifications',
                '✅ Lernfortschritt',
                '❌ Statistik & Auswertung',
                '❌ Prüfungssimulator',
                '❌ Alle 450 Karten',
              ],
              buttonLabel: 'Light kaufen — 9,99 €',
              onTap: () {},
              isHighlighted: false,
            ),
            const SizedBox(height: 16),

            // Deluxe Plan — highlighted
            _planCard(
              context: context,
              title: 'App Deluxe',
              price: '19,99 €',
              priceLabel: 'einmalig · empfohlen',
              color: const Color(0xFF1e3a5f),
              features: [
                '✅ 450+ Karten (alle Decks)',
                '✅ FSRS Algorithmus',
                '✅ Push-Notifications',
                '✅ Statistik & Sicherheitsgrad',
                '✅ Prüfungssimulator',
                '✅ Lernkalender',
                '✅ Alle zukünftigen Updates',
              ],
              buttonLabel: 'Deluxe kaufen — 19,99 €',
              onTap: () {},
              isHighlighted: true,
            ),
            const SizedBox(height: 24),

            // Vergleich mit U-Form
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline,
                    color: Color(0xFFE8813A), size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(
                  'U-Form Verlag kostet 20 €/Jahr — ohne Algorithmus, ohne App. '
                  'Learn-Factory: einmalig zahlen, smarter lernen.',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11),
                )),
              ]),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _planCard({
    required BuildContext context,
    required String title,
    required String price,
    required String priceLabel,
    required Color color,
    required List<String> features,
    required String buttonLabel,
    required VoidCallback onTap,
    required bool isHighlighted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: isHighlighted
            ? Border.all(color: const Color(0xFFE8813A), width: 2)
            : Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          if (isHighlighted)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFE8813A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: const Text('⭐ EMPFOHLEN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5)),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(price,
                            style: const TextStyle(
                                color: Color(0xFFE8813A),
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        Text(priceLabel,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 10)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(f,
                      style: TextStyle(
                          color: f.startsWith('✅')
                              ? Colors.white
                              : Colors.white.withOpacity(0.35),
                          fontSize: 13)),
                )),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isHighlighted
                          ? const Color(0xFFE8813A)
                          : Colors.white.withOpacity(0.15),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: Text(buttonLabel,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
