// lib/screens/lern_session_screen.dart
// Alles in einem Screen — kein Push/Pop zwischen Frage und Antwort

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/card_model.dart';
import '../services/fsrs_service.dart';

const _bg      = Color(0xFF162447);
const _accent  = Color(0xFFE8813A);
const _dark    = Color(0xFF1a2744);


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
  final _fsrs = FSRSService();

  CardModel get _card => widget.cards[_index];
  bool get _isLast => _index >= widget.cards.length - 1;

  Future<void> _rate(int rating) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _fsrs.reviewCard(
          userId: user.uid,
          deckId: 'default',
          card: _card,
          rating: FSRSRating.values[rating - 1],
        );
      }
    } catch (_) {}

    if (!mounted) return;

    if (_isLast) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lernsitzung abgeschlossen!'),
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
      backgroundColor: _bg,
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
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(_accent),
              minHeight: 4,
            ),

            // ── Inhalt ──────────────────────────────────
            if (!_showAnswer)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                  : Colors.white24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: _dark,
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (_showAnswer)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label
                    const Text('AKTUELLE KARTE',
                      style: TextStyle(
                        color: _accent, fontSize: 10,
                        fontWeight: FontWeight.bold, letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Frage
                    Text(_card.question,
                      style: const TextStyle(
                        color: Colors.white, fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // KERNANTWORT mit linkem orangenen Rand
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1e3a5f),
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          left: BorderSide(color: _accent, width: 3),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.star, color: _accent, size: 16),
                            const SizedBox(width: 8),
                            const Text('KERNANTWORT',
                              style: TextStyle(
                                color: _accent, fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          Text(_card.shortAnswer,
                            style: const TextStyle(
                              color: Colors.white, fontSize: 15, height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Erklärung Accordion
                    if (_card.longAnswer.isNotEmpty) ...[
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1e3a5f),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          leading: const Icon(Icons.menu_book,
                              color: Colors.white54, size: 20),
                          title: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Erklärungen', style: TextStyle(
                                  color: Colors.white, fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                              Text('Ausführliche Erklärung', style: TextStyle(
                                  color: Colors.white54, fontSize: 11)),
                            ],
                          ),
                          trailing: const Icon(Icons.expand_more,
                              color: Colors.white54),
                          backgroundColor: const Color(0xFF1e3a5f),
                          collapsedBackgroundColor: const Color(0xFF1e3a5f),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Text(_card.longAnswer,
                                style: const TextStyle(
                                  color: Colors.white70, fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Weiterlernen Accordion
                    if (_card.url.isNotEmpty) ...[
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1e3a5f),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 4),
                          leading: const Icon(Icons.open_in_new,
                              color: Colors.white54, size: 20),
                          title: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Weiterlernen', style: TextStyle(
                                  color: Colors.white, fontSize: 14,
                                  fontWeight: FontWeight.w600)),
                              Text('1 Link', style: TextStyle(
                                  color: Colors.white54, fontSize: 11)),
                            ],
                          ),
                          trailing: const Icon(Icons.expand_more,
                              color: Colors.white54),
                          backgroundColor: const Color(0xFF1e3a5f),
                          collapsedBackgroundColor: const Color(0xFF1e3a5f),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: GestureDetector(
                                onTap: () => launchUrl(
                                  Uri.parse(_card.url),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: Text(_card.url,
                                  style: const TextStyle(
                                    color: _accent, fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    decorationColor: _accent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Hashtags
                    if (_card.hashtags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6, runSpacing: 6,
                        children: _card.hashtags.map((tag) =>
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tag.startsWith('#') ? tag : '#$tag',
                              style: const TextStyle(
                                color: _accent, fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ).toList(),
                      ),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Buttons (immer am unteren Rand) ────────
            Container(
              color: const Color(0xFF1e3a5f),
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
                  // 2x2 Bewertungsbuttons
                  : Column(
                      children: [
                        const Text(
                          'Wie gut kennst du diese Karte?',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _RatingBtn(
                              label: 'Nochmal',
                              sub: _fsrs.getIntervalLabel(_card, FSRSRating.again),
                              color: const Color(0xFFE84C3C),
                              onTap: () => _rate(1),
                            ),
                            const SizedBox(width: 6),
                            _RatingBtn(
                              label: 'Schwer',
                              sub: _fsrs.getIntervalLabel(_card, FSRSRating.hard),
                              color: const Color(0xFFF0C030),
                              onTap: () => _rate(2),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _RatingBtn(
                              label: 'Gut',
                              sub: _fsrs.getIntervalLabel(_card, FSRSRating.good),
                              color: const Color(0xFF32CD32),
                              onTap: () => _rate(3),
                            ),
                            const SizedBox(width: 6),
                            _RatingBtn(
                              label: 'Einfach',
                              sub: _fsrs.getIntervalLabel(_card, FSRSRating.easy),
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
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(sub,
                style: TextStyle(
                  color: color.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
