import 'package:flutter/material.dart';
import '../main.dart';
import 'datenschutz_screen.dart';

class CookieSettingsScreen extends StatefulWidget {
  const CookieSettingsScreen({super.key});

  @override
  State<CookieSettingsScreen> createState() => _CookieSettingsScreenState();
}

class _CookieSettingsScreenState extends State<CookieSettingsScreen> {
  bool _analyticsCookies = true;
  bool _marketingCookies = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Cookie-Einstellungen',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verwalte deine Cookie-Praeferenzen. Notwendige Cookies '
              'koennen nicht deaktiviert werden.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // 1. Notwendige Cookies
            _cookieCard(
              title: 'Notwendige Cookies',
              description:
                  'Fuer den Betrieb der App erforderlich (Session, Auth)',
              value: true,
              enabled: false,
              onChanged: null,
            ),
            const SizedBox(height: 12),

            // 2. Analyse-Cookies
            _cookieCard(
              title: 'Analyse-Cookies',
              description:
                  'Firebase Analytics \u2014 helfen uns die App zu verbessern',
              value: _analyticsCookies,
              enabled: true,
              onChanged: (v) => setState(() => _analyticsCookies = v),
            ),
            const SizedBox(height: 12),

            // 3. Marketing-Cookies
            _cookieCard(
              title: 'Marketing-Cookies',
              description: 'Fuer personalisierte Inhalte',
              value: _marketingCookies,
              enabled: true,
              onChanged: (v) => setState(() => _marketingCookies = v),
            ),
            const SizedBox(height: 24),

            // Speichern-Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Einstellungen speichern',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Datenschutz-Link
            Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const DatenschutzScreen(),
                  ),
                ),
                child: const Text(
                  'Mehr erfahren in unserer Datenschutzerklaerung',
                  style: TextStyle(
                    color: kAccentColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cookieCard({
    required String title,
    required String description,
    required bool value,
    required bool enabled,
    required ValueChanged<bool>? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: kAccentColor,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
