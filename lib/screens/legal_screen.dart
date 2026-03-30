import 'package:flutter/material.dart';

// ─── Impressum Screen ───────────────────────────────────────
class ImpressumScreen extends StatelessWidget {
  const ImpressumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Impressum',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section('Angaben gemäß § 5 TMG', [
              _block('BBQ Berufliche Bildung gGmbH\nKreuzstraße 16\n40213 Düsseldorf'),
              _block('Vertreten durch die Geschäftsführung'),
            ]),
            _section('Kontakt', [
              _row('Telefon', '+49 (0)211 / 82 89 9-0'),
              _row('E-Mail', 'info@bbq-online.de'),
              _row('Web', 'www.bbq-online.de'),
            ]),
            _section(
                'Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV', [
              _block(
                  'BBQ Berufliche Bildung gGmbH\nAbteilung IT-Ausbildung\nKreuzstraße 16\n40213 Düsseldorf'),
            ]),
            _section('Haftungsausschluss', [
              _block(
                  'Die Inhalte dieser App wurden mit größtmöglicher Sorgfalt erstellt. Für die Richtigkeit, Vollständigkeit und Aktualität der Inhalte übernehmen wir keine Gewähr. Als Diensteanbieter sind wir gemäß § 7 Abs. 1 TMG für eigene Inhalte verantwortlich.'),
            ]),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Stand: März 2026',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF162447))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _block(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF374151),
                height: 1.6)),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[500])),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}

// ─── Datenschutz Screen ─────────────────────────────────────
class DatenschutzScreen extends StatelessWidget {
  const DatenschutzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Datenschutzerklärung',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoCard(
              icon: Icons.privacy_tip_outlined,
              text:
                  'Diese App verarbeitet Ihre Daten gemäß der Datenschutz-Grundverordnung (DSGVO). Alle Daten werden ausschließlich in der EU gespeichert.',
            ),
            const SizedBox(height: 16),

            _section('Verantwortlicher', [
              _block(
                  'BBQ Berufliche Bildung gGmbH\nKreuzstraße 16\n40213 Düsseldorf'),
              _row('E-Mail', 'datenschutz@bbq-online.de'),
            ]),

            _section('1. Erhobene Daten', [
              _bullet('Kontodaten: E-Mail-Adresse und Anzeigename'),
              _bullet(
                  'Lernfortschritt: FSRS-Daten je Karte (Schwierigkeit, Stabilität, Fälligkeitsdatum)'),
              _bullet(
                  'Gerätedaten: FCM-Token für Push-Benachrichtigungen'),
              _bullet(
                  'Nutzungsdaten: Zeitpunkt der letzten Wiederholung, Bewertungen'),
            ]),

            _section('2. Rechtsgrundlage', [
              _block(
                  'Art. 6 Abs. 1 lit. b DSGVO — Vertragserfüllung\nArt. 6 Abs. 1 lit. f DSGVO — Berechtigtes Interesse'),
            ]),

            _section('3. Speicherung & Hosting', [
              _block(
                  'Die App nutzt Firebase (Google LLC) mit Datenspeicherung in der EU:'),
              _bullet(
                  'Firebase Authentication — Benutzerkontenverwaltung'),
              _bullet(
                  'Cloud Firestore — Lernfortschritt (Server: europe-west3, Frankfurt)'),
              _bullet('Firebase Hosting — Bereitstellung der App'),
              _bullet(
                  'Firebase Cloud Messaging — Push-Benachrichtigungen'),
              const SizedBox(height: 6),
              _block(
                  'Mit Google wurde ein Auftragsverarbeitungsvertrag (AVV) gemäß Art. 28 DSGVO geschlossen.'),
            ]),

            _section('4. Push-Benachrichtigungen', [
              _block(
                  'Mit Ihrer Einwilligung senden wir tägliche Lernreminder um 07:30 Uhr. Sie können die Berechtigung jederzeit in Ihren Browser- oder Geräteeinstellungen widerrufen.'),
            ]),

            _section('5. Ihre Rechte nach DSGVO', [
              _bullet('Auskunft über Ihre Daten (Art. 15)'),
              _bullet('Berichtigung unrichtiger Daten (Art. 16)'),
              _bullet(
                  'Löschung Ihrer Daten (Art. 17) — über Einstellungen'),
              _bullet(
                  'Einschränkung der Verarbeitung (Art. 18)'),
              _bullet('Datenübertragbarkeit (Art. 20)'),
              _bullet(
                  'Widerspruch gegen die Verarbeitung (Art. 21)'),
            ]),

            _section('6. Datenlöschung', [
              _block(
                  'Nach Kündigung Ihres Kontos werden alle personenbezogenen Daten innerhalb von 30 Tagen gelöscht.'),
            ]),

            _section('7. Cookies', [
              _block(
                  'Diese App verwendet ausschließlich technisch notwendige Cookies für die Authentifizierung (Firebase Auth Session). Es werden keine Tracking- oder Werbe-Cookies eingesetzt.'),
            ]),

            _section('8. Beschwerderecht', [
              _block(
                  'Sie haben das Recht, sich bei der zuständigen Aufsichtsbehörde zu beschweren:'),
              _row('Behörde',
                  'Landesbeauftragte für Datenschutz und Informationsfreiheit NRW'),
              _row('Web', 'www.ldi.nrw.de'),
            ]),

            const SizedBox(height: 12),
            Center(
              child: Text(
                'Stand: März 2026',
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[400]),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
      {required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF1E40AF), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1E40AF),
                    height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF162447))),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _block(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF374151),
                height: 1.6)),
      );

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 6, right: 8),
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFFE8813A),
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      height: 1.5)),
            ),
          ],
        ),
      );

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 70,
              child: Text(label,
                  style: TextStyle(
                      fontSize: 13, color: Colors.grey[500])),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}
