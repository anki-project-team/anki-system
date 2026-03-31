import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ihk_ap1_prep/services/auth_service.dart';
import 'package:ihk_ap1_prep/screens/legal_screen.dart';
import 'package:ihk_ap1_prep/widgets/auth_wrapper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _taeglicheErinnerung = true;
  bool _streakWarnung = true;
  bool _pruefungsCountdown = false;
  bool _darkMode = false;

  String _daysLeft() {
    final pruefung = DateTime(2027, 2, 24);
    final diff = pruefung.difference(DateTime.now()).inDays;
    return '$diff Tage';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? 'Lernender';
    final email = user?.email ?? '';
    final initial = name.isNotEmpty
        ? name.trim()[0].toUpperCase()
        : 'L';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Einstellungen',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
            ),
            child: const Icon(Icons.settings_outlined,
                color: Colors.white, size: 17),
          ),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Profil Card
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: _profileCard(name, email, initial),
          ),
          const SizedBox(height: 24),

          // ── LERNEN ──────────────────────────────────────
          _sectionHeader('LERNEN'),
          _groupCard([
            _navRow(
              label: 'Tägliches Ziel',
              value: '20 Karten',
              onTap: () {},
            ),
            _divider(),
            _navRow(
              label: 'Lernpfad',
              value: 'Systemintegration',
              onTap: () {},
            ),
            _divider(),
            _navRow(
              label: 'Prüfungsdatum',
              value: '24.02.2027 · ${_daysLeft()}',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 24),

          // ── BENACHRICHTIGUNGEN ───────────────────────────
          _sectionHeader('BENACHRICHTIGUNGEN'),
          _groupCard([
            _toggleRow(
              label: 'Tägliche Erinnerung',
              subtitle: '07:30 Uhr',
              value: _taeglicheErinnerung,
              onChanged: (v) =>
                  setState(() => _taeglicheErinnerung = v),
            ),
            _divider(),
            _toggleRow(
              label: 'Streak-Warnung',
              subtitle: '3 Stunden vor Ablauf',
              value: _streakWarnung,
              onChanged: (v) =>
                  setState(() => _streakWarnung = v),
            ),
            _divider(),
            _toggleRow(
              label: 'Prüfungs-Countdown',
              subtitle: '7 Tage vorher',
              value: _pruefungsCountdown,
              onChanged: (v) =>
                  setState(() => _pruefungsCountdown = v),
            ),
          ]),
          const SizedBox(height: 24),

          // ── DARSTELLUNG ──────────────────────────────────
          _sectionHeader('DARSTELLUNG'),
          _groupCard([
            _toggleRow(
              label: 'Dark Mode',
              subtitle: 'Automatisch',
              value: _darkMode,
              onChanged: (v) =>
                  setState(() => _darkMode = v),
            ),
          ]),
          const SizedBox(height: 24),

          // ── RECHTLICHES & DATENSCHUTZ ───────────────────
          _sectionHeader('RECHTLICHES & DATENSCHUTZ'),
          _groupCard([
            _navRow(
              label: 'Impressum',
              subtitle: '§ 5 TMG',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const ImpressumScreen())),
            ),
            _divider(),
            _navRow(
              label: 'Datenschutzerklärung',
              subtitle: 'DSGVO-konform',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          const DatenschutzScreen())),
            ),
            _divider(),
            _navRow(
              label: 'App-Version',
              value: '1.0.0',
              onTap: () {},
              showChevron: false,
            ),
          ]),
          const SizedBox(height: 32),

          // Logout Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: _groupCard([
              InkWell(
                onTap: () async {
                  await AuthService().logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AuthWrapper()),
                      (route) => false,
                    );
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout,
                          color: Color(0xFFEF4444),
                          size: 18),
                      SizedBox(width: 8),
                      Text('Abmelden',
                          style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 15,
                              fontWeight:
                                  FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ]),
          ),

          const SizedBox(height: 16),
          Center(
            child: Text(
              'Learn-Factory · IHK AP1 Prep · BBQ Düsseldorf',
              style: TextStyle(
                  fontSize: 11, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Profil Card ─────────────────────────────────────────
  Widget _profileCard(
      String name, String email, String initial) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Orange Avatar
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE8813A),
            ),
            child: Center(
              child: Text(initial,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827))),
                const SizedBox(height: 2),
                Text(
                  'Systemintegration · AP1 Prüfungsjahr',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500]),
                ),
                if (email.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(email,
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[400])),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: Color(0xFFD1D5DB)),
        ],
      ),
    );
  }

  // ── Section Header ──────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 32, bottom: 6, right: 16),
      child: Text(title,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.4)),
    );
  }

  // ── Group Card ──────────────────────────────────────────
  Widget _groupCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: children),
      ),
    );
  }

  // ── Nav Row ─────────────────────────────────────────────
  Widget _navRow({
    required String label,
    String? subtitle,
    String? value,
    required VoidCallback onTap,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF111827))),
                  if (subtitle != null)
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400])),
                ],
              ),
            ),
            if (value != null)
              Text(value,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400])),
            if (showChevron)
              const Icon(Icons.chevron_right,
                  color: Color(0xFFD1D5DB), size: 20),
          ],
        ),
      ),
    );
  }

  // ── Toggle Row ──────────────────────────────────────────
  Widget _toggleRow({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF111827))),
                Text(subtitle,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400])),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF162447),
          ),
        ],
      ),
    );
  }

  // ── Divider ─────────────────────────────────────────────
  Widget _divider() => const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Divider(
            height: 1,
            thickness: 0.5,
            color: Color(0xFFE5E7EB)),
      );
}
