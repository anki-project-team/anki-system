import 'package:flutter/material.dart';
import '../main.dart';

class DatenschutzScreen extends StatelessWidget {
  const DatenschutzScreen({super.key});

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
          'Datenschutzerklaerung',
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
            // 1. Datenschutz auf einen Blick
            _section(
              '1. Datenschutz auf einen Blick',
              'Diese Datenschutzerklaerung informiert Sie ueber die Art, den Umfang '
                  'und den Zweck der Verarbeitung personenbezogener Daten innerhalb '
                  'unserer Lern-App "IHK AP1 Prep". Der Schutz Ihrer persoenlichen '
                  'Daten ist uns ein wichtiges Anliegen. Wir behandeln Ihre Daten '
                  'vertraulich und entsprechend der gesetzlichen Datenschutzvorschriften '
                  'sowie dieser Datenschutzerklaerung.',
            ),

            // 2. Verantwortlicher
            _section(
              '2. Verantwortlicher',
              'Verantwortlich fuer die Datenverarbeitung:\n\n'
                  'Wilfried Ifland\n'
                  'BBQ Duesseldorf\n'
                  'Bildung und Berufliche Qualifizierung gGmbH\n'
                  'Duesseldorf, Deutschland\n\n'
                  'Bei Fragen zum Datenschutz wenden Sie sich bitte an den '
                  'oben genannten Verantwortlichen.',
            ),

            // 3. Erhobene Daten
            _section(
              '3. Erhobene Daten',
              'Im Rahmen der Nutzung unserer App erheben wir folgende Daten:\n\n'
                  '\u2022 Lernfortschritt: Ihre Antworten, Wiederholungsintervalle und '
                  'Fortschrittsdaten werden gespeichert, um den Spaced-Repetition-Algorithmus '
                  'zu optimieren und Ihren individuellen Lernplan zu erstellen.\n\n'
                  '\u2022 Geraeteinformationen: Technische Daten wie Geraetetyp, '
                  'Betriebssystem und Browser-Version werden zur Gewaehrleistung '
                  'der Kompatibilitaet und Fehlerbehebung erhoben.\n\n'
                  '\u2022 Anonyme Nutzungsstatistiken: Aggregierte, nicht-personenbezogene '
                  'Daten zur App-Nutzung helfen uns, die Lernerfahrung kontinuierlich '
                  'zu verbessern.',
            ),

            // 4. Zweck der Datenverarbeitung
            _section(
              '4. Zweck der Datenverarbeitung',
              'Die Verarbeitung Ihrer Daten erfolgt auf Grundlage der DSGVO '
                  '(Datenschutz-Grundverordnung), insbesondere:\n\n'
                  '\u2022 Art. 6 Abs. 1 lit. a DSGVO: Einwilligung \u2013 Sie haben '
                  'in die Verarbeitung Ihrer Daten bei der Registrierung eingewilligt.\n\n'
                  '\u2022 Art. 6 Abs. 1 lit. b DSGVO: Vertragseruellung \u2013 Die '
                  'Datenverarbeitung ist zur Bereitstellung der Lern-App und ihrer '
                  'Funktionen erforderlich.\n\n'
                  '\u2022 Art. 6 Abs. 1 lit. f DSGVO: Berechtigtes Interesse \u2013 '
                  'Wir haben ein berechtigtes Interesse an der Analyse anonymer '
                  'Nutzungsdaten zur Verbesserung unseres Angebots.',
            ),

            // 5. Firebase / Google
            _section(
              '5. Firebase / Google',
              'Unsere App nutzt Firebase, einen Dienst der Google Ireland Limited, '
                  'zur Datenspeicherung und Authentifizierung.\n\n'
                  '\u2022 Ihre Daten werden auf Firebase-Servern in der EU '
                  '(Standort: Frankfurt am Main, Deutschland) gespeichert.\n\n'
                  '\u2022 Firebase Authentication verarbeitet Ihre Anmeldedaten '
                  '(E-Mail-Adresse oder Google-Konto) zur sicheren Identifikation.\n\n'
                  '\u2022 Cloud Firestore speichert Ihren Lernfortschritt verschluesselt '
                  'und zugriffskontrolliert.\n\n'
                  'Google unterliegt dem EU-US Data Privacy Framework. Weitere '
                  'Informationen finden Sie in der Datenschutzerklaerung von Google: '
                  'policies.google.com/privacy',
            ),

            // 6. Ihre Rechte
            _section(
              '6. Ihre Rechte',
              'Als betroffene Person haben Sie folgende Rechte:\n\n'
                  '\u2022 Auskunftsrecht (Art. 15 DSGVO): Sie koennen jederzeit '
                  'Auskunft ueber die bei uns gespeicherten Daten verlangen.\n\n'
                  '\u2022 Recht auf Loeschung (Art. 17 DSGVO): Sie koennen die '
                  'Loeschung Ihrer personenbezogenen Daten verlangen. Ihr Konto '
                  'und alle zugehoerigen Daten werden daraufhin unwiderruflich '
                  'geloescht.\n\n'
                  '\u2022 Widerspruchsrecht (Art. 21 DSGVO): Sie koennen der '
                  'Verarbeitung Ihrer Daten jederzeit widersprechen.\n\n'
                  'Zur Ausuebung Ihrer Rechte wenden Sie sich bitte an den '
                  'unter Punkt 2 genannten Verantwortlichen.',
            ),

            // 7. Cookies
            _section(
              '7. Cookies',
              'Unsere App verwendet technisch notwendige Cookies und lokale '
                  'Speichermechanismen, um Ihre Sitzung aufrechtzuerhalten und '
                  'Einstellungen zu speichern.\n\n'
                  'Detaillierte Informationen zu den verwendeten Cookies und die '
                  'Moeglichkeit, Ihre Cookie-Einstellungen anzupassen, finden Sie '
                  'unter den Cookie-Einstellungen in der App.',
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                'Stand: April 2026',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.3),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: kAccentColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
