// ===============================================================
// FILE: lib/features/auth/screens/login_phone.dart
// PURPOSE: Collect phone number and move to OTP screen.
// NOTE: No Firebase yet; just validates and navigates.
// ===============================================================

import 'package:flutter/material.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});
  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final _ctrl = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _sending = false;

  // BEGIN validation
  String? _validatePhone(String? v) {
    final s = (v ?? '').replaceAll(' ', '');
    if (s.isEmpty) return 'Phone required';
    // simple 10-digit check for India; adjust as needed
    if (!RegExp(r'^\+?\d{10,13}$').hasMatch(s)) return 'Enter valid mobile number';
    return null;
  }
  // END validation

  Future<void> _sendOtp() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 600)); // pretend send
    if (!mounted) return;
    Navigator.pushNamed(context, '/auth/otp-verify', arguments: _ctrl.text.trim());
    setState(() => _sending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify phone')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                controller: _ctrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile number',
                  hintText: '+91xxxxxxxxxx',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _sending ? null : _sendOtp,
                child: Text(_sending ? 'Sending…' : 'Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
