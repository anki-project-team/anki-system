// lib/services/fsrs_service.dart
// Woche 5 — FSRS 4.5 (Free Spaced Repetition Scheduler)
// Vollständige Implementierung mit CardModel + Firestore-Integration

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';

// ════════════════════════════════════════════════════════
// BEWERTUNGS-ENUM
// Entspricht den 4 Buttons im flashcard_answer_screen.dart
// ════════════════════════════════════════════════════════
enum FSRSRating {
  again(1),   // Nochmal  — rot
  hard(2),    // Schwer   — gelb
  good(3),    // Gut      — grün
  easy(4);    // Einfach  — orange

  final int value;
  const FSRSRating(this.value);
}

// ════════════════════════════════════════════════════════
// KARTEN-ZUSTAND
// ════════════════════════════════════════════════════════
enum CardState {
  newCard,     // Noch nie gelernt
  learning,    // Gerade in Einlernphase
  review,      // Reguläre Wiederholung
  relearning,  // Nach Fehler neu lernen
}

// ════════════════════════════════════════════════════════
// FSRS KARTEN-OBJEKT
// Intern genutzt während einer Lernsitzung
// ════════════════════════════════════════════════════════
class FSRSCard {
  final String id;
  double difficulty;   // D: 1.0 – 10.0
  double stability;    // S: Intervall in Tagen
  DateTime dueDate;
  DateTime lastReview;
  int reviewCount;
  CardState state;

  FSRSCard({
    required this.id,
    this.difficulty = 5.0,
    this.stability = 1.0,
    DateTime? dueDate,
    DateTime? lastReview,
    this.reviewCount = 0,
    this.state = CardState.newCard,
  })  : dueDate = dueDate ?? DateTime.now(),
        lastReview = lastReview ?? DateTime.now();

  /// Aus CardModel erstellen
  factory FSRSCard.fromCardModel(CardModel card) {
    return FSRSCard(
      id: card.id,
      difficulty: card.difficulty,
      stability: card.stability,
      dueDate: card.dueDate,
      lastReview: card.dueDate, // Fallback
      reviewCount: card.reviewCount,
      state: card.reviewCount == 0 ? CardState.newCard : CardState.review,
    );
  }

  /// In CardModel zurückschreiben (für Firestore)
  CardModel toCardModel(CardModel original) {
    return CardModel(
      id: original.id,
      question: original.question,
      shortAnswer: original.shortAnswer,
      longAnswer: original.longAnswer,
      url: original.url,
      hashtags: original.hashtags,
      difficulty: difficulty,
      stability: stability,
      dueDate: dueDate,
      reviewCount: reviewCount,
    );
  }
}

