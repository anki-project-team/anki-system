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

  CardModel({
    required this.id,
    required this.question,
    required this.shortAnswer,
    required this.longAnswer,
    required this.url,
    required this.hashtags,
    this.difficulty = 5.0,
    this.stability = 1.0,
    DateTime? dueDate,
    this.reviewCount = 0,
  }) : dueDate = dueDate ?? DateTime.now();

  // Aus Firestore lesen
  factory CardModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CardModel(
      id: id,
      question: data['question'] ?? '',
      shortAnswer: data['shortAnswer'] ?? '',
      longAnswer: data['longAnswer'] ?? '',
      url: data['url'] ?? '',
      hashtags: List<String>.from(data['hashtags'] ?? []),
      difficulty: (data['difficulty'] ?? 5.0).toDouble(),
      stability: (data['stability'] ?? 1.0).toDouble(),
      dueDate: data['dueDate']?.toDate() ?? DateTime.now(),
      reviewCount: data['reviewCount'] ?? 0,
    );
  }

  // In Firestore speichern
  Map<String, dynamic> toFirestore() {
    return {
      'question': question,
      'shortAnswer': shortAnswer,
      'longAnswer': longAnswer,
      'url': url,
      'hashtags': hashtags,
      'difficulty': difficulty,
      'stability': stability,
      'dueDate': dueDate,
      'reviewCount': reviewCount,
    };
  }
}
