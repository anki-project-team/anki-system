// lib/widgets/premium_lock.dart
// Fix: isPremium Parameter — Lock nur anzeigen wenn NICHT Premium

import 'package:flutter/material.dart';

class PremiumLock extends StatelessWidget {
  final String featureName;
  final Widget child;
  final bool isPremium; // NEU: von außen übergeben

  const PremiumLock({
    super.key,
    required this.featureName,
    required this.child,
    required this.isPremium, // Pflichtfeld
  });

  @override
  Widget build(BuildContext context) {
    // Vollversion: kein Lock, direkt den Inhalt zeigen
    if (isPremium) return child;

    // Gratis: Lock-Overlay anzeigen
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF162447).withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline,
                    color: Color(0xFFE8813A), size: 36),
                const SizedBox(height: 12),
                Text(
                  featureName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Nur in der Vollversion',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/purchase'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE8813A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text('Vollversion — 29,90 €',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
