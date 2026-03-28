# IHK AP1 Prep

![Flutter](https://img.shields.io/badge/Flutter-3.8-02569B?logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-3.8-0175C2?logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

Progressive Web App zur IHK AP1-Prüfungsvorbereitung mit wissenschaftlich fundiertem Spaced-Repetition-Algorithmus (FSRS 4.5). Entwickelt als IHK-Abschlussprojekt bei BBQ Düsseldorf, 2026.

---

## Screenshots

> *Screenshots werden nach dem finalen UI-Review hier eingefügt.*

| Frage-Screen | Antwort-Screen | Kalender |
|:---:|:---:|:---:|
| *Platzhalter* | *Platzhalter* | *Platzhalter* |

---

## Tech-Stack

| Komponente | Technologie | Version |
|------------|-------------|---------|
| Frontend | Flutter (Web/PWA) | 3.8+ |
| Sprache | Dart | 3.8+ |
| Datenbank | Cloud Firestore (NoSQL) | 5.0 |
| Backend | Firebase (Spark-Tarif) | — |
| Algorithmus | FSRS 4.5 | Custom |
| Notifications | flutter_local_notifications | 17.0 |
| Zeitzonen | timezone | 0.9 |
| Hosting | Firebase Hosting | — |

---

## Features

- **FSRS 4.5** — Adaptiver Spaced-Repetition-Algorithmus mit 4 Bewertungsstufen
- **5-Feld-Lernkarten** — Frage, Kurzantwort, Erklärung, Link, Hashtags
- **Kalenderansicht** — Monatskalender mit Farbkodierung (grün/orange/rot)
- **Push-Notifications** — Tägliche Erinnerung mit Anzahl fälliger Karten
- **Firestore-Sync** — Echtzeit-Synchronisation, geräteübergreifend
- **PWA** — Installierbar auf Desktop und Mobilgeräten

---

## Projektstruktur

```
lib/
├── main.dart                          # App-Einstiegspunkt + Navigation
├── firebase_options.dart              # Firebase-Konfiguration (generiert)
├── models/
│   └── card_model.dart                # 5-Feld-Kartenmodell + FSRS-Felder
├── services/
│   ├── firestore_service.dart         # Firestore CRUD + Queries
│   ├── fsrs_service.dart              # FSRS 4.5 Algorithmus
│   └── notification_service.dart      # Push-Notification Scheduling
└── screens/
    ├── flashcard_question_screen.dart  # Frage-Ansicht
    ├── flashcard_answer_screen.dart    # Antwort + 4 Bewertungsbuttons
    ├── calendar_screen.dart           # Monatskalender + Stats
    └── splash_screen.dart             # Ladebildschirm

test/
└── app_validation_test.dart           # 10 Validierungstests (T1–T10)

docs/
├── projektbericht.md                  # IHK-Projektbericht (Phase 5)
└── testprotokoll_phase4.md            # Testprotokoll (Phase 4)
```

---

## Setup

### Voraussetzungen

- [Flutter SDK](https://flutter.dev/docs/get-started/install) >= 3.8.0
- [Git](https://git-scm.com/)
- Firebase-Projekt (Spark-Tarif, kostenlos)

### Installation

```bash
# Repository klonen
git clone https://github.com/anki-project-team/anki-system.git
cd anki-system

# Dependencies installieren
flutter pub get

# Firebase konfigurieren (optional, für eigenes Projekt)
flutterfire configure

# Im Browser starten
flutter run -d chrome
```

### Tests ausführen

```bash
flutter test test/app_validation_test.dart --reporter expanded
```

---

## Firestore-Datenmodell

```
users/{userId}/decks/{deckId}/cards/{cardId}
  ├── question      (String)     // Frage
  ├── shortAnswer   (String)     // Kurzantwort
  ├── longAnswer    (String)     // Ausführliche Erklärung
  ├── url           (String)     // Weiterführender Link
  ├── hashtags      (Array)      // Hashtags zur Filterung
  ├── difficulty    (Double)     // FSRS: 1.0–10.0
  ├── stability     (Double)     // FSRS: Stabilität in Tagen
  ├── dueDate       (Timestamp)  // Nächste Wiederholung
  ├── reviewCount   (Integer)    // Anzahl Reviews
  └── state         (String)     // new|learning|review|relearning
```

---

## IHK-Projekt

Entstanden als IHK-Abschlussprojekt (AP1), Fachinformatiker Anwendungsentwicklung, BBQ Düsseldorf 2026.

| Phase | Stunden | Status |
|-------|---------|--------|
| Phase 1 — Analyse | 10h | Abgeschlossen |
| Phase 2 — Konzeption | 15h | Abgeschlossen |
| Phase 3 — Realisierung | 35h | Abgeschlossen |
| Phase 4 — Validierung | 10h | Abgeschlossen |
| Phase 5 — Dokumentation | 10h | Abgeschlossen |
| **Gesamt** | **80h** | |

---

## Lizenz

[MIT](LICENSE)
