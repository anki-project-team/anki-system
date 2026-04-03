// lib/services/premium_service.dart
// Premium-Status Verwaltung — Firestore + Digistore24 IPN

import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Premium-Status einmalig prüfen ───────────────────
  Future<bool> checkPremiumStatus(String userId) async {
    try {
      final doc = await _db.collection('users').doc(userId).get();
      if (!doc.exists) return false;
      return doc.data()?['isPremium'] == true;
    } catch (e) {
      return false;
    }
  }

  // ── Premium-Status als Stream (live updates) ─────────
  // Nutze dies in Widgets um sofort auf Statusänderungen zu reagieren
  Stream<bool> premiumStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.data()?['isPremium'] == true);
  }

  // ── Premium manuell setzen (nur für Tests / Admin) ───
  Future<void> setPremium(String userId, {bool value = true}) async {
    await _db.collection('users').doc(userId).set(
      {
        'isPremium': value,
        'premiumSince': value ? FieldValue.serverTimestamp() : null,
        'plan': value ? 'vollversion' : 'gratis',
      },
      SetOptions(merge: true),
    );
  }

  // ── Nutzerprofil anlegen (bei Registrierung) ─────────
  Future<void> createUserProfile(String userId, String email) async {
    await _db.collection('users').doc(userId).set(
      {
        'email': email,
        'isPremium': false,
        'plan': 'gratis',
        'createdAt': FieldValue.serverTimestamp(),
        'freeCardsUsed': 0,
      },
      SetOptions(merge: true),
    );
  }

  // ── Freie Karten zählen ──────────────────────────────
  Future<int> getFreeCardsUsed(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return doc.data()?['freeCardsUsed'] ?? 0;
  }

  Future<void> incrementFreeCardsUsed(String userId) async {
    await _db.collection('users').doc(userId).set(
      {'freeCardsUsed': FieldValue.increment(1)},
      SetOptions(merge: true),
    );
  }

  // ── Maximale Gratis-Karten ───────────────────────────
  static const int kMaxFreeCards = 10;

  Future<bool> hasReachedFreeLimit(String userId) async {
    final used = await getFreeCardsUsed(userId);
    return used >= kMaxFreeCards;
  }
}
