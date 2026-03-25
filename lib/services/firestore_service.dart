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

  // Fällige Karten laden
  Future<List<CardModel>> getDueCards(String userId, String deckId) async {
    final snapshot = await _db
      .collection('users')
      .doc(userId)
      .collection('decks')
      .doc(deckId)
      .collection('cards')
      .where('dueDate', isLessThanOrEqualTo: DateTime.now())
      .get();

    return snapshot.docs
      .map((doc) => CardModel.fromFirestore(doc.data(), doc.id))
      .toList();
  }
}
