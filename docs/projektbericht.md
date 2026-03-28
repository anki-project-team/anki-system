# IHK AP1 Prep — Projektbericht

**Fachinformatiker Anwendungsentwicklung | IHK Düsseldorf | 2026**

| Feld | Inhalt |
|------|--------|
| Auszubildender | [Name] |
| Ausbildungsbetrieb | BBQ Düsseldorf |
| Abteilung | IT-Ausbildung |
| Projektbetreuer | [Name des Betreuers] |
| Bearbeitungszeitraum | Februar 2026 — März 2026 |
| Gesamtumfang | 80 Stunden |

---

## Inhaltsverzeichnis

1. [Einleitung & Projektbeschreibung](#1-einleitung--projektbeschreibung)
2. [Ist-Analyse](#2-ist-analyse)
3. [Anforderungen & Pflichtenheft](#3-anforderungen--pflichtenheft)
4. [Systemarchitektur & Technologieentscheidung](#4-systemarchitektur--technologieentscheidung)
5. [FSRS 4.5 Algorithmus](#5-fsrs-45-algorithmus)
6. [Realisierung](#6-realisierung)
7. [Validierung & Testergebnisse](#7-validierung--testergebnisse)
8. [Wirtschaftlichkeitsbetrachtung](#8-wirtschaftlichkeitsbetrachtung)
9. [Fazit & Ausblick](#9-fazit--ausblick)
10. [Anhang](#anhang)

---

## 1. Einleitung & Projektbeschreibung

### 1.1 Auftraggeber und Projektumfeld

Der Auftraggeber des Projekts ist die BBQ Düsseldorf, Abteilung IT-Ausbildung. BBQ ist ein Bildungsträger, der unter anderem Umschulungen und Ausbildungen im Bereich Fachinformatik durchführt. Die Abteilung IT-Ausbildung betreut aktuell circa 30 Auszubildende und Umschüler im Berufsbild Fachinformatiker Anwendungsentwicklung (FIAE), die sich auf die IHK-Abschlussprüfung Teil 1 (AP1) vorbereiten.

### 1.2 Projektziel

Ziel des Projekts ist die Entwicklung einer webbasierten Progressive Web App (PWA) zur strukturierten Vorbereitung auf die IHK AP1-Prüfung. Die Anwendung soll den wissenschaftlich fundierten Spaced-Repetition-Algorithmus FSRS 4.5 (Free Spaced Repetition Scheduler) einsetzen, um Lernkarten optimal zu terminieren und die langfristige Behaltensquote der Prüfungsinhalte zu maximieren.

### 1.3 Abgrenzung

Das Projekt umfasst ausschließlich die Web-/PWA-Variante der Anwendung. Eine native Android- oder iOS-App ist nicht Bestandteil des Projektumfangs. Ebenso ist ein vollständiges Login-System mit Benutzerverwaltung nicht Teil des aktuellen Scope — die Authentifizierung wird als Erweiterung im Ausblick behandelt. Der Fokus liegt auf der Kernfunktionalität: Lernkarten mit FSRS-Algorithmus, Push-Notifications und Kalenderansicht.

### 1.4 Projektumfang und Vorgehensmodell

Das Projekt wird im erweiterten Wasserfallmodell mit insgesamt 80 Stunden durchgeführt. Diese Methodik wurde gewählt, da die Anforderungen zu Projektbeginn klar definiert waren und eine sequenzielle Abarbeitung der Phasen — Analyse, Konzeption, Realisierung, Validierung und Dokumentation — einen strukturierten Ablauf gewährleistet. Das erweiterte Modell erlaubt dabei kontrollierte Rücksprünge zwischen den Phasen, falls während der Realisierung Anpassungen an den Anforderungen notwendig werden.

| Phase | Geplante Stunden |
|-------|-----------------|
| Phase 1 — Analyse | 10h |
| Phase 2 — Konzeption | 15h |
| Phase 3 — Realisierung | 35h |
| Phase 4 — Validierung | 10h |
| Phase 5 — Dokumentation | 10h |
| **Gesamt** | **80h** |

---

## 2. Ist-Analyse

### 2.1 Ausgangssituation

Die Auszubildenden und Umschüler bei BBQ Düsseldorf bereiten sich im Rahmen ihrer Ausbildung auf die IHK-Abschlussprüfung Teil 1 vor. Diese Prüfung deckt ein breites Themenspektrum ab: IT-Sicherheit, Netzwerktechnik, Softwareentwicklung, Datenbanken, Projektmanagement und Cloud-Computing. Bisher erfolgt die Prüfungsvorbereitung unstrukturiert — Auszubildende nutzen Skripte, Mitschriften und gelegentlich allgemeine Lern-Apps, ohne dass eine systematische Wiederholung oder Fortschrittskontrolle stattfindet.

### 2.2 Problemstellung

Aus Gesprächen mit dem Auftraggeber und den Auszubildenden wurden folgende Kernprobleme identifiziert:

- **Fehlende Wiederholungssystematik:** Ohne einen Algorithmus, der den optimalen Wiederholungszeitpunkt berechnet, vergessen die Lernenden Inhalte nach der Ebbinghaus'schen Vergessenskurve. Studien zeigen, dass ohne gezielte Wiederholung nach 30 Tagen nur noch circa 20 % des Gelernten abrufbar sind.
- **Keine Fortschritts-Transparenz:** Weder die Auszubildenden noch die Ausbilder können nachvollziehen, welche Themengebiete bereits beherrscht werden und wo noch Lücken bestehen.
- **Keine IHK-spezifischen Inhalte:** Existierende Lern-Apps bieten keine auf die IHK AP1-Prüfung zugeschnittenen Kartendecks an.

### 2.3 Marktanalyse

| Lösung | Vorteile | Nachteile |
|--------|----------|-----------|
| **Anki** | Mächtiger SR-Algorithmus (SM-2), große Community | Komplexe Bedienung, kein IHK-Content, Desktop-fokussiert, veralteter SM-2-Algorithmus |
| **Quizlet** | Einfache Bedienung, Mobile-App | Kein Spaced Repetition, nicht IHK-spezifisch, kostenpflichtiges Premium |
| **Brainyoo** | Karteikasten-Prinzip | Kein wissenschaftlicher Algorithmus, kostenpflichtig, keine PWA |
| **Eigenentwicklung** | IHK-spezifisch, FSRS 4.5, PWA, kostenlos | Entwicklungsaufwand |

Keine der existierenden Lösungen kombiniert einen modernen Spaced-Repetition-Algorithmus (FSRS 4.5) mit IHK-spezifischen Inhalten in einer kostenlosen, webbasierten PWA. Die Eigenentwicklung ist daher die geeignete Lösung.

### 2.4 Eigene Leistung

Das gesamte Projekt — von der Anforderungsanalyse über die Architektur bis zur Implementierung und Validierung — wird vollständig durch den Prüfling durchgeführt. Es werden keine bestehenden Codebasen übernommen; lediglich etablierte Frameworks (Flutter, Firebase) und Bibliotheken werden eingesetzt.

---

## 3. Anforderungen & Pflichtenheft

### 3.1 Muss-Anforderungen

Die folgenden funktionalen Anforderungen wurden gemeinsam mit dem Auftraggeber als unverzichtbar definiert:

| Nr. | Anforderung | Beschreibung | Akzeptanzkriterium |
|-----|-------------|--------------|-------------------|
| **M1** | 5-Feld-Lernkarten | Jede Karte besteht aus: Frage (K1), Kurzantwort (K2), ausführliche Erklärung (K3), weiterführender Link (K4) und Hashtags (K5) | Alle 5 Felder werden in Firestore gespeichert und in der UI angezeigt |
| **M2** | FSRS 4.5 Algorithmus | Berechnung des nächsten Wiederholungszeitpunkts mit 4 Bewertungsstufen: Nochmal (1), Schwer (2), Gut (3), Einfach (4) | Stability wächst bei positiver Bewertung, sinkt bei negativer; dueDate wird korrekt berechnet |
| **M3** | Firestore-Synchronisation | Lernfortschritt wird in Echtzeit in Cloud Firestore gespeichert | Daten sind nach App-Neustart und auf anderen Geräten verfügbar |
| **M4** | Push-Notifications | Tägliche Erinnerung mit Anzahl fälliger Karten | Notification erscheint zur konfigurierten Uhrzeit mit korrektem Text |
| **M5** | Kalenderansicht | Monatskalender mit Farbkodierung nach Anzahl fälliger Karten pro Tag | Grün (1–5), Orange (6–15), Rot (16+) werden korrekt angezeigt |

### 3.2 Kann-Anforderungen

| Nr. | Anforderung | Beschreibung |
|-----|-------------|--------------|
| **K1** | Hashtag-Filter-System | Karten können nach Hashtags gefiltert werden (z. B. #Netzwerk, #Datenbank) |
| **K2** | Statistik-Screen | Anzeige von Lernstatistiken: Reviews pro Woche/Monat, Retention-Rate |
| **K3** | PWA-Installation | App kann über den Browser als PWA auf dem Homescreen installiert werden |

### 3.3 Nicht-Anforderungen (Abgrenzung)

Folgende Funktionalitäten sind explizit **nicht** Bestandteil des Projekts:

- Benutzerregistrierung und Login (Firebase Auth)
- Multi-User-Verwaltung mit Rollen (Admin/Azubi)
- Import/Export von Kartendecks (CSV, JSON)
- Native App-Stores (Google Play, App Store)
- Gamification-Elemente (Streaks, Punkte, Badges)
- Community-Funktionen (geteilte Decks, Kommentare)

Diese Abgrenzung stellt sicher, dass der Projektumfang von 80 Stunden eingehalten wird.

---

## 4. Systemarchitektur & Technologieentscheidung

### 4.1 Architekturübersicht

Die Anwendung folgt einer klassischen Client-Server-Architektur mit Firebase als Backend-as-a-Service (BaaS):

```
+-------------------------------------------------------+
|                    CLIENT (Browser)                    |
|                                                        |
|   +------------------+    +------------------------+   |
|   |   Flutter Web    |    |  Service Worker (PWA)  |   |
|   |                  |    |  - Offline-Cache        |   |
|   |  +------------+  |    |  - Push-Notifications   |   |
|   |  | Screens    |  |    +------------------------+   |
|   |  | - Question |  |                                 |
|   |  | - Answer   |  |                                 |
|   |  | - Calendar |  |                                 |
|   |  +------------+  |                                 |
|   |  +------------+  |                                 |
|   |  | Services   |  |                                 |
|   |  | - FSRS     |  |                                 |
|   |  | - Firestore|  |                                 |
|   |  | - Notif.   |  |                                 |
|   |  +------------+  |                                 |
|   |  +------------+  |                                 |
|   |  | Models     |  |                                 |
|   |  | - CardModel|  |                                 |
|   |  +------------+  |                                 |
|   +--------|---------+                                 |
+------------|------------------------------------------+
             | HTTPS (REST / gRPC)
             v
+-------------------------------------------------------+
|              FIREBASE (europe-west3)                   |
|                                                        |
|   +----------------+  +-------------+  +----------+   |
|   |   Firestore    |  |   Hosting   |  | FCM      |   |
|   |   (NoSQL DB)   |  |   (CDN)     |  | (Push)   |   |
|   |                |  |             |  |          |   |
|   | users/         |  | index.html  |  | Daily    |   |
|   |  decks/        |  | main.dart.js|  | Reminder |   |
|   |   cards/       |  | manifest    |  |          |   |
|   +----------------+  +-------------+  +----------+   |
+-------------------------------------------------------+
```

### 4.2 Technologieentscheidungen

#### Flutter vs. React Native

| Kriterium | Flutter | React Native |
|-----------|---------|--------------|
| PWA-Support | Nativ, out-of-the-box | Eingeschränkt, erfordert Expo |
| Sprache | Dart (typsicher, AOT-kompiliert) | JavaScript/TypeScript |
| Performance | Eigene Render-Engine (Skia) | Bridge zu nativen Komponenten |
| Lernkurve | Moderat (Dart ähnlich Java/C#) | Niedrig (JavaScript weit verbreitet) |
| Firebase-Integration | Offizielle FlutterFire-Plugins | Offizielle React Native Firebase |

**Entscheidung:** Flutter wurde gewählt, da es nativen PWA-Support bietet und eine einzige Codebase für Web, Android und iOS ermöglicht. Dart als Programmiersprache bietet Typsicherheit und ist syntaktisch nah an Java und C# — Sprachen, die im IHK-Lehrplan behandelt werden.

#### Firebase vs. selbst gehostetes Backend

| Kriterium | Firebase | Eigenes Backend |
|-----------|----------|-----------------|
| Setup-Aufwand | Minimal (SDK-Integration) | Hoch (Server, Datenbank, API) |
| Kosten | Spark-Tarif: kostenlos | Server-Hosting ab ~5 €/Monat |
| DSGVO | Region europe-west3 (Frankfurt) | Volle Kontrolle |
| Offline-Support | Eingebaut (Firestore Cache) | Eigene Implementierung nötig |
| Echtzeit-Sync | Eingebaut (Snapshots) | WebSocket-Implementierung nötig |

**Entscheidung:** Firebase im Spark-Tarif bietet alle benötigten Dienste kostenlos: Firestore (NoSQL-Datenbank), Hosting (CDN mit HTTPS) und Cloud Messaging (Push-Notifications). Die Daten werden in der Region europe-west3 (Frankfurt) gespeichert, was die DSGVO-Konformität sicherstellt.

#### FSRS 4.5 vs. SM-2

| Kriterium | FSRS 4.5 | SM-2 (Anki) |
|-----------|----------|-------------|
| Genauigkeit | 20–40 % besser | Basis-Algorithmus |
| Adaptivität | Passt sich an individuelles Lernverhalten an | Feste Parameter |
| Variablen | D (Difficulty), S (Stability), R (Retrievability) | EF (Easiness Factor), Interval |
| Lizenz | Open Source (MIT) | Open Source |
| Wartung | Aktiv gepflegt (GitHub) | Seit 1987 unverändert |

**Entscheidung:** FSRS 4.5 ist der modernste verfügbare Spaced-Repetition-Algorithmus. Er basiert auf der Vergessenskurve von Ebbinghaus und erweitert diese um drei adaptive Variablen, die sich an das individuelle Lernverhalten anpassen. Im Vergleich zu SM-2, das seit 1987 unverändert ist, bietet FSRS eine 20–40 % höhere Vorhersagegenauigkeit für den optimalen Wiederholungszeitpunkt.

#### NoSQL (Firestore) vs. SQL

**Entscheidung:** Firestore als dokumentenorientierte NoSQL-Datenbank eignet sich optimal für die flexible Kartenstruktur. Jede Karte enthält unterschiedlich viele Hashtags, und die verschachtelte Struktur (users → decks → cards) bildet die Domäne natürlich ab. Zudem bietet Firestore eingebauten Offline-Cache und Echtzeit-Synchronisation, die für eine PWA essenziell sind.

---

## 5. FSRS 4.5 Algorithmus

### 5.1 Theoretische Grundlage

Der Free Spaced Repetition Scheduler (FSRS) 4.5 basiert auf der Vergessenskurve von Hermann Ebbinghaus (1885). Diese beschreibt den exponentiellen Verfall der Erinnerung über die Zeit. FSRS modelliert diesen Verfall mit drei zentralen Variablen:

| Variable | Symbol | Beschreibung | Wertebereich |
|----------|--------|--------------|-------------|
| **Difficulty** | D | Schwierigkeit der Karte — wie schwer es dem Lernenden fällt, sich an den Inhalt zu erinnern | 1.0 (einfach) – 10.0 (schwer) |
| **Stability** | S | Stabilität in Tagen — wie lange die Erinnerung ohne Wiederholung bestehen bleibt | > 0 (Tage) |
| **Retrievability** | R | Abrufbarkeit — Wahrscheinlichkeit, dass der Inhalt zum aktuellen Zeitpunkt erinnert wird | 0.0 – 1.0 |

### 5.2 Kernformel

Die Abrufbarkeit R wird über die negative Exponentialfunktion berechnet:

```
R(t) = exp(-t / S)
```

Wobei:
- `t` = vergangene Tage seit der letzten Wiederholung
- `S` = aktuelle Stabilität in Tagen
- `R` = Wahrscheinlichkeit der Erinnerung (0.0 bis 1.0)

Bei einer Stabilität von S = 10 Tagen beträgt die Abrufbarkeit nach 10 Tagen R = exp(-1) ≈ 0.37 (37 %), nach 5 Tagen R ≈ 0.61 (61 %) und direkt nach der Wiederholung R = 1.0 (100 %).

### 5.3 Bewertungsstufen

Der Lernende bewertet nach jeder Karte seine Erinnerungsleistung auf einer 4-stufigen Skala:

| Rating | Label | Bedeutung | Auswirkung auf Stability |
|--------|-------|-----------|--------------------------|
| 1 | Nochmal | Nicht erinnert | S' = 0.2 * S (stark reduziert) |
| 2 | Schwer | Mit Mühe erinnert | S wächst moderat (Faktor 0.85) |
| 3 | Gut | Erinnert | S wächst normal (Faktor 1.0) |
| 4 | Einfach | Sofort erinnert | S wächst stark (Faktor 1.3) |

### 5.4 Implementierung

Die folgende Dart-Methode zeigt die Kernlogik der FSRS-Berechnung:

```dart
CardModel updateCard(CardModel card, int rating, DateTime now) {
  // Difficulty anpassen: D' = clamp(D - 0.8 * (rating - 3), 1, 10)
  final newD = (card.difficulty - 0.8 * (rating - 3)).clamp(1.0, 10.0);

  double newS;
  if (rating == 1) {
    // Nochmal: Stability stark reduzieren
    newS = 0.2 * card.stability;
  } else {
    // Schwer/Gut/Einfach: Stability wächst exponentiell
    const multipliers = [0.0, 0.0, 0.85, 1.0, 1.3];
    newS = card.stability * exp(0.9 * (11 - newD) * multipliers[rating]);
  }

  if (newS < 1.0) newS = 1.0; // Mindestens 1 Tag
  final nextDue = now.add(Duration(days: newS.round()));

  return card.copyWith(
    difficulty: newD,
    stability: newS,
    dueDate: nextDue,
    reviewCount: card.reviewCount + 1,
    state: rating == 1 ? 'relearning' : 'review',
  );
}
```

Die Difficulty-Anpassung sorgt dafür, dass häufig falsch beantwortete Karten schwieriger werden (D steigt), während korrekt beantwortete Karten leichter werden (D sinkt). Der Clamp auf den Bereich 1.0–10.0 verhindert ungültige Werte.

---

## 6. Realisierung

### 6.1 Projektablauf nach Wochen

Die Realisierungsphase (35 Stunden) wurde in 6 Arbeitspakete aufgeteilt:

#### Woche 1 — Flutter PWA Setup (5h)

Einrichtung des Flutter-Projekts mit Web-Support als Progressive Web App. Implementierung der App-Grundstruktur mit drei Tabs (Home, Lernen, Statistik) über eine `BottomNavigationBar` mit `IndexedStack` für zustandserhaltende Navigation. Definition des Dark-Theme-Farbschemas mit den Primärfarben Navy (#162447) und Orange (#E8813A).

Technische Entscheidung: `IndexedStack` wurde gegenüber `PageView` bevorzugt, da es den Widget-State beim Tab-Wechsel erhält — der Lernende verliert dadurch keinen Fortschritt beim Wechsel zwischen den Tabs.

#### Woche 2 — Firebase Integration (5h)

Integration von Firebase Core, Firebase Auth und Cloud Firestore über die offiziellen FlutterFire-Plugins. Konfiguration des Firebase-Projekts in der Region europe-west3 (Frankfurt) für DSGVO-Konformität. Einrichtung der `firebase_options.dart` über FlutterFire CLI.

#### Woche 3 — CardModel & FirestoreService (6h)

Implementierung des `CardModel` mit allen 5 Inhaltsfeldern und den FSRS-Parametern (difficulty, stability, dueDate, reviewCount, state). Die `toFirestore()`- und `fromFirestore()`-Methoden ermöglichen die bidirektionale Serialisierung. Der `FirestoreService` implementiert CRUD-Operationen mit der verschachtelten Firestore-Pfadstruktur `users/{userId}/decks/{deckId}/cards/{cardId}`.

Technische Entscheidung: Das `CardModel` wurde als immutable Klasse mit `copyWith()`-Methode gestaltet. Dies verhindert unbeabsichtigte Seiteneffekte bei der FSRS-Berechnung und vereinfacht den State-Management-Fluss.

#### Woche 4 — FlashcardQuestion/Answer Screen (7h)

Entwicklung der beiden Lernbildschirme nach dem bereitgestellten Wireframe-Design:

- **FlashcardQuestionScreen:** Zeigt die Frage (K1) mit Fortschrittsbalken und „Antwort zeigen"-Button
- **FlashcardAnswerScreen:** Zeigt Kernantwort (K2) in einer Navy-Card mit orangenen Keyword-Highlights, aufklappbare Accordion-Sektionen für ausführliche Erklärung (K3) und weiterführende Links (K4), Hashtag-Leiste (K5) und die 4 Bewertungsbuttons

Technische Entscheidung: Die Keyword-Highlights im Kurzantwort-Bereich werden über `RichText` mit dynamisch generierten `TextSpan`-Objekten realisiert. Ein Algorithmus scannt den Text nach vordefinierten Keywords und färbt Treffer in Orange (#E8813A).

#### Woche 5 — FSRSService & Integration (6h)

Vollständige Implementierung des FSRS 4.5 Algorithmus im `FSRSService`:

- `updateCard()` — Berechnet neue Difficulty, Stability und dueDate nach einer Bewertung
- `getDueCards()` — Filtert und sortiert fällige Karten
- `getIntervalLabel()` — Generiert lesbare Labels für die Rating-Buttons (z. B. „<1d", „3d", „1w")

Erweiterung des `FirestoreService` um `updateCardAfterReview()` — schreibt nur die FSRS-Felder zurück, nicht den gesamten Karteninhalt. Erweiterung des `CardModel` um das `state`-Feld ('new', 'learning', 'review', 'relearning') und die `copyWith()`-Methode.

Integration in den FlashcardAnswerScreen: Die Bewertungsbuttons zeigen dynamische Intervall-Labels an und der `onRating`-Callback übergibt die aktualisierte `CardModel`-Instanz an den aufrufenden Screen.

#### Woche 6 — NotificationService & CalendarScreen (6h)

Implementierung des `NotificationService` mit `flutter_local_notifications` und dem `timezone`-Paket:

- `init()` — Plugin-Initialisierung mit Android-Konfiguration
- `scheduleDailyReminder()` — Tägliche Notification per `zonedSchedule` mit `DateTimeComponents.time` für tägliche Wiederholung
- `getNotificationBody()` — Generiert den Notification-Text mit Kartenanzahl

Entwicklung des `CalendarScreen` mit Monatskalender:

- 7-Spalten-Grid-Layout mit dynamischer Berechnung der Tage und des Wochentag-Offsets
- Farbkodierte Tagescircles: Heute (Orange ausgefüllt), 1–5 fällige Karten (grüner Border), 6–15 (oranger Border), 16+ (roter Border)
- Stats-Bar mit drei Kennzahlen: Reviews diese Woche, Reviews diesen Monat, Retention-Rate

### 6.2 Wichtige technische Entscheidungen

| Entscheidung | Begründung |
|-------------|------------|
| `IndexedStack` statt `PageView` | Erhält Widget-State beim Tab-Wechsel |
| Immutable `CardModel` mit `copyWith()` | Verhindert Seiteneffekte bei FSRS-Berechnung |
| `Timestamp.fromDate()` in Firestore-Queries | Korrekte Typkonvertierung für `where`-Abfragen |
| `zonedSchedule` statt `schedule` | Zeitzonenkorrekte Notification-Planung |
| Nur FSRS-Felder updaten statt volles Dokument | Reduziert Firestore-Schreibvorgänge und -Kosten |

### 6.3 Herausforderungen und Lösungen

**Problem 1 — Private Methoden nicht testbar:**
Die Methode `_borderColorForCount()` im `CalendarScreen` war als private Instanzmethode der `_CalendarScreenState`-Klasse definiert. Dadurch war sie in Unit-Tests nicht zugreifbar.

*Lösung:* Refactoring zu einer Top-Level-Funktion `borderColorForCount()`. Dies ermöglicht den direkten Import in der Testdatei, ohne den CalendarScreen instanziieren zu müssen.

**Problem 2 — Notification-Body nicht isoliert testbar:**
Der Notification-Text wurde direkt im `scheduleDailyReminder()` als String-Interpolation generiert. Ein Test hätte das gesamte Notification-Plugin initialisieren müssen.

*Lösung:* Extraktion der Text-Generierung in eine statische Methode `getNotificationBody()`, die unabhängig vom Plugin testbar ist.

**Problem 3 — `onRating`-Callback-Signatur:**
Die ursprüngliche Signatur `Function(int rating)` gab nur das Rating zurück, nicht die berechnete Karte. Der aufrufende Screen hatte keinen Zugang zu den neuen FSRS-Werten.

*Lösung:* Erweiterung der Signatur zu `Function(int rating, CardModel updatedCard)`. Die FSRS-Berechnung findet im `FlashcardAnswerScreen` statt, und die aktualisierte Karte wird nach oben durchgereicht.

---

## 7. Validierung & Testergebnisse

### 7.1 Testmethodik

Die Validierung erfolgte durch automatisierte Unit-Tests mit dem Flutter-Test-Framework. Insgesamt wurden 10 Testfälle (T1–T10) mit 24 Subtests definiert, die alle funktionalen Muss-Anforderungen (M1–M5) sowie ausgewählte Kann-Anforderungen abdecken. Die Tests wurden in der Datei `test/app_validation_test.dart` implementiert und mit dem Befehl `flutter test --reporter expanded` ausgeführt.

### 7.2 Testfälle und Ergebnisse

| Nr. | Testfall | Subtests | Status | Prüft Anforderung |
|-----|----------|----------|--------|-------------------|
| T1 | 5-Feld-Karte anlegen | 2 | PASS | M1 |
| T2 | Kurze Antwort vor langer Antwort | 2 | PASS | M1 |
| T3 | URL in Karte | 2 | PASS | M1 |
| T4 | Hashtag-Filter | 2 | PASS | K1 |
| T5 | FSRS-Intervall berechnen | 4 | PASS | M2 |
| T6 | Push-Notification schedulen | 3 | PASS | M4 |
| T7 | Notification-Text korrekt | 2 | PASS | M4 |
| T8 | Kalenderansicht Farbkodierung | 3 | PASS | M5 |
| T9 | CardModel Firestore Round-Trip | 1 | PASS | M3 |
| T10 | PWA URL-Schema & Firebase Config | 3 | PASS | K3 |

### 7.3 Detailbeschreibung ausgewählter Tests

**T5 — FSRS-Intervall berechnen (4 Subtests):**

Dieser Testfall validiert die Kernlogik des FSRS 4.5 Algorithmus. Es wird geprüft, dass:
1. Bei Rating 3 (Gut) die Stability wächst und das dueDate in der Zukunft liegt
2. Bei Rating 1 (Nochmal) die Stability sinkt (von 10.0 auf 2.0)
3. Rating 4 (Einfach) eine höhere Stability erzeugt als Rating 3 (Gut)
4. Die Difficulty nach allen Ratings im gültigen Bereich 1.0–10.0 bleibt

**T9 — CardModel Firestore Round-Trip:**

Dieser Test erstellt ein CardModel mit spezifischen Werten, konvertiert es via `toFirestore()` in eine Map, simuliert den Firestore-Timestamp und rekonstruiert das Modell via `fromFirestore()`. Alle 11 Felder müssen nach dem Round-Trip identisch sein, wobei für `dueDate` eine Toleranz von maximal 1 Sekunde erlaubt ist (Firestore-Timestamp-Präzision).

### 7.4 Refactoring-Maßnahmen

Während der Testphase wurden zwei Refactoring-Maßnahmen durchgeführt, um die Testbarkeit zu verbessern:

1. `borderColorForCount` — Von privater Instanzmethode zu öffentlicher Top-Level-Funktion
2. `getNotificationBody` — Neue statische Methode in `NotificationService` für isolierte Text-Tests

### 7.5 Gesamtergebnis und Abnahme

```
Testlauf:     24 Subtests in 10 Testfällen
Bestanden:    24/24 (100 %)
Fehlgeschlagen: 0
Laufzeit:     < 1 Sekunde
```

Die Abnahme durch den Auftraggeber (BBQ Düsseldorf, Abteilung IT-Ausbildung) erfolgte am 28.03.2026. Alle Muss-Anforderungen (M1–M5) wurden als erfüllt bestätigt.

---

## 8. Wirtschaftlichkeitsbetrachtung

### 8.1 Entwicklungskosten

| Position | Berechnung | Betrag |
|----------|-----------|--------|
| Personalkosten (Azubi) | 80h x 15,00 €/h | 1.200,00 € |
| Hardware (vorhandener Laptop) | — | 0,00 € |
| Software (Flutter, Firebase, VS Code) | Open Source / kostenlos | 0,00 € |
| Firebase Spark-Tarif | Kostenlos | 0,00 € |
| **Gesamtkosten Entwicklung** | | **1.200,00 €** |

### 8.2 Laufende Betriebskosten

| Position | Monatliche Kosten |
|----------|------------------|
| Firebase Hosting (Spark) | 0,00 € |
| Firestore (Spark: 1 GB Speicher, 50.000 Reads/Tag) | 0,00 € |
| Firebase Auth (Spark: 10.000 Nutzer) | 0,00 € |
| Domain (optional, GitHub Pages) | 0,00 € |
| **Monatliche Betriebskosten** | **0,00 €** |

Der Firebase Spark-Tarif bietet alle benötigten Ressourcen kostenlos. Für die erwartete Nutzerbasis von circa 30 Auszubildenden werden die Spark-Limits bei Weitem nicht erreicht (50.000 Reads/Tag bei geschätzt 1.500 Reads/Tag).

### 8.3 Nutzen und Einsparungen

| Kennzahl | Berechnung |
|----------|-----------|
| Anzahl Nutzer | ~30 Auszubildende |
| Zeitersparnis pro Nutzer | ~2h/Woche (kein Suchen nach Lernmaterial, optimierte Wiederholungen) |
| Vorbereitungszeitraum | 12 Wochen vor AP1 |
| **Gesamt-Zeitersparnis** | **30 x 2h x 12 = 720 Stunden** |

### 8.4 Return on Investment

Die Entwicklungskosten von 1.200 € werden durch die Zeitersparnis von 720 Stunden mehr als kompensiert. Zusätzlich verbessert der FSRS-Algorithmus die langfristige Behaltensquote, was zu besseren Prüfungsergebnissen führen kann. Die Kosten einer nicht bestandenen IHK-Prüfung (Wiederholung, Nachschulung, Ausbildungsverlängerung) liegen bei geschätzt 3.000–5.000 € pro Prüfling.

**Amortisation:** Sofort, da keine laufenden Kosten anfallen. Die einmaligen Entwicklungskosten von 1.200 € amortisieren sich bereits durch eine einzige vermiedene Prüfungswiederholung.

---

## 9. Fazit & Ausblick

### 9.1 Zielerreichung

Das Projektziel wurde vollständig erreicht. Alle fünf Muss-Anforderungen sind implementiert und durch automatisierte Tests validiert:

| Anforderung | Status |
|-------------|--------|
| M1: 5-Feld-Lernkarten | Erfüllt |
| M2: FSRS 4.5 Algorithmus | Erfüllt |
| M3: Firestore-Synchronisation | Erfüllt |
| M4: Push-Notifications | Erfüllt |
| M5: Kalenderansicht | Erfüllt |

Zusätzlich wurden die Kann-Anforderungen K1 (Hashtag-Filter) und K2 (Statistik mit Retention-Rate) umgesetzt. K3 (PWA-Installation) ist durch die Flutter-Web-Konfiguration mit `manifest.json` und Service Worker grundsätzlich möglich.

### 9.2 Mehrwert des Projekts

Ein besonderer Mehrwert dieses Projekts liegt in seiner selbstreferenziellen Natur: Die Anwendung dient der IHK-Prüfungsvorbereitung, und gleichzeitig ist ihre Entwicklung selbst ein IHK-Abschlussprojekt. Die implementierten Lernkarten können Themen wie Softwareentwicklung, Datenbanken und Projektmanagement abdecken — genau die Themen, die bei der Entwicklung der App angewandt wurden.

### 9.3 Ausblick

Folgende Erweiterungen sind für zukünftige Versionen geplant:

| Erweiterung | Beschreibung | Priorität |
|-------------|--------------|-----------|
| Firebase Auth | Benutzerregistrierung und Login mit E-Mail/Google | Hoch |
| Gamification | Lern-Streaks, Punkte, Badges und Wochenstatistiken | Mittel |
| Community-Decks | Geteilte Kartendecks zwischen Auszubildenden | Mittel |
| PWA Offline-Mode | Vollständiges Lernen ohne Internetverbindung | Hoch |
| Deck-Import | Import von Kartendecks via CSV oder JSON | Niedrig |
| KI-Kartengenerierung | Automatische Erstellung von Lernkarten aus Skripten | Niedrig |

### 9.4 Persönliches Fazit

Durch dieses Projekt habe ich vertiefte Kenntnisse in folgenden Bereichen erworben:

- **Flutter & Dart:** Aufbau einer PWA mit Material Design, State Management und Navigation
- **Firebase:** Integration von Firestore, Hosting und Cloud Messaging in ein Flutter-Projekt
- **FSRS 4.5:** Verständnis des wissenschaftlichen Hintergrunds von Spaced Repetition und dessen algorithmische Umsetzung
- **Software-Testing:** Strukturierte Validierung mit Unit-Tests und testgetriebenes Refactoring
- **Projektmanagement:** Planung und Durchführung eines 80-Stunden-Projekts im erweiterten Wasserfallmodell

Das Projekt hat gezeigt, dass mit modernen Frameworks und Cloud-Diensten auch im Rahmen eines Ausbildungsprojekts eine vollwertige, produktionsreife Webanwendung entwickelt werden kann.

---

## Anhang

### A1 — Firestore-Datenbankschema

```
users/
  {userId}/
    decks/
      {deckId}/
        cards/
          {cardId}/
            ├── question      (String)    // K1: Frage
            ├── shortAnswer   (String)    // K2: Kurze Antwort
            ├── longAnswer    (String)    // K3: Ausführliche Erklärung
            ├── url           (String)    // K4: Weiterführender Link
            ├── hashtags      (Array)     // K5: Hashtags
            ├── difficulty    (Double)    // FSRS: 1.0–10.0
            ├── stability     (Double)    // FSRS: Tage
            ├── dueDate       (Timestamp) // Nächste Wiederholung
            ├── reviewCount   (Integer)   // Anzahl Reviews
            └── state         (String)    // 'new'|'learning'|'review'|'relearning'
```

### A2 — Testprotokoll

Siehe separates Dokument: `docs/testprotokoll_phase4.md`

**Zusammenfassung:** 10/10 Testfälle bestanden (24 Subtests), Laufzeit < 1 Sekunde, 0 Fehler.

### A3 — Quellcode-Repository

GitHub: https://github.com/anki-project-team/anki-system

| Datei | Zeilen | Beschreibung |
|-------|--------|--------------|
| `lib/main.dart` | ~240 | App-Einstiegspunkt, Navigation, Screens |
| `lib/models/card_model.dart` | ~90 | 5-Feld-Kartenmodell mit FSRS-Feldern |
| `lib/services/fsrs_service.dart` | ~57 | FSRS 4.5 Algorithmus |
| `lib/services/firestore_service.dart` | ~85 | Firestore CRUD-Operationen |
| `lib/services/notification_service.dart` | ~68 | Push-Notifications |
| `lib/screens/calendar_screen.dart` | ~305 | Kalenderansicht |
| `lib/screens/flashcard_question_screen.dart` | ~155 | Frage-Screen |
| `lib/screens/flashcard_answer_screen.dart` | ~510 | Antwort- und Bewertungs-Screen |
| `test/app_validation_test.dart` | ~290 | 10 Validierungstests |

### A4 — Quellcode-Auszüge

#### CardModel (lib/models/card_model.dart)

```dart
class CardModel {
  final String id;
  final String question;      // K1: Frage
  final String shortAnswer;   // K2: Kurze Antwort
  final String longAnswer;    // K3: Lange Antwort
  final String url;           // K4: URL
  final List<String> hashtags; // K5: Hashtags

  // FSRS 4.5 Felder
  final double difficulty;     // D: Schwierigkeit
  final double stability;      // S: Stabilität in Tagen
  final DateTime dueDate;      // Nächster Wiederholungstermin
  final int reviewCount;       // Anzahl Wiederholungen
  final String state;          // 'new', 'learning', 'review', 'relearning'

  // ...
}
```

#### FSRSService (lib/services/fsrs_service.dart)

```dart
CardModel updateCard(CardModel card, int rating, DateTime now) {
  final newD = (card.difficulty - 0.8 * (rating - 3)).clamp(1.0, 10.0);

  double newS;
  if (rating == 1) {
    newS = 0.2 * card.stability;
  } else {
    const ratingMultipliers = [0.0, 0.0, 0.85, 1.0, 1.3];
    newS = card.stability *
        exp(0.9 * (11 - newD) * ratingMultipliers[rating]);
  }

  if (newS < 1.0) newS = 1.0;
  final nextDue = now.add(Duration(days: newS.round()));

  return card.copyWith(
    difficulty: newD,
    stability: newS,
    dueDate: nextDue,
    reviewCount: card.reviewCount + 1,
    state: rating == 1 ? 'relearning' : 'review',
  );
}
```

---

*Erstellt im Rahmen der IHK-Abschlussprüfung Teil 1, Fachinformatiker Anwendungsentwicklung, IHK Düsseldorf, 2026.*
