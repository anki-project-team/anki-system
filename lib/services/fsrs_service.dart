import 'dart:math';
import '../models/card_model.dart';

class FSRSService {
  /// Berechnet die neuen FSRS-Werte nach einer Bewertung.
  /// rating: 1=Nochmal, 2=Schwer, 3=Gut, 4=Einfach
  CardModel updateCard(CardModel card, int rating, DateTime now) {
    // Neue Difficulty: D' = clamp(D - 0.8*(rating-3), 1, 10)
    final newD = (card.difficulty - 0.8 * (rating - 3)).clamp(1.0, 10.0);

    // Neue Stability
    double newS;
    if (rating == 1) {
      // Again: stark reduzieren
      newS = 0.2 * card.stability;
    } else {
      // Schwer/Gut/Einfach: Stability wächst
      const ratingMultipliers = [0.0, 0.0, 0.85, 1.0, 1.3];
      newS = card.stability *
          exp(0.9 * (11 - newD) * ratingMultipliers[rating]);
    }

    // Mindestens 1 Tag
    if (newS < 1.0) newS = 1.0;

    final nextDue = now.add(Duration(days: newS.round()));
    final newState = rating == 1 ? 'relearning' : 'review';

    return card.copyWith(
      difficulty: newD,
      stability: newS,
      dueDate: nextDue,
      reviewCount: card.reviewCount + 1,
      state: newState,
    );
  }

  /// Gibt alle fälligen Karten zurück (dueDate <= now).
  List<CardModel> getDueCards(List<CardModel> cards) {
    final now = DateTime.now();
    return cards.where((c) => c.dueDate.isBefore(now) || c.dueDate.isAtSameMomentAs(now)).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  /// Gibt ein lesbares Intervall-Label für einen Rating-Button zurück.
  String getIntervalLabel(CardModel card, int rating) {
    final preview = updateCard(card, rating, DateTime.now());
    final days = preview.dueDate.difference(DateTime.now()).inDays;

    if (days < 1) return '<1d';
    if (days == 1) return '1d';
    if (days < 7) return '${days}d';
    if (days < 30) return '${(days / 7).round()}w';
    if (days < 365) return '${(days / 30).round()}mo';
    return '${(days / 365).round()}y';
  }
}
