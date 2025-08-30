// BEGIN firebase_service
// File: lib/services/firebase_service.dart
// Purpose: Centralized Firebase Auth for LOCSY
//  - Google Sign-In -> Firebase
//  - Phone OTP (send + verify)
//  - Link phone with the same user (single uid)
//  - Heavy comments with BEGIN/END markers as requested

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// BEGIN FirebaseService
/// Usage pattern:
///   final auth = FirebaseService.instance;
///   await auth.signInWithGoogle();                 // Step 1
///   await auth.startPhoneVerification('+91...');   // Step 2: gets code
///   await auth.verifyOtpAndLink(verificationId, smsCode); // Step 3: link phone
class FirebaseService {
  FirebaseService._();
  static final FirebaseService instance = FirebaseService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  /// Stream of current user (null if signed out)
  Stream<User?> get userChanges => _auth.userChanges();

  User? get currentUser => _auth.currentUser;

  /// BEGIN Google Sign-In flow
  /// - Opens Google account picker
  /// - Exchanges tokens for Firebase credential
  /// - Signs in (or returns existing user)
  /// Throws [FirebaseAuthException] (wrapped) if something fails.
  Future<UserCredential> signInWithGoogle() async {
    // 1) Ask user to pick a Google account
    final GoogleSignInAccount? gUser = await _google.signIn();
    if (gUser == null) {
      throw FirebaseAuthException(
        code: 'aborted-by-user',
        message: 'Google sign-in was cancelled.',
      );
    }

    // 2) Get the Google auth tokens
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // 3) Build a Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // 4) Sign in to Firebase
    final result = await _auth.signInWithCredential(credential);

    // Optional: ensure email is verified for Google providers
    // (Google accounts are considered verified; no extra action needed)

    return result;
  }
  /// END Google Sign-In flow

  /// BEGIN Start phone verification
  /// Sends OTP to the given E.164 phone number (e.g., +91XXXXXXXXXX).
  /// Callbacks:
  ///  - onCodeSent: returns verificationId + (optional) forceResendingToken
  ///  - onAutoVerified: if Android auto-detects OTP; you can auto-link/sign-in
  ///  - onFailed: provide user-friendly error message
  Future<void> startPhoneVerification(
      String phoneNumber, {
        required void Function(String verificationId, int? resendToken) onCodeSent,
        void Function(UserCredential cred)? onAutoVerified,
        void Function(String message)? onFailed,
        Duration timeout = const Duration(seconds: 60),
      }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval (Android): link if already signed-in with Google
          try {
            final user = _auth.currentUser;
            UserCredential cred;
            if (user != null) {
              cred = await user.linkWithCredential(credential);
            } else {
              cred = await _auth.signInWithCredential(credential);
            }
            if (onAutoVerified != null) onAutoVerified(cred);
          } catch (e) {
            if (onFailed != null) onFailed(_friendlyError(e));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          if (onFailed != null) onFailed(_friendlyAuthError(e));
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          onCodeSent(verificationId, forceResendingToken);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // No-op; UI will handle manual entry.
        },
      );
    } catch (e) {
      if (onFailed != null) onFailed(_friendlyError(e));
    }
  }
  /// END Start phone verification

  /// BEGIN Verify OTP & link phone to current user (preferred)
  /// If a user is already signed-in (Google), links phone to that user.
  /// If not signed-in, this will sign in using the phone credential.
  Future<UserCredential> verifyOtpAndLink({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final user = _auth.currentUser;
    if (user != null) {
      // Link phone to existing user (keeps same uid)
      try {
        return await user.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        // If already linked, try reauthenticate/update instead
        if (e.code == 'provider-already-linked') {
          return await _auth.signInWithCredential(credential);
        }
        rethrow;
      }
    } else {
      // No user yet → sign in with phone
      return await _auth.signInWithCredential(credential);
    }
  }
  /// END Verify OTP & link phone

  /// BEGIN Sign out
  Future<void> signOut() async {
    // Sign out from both Firebase and Google (if used)
    await Future.wait([
      _auth.signOut(),
      _google.signOut(),
    ]);
  }
  /// END Sign out

  /// BEGIN Helpers: error mapping
  String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'Invalid OTP. Please check and try again.';
      case 'session-expired':
        return 'OTP session expired. Please request a new code.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'aborted-by-user':
        return 'Cancelled by user.';
      default:
        return e.message ?? 'Authentication error (${e.code}).';
    }
  }

  String _friendlyError(Object e) {
    if (e is FirebaseAuthException) return _friendlyAuthError(e);
    return 'Something went wrong. Please try again.';
    // For debugging, you can log e.toString()
  }
/// END Helpers
}
/// END FirebaseService
// END firebase_service
