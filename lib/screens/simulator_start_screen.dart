import 'package:flutter/material.dart';
import '../main.dart';

class SimulatorStartScreen extends StatefulWidget {
  const SimulatorStartScreen({super.key});

  @override
  State<SimulatorStartScreen> createState() => _SimulatorStartScreenState();
}

class _SimulatorStartScreenState extends State<SimulatorStartScreen> {
  int _selectedIndex = 1;

  static const _modes = [
    {
      'icon': '\u23F1',
      'title': 'Schnelltest',
      'questions': '10 Fragen',
      'time': '15 Min.',
    },
    {
      'icon': '\uD83D\uDCDA',
      'title': 'Standard',
      'questions': '25 Fragen',
      'time': '45 Min.',
    },
    {
      'icon': '\uD83C\uDFC6',
      'title': 'Vollsimulation',
      'questions': '50 Fragen',
      'time': '90 Min.',
    },
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          children: [
            // Header
            const SizedBox(height: 12),
            const Text('\uD83C\uDFAF', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'IHK AP1 Simulator',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Teste dein Wissen unter echten Pruefungsbedingungen',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),

            // Mode Cards
            for (var i = 0; i < _modes.length; i++) ...[
              _modeCard(i),
              if (i < _modes.length - 1) const SizedBox(height: 10),
            ],

            const SizedBox(height: 24),

            // Stats Row
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '78%',
                          style: TextStyle(
                            color: kAccentColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Letzter Score',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          '72%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Durchschnitt',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Start Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Simulation starten \u2192',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeCard(int index) {
    final mode = _modes[index];
    final selected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? kAccentColor.withOpacity(0.1)
              : kCardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? kAccentColor
                : Colors.white.withOpacity(0.06),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(mode['icon']!, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mode['title']!,
                    style: TextStyle(
                      color: selected ? kAccentColor : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${mode['questions']} \u00B7 ${mode['time']}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? kAccentColor
                    : Colors.transparent,
                border: Border.all(
                  color: selected
                      ? kAccentColor
                      : Colors.white.withOpacity(0.25),
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
