import 'package:flutter/material.dart';
import '../models/card_model.dart';

class FlashcardAnswerScreen extends StatefulWidget {
  final CardModel card;
  final Function(int rating) onRating;
  final int currentCard;
  final int totalCards;
  final bool isNew;

  const FlashcardAnswerScreen({
    super.key,
    required this.card,
    required this.onRating,
    this.currentCard = 3,
    this.totalCards = 5,
    this.isNew = true,
  });

  @override
  State<FlashcardAnswerScreen> createState() => _FlashcardAnswerScreenState();
}

class _FlashcardAnswerScreenState extends State<FlashcardAnswerScreen> {
  bool _showExplanation = false;
  bool _showResources = false;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Fortschrittsbalken (orange) ──
            LinearProgressIndicator(
              value: widget.currentCard / widget.totalCards,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFE8813A)),
              minHeight: 3,
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── KARTENFORTSCHRITT + Punkte ──
                  _buildProgressRow(),
                  const SizedBox(height: 16),

                  // ── NEU Badge + Breadcrumb ──
                  _buildBreadcrumb(),
                  const SizedBox(height: 16),

                  // ── Frage ──
                  Text(
                    widget.card.question,
                    style: const TextStyle(
                      color: Color(0xFF1a1a2e),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── KERNANTWORT (dunkler Hintergrund) ──
                  _buildKernantwort(),
                  const SizedBox(height: 12),

                  // ── Erklärung Accordion ──
                  _buildAccordion(
                    icon: Icons.auto_stories,
                    title: 'Erklärungen & DORA-Prozess',
                    subtitle:
                        'Discovery · Offer · Request · Acknowledgement',
                    content: widget.card.longAnswer,
                    isOpen: _showExplanation,
                    onTap: () => setState(
                        () => _showExplanation = !_showExplanation),
                  ),
                  const SizedBox(height: 8),

                  // ── Weiterlernen Accordion ──
                  _buildAccordion(
                    icon: Icons.school,
                    title: 'Weiterlernen',
                    subtitle: '3 Ressourcen · Links, Videos, Docs',
                    content: widget.card.url,
                    isOpen: _showResources,
                    onTap: () => setState(
                        () => _showResources = !_showResources),
                    isLink: true,
                  ),
                  const SizedBox(height: 24),

                  // ── HASHTAGS (immer sichtbar) ──
                  _buildHashtags(),
                  const SizedBox(height: 12),

                  // ── + Hashtag hinzufügen ──
                  _buildAddHashtag(),
                  const SizedBox(height: 24),

                  // ── Bewertung ──
                  _buildRatingSection(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Fortschrittsanzeige mit Punkten ──
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
          children: List.generate(widget.totalCards, (i) {
            final bool isCompleted = i < widget.currentCard;
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
          '${widget.currentCard}/${widget.totalCards}',
          style: const TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── NEU Badge + Breadcrumb ──
  Widget _buildBreadcrumb() {
    return Row(
      children: [
        if (widget.isNew)
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
        if (widget.isNew) const SizedBox(width: 10),
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

  // ── KERNANTWORT mit dunklem Navy-Hintergrund + Keyword-Highlights ──
  Widget _buildKernantwort() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1a2744),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KERNANTWORT',
            style: TextStyle(
              color: Color(0xFFE8813A),
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 14),
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.7,
              ),
              children: _buildHighlightedAnswer(),
            ),
          ),
        ],
      ),
    );
  }

  // Antwort-Text mit orangenen Keywords
  List<TextSpan> _buildHighlightedAnswer() {
    final keywords = [
      'IP-Adressen',
      'Subnetzmasken',
      'Gateway',
      'DNS-Server',
    ];

    final text = widget.card.shortAnswer;
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    final matches = <MapEntry<int, String>>[];
    for (final keyword in keywords) {
      int index = text.indexOf(keyword);
      while (index != -1) {
        matches.add(MapEntry(index, keyword));
        index = text.indexOf(keyword, index + keyword.length);
      }
    }
    matches.sort((a, b) => a.key.compareTo(b.key));

    for (final match in matches) {
      if (match.key > currentIndex) {
        spans.add(TextSpan(text: text.substring(currentIndex, match.key)));
      }
      if (match.key >= currentIndex) {
        spans.add(TextSpan(
          text: match.value,
          style: const TextStyle(
            color: Color(0xFFE8813A),
            fontWeight: FontWeight.bold,
          ),
        ));
        currentIndex = match.key + match.value.length;
      }
    }

    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans.isEmpty ? [TextSpan(text: text)] : spans;
  }

  // ── Accordion (weiße Karte) ──
  Widget _buildAccordion({
    required IconData icon,
    required String title,
    required String subtitle,
    required String content,
    required bool isOpen,
    required VoidCallback onTap,
    bool isLink = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF9E9E9E), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isOpen ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFFBBBBBB),
                ),
              ],
            ),
            if (isOpen) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  content,
                  style: TextStyle(
                    color: isLink
                        ? const Color(0xFFE8813A)
                        : const Color(0xFF555555),
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── HASHTAGS (immer sichtbar) ──
  Widget _buildHashtags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'HASHTAGS',
          style: TextStyle(
            color: Color(0xFF9E9E9E),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.card.hashtags
              .map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(
                        color: Color(0xFF5A6A7A),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  // ── + Hashtag hinzufügen ──
  Widget _buildAddHashtag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: const Row(
        children: [
          Icon(Icons.add, color: Color(0xFFBBBBBB), size: 18),
          SizedBox(width: 8),
          Text(
            '+ Hashtag hinzufügen',
            style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
          ),
          Spacer(),
          Icon(Icons.expand_more, color: Color(0xFFBBBBBB), size: 20),
        ],
      ),
    );
  }

  // ── Bewertungs-Sektion ──
  Widget _buildRatingSection() {
    return Column(
      children: [
        const Text(
          'Wie gut kennst du diese Karte?',
          style: TextStyle(color: Color(0xFF999999), fontSize: 13),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _buildRatingBtn('Nochmal', '<1 Min', 1, const Color(0xFFE57373)),
            const SizedBox(width: 8),
            _buildRatingBtn('Schwer', '<10 Min', 2, const Color(0xFFFFB74D)),
            const SizedBox(width: 8),
            _buildRatingBtn('Gut', '4 Tage', 3, const Color(0xFF81C784)),
            const SizedBox(width: 8),
            _buildRatingBtn('Einfach', '14 Tage', 4, const Color(0xFFE8813A)),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingBtn(
      String label, String time, int rating, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onRating(rating),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.3)),
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
                time,
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
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
