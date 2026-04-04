import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../services/fsrs_service.dart';
import 'flashcard_answer_screen.dart';

class FlashcardQuestionScreen extends StatelessWidget {
  final CardModel card;
  final Function(int rating, CardModel updatedCard) onRating;
  final int currentCard;
  final int totalCards;
  final bool isNew;
  final String? deckName;

  const FlashcardQuestionScreen({
    super.key,
    required this.card,
    required this.onRating,
    this.currentCard = 3,
    this.totalCards = 5,
    this.isNew = true,
    this.deckName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'IHK Prüfungsvorbereitung',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: currentCard / totalCards,
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFFE8813A)),
            minHeight: 3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressRow(),
                  const SizedBox(height: 16),
                  _buildBreadcrumb(),
                  const SizedBox(height: 16),
                  Text(
                    card.question,
                    style: const TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: const Color(0xFF162447),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Color(0xFFE8813A),
                              size: 40,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              card.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'NETZWERKGRUNDLAGEN · AP1 · TEIL 1',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      '$currentCard / $totalCards',
                      style: const TextStyle(
                          color: Color(0xFF9E9E9E), fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Antwort zeigen Button ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Push AnswerScreen — wartet bis AnswerScreen sich selbst poppt
                        final result = await Navigator.push<FSRSRating>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlashcardAnswerScreen(
                              card: card,
                              currentCard: currentCard,
                              totalCards: totalCards,
                            ),
                          ),
                        );

                        // AnswerScreen hat sich gepoppt (mit rating)
                        if (result != null && context.mounted) {
                          // ERST QuestionScreen poppen
                          Navigator.of(context).pop();
                          // DANN nächste Karte pushen via onRating
                          onRating(result.value, card);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE8813A),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Antwort zeigen',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow() {
    return Row(
      children: [
        const Text(
          'KARTENFORTSCHRITT',
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const Spacer(),
        Row(
          children: List.generate(totalCards, (i) {
            final bool isCompleted = i < currentCard;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFFE8813A)
                    : const Color(0xFFD9D9D9),
              ),
            );
          }),
        ),
        const SizedBox(width: 8),
        Text(
          '$currentCard/$totalCards',
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        if (isNew)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'NEU',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        if (isNew) const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Netzwerkgrundlagen · AP1 Teil 1',
            style: TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
