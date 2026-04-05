import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  const SplashScreen({super.key, required this.nextScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    _fade = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 25),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 25),
    ]).animate(_ctrl);

    _scale = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.82, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 25),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 75),
    ]).animate(_ctrl);

    _ctrl.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => widget.nextScreen,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF162447),
      body: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Opacity(
          opacity: _fade.value.clamp(0.0, 1.0),
          child: Center(
            child: Transform.scale(
              scale: _scale.value,
              child: Column(mainAxisSize: MainAxisSize.min, children: [

                // LF Logo Box
                Container(
                  width: 100, height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e3a5f),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: const Color(0xFFE8813A).withOpacity(0.35),
                        width: 1.5),
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const Text('LF',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1)),
                    const SizedBox(height: 5),
                    Container(
                      width: 42, height: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8813A),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 6),

                // "Learn-Factory" direkt unter dem Logo
                Text('Learn-Factory',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 12,
                        letterSpacing: 0.5)),
                const SizedBox(height: 28),

                // App-Name groß
                const Text('Learn-Factory',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                const SizedBox(height: 8),

                // Tagline
                Text('AP1 Bestanden. Nicht zufällig.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 14)),
                const SizedBox(height: 32),

                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8813A).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFFE8813A).withOpacity(0.3)),
                  ),
                  child: const Text('IHK AP1 · 7 Berufsbilder',
                      style: TextStyle(
                          color: Color(0xFFE8813A),
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 48),

                // BBQ Footer
                Text('BBQ Düsseldorf · Abt. IT-Ausbildung',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.2),
                        fontSize: 11)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
