import 'package:flutter/material.dart';

void main() {
  runApp(const IHKApp());
}

class IHKApp extends StatelessWidget {
  const IHKApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IHK AP1 Prep',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE8813A),
          surface: const Color(0xFF162447),
        ),
        scaffoldBackgroundColor: const Color(0xFF162447),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        title: const Text(
          'IHK AP1 Prep',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, color: Color(0xFFE8813A), size: 80),
            SizedBox(height: 24),
            Text(
              'Meistere deine Prüfung\nmit System.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'FSRS 4.5 · Push-Notifications · 6-Monats-Plan',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
