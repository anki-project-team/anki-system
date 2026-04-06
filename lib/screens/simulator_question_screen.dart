import 'package:flutter/material.dart';
import '../main.dart';

class SimulatorQuestionScreen extends StatefulWidget {
  const SimulatorQuestionScreen({super.key});

  @override
  State<SimulatorQuestionScreen> createState() =>
      _SimulatorQuestionScreenState();
}

class _SimulatorQuestionScreenState extends State<SimulatorQuestionScreen> {
  int? _selectedAnswer;

  static const _answers = [
    'Sicherungsschicht (Layer 2)',
    'Vermittlungsschicht (Layer 3)',
    'Transportschicht (Layer 4)',
    'Anwendungsschicht (Layer 7)',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Pruefungs-Simulator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer_outlined,
                      size: 16, color: Colors.white.withOpacity(0.6)),
                  const SizedBox(width: 4),
                  const Text(
                    '38:24',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 7 / 25,
                backgroundColor: kCardColor,
                valueColor: AlwaysStoppedAnimation(kAccentColor),
                minHeight: 6,
              ),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Frage-Nr Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Frage 7',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Frage
                  const Text(
                    'Welches OSI-Schichtmodell-Layer ist fuer die '
                    'Ende-zu-Ende-Verbindung zustaendig?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Antworten
                  for (var i = 0; i < _answers.length; i++) ...[
                    _answerCard(i),
                    if (i < _answers.length - 1) const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),

          // Bottom Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedAnswer != null ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kCardColor,
                  disabledForegroundColor: Colors.white.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Antwort bestaetigen',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _answerCard(int index) {
    final selected = _selectedAnswer == index;
    final letter = String.fromCharCode(65 + index); // A, B, C, D

    return GestureDetector(
      onTap: () => setState(() => _selectedAnswer = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? kAccentColor.withOpacity(0.1) : kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? kAccentColor : Colors.white.withOpacity(0.06),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: selected
                    ? kAccentColor
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  letter,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.white.withOpacity(0.5),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _answers[index],
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white.withOpacity(0.75),
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
