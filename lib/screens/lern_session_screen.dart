// lib/screens/lern_session_screen.dart
// Alles in einem Screen — kein Push/Pop zwischen Frage und Antwort

import 'package:flutter/material.dart';
import '../models/card_model.dart';

const _bg      = Color(0xFF162447);
const _accent  = Color(0xFFE8813A);
const _card    = Color(0xFF1e3a5f);
const _dark    = Color(0xFF1a2744);
const _light   = Color(0xFFF5F5F5);

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
  int _index = 0;
  bool _showAnswer = false;

  CardModel get _card => widget.cards[_index];
  bool get _isLast => _index >= widget.cards.length - 1;

  void _rate(int rating) {
    if (_isLast) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lernsitzung abgeschlossen! 🎉'),
          backgroundColor: Color(0xFFE8813A),
        ),
      );
    } else {
      setState(() {
        _index++;
        _showAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _light,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ─────────────────────────────────
            Container(
              color: _bg,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close,
                        color: Colors.white70, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(widget.deckName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${_index + 1} / ${widget.cards.length}',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),

            // ── Fortschrittsbalken ──────────────────────
            LinearProgressIndicator(
              value: (_index + 1) / widget.cards.length,
              backgroundColor: Colors.grey.shade300,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(_accent),
              minHeight: 4,
            ),

            // ── Inhalt ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fortschrittspunkte
                    Row(
                      children: List.generate(
                        widget.cards.length.clamp(0, 10),
                        (i) => Container(
                          margin: const EdgeInsets.only(right: 4),
                          width: 8, height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i <= _index
                                ? _accent
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Frage
                    Text(
                      _card.question,
                      style: const TextStyle(
                        color: Color(0xFF1a1a2e),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Frage-Karte (dunkel)
                    if (!_showAnswer)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.help_outline,
                                color: _accent, size: 36),
                            const SizedBox(height: 16),
                            Text(
                              _card.question,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // KERNANTWORT (nach Aufdecken)
                    if (_showAnswer) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _dark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('KERNANTWORT',
                              style: TextStyle(
                                color: _accent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _card.shortAnswer,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (_card.longAnswer.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _card.longAnswer,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],

                      if (_card.hashtags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6, runSpacing: 6,
                          children: _card.hashtags.map((tag) =>
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: _accent.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                tag.startsWith('#') ? tag : '#$tag',
                                style: const TextStyle(
                                  color: _accent,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ).toList(),
                        ),
                      ],
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Buttons (immer am unteren Rand) ────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: !_showAnswer
                  // Antwort zeigen Button
                  ? SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () =>
                            setState(() => _showAnswer = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Antwort zeigen  →',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  // 4 Bewertungsbuttons
                  : Column(
                      children: [
                        const Text(
                          'Wie gut kennst du diese Karte?',
                          style: TextStyle(
                            color: Color(0xFF162447),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _RatingBtn(
                              label: 'Nochmal',
                              sub: '<1 Min',
                              color: const Color(0xFFE84C3C),
                              onTap: () => _rate(1),
                            ),
                            const SizedBox(width: 6),
                            _RatingBtn(
                              label: 'Schwer',
                              sub: '10 Min',
                              color: const Color(0xFFF0C030),
                              onTap: () => _rate(2),
                            ),
                            const SizedBox(width: 6),
                            _RatingBtn(
                              label: 'Gut',
                              sub: '4 Tage',
                              color: const Color(0xFF32CD32),
                              onTap: () => _rate(3),
                            ),
                            const SizedBox(width: 6),
                            _RatingBtn(
                              label: 'Einfach',
                              sub: '14 Tage',
                              color: _accent,
                              onTap: () => _rate(4),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RatingBtn extends StatelessWidget {
  final String label;
  final String sub;
  final Color color;
  final VoidCallback onTap;

  const _RatingBtn({
    required this.label,
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Column(
            children: [
              Text(label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(sub,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
