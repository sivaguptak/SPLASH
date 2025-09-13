// BEGIN AUTH DEBUG UTILITY
// PURPOSE: Debug utility for phone authentication testing
// USAGE: Call AuthDebug.logAuthState() to check current auth status

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthDebug {
  static void logAuthState() {
    if (kDebugMode) {
      final user = FirebaseAuth.instance.currentUser;
      print('🔍 Auth Debug Info:');
      print('  - Current User: ${user?.uid ?? 'None'}');
      print('  - Phone Number: ${user?.phoneNumber ?? 'None'}');
      print('  - Email: ${user?.email ?? 'None'}');
      print('  - Email Verified: ${user?.emailVerified ?? false}');
      print('  - Phone Verified: ${user?.phoneNumber != null}');
      print('  - Providers: ${user?.providerData.map((p) => p.providerId).join(', ') ?? 'None'}');
    }
  }

  static void logFirebaseConfig() {
    if (kDebugMode) {
      final app = FirebaseAuth.instance.app;
      final options = app.options;
      print('🔥 Firebase Config:');
      print('  - Project ID: ${options.projectId}');
      print('  - App ID: ${options.appId}');
      print('  - API Key: ${options.apiKey}');
      print('  - Auth Domain: ${options.authDomain}');
    }
  }

  static Future<void> testPhoneAuth(String phoneNumber) async {
    if (kDebugMode) {
      print('🧪 Testing Phone Auth for: $phoneNumber');
      try {
        // This will trigger the verification process
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 30),
          verificationCompleted: (credential) {
            print('✅ Auto-verification completed');
          },
          verificationFailed: (error) {
            print('❌ Verification failed: ${error.code} - ${error.message}');
          },
          codeSent: (verificationId, resendToken) {
            print('📱 Code sent successfully');
            print('  - Verification ID: ${verificationId.substring(0, 20)}...');
          },
          codeAutoRetrievalTimeout: (verificationId) {
            print('⏰ Auto-retrieval timeout');
          },
        );
      } catch (e) {
        print('❌ Test failed: $e');
      }
    }
  }
}
// END AUTH DEBUG UTILITY
