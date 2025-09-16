// BEGIN PHONE AUTH SERVICE
// PURPOSE: Encapsulate Firebase Phone OTP verification & sign-in securely.
// SECURITY NOTES:
//  - Never log OTP or verificationId.
//  - Normalize Indian phone numbers to +91 format.
//  - Do NOT auto sign-in on verificationCompleted; store credential and let UI confirm.
//  - Handle error codes and throttle resends with forceResendingToken.
//  - Expose only minimal, safe methods for UI layer.
// DEPENDENCIES: firebase_auth.

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PhoneAuthService {
  // Singleton
  PhoneAuthService._();
  static final PhoneAuthService I = PhoneAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // In-memory state (not persisted)
  String? _lastVerificationId;
  int? _resendToken;
  PhoneAuthCredential? _autoCredential; // set if verificationCompleted fires

  /// Auth state changes to let UI navigate after sign-in automatically.
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  /// Returns currently signed-in user (or null).
  User? get currentUser => _auth.currentUser;

  /// Whether an auto-verified credential is available to use.
  bool get hasAutoCredential => _autoCredential != null;

  /// Normalize Indian numbers:
  /// - Removes spaces/dashes.
  /// - Ensures it starts with +91 where applicable.
  String _normalizeIndianPhone(String raw) {
    final clean = raw.replaceAll(RegExp(r'\s+|-'), '');
    if (clean.startsWith('+91')) return clean;
    if (clean.startsWith('0')) return '+91${clean.substring(1)}';
    if (clean.length == 10 && RegExp(r'^[6-9]\d{9}$').hasMatch(clean)) {
      return '+91$clean';
    }
    if (clean.startsWith('+')) return clean; // already international format
    return clean; // let Firebase validate
  }

  /// Start phone number verification.
  /// Resolves when code is SENT (returns verificationId).
  /// If auto-verification succeeds, we store a credential (no auto sign-in).
  Future<String> startVerification({
    required String phoneNumber,
    required void Function(User user) onAutoVerified, // kept for API compatibility; not called auto
    Duration timeout = const Duration(seconds: 60),
    bool forceResend = false,
  }) async {
    final normalized = _normalizeIndianPhone(phoneNumber);
    final completer = Completer<String>();

    await _auth.verifyPhoneNumber(
      phoneNumber: normalized,
      timeout: timeout,
      forceResendingToken: forceResend ? _resendToken : null,

      // IMPORTANT: do NOT sign in automatically here
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Store the credential; UI will decide when to sign in.
        _autoCredential = credential;
        // No auto-callback to onAutoVerified to avoid silent sign-in.
      },

      verificationFailed: (FirebaseAuthException e) {
        print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
        print('❌ Error details: ${e.toString()}');
        completer.completeError(_mapError(e));
      },

      codeSent: (String verificationId, int? forceResendToken) {
        _lastVerificationId = verificationId;
        _resendToken = forceResendToken;

        if (!completer.isCompleted) {
          completer.complete(verificationId);
        }
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        _lastVerificationId = verificationId;
      },
    );

    return completer.future;
  }

  /// Verify the OTP code and sign in.
  Future<User> confirmCode({
    String? verificationId,
    required String smsCode,
  }) async {
    final verId = verificationId ?? _lastVerificationId;
    if (verId == null) {
      throw Exception('No verification session found. Please request a new code.');
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verId,
        smsCode: smsCode,
      );
      final cred = await _auth.signInWithCredential(credential);
      final user = cred.user;
      if (user == null) {
        throw Exception('Sign-in failed. Please try again.');
      }
      // Clear transient state after successful sign-in
      _autoCredential = null;
      _lastVerificationId = null;
      _resendToken = null;
      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  /// Use the auto-verified credential (if available) to sign in.
  Future<User> signInWithAutoCredential() async {
    final cred = _autoCredential;
    if (cred == null) {
      throw Exception('No verified credential. Please request a new code.');
    }
    try {
      final res = await _auth.signInWithCredential(cred);
      final user = res.user;
      if (user == null) {
        throw Exception('Sign-in failed. Please try again.');
      }
      // Clear transient state after successful sign-in
      _autoCredential = null;
      _lastVerificationId = null;
      _resendToken = null;
      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  /// Resend the OTP (throttled by Firebase using _resendToken).
  Future<String> resendCode({
    required String phoneNumber,
    required void Function(User user) onAutoVerified, // not used for auto sign-in
    Duration timeout = const Duration(seconds: 60),
  }) {
    return startVerification(
      phoneNumber: phoneNumber,
      onAutoVerified: onAutoVerified,
      timeout: timeout,
      forceResend: true,
    );
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
    // Clear transient state on sign-out
    _autoCredential = null;
    _lastVerificationId = null;
    _resendToken = null;
  }

  /// Friendly error messages (safe to show in UI).
  Exception _mapError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return Exception('Invalid phone number format.');
      case 'missing-phone-number':
        return Exception('Please enter your phone number.');
      case 'captcha-check-failed':
        return Exception('Verification failed. Please try again.');
      case 'quota-exceeded':
        return Exception('Too many requests. Please try after some time.');
      case 'session-expired':
        return Exception('Session expired. Please request a new code.');
      case 'invalid-verification-code':
        return Exception('Incorrect OTP. Please recheck and try again.');
      case 'user-disabled':
        return Exception('Your account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      case 'network-request-failed':
        return Exception('Network error. Check your connection.');
      case 'app-not-authorized':
        return Exception('App not authorized for phone authentication. Please contact support.');
      case 'missing-app-credential':
        return Exception('App credential missing. Please contact support.');
      case 'invalid-app-credential':
        return Exception('Invalid app credential. Please contact support.');
      case 'phone-number-already-exists':
        return Exception('This phone number is already registered.');
      case 'credential-already-in-use':
        return Exception('This phone number is already linked to another account.');
      case 'unknown':
        return Exception('Firebase configuration error. Please check your Firebase Console setup.');
      default:
        return Exception('Authentication error (${e.code}). Please try again.');
    }
  }
}
// END PHONE AUTH SERVICE
