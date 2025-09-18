import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BackButtonService {
  static DateTime? _lastBackPressed;
  static const Duration _doubleTapDuration = Duration(seconds: 2);

  /// Handle back button press with double-tap confirmation
  static Future<bool> handleBackPress(BuildContext context) async {
    final now = DateTime.now();
    
    // If this is the first back press or enough time has passed since last press
    if (_lastBackPressed == null || 
        now.difference(_lastBackPressed!) > _doubleTapDuration) {
      
      // Show "Press again to exit" message
      _lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Press again to exit',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFF7A00),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      
      // Return false to prevent exit
      return false;
    }
    
    // If pressed again within the time limit, exit the app properly
    SystemNavigator.pop(); // Properly exit the app
    return true;
  }

  /// Handle back button for screens that should navigate to previous screen
  static Future<bool> handleBackNavigation(BuildContext context) async {
    // Check if we can pop (go back to previous screen)
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return false; // Prevent default back behavior
    }
    
    // If no previous screen, show exit confirmation
    return handleBackPress(context);
  }

  /// Handle back button for specific screens that should go to home
  static Future<bool> handleBackToHome(BuildContext context) async {
    // Navigate to home screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home', // Home route from AppRoutes
      (route) => false,
    );
    return false; // Prevent default back behavior
  }
}
