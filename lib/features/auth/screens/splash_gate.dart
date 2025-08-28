// ===============================================================
// FILE: lib/features/auth/screens/splash_gate.dart
// PURPOSE: LOCSY splash with intro + ring. SINGLE TAP to continue.
// CHANGE NOW: Navigate to AppRoutes.authChoice (Register/Login page).
// ASSETS: uses 'assets/images/locsy_avatar.png' as you had.
// ===============================================================

import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../app.dart';

class SplashGate extends StatefulWidget {
  const SplashGate({super.key});
  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> with TickerProviderStateMixin {
  // BEGIN intro animation (avatar + texts)
  late final AnimationController _intro;
  late final Animation<double> _fadeAvatar, _scaleAvatar, _fadeT1, _fadeT2, _fadeT3;
  late final Animation<Offset> _slideT1, _slideT2, _slideT3;
  // END intro animation

  // BEGIN hold ring (kept for look) + CTA state
  late final AnimationController _hold;
  bool _showEnter = false;
  // END

  @override
  void initState() {
    super.initState();

    // BEGIN intro setup
    _intro = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..forward();
    _fadeAvatar = CurvedAnimation(parent: _intro, curve: const Interval(0.00, 0.35, curve: Curves.easeOut));
    _scaleAvatar = Tween(begin: .92, end: 1.0).animate(
      CurvedAnimation(parent: _intro, curve: const Interval(0.00, 0.45, curve: Curves.easeOutBack)),
    );
    _slideT1 = Tween<Offset>(begin: const Offset(0, .20), end: Offset.zero)
        .animate(CurvedAnimation(parent: _intro, curve: const Interval(.35, .60, curve: Curves.easeOut)));
    _fadeT1  = CurvedAnimation(parent: _intro, curve: const Interval(.35, .60));
    _slideT2 = Tween<Offset>(begin: const Offset(0, .20), end: Offset.zero)
        .animate(CurvedAnimation(parent: _intro, curve: const Interval(.55, .80, curve: Curves.easeOut)));
    _fadeT2  = CurvedAnimation(parent: _intro, curve: const Interval(.55, .80));
    _slideT3 = Tween<Offset>(begin: const Offset(0, .20), end: Offset.zero)
        .animate(CurvedAnimation(parent: _intro, curve: const Interval(.70, 1.00, curve: Curves.easeOut)));
    _fadeT3  = CurvedAnimation(parent: _intro, curve: const Interval(.70, 1.00));
    _intro.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) setState(() => _showEnter = true);
    });
    // END intro setup

    // BEGIN ring controller (for the animated circle look)
    _hold = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    // If hold completes, we also proceed
    _hold.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) _nudgeForward();
    });
    // END ring controller
  }

  @override
  void dispose() {
    _intro.dispose();
    _hold.dispose();
    super.dispose();
  }

  // BEGIN navigation: go to Register/Login (authChoice)
  void _nudgeForward() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.authChoice);
  }
  // END navigation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BEGIN avatar
                ScaleTransition(
                  scale: _scaleAvatar,
                  child: FadeTransition(
                    opacity: _fadeAvatar,
                    child: Image.asset(
                      'assets/images/locsy_avatar.png', // path kept same
                      width: 220, height: 220, fit: BoxFit.contain,
                    ),
                  ),
                ),
                // END avatar
                const SizedBox(height: 16),

                // BEGIN titles
                FadeTransition(
                  opacity: _fadeT1,
                  child: SlideTransition(
                    position: _slideT1,
                    child: const Text(
                      'LOCSY',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900,
                          color: LocsyColors.orange, letterSpacing: 1.2),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                FadeTransition(
                  opacity: _fadeT2,
                  child: SlideTransition(
                    position: _slideT2,
                    child: const Text(
                      'Local Services for you',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: LocsyColors.orange),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _fadeT3,
                  child: SlideTransition(
                    position: _slideT3,
                    child: const Text(
                      'Mana Services · Mana Area\nMana App',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, height: 1.25, fontWeight: FontWeight.w800, color: LocsyColors.navy),
                    ),
                  ),
                ),
                // END titles

                const SizedBox(height: 32),

                // BEGIN CTA with animated circle (look intact). Single tap + optional hold.
                if (_showEnter)
                  GestureDetector(
                    onTap: _nudgeForward,                     // NEW: single tap to continue
                    onLongPressStart: (_) => _hold.forward(from: 0), // keep ring feel
                    onLongPressEnd:   (_) => _hold.reverse(),
                    child: Column(
                      children: [
                        AnimatedBuilder(
                          animation: _hold,
                          builder: (_, __) => Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 96, height: 96,
                                child: CircularProgressIndicator(
                                  value: _hold.value == 0 ? null : _hold.value,
                                  strokeWidth: 6,
                                  color: LocsyColors.orange,
                                  backgroundColor: LocsyColors.cream,
                                ),
                              ),
                              Container(
                                width: 72, height: 72,
                                decoration: BoxDecoration(
                                  color: LocsyColors.navy,
                                  borderRadius: BorderRadius.circular(36),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 10, offset: Offset(0,4))
                                  ],
                                ),
                                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 32),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Tap to continue · Press & hold to enter',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: LocsyColors.slate, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                // END CTA
              ],
            ),
          ),
        ),
      ),
    );
  }
}
