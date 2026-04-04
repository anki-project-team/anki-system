import 'package:flutter/material.dart';
import '../models/card_model.dart';

class LernSessionScreen extends StatefulWidget {
  final List<CardModel> cards;
  final String deckName;

  const LernSessionScreen({
    super.key,
    required this.cards,
    required this.deckName,
  });

  @override
  State<LernSessionScreen> createState() => _LernSessionScreenState();
}

class _LernSessionScreenState extends State<LernSessionScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.cards[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.deckName}  ·  ${_currentIndex + 1} / ${widget.cards.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Fortschrittsbalken
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.cards.length,
            backgroundColor: const Color(0xFFE0E0E0),
            valueColor:
                const AlwaysStoppedAnimation<Color>(Color(0xFFE8813A)),
            minHeight: 3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // ── Frage-Karte ────────────────────────
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: const Color(0xFF162447),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _showAnswer
                                ? Icons.lightbulb_outline
                                : Icons.help_outline,
                            color: const Color(0xFFE8813A),
                            size: 36,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            card.question,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              height: 1.4,
                            ),
                          ),
                          if (_showAnswer) ...[
                            const SizedBox(height: 24),
                            Container(
                              width: 60,
                              height: 1,
                              color: Colors.white24,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              card.shortAnswer,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFE8813A),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Buttons ────────────────────────────
                  if (!_showAnswer)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            setState(() => _showAnswer = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8813A),
                          padding:
                              const EdgeInsets.symmetric(vertical: 18),
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
                            Icon(Icons.arrow_forward,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        _ratingButton('Nochmal', const Color(0xFFEF4444)),
                        const SizedBox(width: 8),
                        _ratingButton('Schwer', const Color(0xFFF59E0B)),
                        const SizedBox(width: 8),
                        _ratingButton('Gut', const Color(0xFF3B82F6)),
                        const SizedBox(width: 8),
                        _ratingButton('Einfach', const Color(0xFF22C55E)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingButton(String label, Color color) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onRate(),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _onRate() {
    final nextIndex = _currentIndex + 1;
    if (nextIndex >= widget.cards.length) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lernsitzung abgeschlossen! \u{1F389}'),
          backgroundColor: Color(0xFFE8813A),
        ),
      );
      return;
    }
    setState(() {
      _currentIndex = nextIndex;
      _showAnswer = false;
    });
  }
}
