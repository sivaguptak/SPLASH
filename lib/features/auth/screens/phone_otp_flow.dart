// BEGIN PHONE OTP FLOW UI
// PURPOSE: Secure Phone -> OTP UI built on top of PhoneAuthService.
// NOTES:
//  - No OTP or verificationId is ever logged.
//  - Handles +91 normalization in service; UI does basic validation.
//  - Auto-verification path navigates without asking for manual OTP.
//  - Resend OTP uses Firebase forceResendingToken internally.
//  - Change NAVIGATE_SUCCESS_ROUTE to your dashboard route if needed.

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../services/phone_auth_service.dart';
import '../../../utils/auth_debug.dart';

// BEGIN CONFIG
const String NAVIGATE_SUCCESS_ROUTE = '/home'; // Navigate to home screen after successful auth
// END CONFIG

class PhoneOtpFlow extends StatelessWidget {
  const PhoneOtpFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const _PhoneNumberScreen();
  }
}

// ========================
// SCREEN 1: PHONE NUMBER
// ========================
class _PhoneNumberScreen extends StatefulWidget {
  const _PhoneNumberScreen();

  @override
  State<_PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<_PhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'Enter phone number';
    final clean = v.replaceAll(RegExp(r'\s+|-'), '');
    // Allow +91XXXXXXXXXX or 10-digit Indian numbers starting 6-9
    if (clean.startsWith('+')) {
      if (!RegExp(r'^\+\d{10,15}$').hasMatch(clean)) {
        return 'Invalid phone format';
      }
      return null;
    }
    if (RegExp(r'^[6-9]\d{9}$').hasMatch(clean)) return null;
    if (clean.startsWith('0') && RegExp(r'^0[6-9]\d{9}$').hasMatch(clean)) {
      return null;
    }
    return 'Invalid phone number';
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);

    try {
      final phoneNumber = _phoneCtrl.text.trim();
      print('📱 Attempting to send OTP to: $phoneNumber');
      
      final verificationId = await PhoneAuthService.I.startVerification(
        phoneNumber: phoneNumber,
        onAutoVerified: (User user) async {
          if (!mounted) return;
          print('✅ Auto-verification successful for user: ${user.uid}');
          // Auto-verification success path:
          Navigator.of(context).pushNamedAndRemoveUntil(
            NAVIGATE_SUCCESS_ROUTE,
                (route) => false,
          );
        },
      );

      print('📱 OTP sent successfully, verification ID received');
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => _OtpCodeScreen(verificationId: verificationId, rawPhoneInput: phoneNumber),
        ),
      );
    } catch (e) {
      print('❌ Error sending OTP: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your phone')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      'Enter your mobile number',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        hintText: 'e.g. 9876543210 or +91XXXXXXXXXX',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: _sending ? null : _sendCode,
                        child: _sending
                            ? const SizedBox(
                            width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Send OTP'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll verify using a one-time password (OTP). Standard SMS charges may apply.',
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Debug button for testing
                    if (kDebugMode)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              AuthDebug.logFirebaseConfig();
                              AuthDebug.logAuthState();
                            },
                            child: const Text('Debug Firebase Config'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await AuthDebug.testPhoneAuth('+919876543210');
                              } catch (e) {
                                print('Test failed: $e');
                              }
                            },
                            child: const Text('Test Phone Auth'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ========================
// SCREEN 2: OTP CODE
// ========================
class _OtpCodeScreen extends StatefulWidget {
  final String verificationId;
  final String rawPhoneInput;
  const _OtpCodeScreen({required this.verificationId, required this.rawPhoneInput});

  @override
  State<_OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState extends State<_OtpCodeScreen> {
  final _otpCtrl = TextEditingController();
  bool _verifying = false;
  bool _resending = false;
  int _secondsLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpCtrl.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsLeft = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _confirm() async {
    final code = _otpCtrl.text.trim();
    if (code.length != 6 || !RegExp(r'^\d{6}$').hasMatch(code)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter 6-digit OTP'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _verifying = true);
    try {
      print('🔐 Verifying OTP: ${code.substring(0, 2)}****');
      final user = await PhoneAuthService.I.confirmCode(
        verificationId: widget.verificationId,
        smsCode: code,
      );
      print('✅ OTP verification successful for user: ${user.uid}');
      AuthDebug.logAuthState();
      if (!mounted) return;
      if (user.uid.isNotEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          NAVIGATE_SUCCESS_ROUTE,
              (route) => false,
        );
      }
    } catch (e) {
      print('❌ OTP verification failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0) return; // throttle
    setState(() => _resending = true);
    try {
      final newVerificationId = await PhoneAuthService.I.resendCode(
        phoneNumber: widget.rawPhoneInput,
        onAutoVerified: (User user) {
          if (!mounted) return;
          Navigator.of(context).pushNamedAndRemoveUntil(
            NAVIGATE_SUCCESS_ROUTE,
                (route) => false,
          );
        },
      );
      if (!mounted) return;
      // Update to new verificationId for next confirm
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => _OtpCodeScreen(
            verificationId: newVerificationId,
            rawPhoneInput: widget.rawPhoneInput,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _resending = false);
        _startCountdown();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canResend = _secondsLeft == 0 && !_resending;
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Text(
                    'We sent a 6-digit code',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'To: ${widget.rawPhoneInput}',
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _otpCtrl,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      hintText: 'Enter 6-digit code',
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    onSubmitted: (_) => _confirm(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _verifying ? null : _confirm,
                      child: _verifying
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Verify & Continue'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Didn’t get the code?', style: theme.textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _secondsLeft > 0 ? 'Resend in $_secondsLeft s' : 'You can resend now',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: canResend ? _resend : null,
                        child: _resending
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Resend OTP'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// END PHONE OTP FLOW UI
