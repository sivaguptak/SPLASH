// ===============================================================
// FILE: lib/features/auth/screens/otp_verify.dart
// PURPOSE: Enter OTP and continue. Stub without Firebase.
// NEXT: After we add Firebase, verify code then link to same Google user.
// ===============================================================

import 'package:flutter/material.dart';
import '../../../app.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});
  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _otpCtrl = TextEditingController();
  bool _verifying = false;

  Future<void> _verify() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter 6-digit OTP')));
      return;
    }
    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 600)); // pretend verify
    if (!mounted) return;
    // TODO: If user exists → Dashboard; else → area capture
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.userDash, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    final phone = (ModalRoute.of(context)?.settings.arguments ?? '') as String? ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (phone.isNotEmpty)
              Text('OTP sent to: $phone',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: _otpCtrl,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: '6-digit OTP',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _verifying ? null : _verify,
              child: Text(_verifying ? 'Verifying…' : 'Verify & Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
