# 🎓 IHK AP1 Prep — Anki Lernsystem (PWA)

> Webbasierte Lernplattform mit adaptivem Spaced-Repetition-Algorithmus (FSRS 4.5) zur optimalen Vorbereitung auf die IHK AP1-Prüfung.

## 📋 Projektübersicht

| Feld | Inhalt |
|------|--------|
| **Projekttitel** | Entwicklung einer webbasierten Lernplattform mit adaptivem Spaced-Repetition-Algorithmus |
| **Ausbildungsberuf** | Fachinformatiker Anwendungsentwicklung (FIAE) |
| **IHK** | Düsseldorf |
| **Gesamtstunden** | 80h |
| **Vorgehensmodell** | Erweitertes Wasserfallmodell |
| **Lizenz** | MIT |

## 🚀 Tech-Stack

| Komponente | Technologie | Begründung |
|------------|-------------|------------|
| **Frontend** | Flutter (Web/PWA) | Cross-Plattform, eine Codebase für Web, Android, iOS |
| **Backend/DB** | Firebase Firestore | NoSQL, Echtzeit-Sync, Offline-Cache |
| **Auth** | Firebase Auth | Sichere Authentifizierung mit JWT |
| **Hosting** | Firebase Hosting | HTTPS, globales CDN, kostenloser Spark-Tarif |
| **Algorithmus** | FSRS 4.5 | 20–40% genauer als SM-2, adaptiv |
| **Versionsverwaltung** | GitHub | Kanban-Board + Commit-Verlauf |

## 🧠 Kernfeatures

- **FSRS 4.5 Algorithmus** — Wissenschaftlich fundiertes Spaced Repetition mit drei Variablen: Difficulty (D), Stability (S), Retrievability (R)
- **5-Feld-Kartenformat** — Frage (K1), Kurzantwort (K2), Ausführliche Erklärung (K3), Weiterführender Link (K4), Hashtags (K5)
- **Push-Notifications** — Tägliche Erinnerung via Firebase Cloud Messaging
- **DSGVO-konform** — EU-Region (europe-west3, Frankfurt), Cookie-Banner nach TDDDG, Datenschutzerklärung
- **Offline-fähig** — Firestore Offline-Cache für Lernen ohne Internetverbindung

## 📁 Projektstruktur

```
ihk_ap1_prep/
├── lib/
│   ├── main.dart                 # App-Einstiegspunkt + Navigation
│   ├── firebase_options.dart     # Firebase-Konfiguration
│   ├── models/
│   │   └── card_model.dart       # Datenmodell mit FSRS-Feldern
│   └── services/
│       └── firestore_service.dart # CRUD-Operationen für Firestore
├── backend/                      # Backend-Logik
├── database/                     # Datenbankschema & Regeln
├── docs/                         # Dokumentation
│   ├── algorithm.md              # FSRS 4.5 Algorithmus-Dokumentation
│   ├── fsrs.md                   # Spaced Repetition Theorie
│   └── README.md                 # Zusätzliche Docs
├── frontend/                     # Web-Frontend Assets
├── web/                          # Flutter Web Build
├── android/                      # Android-spezifisch
├── ios/                          # iOS-spezifisch
├── pubspec.yaml                  # Flutter Dependencies
└── firebase.json                 # Firebase-Konfiguration
```

## 🗄️ Firestore Datenmodell

```
users/
  {userId}/
    decks/
      {deckId}/
        cards/
          {cardId}/
            question: String       // K1: Frage
            shortAnswer: String    // K2: Kurze Antwort
            longAnswer: String     // K3: Ausführliche Erklärung
            url: String            // K4: Weiterführender Link
            hashtags: Array        // K5: Hashtags zur Filterung
            difficulty: Double     // FSRS: Schwierigkeit (1.0–10.0)
            stability: Double      // FSRS: Stabilität in Tagen
            dueDate: Timestamp     // Nächster Wiederholungstermin
            reviewCount: Int       // Anzahl Wiederholungen
```

## 🏗️ Phasen (Wasserfallmodell)

| Phase | Stunden | Status |
|-------|---------|--------|
| 🔍 Phase 1 — Analyse | 10h | ✅ Abgeschlossen |
| 📐 Phase 2 — Konzeption | 15h | 🟡 In Arbeit |
| 💻 Phase 3 — Realisierung | 35h | 🔴 Offen |
| ✅ Phase 4 — Validierung | 10h | 🔴 Offen |
| 📝 Phase 5 — Dokumentation | 10h | 🔴 Offen |
| **Gesamt** | **80h** | |

## 🛠️ Lokales Setup

```bash
# Repository klonen
git clone https://github.com/anki-project-team/anki-system.git
cd anki-system

# Flutter Web aktivieren
flutter config --enable-web

# Dependencies installieren
flutter pub get

# Im Browser starten
flutter run -d chrome
```

### Voraussetzungen

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (≥ 3.8.0)
- [VS Code](https://code.visualstudio.com/) mit Flutter & Dart Extensions
- [Git](https://git-scm.com/)
- Firebase-Projekt (Spark-Tarif, kostenlos)

## 📊 IHK AP1 Themenabdeckung

| Prüfungsthema | Punkte AP1 | Abdeckung durch Projekt |
|----------------|-----------|------------------------|
| IT-Sicherheit | 15–20 | ✅ HTTPS, Auth, Security Rules, DSGVO |
| KI / Machine Learning | bis 25 | ✅ FSRS-Algorithmus, adaptives Lernen |
| Netzwerktechnik | 8–12 | ✅ HTTP/S, FCM, WebPush |
| Softwareentwicklung (OOP) | 10–15 | ✅ Dart Klassen, Vererbung, Entwurfsmuster |
| Datenbanken (NoSQL) | 8–10 | ✅ Firestore Collections, CRUD |
| Projektmanagement | 5–8 | ✅ Wasserfall, Pflichtenheft |
| Cloud-Computing | 5–8 | ✅ Firebase PaaS, CDN |

## 📄 Lizenz

Dieses Projekt ist unter der [MIT-Lizenz](LICENSE) lizenziert.
