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
    this.state = 'new',
  }) : dueDate = dueDate ?? DateTime.now();

  CardModel copyWith({
    String? id,
    String? question,
    String? shortAnswer,
    String? longAnswer,
    String? url,
    List<String>? hashtags,
    double? difficulty,
    double? stability,
    DateTime? dueDate,
    int? reviewCount,
    String? state,
  }) {
    return CardModel(
      id: id ?? this.id,
      question: question ?? this.question,
      shortAnswer: shortAnswer ?? this.shortAnswer,
      longAnswer: longAnswer ?? this.longAnswer,
      url: url ?? this.url,
      hashtags: hashtags ?? this.hashtags,
      difficulty: difficulty ?? this.difficulty,
      stability: stability ?? this.stability,
      dueDate: dueDate ?? this.dueDate,
      reviewCount: reviewCount ?? this.reviewCount,
      state: state ?? this.state,
    );
  }

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
      state: data['state'] ?? 'new',
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
      'state': state,
    };
  }
}
