import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';
import 'package:ihk_ap1_prep/screens/legal_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'Lernender';
    final email = user?.email ?? '';
    final initials = name.isNotEmpty
        ? name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase()
        : 'LF';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        title: const Text('Profil & Einstellungen',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.w600, fontSize: 17)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Profil Card
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF162447),
                      ),
                      child: Center(
                        child: Text(initials,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111827))),
                    const SizedBox(height: 4),
                    Text(email,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[500])),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('IHK AP1 — Prüfung 24.02.2027',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF1E40AF),
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lernplan Stats
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Mein Lernplan',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF111827))),
                    const SizedBox(height: 12),
                    _infoRow('Prüfungsdatum', '24. Februar 2027'),
                    _infoRow('Verbleibende Tage', _daysLeft()),
                    _infoRow('Lernstart', '1. Mai 2026'),
                    _infoRow('Tägliches Ziel', '15 Minuten'),
                    _infoRow('Notification', 'Täglich 07:30 Uhr'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Einstellungen
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _settingsRow(
                    icon: Icons.notifications_outlined,
                    label: 'Benachrichtigungen',
                    subtitle: 'Täglich 07:30 Uhr',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _settingsRow(
                    icon: Icons.school_outlined,
                    label: 'Prüfungsdatum ändern',
                    subtitle: '24.02.2027',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _settingsRow(
                    icon: Icons.language_outlined,
                    label: 'App-Version',
                    subtitle: '1.0.0 — IHK AP1 Prep',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rechtliches
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _settingsRow(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Datenschutz',
                    subtitle: 'DSGVO-konform',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const DatenschutzScreen())),
                  ),
                  const Divider(height: 1, indent: 56),
                  _settingsRow(
                    icon: Icons.description_outlined,
                    label: 'Impressum',
                    subtitle: 'BBQ Düsseldorf',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ImpressumScreen())),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () async {
                await AuthService().logout();
              },
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Abmelden'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Learn-Factory · IHK AP1 Prep · BBQ Düsseldorf',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _daysLeft() {
    final pruefung = DateTime(2027, 2, 24);
    final heute = DateTime.now();
    final diff = pruefung.difference(heute).inDays;
    return '$diff Tage';
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827))),
        ],
      ),
    );
  }

  Widget _settingsRow({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF162447), size: 22),
      title: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      trailing: const Icon(Icons.chevron_right,
          color: Color(0xFFD1D5DB), size: 20),
      onTap: onTap,
    );
  }
}
