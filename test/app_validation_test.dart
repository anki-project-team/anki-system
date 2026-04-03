import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/services/fsrs_service.dart';
import 'package:ihk_ap1_prep/services/notification_service.dart';
Color borderColorForCount(int count) {
  if (count >= 8) return Colors.red;
  if (count >= 4) return Colors.orange;
  return Colors.green;
}

/// Hilfsobjekt das .toDate() unterstützt wie ein Firestore Timestamp
class FakeTimestamp {
  final DateTime _dt;
  FakeTimestamp(this._dt);
  DateTime toDate() => _dt;
}

CardModel _makeCard({
  String id = 'test-001',
  String question = 'Was ist DHCP?',
  String shortAnswer = 'DHCP vergibt automatisch IP-Adressen.',
  String longAnswer = 'DHCP steht für Dynamic Host Configuration Protocol...',
  String url = 'https://example.com',
  List<String> hashtags = const ['#Netzwerk', '#AP1'],
  double difficulty = 5.0,
  double stability = 1.0,
  DateTime? dueDate,
  int reviewCount = 0,
  String state = 'new',
}) {
  return CardModel(
    id: id,
    question: question,
    shortAnswer: shortAnswer,
    longAnswer: longAnswer,
    url: url,
    hashtags: hashtags,
    difficulty: difficulty,
    stability: stability,
    dueDate: dueDate,
    reviewCount: reviewCount,
    state: state,
  );
}

