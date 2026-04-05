// lib/widgets/auth_wrapper.dart
// Fix: Premium-Status wird nach Login aus Firestore geladen

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/onboarding_screen.dart';
import 'package:ihk_ap1_prep/screens/splash_screen.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';
import 'package:ihk_ap1_prep/services/premium_service.dart';
import 'package:ihk_ap1_prep/main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF162447),
          );
        }

        if (snapshot.hasData) {
          final user = snapshot.data!;

          // Premium-Status laden BEVOR MainShell gezeigt wird
          return FutureBuilder<bool>(
            future: PremiumService().checkPremiumStatus(user.uid),
            builder: (context, premiumSnapshot) {
              // Während Premium-Status geladen wird: Splash zeigen
              if (premiumSnapshot.connectionState == ConnectionState.waiting) {
                return const SplashScreen(nextScreen: SizedBox());
              }

              // NEU: Fehlerfall — trotzdem zur App navigieren
              if (premiumSnapshot.hasError) {
                return const MainShell(isPremium: false);
              }

              final isPremium = premiumSnapshot.data ?? false;

              // MainShell mit Premium-Status aufrufen
              return MainShell(isPremium: isPremium);
            },
          );
        }

        // Kein Login → Onboarding zeigen
        return const OnboardingScreen();
      },
    );
  }
}

