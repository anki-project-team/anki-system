import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PremiumService {
  static Future<String> getPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'free';
    final doc = await FirebaseFirestore.instance
        .collection('users').doc(user.uid).get();
    return doc.data()?['plan'] ?? 'free';
  }

  static Future<bool> isPremium() async {
    final plan = await getPlan();
    return plan == 'deluxe';
  }

  static Future<bool> isLight() async {
    final plan = await getPlan();
    return plan == 'light' || plan == 'deluxe';
  }

  // Beim ersten Login: Plan auf 'light' setzen
  static Future<void> initUserPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await FirebaseFirestore.instance
        .collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data()?['plan'] == null) {
      await FirebaseFirestore.instance
          .collection('users').doc(user.uid)
          .set({'plan': 'light'}, SetOptions(merge: true));
    }
  }
}