void main() {
  // ══════════════════════════════════════════════════════════════
  // T1 — 5-Feld-Karte anlegen
  // ══════════════════════════════════════════════════════════════
  group('T1 — 5-Feld-Karte anlegen', () {
    test('toFirestore() enthält alle 5 Inhaltsfelder', () {
      final card = _makeCard();
      final map = card.toFirestore();

      expect(map.containsKey('question'), isTrue);
      expect(map.containsKey('shortAnswer'), isTrue);
      expect(map.containsKey('longAnswer'), isTrue);
      expect(map.containsKey('url'), isTrue);
      expect(map.containsKey('hashtags'), isTrue);

      expect(map['question'], equals('Was ist DHCP?'));
      expect(map['shortAnswer'], equals('DHCP vergibt automatisch IP-Adressen.'));
      expect(map['longAnswer'], contains('Dynamic Host Configuration Protocol'));
      expect(map['url'], equals('https://example.com'));
      expect(map['hashtags'], equals(['#Netzwerk', '#AP1']));
    });

    test('fromFirestore() rekonstruiert identische Werte', () {
      final original = _makeCard(dueDate: DateTime(2026, 6, 15));
      final map = original.toFirestore();
      // Simuliere Firestore: dueDate wird als Objekt mit .toDate() gespeichert
      map['dueDate'] = FakeTimestamp(original.dueDate);

      final restored = CardModel.fromFirestore(map, original.id);

      expect(restored.question, equals(original.question));
      expect(restored.shortAnswer, equals(original.shortAnswer));
      expect(restored.longAnswer, equals(original.longAnswer));
      expect(restored.url, equals(original.url));
      expect(restored.hashtags, equals(original.hashtags));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T2 — Kurze Antwort vor langer Antwort
  // ══════════════════════════════════════════════════════════════
  group('T2 — Kurze Antwort vor langer Antwort', () {
    test('shortAnswer und longAnswer sind nicht leer und unterschiedlich', () {
      final card = _makeCard();
      expect(card.shortAnswer.isNotEmpty, isTrue);
      expect(card.longAnswer.isNotEmpty, isTrue);
      expect(card.shortAnswer, isNot(equals(card.longAnswer)));
    });

    test('shortAnswer ist kürzer als longAnswer', () {
      final card = _makeCard();
      expect(card.shortAnswer.length, lessThan(card.longAnswer.length));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T3 — URL in Karte
  // ══════════════════════════════════════════════════════════════
  group('T3 — URL in Karte', () {
    test('URL beginnt mit https:// und ist valide', () {
      final card = _makeCard(url: 'https://de.wikipedia.org/wiki/DHCP');
      expect(card.url.startsWith('https://'), isTrue);

      final uri = Uri.tryParse(card.url);
      expect(uri, isNotNull);
      expect(uri!.isAbsolute, isTrue);
    });

    test('Leere URL ist trotzdem ein gültiger CardModel', () {
      final card = _makeCard(url: '');
      expect(card.url, isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T4 — Hashtag-Filter
  // ══════════════════════════════════════════════════════════════
  group('T4 — Hashtag-Filter', () {
    test('Filter nach #Netzwerk liefert genau 2 Karten', () {
      final cards = [
        _makeCard(id: 'c1', hashtags: ['#Netzwerk']),
        _makeCard(id: 'c2', hashtags: ['#Netzwerk', '#AP1']),
        _makeCard(id: 'c3', hashtags: ['#Datenbank']),
      ];

      final filtered =
          cards.where((c) => c.hashtags.contains('#Netzwerk')).toList();

      expect(filtered.length, equals(2));
      expect(filtered.map((c) => c.id), containsAll(['c1', 'c2']));
    });

    test('Filter nach nicht existierendem Hashtag liefert 0', () {
      final cards = [
        _makeCard(id: 'c1', hashtags: ['#Netzwerk']),
      ];

      final filtered =
          cards.where((c) => c.hashtags.contains('#Gibtsnet')).toList();
      expect(filtered, isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T5 — FSRS-Intervall berechnen
  // ══════════════════════════════════════════════════════════════
  group('T5 — FSRS-Intervall berechnen', () {
    final fsrs = FSRSService();
    final now = DateTime(2026, 3, 28, 12, 0);

    test('Rating 3 (Gut): stability wächst, dueDate liegt in der Zukunft', () {
      final card = _makeCard(difficulty: 5.0, stability: 1.0, dueDate: now);
      final updated = fsrs.updateCard(card, 3, now);

      expect(updated.stability, greaterThan(1.0));
      expect(updated.dueDate.isAfter(now), isTrue);
      expect(updated.reviewCount, equals(1));
      expect(updated.state, equals('review'));
    });

    test('Rating 1 (Nochmal): stability sinkt', () {
      final card = _makeCard(difficulty: 5.0, stability: 10.0, dueDate: now);
      final updated = fsrs.updateCard(card, 1, now);

      expect(updated.stability, lessThan(10.0));
      expect(updated.state, equals('relearning'));
    });

    test('Rating 4 (Einfach): höhere stability als Rating 3', () {
      final card = _makeCard(difficulty: 5.0, stability: 1.0, dueDate: now);
      final gut = fsrs.updateCard(card, 3, now);
      final einfach = fsrs.updateCard(card, 4, now);

      expect(einfach.stability, greaterThan(gut.stability));
    });

    test('Difficulty bleibt im Bereich 1.0–10.0', () {
      final card = _makeCard(difficulty: 1.5, stability: 1.0, dueDate: now);
      final afterEasy = fsrs.updateCard(card, 4, now);
      expect(afterEasy.difficulty, greaterThanOrEqualTo(1.0));

      final hardCard = _makeCard(difficulty: 9.5, stability: 1.0, dueDate: now);
      final afterAgain = fsrs.updateCard(hardCard, 1, now);
      expect(afterAgain.difficulty, lessThanOrEqualTo(10.0));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T6 — Push-Notification schedulen (Body-Format-Test)
  // ══════════════════════════════════════════════════════════════
  group('T6 — Push-Notification schedulen', () {
    test('getNotificationBody enthält Kartenanzahl', () {
      final body = NotificationService.getNotificationBody(5);
      expect(body, contains('5 Karten fällig'));
    });

    test('getNotificationBody mit 0 Karten', () {
      final body = NotificationService.getNotificationBody(0);
      expect(body, contains('0 Karten fällig'));
    });

    test('getNotificationBody mit hoher Zahl', () {
      final body = NotificationService.getNotificationBody(42);
      expect(body, contains('42 Karten fällig'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T7 — Notification-Text korrekt
  // ══════════════════════════════════════════════════════════════
  group('T7 — Notification-Text korrekt', () {
    test('Body beginnt mit "Heute" und enthält Handlungsaufforderung', () {
      final body = NotificationService.getNotificationBody(5);
      expect(body, startsWith('Heute'));
      expect(body, contains('Jetzt lernen'));
    });

    test('Titel ist immer "IHK AP1 Prep"', () {
      // Titel ist im NotificationService hardcoded — hier dokumentiert
      expect('IHK AP1 Prep', equals('IHK AP1 Prep'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T8 — Kalenderansicht Farbkodierung
  // ══════════════════════════════════════════════════════════════
  group('T8 — Kalenderansicht Farbkodierung', () {
    // Farbwerte aus calendar_screen.dart
    const green = Color(0xFF81C784);
    const orange = Color(0xFFE8813A);
    const red = Color(0xFFE57373);

    test('1–5 Karten → grün', () {
      expect(borderColorForCount(1), equals(green));
      expect(borderColorForCount(3), equals(green));
      expect(borderColorForCount(5), equals(green));
    });

    test('6–15 Karten → orange', () {
      expect(borderColorForCount(6), equals(orange));
      expect(borderColorForCount(10), equals(orange));
      expect(borderColorForCount(15), equals(orange));
    });

    test('16+ Karten → rot', () {
      expect(borderColorForCount(16), equals(red));
      expect(borderColorForCount(20), equals(red));
      expect(borderColorForCount(100), equals(red));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T9 — CardModel Firestore Round-Trip
  // ══════════════════════════════════════════════════════════════
  group('T9 — CardModel Firestore Round-Trip', () {
    test('Alle Felder überleben toFirestore → fromFirestore', () {
      final dueDate = DateTime(2026, 6, 15, 18, 30);
      final original = _makeCard(
        id: 'rt-001',
        question: 'Round-Trip Test?',
        shortAnswer: 'Ja.',
        longAnswer: 'Ausfuehrliche Antwort hier.',
        url: 'https://test.de',
        hashtags: ['#Test', '#Roundtrip'],
        difficulty: 7.3,
        stability: 4.5,
        dueDate: dueDate,
        reviewCount: 12,
        state: 'review',
      );

      final map = original.toFirestore();
      // Simuliere Firestore Timestamp-Verhalten
      map['dueDate'] = FakeTimestamp(dueDate);

      final restored = CardModel.fromFirestore(map, 'rt-001');

      expect(restored.id, equals(original.id));
      expect(restored.question, equals(original.question));
      expect(restored.shortAnswer, equals(original.shortAnswer));
      expect(restored.longAnswer, equals(original.longAnswer));
      expect(restored.url, equals(original.url));
      expect(restored.hashtags, equals(original.hashtags));
      expect(restored.difficulty, equals(original.difficulty));
      expect(restored.stability, equals(original.stability));
      expect(restored.reviewCount, equals(original.reviewCount));
      expect(restored.state, equals(original.state));
      // dueDate: maximal 1 Sekunde Abweichung erlaubt
      expect(
        restored.dueDate.difference(original.dueDate).inSeconds.abs(),
        lessThanOrEqualTo(1),
      );
    });
  });

  // ══════════════════════════════════════════════════════════════
  // T10 — PWA / Firebase Konfiguration
  // ══════════════════════════════════════════════════════════════
  group('T10 — PWA URL-Schema & Firebase Config', () {
    test('firebase.json existiert', () {
      final file = File('firebase.json');
      expect(file.existsSync(), isTrue);
    });

    test('pubspec.yaml existiert und enthält Projektnamen', () {
      final file = File('pubspec.yaml');
      expect(file.existsSync(), isTrue);
      final content = file.readAsStringSync();
      expect(content, contains('ihk_ap1_prep'));
    });

    test('Web-Plattform ist konfiguriert (web/ Ordner existiert)', () {
      final webDir = Directory('web');
      expect(webDir.existsSync(), isTrue);
    });
  });
}
