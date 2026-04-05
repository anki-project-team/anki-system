import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihk_ap1_prep/main.dart';
import 'package:ihk_ap1_prep/screens/onboarding_screen.dart';
import 'package:ihk_ap1_prep/screens/profile_screen.dart';
import 'package:ihk_ap1_prep/screens/impressum_screen.dart';
import 'package:ihk_ap1_prep/screens/datenschutz_screen.dart';
import 'package:ihk_ap1_prep/screens/cookie_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Einstellungen',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // ── Profil-Karte ────────────────────────────
          if (user != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kAccentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (user.displayName ?? user.email ?? '?')[0].toUpperCase(),
                      style: const TextStyle(
                          color: kAccentColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.displayName ?? 'Nutzer',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email ?? '',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: Colors.white.withOpacity(0.3)),
              ]),
            ),
            const SizedBox(height: 20),
          ],

          // ── Konto ───────────────────────────────────
          _sectionLabel('Konto'),
          _tile(
            icon: Icons.person_outline,
            label: 'Profil bearbeiten',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),

          const SizedBox(height: 20),

          // ── Rechtliches ─────────────────────────────
          _sectionLabel('Rechtliches'),
          _tile(
            icon: Icons.description_outlined,
            label: 'Impressum',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ImpressumScreen())),
          ),
          _tile(
            icon: Icons.shield_outlined,
            label: 'Datenschutz',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const DatenschutzScreen())),
          ),
          _tile(
            icon: Icons.cookie_outlined,
            label: 'Cookie-Einstellungen',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const CookieSettingsScreen())),
          ),

          const SizedBox(height: 20),

          // ── App-Info ────────────────────────────────
          _sectionLabel('App'),
          _tile(
            icon: Icons.info_outline,
            label: 'Version',
            trailing: Text('1.0.0',
                style: TextStyle(
                    color: Colors.white.withOpacity(0.4), fontSize: 13)),
          ),

          const SizedBox(height: 32),

          // ── Logout Button ──────────────────────────
          if (user != null)
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Abmelden',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: BorderSide(
                      color: const Color(0xFFEF4444).withOpacity(0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ── Logout Dialog ─────────────────────────────────────
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Abmelden?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Dein Lernfortschritt bleibt gespeichert. Du kannst dich jederzeit wieder anmelden.',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Abbrechen',
                style: TextStyle(color: Colors.white.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => const OnboardingScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Abmelden',
                style: TextStyle(
                    color: Color(0xFFEF4444), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5)),
      );

  Widget _tile({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white.withOpacity(0.7), size: 20),
        title: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 14)),
        trailing: trailing ??
            (onTap != null
                ? Icon(Icons.chevron_right,
                    color: Colors.white.withOpacity(0.3), size: 20)
                : null),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        tileColor: kCardColor,
      ),
    );
  }
}
