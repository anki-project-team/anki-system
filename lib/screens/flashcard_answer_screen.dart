import 'package:flutter/material.dart';
import 'package:ihk_ap1_prep/models/card_model.dart';
import 'package:ihk_ap1_prep/services/fsrs_service.dart';

class FlashcardAnswerScreen extends StatefulWidget {
  final CardModel card;
  final int currentCard;
  final int totalCards;
  final String deckName;
  final Function(int rating, CardModel updatedCard) onRating;

  const FlashcardAnswerScreen({
    super.key,
    required this.card,
    required this.currentCard,
    required this.totalCards,
    this.deckName = 'Hardware',
    required this.onRating,
  });

  @override
  State<FlashcardAnswerScreen> createState() =>
      _FlashcardAnswerScreenState();
}

class _FlashcardAnswerScreenState extends State<FlashcardAnswerScreen> {
  bool _erklaerungOpen = false;
  bool _weiterlernOpen = false;
  final FSRSService _fsrs = FSRSService();

  String _intervalLabel(int rating) =>
      _fsrs.getIntervalLabel(widget.card, rating);

  // Hebt Schlüsselwörter orange hervor
  Widget _buildHighlightedText(String text, List<String> keywords) {
    final spans = <TextSpan>[];
    String remaining = text;
    while (remaining.isNotEmpty) {
      int earliest = remaining.length;
      String? match;
      for (final kw in keywords) {
        final idx = remaining.toLowerCase().indexOf(kw.toLowerCase());
        if (idx != -1 && idx < earliest) {
          earliest = idx;
          match = remaining.substring(idx, idx + kw.length);
        }
      }
      if (match == null) {
        spans.add(TextSpan(
            text: remaining,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, height: 1.6)));
        break;
      }
      if (earliest > 0) {
        spans.add(TextSpan(
            text: remaining.substring(0, earliest),
            style: const TextStyle(
                color: Colors.white, fontSize: 15, height: 1.6)));
      }
      spans.add(TextSpan(
          text: match,
          style: const TextStyle(
              color: Color(0xFFE8813A),
              fontWeight: FontWeight.bold,
              fontSize: 15,
              height: 1.6)));
      remaining = remaining.substring(earliest + match.length);
    }
    return RichText(text: TextSpan(children: spans));
  }

  List<String> _getKeywords() => widget.card.hashtags
      .where((h) => !h.contains('AP'))
      .map((h) => h.replaceAll('#', ''))
      .toList();

  // Formatiert den longAnswer-Text mit Zeilenumbrüchen
  Widget _buildFormattedText(String text) {
    final lines = text.split('\\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final isNumbered = RegExp(r'^\d+\.').hasMatch(line.trim());
        final isBullet = line.trim().startsWith('–') ||
            line.trim().startsWith('-') ||
            line.trim().startsWith('•');
        return Padding(
          padding: EdgeInsets.only(
              bottom: 4,
              left: (isNumbered || isBullet) ? 8 : 0),
          child: Text(
            line,
            style: TextStyle(
              fontSize: 13,
              color: const Color(0xFF374151),
              height: 1.6,
              fontWeight: isNumbered || isBullet
                  ? FontWeight.w500
                  : FontWeight.normal,
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF162447),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('IHK Prüfungsvorbereitung',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Fortschrittsbalken
          LinearProgressIndicator(
            value: widget.currentCard / widget.totalCards,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFE8813A)),
            minHeight: 4,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NEU Badge + Deck-Name + Fortschrittspunkte
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                              color: const Color(0xFFDBEAFE),
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text('NEU',
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E40AF))),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.deckName,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280)),
                        ),
                      ]),
                      Row(children: [
                        ...List.generate(
                          widget.totalCards > 5 ? 5 : widget.totalCards,
                          (i) => Container(
                            margin: const EdgeInsets.only(left: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < widget.currentCard
                                  ? const Color(0xFF162447)
                                  : const Color(0xFFE5E7EB),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${widget.currentCard}/${widget.totalCards}',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF374151)),
                        ),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Frage als Text
                  Text(
                    widget.card.question,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF162447),
                        height: 1.4),
                  ),
                  const SizedBox(height: 14),

                  // KERNANTWORT Karte
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a2744),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('KERNANTWORT',
                            style: TextStyle(
                                color: Color(0xFFE8813A),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6)),
                        const SizedBox(height: 10),
                        _buildHighlightedText(
                            widget.card.shortAnswer, _getKeywords()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Accordion: Erklärungen
                  if (widget.card.longAnswer.isNotEmpty)
                    _accordion(
                      icon: Icons.menu_book_outlined,
                      title: 'Erklärungen',
                      subtitle: 'Ausführliche Erklärung',
                      isOpen: _erklaerungOpen,
                      onTap: () => setState(
                          () => _erklaerungOpen = !_erklaerungOpen),
                      child: _buildFormattedText(widget.card.longAnswer),
                    ),
                  if (widget.card.longAnswer.isNotEmpty)
                    const SizedBox(height: 8),

                  // Accordion: Weiterlernen (nur wenn URL vorhanden)
                  _accordion(
                    icon: Icons.open_in_new_outlined,
                    title: 'Weiterlernen',
                    subtitle: widget.card.url.isNotEmpty
                        ? '2 Ressourcen · Links'
                        : 'Links & Ressourcen',
                    isOpen: _weiterlernOpen,
                    onTap: () => setState(
                        () => _weiterlernOpen = !_weiterlernOpen),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.card.url.isNotEmpty) ...[
                          _linkRow(
                              '🔗 Wikipedia',
                              widget.card.url),
                          const SizedBox(height: 8),
                          _linkRow(
                              '📘 IT-Handbuch',
                              'https://www.it-handbuch.de'),
                        ] else
                          _linkRow(
                              '📘 IT-Handbuch',
                              'https://www.it-handbuch.de'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Hashtags — ohne + Button
                  const Text('Hashtags',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.card.hashtags
                        .map((tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3F4F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(tag,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF6B7280))),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Bewertungs-Label
                  const Center(
                    child: Text(
                      'Wie gut kennst du diese Karte?',
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 4 Bewertungsbuttons
                  Row(
                    children: [
                      _ratingBtn('Nochmal', _intervalLabel(1), 1,
                          const Color(0xFFEF4444)),
                      const SizedBox(width: 6),
                      _ratingBtn('Schwer', _intervalLabel(2), 2,
                          const Color(0xFFF59E0B)),
                      const SizedBox(width: 6),
                      _ratingBtn('Gut', _intervalLabel(3), 3,
                          const Color(0xFF22C55E)),
                      const SizedBox(width: 6),
                      _ratingBtn('Einfach', _intervalLabel(4), 4,
                          const Color(0xFFE8813A)),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkRow(String label, String url) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF374151))),
        ),
        Text(
          url.length > 35 ? '${url.substring(0, 35)}...' : url,
          style: const TextStyle(
              fontSize: 11, color: Color(0xFF3B82F6)),
        ),
      ],
    );
  }

  Widget _accordion({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isOpen,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isOpen
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))
                  : BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFF6B7280)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827))),
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF))),
                    ],
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFF9FAFB),
              border: Border(
                left: BorderSide(color: Color(0xFFE5E7EB)),
                right: BorderSide(color: Color(0xFFE5E7EB)),
                bottom: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: child,
          ),
      ],
    );
  }

  Widget _ratingBtn(
      String label, String interval, int rating, Color color) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final updated =
              _fsrs.updateCard(widget.card, rating, DateTime.now());
          widget.onRating(rating, updated);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: color)),
              const SizedBox(height: 2),
              Text(interval,
                  style: TextStyle(
                      fontSize: 10,
                      color: color.withOpacity(0.7))),
            ],
          ),
        ),
      ),
    );
  }
}
