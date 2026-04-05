// lib/widgets/auth_wrapper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/onboarding_screen.dart';
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

        // Firebase lädt — einfacher Navy Screen, kein Splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF162447),
          );
        }

        // Eingeloggt — Premium Status laden
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<bool>(
            future: PremiumService().checkPremiumStatus(user.uid),
            builder: (context, premiumSnapshot) {

              // Premium lädt — Navy Screen (kein Splash!)
              if (premiumSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Color(0xFF162447),
                );
              }

              // Fehlerfall — zur App navigieren
              if (premiumSnapshot.hasError) {
                return const MainShell(isPremium: false);
              }

              final isPremium = premiumSnapshot.data ?? false;
              return MainShell(isPremium: isPremium);
            },
          );
        }

        // Kein Login → Onboarding
        return const OnboardingScreen();
      },
    );
  }
}
