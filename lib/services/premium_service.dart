import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // Plan: 'free' | 'premium'
  static Future<String> getPlan() async {
    final user = _auth.currentUser;
    if (user == null) return 'free';
    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      final plan = doc.data()?['plan'] ?? 'free';
      // Rückwärts-kompatibel: alte 'light' / 'deluxe' → premium
      if (plan == 'light' || plan == 'deluxe') return 'premium';
      return plan;
    } catch (_) {
      return 'free';
    }
  }

  // isPremium: true wenn plan == 'premium'
  static Future<bool> isPremium() async {
    return (await getPlan()) == 'premium';
  }

  // checkPremiumStatus — für auth_wrapper Kompatibilität
  Future<bool> checkPremiumStatus(String uid) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      final plan = doc.data()?['plan'] ?? 'free';
      return plan == 'premium' || plan == 'deluxe' || plan == 'light';
    } catch (_) {
      return false;
    }
  }

  // Beim ersten Login Plan initialisieren
  static Future<void> initUserPlan() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (!doc.exists || doc.data()?['plan'] == null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set({'plan': 'free'}, SetOptions(merge: true));
      }
    } catch (_) {}
  }

  // Plan auf 'premium' setzen (nach Kauf)
  static Future<void> setPlan(String plan) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set({
          'plan': plan,
          'planSince': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }
}
