// lib/widgets/auth_wrapper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/onboarding_screen.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';
import 'package:ihk_ap1_prep/services/premium_service.dart';
import 'package:ihk_ap1_prep/main.dart';

Widget _buildLoadingScreen() {
  return Scaffold(
    backgroundColor: const Color(0xFF162447),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1e3a5f),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE8813A).withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'LF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 36,
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8813A),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Learn-Factory',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {

        // Firebase lädt — LF Logo Screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        }

        // Eingeloggt — Premium Status laden
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<bool>(
            future: PremiumService().checkPremiumStatus(user.uid),
            builder: (context, premiumSnapshot) {

              // Premium lädt — LF Logo Screen
              if (premiumSnapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingScreen();
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
