// ===============================================================
// FILE: lib/features/auth/screens/auth_choice.dart
// PURPOSE: Single entry page -> "Continue with Google".
//          After Google (simulated), we force Phone OTP.
//          If the user was already registered, you'd skip to Home (later).
// NOTE: No Firebase code here; just UI + navigation stubs to keep build clean.
// ===============================================================

import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../app.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});
  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  bool _busy = false;

  // BEGIN simulate Google sign-in (no Firebase yet)
  Future<void> _continueWithGoogle() async {
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 700)); // pretend network
    if (!mounted) return;

    // TODO: When Firebase is added:
    //  - signInWithGoogle()
    //  - call backend /users/me to check exists
    //  - if exists -> go Home; else -> phone OTP (mandatory)
    Navigator.pushReplacementNamed(context, AppRoutes.phoneOtp);
    setState(() => _busy = false);
  }
  // END simulate

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register / Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Text(
              'Sign in with Google.\nWe will verify your phone next.',
              textAlign: TextAlign.center,
              style: TextStyle(color: LocsyColors.navy, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),

            // BEGIN Google button (UI only for now)
            ElevatedButton.icon(
              onPressed: _busy ? null : _continueWithGoogle,
              icon: const Icon(Icons.account_circle),
              label: Text(_busy ? 'Signing in…' : 'Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: LocsyColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            // END Google button

            const SizedBox(height: 12),
            const Text(
              'Why both? Google secures your account; phone helps us contact you and prevent abuse.',
              textAlign: TextAlign.center,
              style: TextStyle(color: LocsyColors.slate, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
