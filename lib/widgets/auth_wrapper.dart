import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/screens/login_screen.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  final Widget authenticatedScreen;

  const AuthWrapper({super.key, required this.authenticatedScreen});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF162447),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE8813A)),
            ),
          );
        }
        if (snapshot.hasData) {
          return authenticatedScreen;
        }
        return const LoginScreen();
      },
    );
  }
}
