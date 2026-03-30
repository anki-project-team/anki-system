import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static const _vapidKey = 'BH_SD17jNoDDzP2mD6gOvUIzF3g9LBBs2f7j03ept7DPWS7Zc7ou-tBx_manThkHdtPscC8qO_TkCstGmR04gSk';

  static Future<void> init() async {
    if (!kIsWeb) return;

    final messaging = FirebaseMessaging.instance;

    // Berechtigung anfragen
    final settings = await messaging.requestPermission(
      alert: true, badge: true, sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // FCM Token holen
      final token = await messaging.getToken(vapidKey: _vapidKey);
      if (token != null) {
        await _saveToken(token);
      }

      // Token refresh
      messaging.onTokenRefresh.listen(_saveToken);

      // Foreground Messages anzeigen
      FirebaseMessaging.onMessage.listen((message) {
        print('FCM Foreground: ${message.notification?.title}');
      });
    }
  }

  static Future<void> _saveToken(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .set({'fcmToken': token, 'updatedAt': DateTime.now()},
           SetOptions(merge: true));
  }

  // Test-Notification direkt senden
  static Future<void> sendTestNotification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // FCM Token aus Firestore laden
    final doc = await FirebaseFirestore.instance
      .collection('users').doc(user.uid).get();
    final token = doc.data()?['fcmToken'];

    if (token != null) {
      print('FCM Token: $token');
      print('Sende Test-Notification über Firebase Console');
    }
  }
}
