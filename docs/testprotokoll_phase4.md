# Testprotokoll Phase 4 — Validierung

**Datum:** 28.03.2026
**Tester:** Claude Code (automatisiert)
**Projekt:** IHK AP1 Prep — Flutter PWA
**Testframework:** Flutter Test (`flutter test --reporter expanded`)
**Testdatei:** `test/app_validation_test.dart`

---

## Testergebnisse

| Nr. | Testfall | Subtests | Status | Ergebnis |
|-----|----------|----------|--------|----------|
| T1 | 5-Feld-Karte anlegen | 2 | PASS | toFirestore() enthält alle 5 Inhaltsfelder (question, shortAnswer, longAnswer, url, hashtags); fromFirestore() rekonstruiert identische Werte |
| T2 | Kurze Antwort vor langer Antwort | 2 | PASS | shortAnswer und longAnswer sind nicht leer, unterschiedlich; shortAnswer ist kürzer als longAnswer |
| T3 | URL in Karte | 2 | PASS | URL beginnt mit https://, Uri.tryParse bestätigt absolute URL; leere URL erzeugt keinen Fehler |
| T4 | Hashtag-Filter | 2 | PASS | Filter nach #Netzwerk liefert exakt 2 von 3 Karten; nicht existierender Hashtag liefert leere Liste |
| T5 | FSRS-Intervall berechnen | 4 | PASS | Rating 3: stability wächst, dueDate in Zukunft; Rating 1: stability sinkt; Rating 4 > Rating 3; Difficulty bleibt 1.0–10.0 |
| T6 | Push-Notification schedulen | 3 | PASS | getNotificationBody enthält korrekte Kartenanzahl (0, 5, 42) |
| T7 | Notification-Text korrekt | 2 | PASS | Body beginnt mit "Heute", enthält "Jetzt lernen"; Titel ist "IHK AP1 Prep" |
| T8 | Kalenderansicht Farbkodierung | 3 | PASS | 1–5 Karten = grün (#81C784); 6–15 = orange (#E8813A); 16+ = rot (#E57373) |
| T9 | CardModel Firestore Round-Trip | 1 | PASS | Alle 11 Felder identisch nach toFirestore → fromFirestore; dueDate-Abweichung < 1s |
| T10 | PWA URL-Schema & Firebase Config | 3 | PASS | firebase.json existiert; pubspec.yaml enthält Projektnamen; web/ Ordner vorhanden |

---

## Zusammenfassung

**Gesamtergebnis:** 10/10 Testfälle bestanden (24 Subtests)
**Laufzeit:** < 1 Sekunde
**Fehlgeschlagen:** 0
**Warnungen:** 0

## Testabdeckung

| Komponente | Getestete Aspekte |
|------------|-------------------|
| `CardModel` | Konstruktor, toFirestore, fromFirestore, copyWith, Round-Trip |
| `FSRSService` | updateCard (alle 4 Ratings), Difficulty-Clamping, Stability-Berechnung |
| `NotificationService` | Notification-Body-Generierung, Text-Format |
| `CalendarScreen` | Farbkodierung (borderColorForCount) |
| Projekt-Config | firebase.json, pubspec.yaml, web/-Plattform |
