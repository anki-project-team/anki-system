// lib/screens/flashcard_answer_screen.dart
// Screen 04 — Antwort-Ansicht mit Live-FSRS-Integration

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/card_model.dart';
import '../services/fsrs_service.dart';

const _bgColor     = Color(0xFFF5F5F5);
const _navColor    = Color(0xFF162447);
const _cardColor   = Color(0xFF1e3a5f);
const _darkColor   = Color(0xFF1a2744);
const _accentColor = Color(0xFFE8813A);
const _againColor  = Color(0xFFE84C3C);
const _hardColor   = Color(0xFFF0C030);
const _goodColor   = Color(0xFF32CD32);
const _easyColor   = Color(0xFFE8813A);

// ════════════════════════════════════════════════════════
class FlashcardAnswerScreen extends StatefulWidget {
  final CardModel card;
  final String? deckId;
  final int currentCard;
  final int totalCards;
  final void Function(FSRSRating)? onRating;

  const FlashcardAnswerScreen({
    super.key,
    required this.card,
    required this.currentCard,
    required this.totalCards,
    this.deckId,
    this.onRating,
  });

  @override
  State<FlashcardAnswerScreen> createState() => _FlashcardAnswerScreenState();
}

class _FlashcardAnswerScreenState extends State<FlashcardAnswerScreen> {
  final FSRSService _fsrs = FSRSService();

  bool _erklaerungExpanded = false;
  bool _weiterlernExpanded = false;
  bool _isRating = false;

  // Interval-Labels für die 4 Buttons — werden beim Build berechnet
  late Map<FSRSRating, String> _labels;

  @override
  void initState() {
    super.initState();
    _labels = _fsrs.getAllIntervalLabels(widget.card);
  }

  // ── Bewertung abgeben ────────────────────────────────
  Future<void> _rate(FSRSRating rating) async {
    if (_isRating) return;
    setState(() => _isRating = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _fsrs.reviewCard(
        userId: user.uid,
        deckId: widget.deckId ?? '',
        card: widget.card,
        rating: rating,
      );
    }

    if (!mounted) return;

    // Zurück zum Question Screen oder Session beenden
    widget.onRating?.call(rating);
    Navigator.of(context).pop(rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ───────────────────────────────
            _AppBar(
              cardIndex: widget.currentCard,
              totalCards: widget.totalCards,
            ),

            // ── Scrollbarer Inhalt ───────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Frage (als Text, nicht in Karte)
                    Text(
                      widget.card.question,
                      style: const TextStyle(
                        color: _navColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── KERNANTWORT ─────────────────
                    _KernantwortCard(shortAnswer: widget.card.shortAnswer),
                    const SizedBox(height: 10),

                    // ── Accordion: Erklärung ────────
                    _Accordion(
                      icon: '📖',
                      title: 'Erklärung',
                      subtitle: 'Schritt-für-Schritt · Details',
                      expanded: _erklaerungExpanded,
                      onTap: () => setState(
                          () => _erklaerungExpanded = !_erklaerungExpanded),
                      content: widget.card.longAnswer,
                    ),
                    const SizedBox(height: 8),

                    // ── Accordion: Weiterlernen ─────
                    _Accordion(
                      icon: '🔗',
                      title: 'Weiterlernen',
                      subtitle: 'Links, Videos, Docs',
                      expanded: _weiterlernExpanded,
                      onTap: () => setState(
                          () => _weiterlernExpanded = !_weiterlernExpanded),
                      content: widget.card.url.isNotEmpty
                          ? widget.card.url
                          : 'Keine Links hinterlegt.',
                    ),
                    const SizedBox(height: 12),

                    // ── Hashtags ────────────────────
                    if (widget.card.hashtags.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: widget.card.hashtags
                            .map((tag) => _HashtagPill(tag: tag))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),

            // ── Bewertungsbereich (immer sichtbar) ──
            _RatingSection(
              labels: _labels,
              isRating: _isRating,
              onRate: _rate,
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// APP BAR
// ════════════════════════════════════════════════════════
class _AppBar extends StatelessWidget {
  final int cardIndex;
  final int totalCards;

  const _AppBar({required this.cardIndex, required this.totalCards});

  @override
  Widget build(BuildContext context) {
    final progress = totalCards > 0 ? cardIndex / totalCards : 0.0;

    return Column(
      children: [
        // Dunkle AppBar
        Container(
          color: _navColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back_ios,
                    color: Colors.white70, size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('IHK Prüfungsvorbereitung',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text('$cardIndex / $totalCards',
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ),

        // Fortschrittsbalken
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(_accentColor),
          minHeight: 3,
        ),

        // Kartenfortschritt
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text('NEU',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Netzwerkgrundlagen · AP1 Teil 1',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 11),
                ),
              ),
              // Dot-Fortschritt
              Row(
                children: List.generate(5, (i) {
                  final filled = i < cardIndex;
                  return Container(
                    margin: const EdgeInsets.only(left: 3),
                    width: 8, height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? _accentColor : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════
// KERNANTWORT KARTE
// ════════════════════════════════════════════════════════
class _KernantwortCard extends StatelessWidget {
  final String shortAnswer;
  const _KernantwortCard({required this.shortAnswer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _darkColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('KERNANTWORT',
            style: TextStyle(
              color: _accentColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            shortAnswer,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// ACCORDION
// ════════════════════════════════════════════════════════
class _Accordion extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool expanded;
  final VoidCallback onTap;
  final String content;

  const _Accordion({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.expanded,
    required this.onTap,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                          style: const TextStyle(
                            color: _navColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
            if (expanded)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                  content,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// HASHTAG PILL
// ════════════════════════════════════════════════════════
class _HashtagPill extends StatelessWidget {
  final String tag;
  const _HashtagPill({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        tag.startsWith('#') ? tag : '#$tag',
        style: const TextStyle(
          color: _accentColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
// BEWERTUNGS-SECTION (immer sichtbar, am Screen-Ende)
// ════════════════════════════════════════════════════════
class _RatingSection extends StatelessWidget {
  final Map<FSRSRating, String> labels;
  final bool isRating;
  final Future<void> Function(FSRSRating) onRate;

  const _RatingSection({
    required this.labels,
    required this.isRating,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Column(
        children: [
          const Text(
            'Wie gut kennst du diese Karte?',
            style: TextStyle(
              color: _navColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _RatingButton(
                label: 'Nochmal',
                interval: labels[FSRSRating.again] ?? '<1 Min',
                color: _againColor,
                isLoading: isRating,
                onTap: () => onRate(FSRSRating.again),
              ),
              const SizedBox(width: 6),
              _RatingButton(
                label: 'Schwer',
                interval: labels[FSRSRating.hard] ?? '<10 Min',
                color: _hardColor,
                isLoading: isRating,
                onTap: () => onRate(FSRSRating.hard),
              ),
              const SizedBox(width: 6),
              _RatingButton(
                label: 'Gut',
                interval: labels[FSRSRating.good] ?? '4 Tage',
                color: _goodColor,
                isLoading: isRating,
                onTap: () => onRate(FSRSRating.good),
              ),
              const SizedBox(width: 6),
              _RatingButton(
                label: 'Einfach',
                interval: labels[FSRSRating.easy] ?? '14 Tage',
                color: _easyColor,
                isLoading: isRating,
                onTap: () => onRate(FSRSRating.easy),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingButton extends StatelessWidget {
  final String label;
  final String interval;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _RatingButton({
    required this.label,
    required this.interval,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isLoading ? 0.5 : 1.0,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  interval,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
