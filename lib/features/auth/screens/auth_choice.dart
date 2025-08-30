// ===============================================================
// FILE: lib/features/auth/screens/auth_choice.dart
// PURPOSE: Single entry page -> "Continue with Google".
//          After Google, we force Phone OTP (mandatory).
//          If the user was already registered, you'd skip to Home (later).
// NOTE: Now uses real Firebase Google sign-in via FirebaseService.
// ===============================================================

import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../app.dart';
// BEGIN add_firebase_service_import
import '../../../services/firebase_service.dart';
// END add_firebase_service_import

class AuthChoiceScreen extends StatefulWidget {
  const AuthChoiceScreen({super.key});
  @override
  State<AuthChoiceScreen> createState() => _AuthChoiceScreenState();
}

class _AuthChoiceScreenState extends State<AuthChoiceScreen> {
  bool _busy = false;

  // BEGIN google_signin_real
  Future<void> _continueWithGoogle() async {
    setState(() => _busy = true);
    try {
      // Real Google sign-in -> Firebase Auth
      await FirebaseService.instance.signInWithGoogle();

      if (!mounted) return;
      // Flow: After Google, enforce Phone OTP
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
  // END google_signin_real

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
              style: TextStyle(
                color: LocsyColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 24),

            // BEGIN Google button
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
              style: TextStyle(
                color: LocsyColors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
