// ===============================================================
// FILE: lib/features/auth/screens/auth_choice.dart
// PURPOSE: Single entry page -> "Continue with Google".
//          After successful Google sign-in, force Phone OTP step.
// NOTES : Shows signed-in email + UID for quick verification.
// ===============================================================

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/theme.dart';
import '../../../app.dart';
import '../../../services/firebase_service.dart';

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});
  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  bool _busy = false;

  Future<void> _continueWithGoogle() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      // Real Google sign-in -> Firebase Auth (handled inside service)
      await FirebaseService.instance.signInWithGoogle();

      if (!mounted) return;

      // Read the signed-in user and surface info
      final u = FirebaseAuth.instance.currentUser;
      final email = u?.email ?? '(no email)';
      final uid   = u?.uid ?? '(no uid)';

      // Quick visual confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as $email\nUID: $uid')),
      );

      // After Google, enforce Phone OTP step
      Navigator.pushReplacementNamed(context, AppRoutes.phoneOtp);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _skipAuth() {
    // Skip authentication for testing - go directly to home screen
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register / Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Sign in with Google.\nWe will verify your phone next.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LocsyColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),

            // Google button
            ElevatedButton.icon(
              onPressed: _busy ? null : _continueWithGoogle,
              icon: const Icon(Icons.account_circle),
              label: Text(_busy ? 'Signing in…' : 'Continue with Google'),
              style: ElevatedButton.styleFrom(
                backgroundColor: LocsyColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),
            const Text(
              'Why both? Google secures your account; phone helps us contact you and prevent abuse.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: LocsyColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Skip button for testing
            TextButton(
              onPressed: _busy ? null : _skipAuth,
              child: const Text(
                'Skip for Testing (Development Mode)',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