// ════════════════════════════════════════════════════════
// FSRS SERVICE
// ════════════════════════════════════════════════════════
class FSRSService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── FSRS 4.5 Kern-Parameter ───────────────────────────
  static const double _wInitialStability     = 0.4;
  static const double _wInitialDifficulty    = 0.9;
  static const double _wDifficultyMultiplier = 0.8;
  static const double _wStabilityGrowthBase  = 0.9;
  static const double _wStabilityGrowthFact  = 11.0;
  static const double _wHardFactor           = 0.85;
  static const double _wEasyFactor           = 1.30;
  static const double _wRelearningBase       = 0.20;
  static const double _wRelearningStab       = 0.80;
  static const double _targetRetention       = 0.90;

  // ────────────────────────────────────────────────────
  /// Karte nach Bewertung aktualisieren (Kern-Algorithmus)
  // ────────────────────────────────────────────────────
  FSRSCard updateCard(FSRSCard card, FSRSRating rating, DateTime now) {
    final daysSince = now.difference(card.lastReview).inHours / 24.0;

    // 1. Retrievability R berechnen
    final r = daysSince > 0
        ? _retrievability(card.stability, daysSince)
        : 1.0;

    // 2. Difficulty aktualisieren
    final deltaD = -_wDifficultyMultiplier * (rating.value - 3);
    final newD = (card.difficulty + deltaD).clamp(1.0, 10.0);

    // 3. Stability aktualisieren
    double newS;
    switch (rating) {
      case FSRSRating.again:
        // Fehler: Stability zurücksetzen
        newS = _wRelearningBase * (1 - r) * card.stability + _wRelearningStab;
        newS = newS.clamp(0.1, 100.0);

      case FSRSRating.hard:
        newS = card.stability *
            (1 + _wStabilityGrowthBase * (_wStabilityGrowthFact - newD) * _wHardFactor);
        newS = newS.clamp(0.1, 365.0);

      case FSRSRating.good:
        newS = card.stability *
            (1 + _wStabilityGrowthBase * (_wStabilityGrowthFact - newD) * 1.0);
        newS = newS.clamp(0.1, 365.0);

      case FSRSRating.easy:
        newS = card.stability *
            (1 + _wStabilityGrowthBase * (_wStabilityGrowthFact - newD) * _wEasyFactor);
        newS = newS.clamp(0.1, 365.0);
    }

    // 4. Nächstes Fälligkeitsdatum berechnen
    final intervalDays = _optimalInterval(newS);
    final nextDue = now.add(Duration(minutes: (intervalDays * 24 * 60).round()));

    // 5. Neuen Zustand bestimmen
    final newState = rating == FSRSRating.again
        ? CardState.relearning
        : (card.state == CardState.newCard ? CardState.learning : CardState.review);

    return FSRSCard(
      id: card.id,
      difficulty: newD,
      stability: newS,
      dueDate: nextDue,
      lastReview: now,
      reviewCount: card.reviewCount + 1,
      state: newState,
    );
  }

  // ────────────────────────────────────────────────────
  /// Neue Karte zum ersten Mal initialisieren
  // ────────────────────────────────────────────────────
  FSRSCard initNewCard(String cardId, FSRSRating firstRating, DateTime now) {
    double initialS;
    double initialD;

    switch (firstRating) {
      case FSRSRating.again:
        initialS = _wInitialStability * 0.5;
        initialD = 8.0;
      case FSRSRating.hard:
        initialS = _wInitialStability * 1.0;
        initialD = 7.0;
      case FSRSRating.good:
        initialS = _wInitialStability * 2.0;
        initialD = 5.0;
      case FSRSRating.easy:
        initialS = _wInitialStability * 4.0;
        initialD = 3.0;
    }

    initialD = (initialD * _wInitialDifficulty).clamp(1.0, 10.0);
    final intervalDays = _optimalInterval(initialS);
    final nextDue = now.add(Duration(minutes: (intervalDays * 24 * 60).round()));

    return FSRSCard(
      id: cardId,
      difficulty: initialD,
      stability: initialS,
      dueDate: nextDue,
      lastReview: now,
      reviewCount: 1,
      state: firstRating == FSRSRating.again
          ? CardState.relearning
          : CardState.learning,
    );
  }

  // ────────────────────────────────────────────────────
  /// Karte in Firestore speichern nach Bewertung
  // ────────────────────────────────────────────────────
  Future<void> reviewCard({
    required String userId,
    required String deckId,
    required CardModel card,
    required FSRSRating rating,
  }) async {
    final now = DateTime.now();
    final fsrsCard = FSRSCard.fromCardModel(card);

    final updatedFsrs = card.reviewCount == 0
        ? initNewCard(card.id, rating, now)
        : updateCard(fsrsCard, rating, now);

    final updatedCard = updatedFsrs.toCardModel(card);

    await _db
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('cards')
        .doc(card.id)
        .update({
      'difficulty':   updatedCard.difficulty,
      'stability':    updatedCard.stability,
      'dueDate':      Timestamp.fromDate(updatedCard.dueDate),
      'reviewCount':  updatedCard.reviewCount,
    });
  }

  // ────────────────────────────────────────────────────
  /// Intervall-Label für Bewertungsbuttons
  /// Gibt z.B. "<1 Min", "10 Min", "4 Tage", "14 Tage" zurück
  // ────────────────────────────────────────────────────
  String getIntervalLabel(CardModel card, FSRSRating rating) {
    final now = DateTime.now();
    final fsrsCard = FSRSCard.fromCardModel(card);

    final updated = card.reviewCount == 0
        ? initNewCard(card.id, rating, now)
        : updateCard(fsrsCard, rating, now);

    final diff = updated.dueDate.difference(now);

    if (diff.inMinutes < 1)  return '<1 Min';
    if (diff.inMinutes < 60) return '${diff.inMinutes} Min';
    if (diff.inHours < 24)   return '${diff.inHours} Std';
    if (diff.inDays < 7)     return '${diff.inDays} Tage';
    if (diff.inDays < 30)    return '${(diff.inDays / 7).round()} Wo';
    return '${(diff.inDays / 30).round()} Mon';
  }

  // ────────────────────────────────────────────────────
  /// Alle 4 Intervall-Labels auf einmal (für Bewertungsbuttons)
  // ────────────────────────────────────────────────────
  Map<FSRSRating, String> getAllIntervalLabels(CardModel card) {
    return {
      for (final r in FSRSRating.values) r: getIntervalLabel(card, r),
    };
  }

  // ────────────────────────────────────────────────────
  /// Sitzungs-Statistik: wie viele Karten heute fällig?
  // ────────────────────────────────────────────────────
  Future<int> getDueCount(String userId, String deckId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('cards')
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  // ────────────────────────────────────────────────────
  /// Retention-Rate berechnen (letzte 30 Tage)
  /// Gibt Wert zwischen 0.0 und 1.0 zurück
  // ────────────────────────────────────────────────────
  Future<double> getRetentionRate(String userId, String deckId) async {
    final since = DateTime.now().subtract(const Duration(days: 30));
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('cards')
        .where('dueDate', isGreaterThan: Timestamp.fromDate(since))
        .get();

    if (snapshot.docs.isEmpty) return 0.0;

    // Durchschnittliche Stability als Proxy für Retention
    final avgStability = snapshot.docs
        .map((d) => (d.data()['stability'] ?? 1.0) as double)
        .reduce((a, b) => a + b) / snapshot.docs.length;

    return _retrievability(avgStability, 1.0).clamp(0.0, 1.0);
  }

  // ══════════════════════════════════════════════════
  // PRIVATE HILFSMETHODEN
  // ══════════════════════════════════════════════════

  /// Retrievability: Wie gut ist die Karte noch abrufbar?
  /// R = e^(-t/S * ln(targetRetention))
  double _retrievability(double stability, double daysSince) {
    if (stability <= 0) return 0.0;
    return (stability / (stability + daysSince)).clamp(0.0, 1.0);
  }

  /// Optimales Intervall für Ziel-Retention von 90%
  /// t = S * (targetRetention^(1/c) - 1) — vereinfacht
  double _optimalInterval(double stability) {
    // Ziel: R = 0.90 → t ≈ stability * 0.9
    return (stability * _targetRetention).clamp(0.01, 365.0);
  }
}
