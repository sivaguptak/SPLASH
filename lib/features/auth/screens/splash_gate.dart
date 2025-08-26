// ===============================================================
// FILE: lib/features/auth/screens/splash_gate.dart
// PURPOSE: LOCSY splash with intro animation + progress ring.
// CHANGE:  Keep animated circle + arrow; REMOVE double-tap;
//          ADD single tap to continue (while long-press still works).
// NOTE:    Asset path kept EXACT: 'assets/images/locsy_avatar.png'
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
  // END intro animation (avatar + texts)

  // BEGIN hold-to-enter progress (ring) + CTA state
  late final AnimationController _hold; // completes → navigate
  bool _showEnter = false; // show CTA after intro completes
  // END hold-to-enter progress (ring) + CTA state

  @override
  void initState() {
    super.initState();

    // BEGIN setup intro animations
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
      if (s == AnimationStatus.completed && mounted) {
        setState(() => _showEnter = true);
      }
    });
    // END setup intro animations

    // BEGIN hold progress controller (kept for ring animation)
    _hold = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _hold.addStatusListener((s) {
      if (s == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelect);
      }
    });
    // END hold progress controller
  }

  @override
  void dispose() {
    // BEGIN dispose controllers
    _intro.dispose();
    _hold.dispose();
    // END dispose controllers
    super.dispose();
  }

  // BEGIN navigation helper (single tap)
  void _nudgeForward() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelect);
  }
  // END navigation helper (single tap)

  @override
  Widget build(BuildContext context) {
    // BEGIN scaffold
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
                      // NOTE: path preserved exactly
                      'assets/images/locsy_avatar.png',
                      width: 220,
                      height: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // END avatar
                const SizedBox(height: 16),

                // BEGIN title "LOCSY"
                FadeTransition(
                  opacity: _fadeT1,
                  child: SlideTransition(
                    position: _slideT1,
                    child: const Text(
                      'LOCSY',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: LocsyColors.orange,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                // END title "LOCSY"
                const SizedBox(height: 6),

                // BEGIN subtitle 1
                FadeTransition(
                  opacity: _fadeT2,
                  child: SlideTransition(
                    position: _slideT2,
                    child: const Text(
                      'Local Services for you',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: LocsyColors.orange,
                      ),
                    ),
                  ),
                ),
                // END subtitle 1
                const SizedBox(height: 10),

                // BEGIN subtitle 2
                FadeTransition(
                  opacity: _fadeT3,
                  child: SlideTransition(
                    position: _slideT3,
                    child: const Text(
                      'Mana Services · Mana Area\nMana App',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: LocsyColors.navy,
                      ),
                    ),
                  ),
                ),
                // END subtitle 2

                const SizedBox(height: 32),

                // ---------- CTA AREA (kept ring + arrow, changed interaction) ----------
                if (_showEnter)
                  GestureDetector(
                    // BEGIN keep long-press ring behavior
                    onLongPressStart: (_) => _hold.forward(from: 0),
                    onLongPressEnd: (_) => _hold.reverse(),
                    // END keep long-press ring behavior

                    // BEGIN change: SINGLE TAP → continue (double-tap removed)
                    onTap: _nudgeForward,
                    // END change

                    child: Column(
                      children: [
                        // BEGIN animated progress ring with center arrow (UNCHANGED)
                        AnimatedBuilder(
                          animation: _hold,
                          builder: (_, __) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 96,
                                  height: 96,
                                  child: CircularProgressIndicator(
                                    value: _hold.value == 0 ? null : _hold.value,
                                    strokeWidth: 6,
                                    color: LocsyColors.orange,
                                    backgroundColor: LocsyColors.cream,
                                  ),
                                ),
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: LocsyColors.navy,
                                    borderRadius: BorderRadius.circular(36),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.08),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        // END animated progress ring with center arrow (UNCHANGED)

                        const SizedBox(height: 10),

                        // BEGIN hint text (updated copy)
                        const Text(
                          'Tap to continue ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: LocsyColors.slate,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // END hint text
                      ],
                    ),
                  ),
                // ---------- END CTA AREA ----------
              ],
            ),
          ),
        ),
      ),
    );
    // END scaffold
  }
}
