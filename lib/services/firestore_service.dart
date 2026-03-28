import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Karte speichern
  Future<void> saveCard(String userId, String deckId, CardModel card) async {
    await _db
      .collection('users')
      .doc(userId)
      .collection('decks')
      .doc(deckId)
      .collection('cards')
      .doc(card.id)
      .set(card.toFirestore());
  }

  // Fällige Karten laden (Stream für Echtzeit-Updates)
  Stream<List<CardModel>> getDueCardsStream(String userId, String deckId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('cards')
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('dueDate')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CardModel.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Fällige Karten laden (einmalig)
  Future<List<CardModel>> getDueCards(String userId, String deckId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('cards')
        .where('dueDate', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('dueDate')
        .get();

    return snapshot.docs
        .map((doc) => CardModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Nur FSRS-Felder nach Review aktualisieren
  Future<void> updateCardAfterReview(
      String userId, String deckId, CardModel updatedCard) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('decks')
        .doc(deckId)
        .collection('cards')
        .doc(updatedCard.id)
        .update({
      'difficulty': updatedCard.difficulty,
      'stability': updatedCard.stability,
      'dueDate': Timestamp.fromDate(updatedCard.dueDate),
      'reviewCount': updatedCard.reviewCount,
      'state': updatedCard.state,
    });
  }
}
