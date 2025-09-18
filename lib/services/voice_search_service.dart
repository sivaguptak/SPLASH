import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceSearchService {
  static const MethodChannel _channel = MethodChannel('voice_search');

  /// Check if speech recognition is available on the device
  static Future<bool> isAvailable() async {
    try {
      final bool result = await _channel.invokeMethod('isAvailable');
      return result;
    } catch (e) {
      print('Error checking speech recognition availability: $e');
      return false;
    }
  }

  /// Start listening for speech and return the recognized text
  static Future<String?> startListening() async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission denied');
      }

      // Start speech recognition
      final String? result = await _channel.invokeMethod('startListening');
      return result;
    } catch (e) {
      print('Error during speech recognition: $e');
      return null;
    }
  }

  /// Stop listening for speech
  static Future<void> stopListening() async {
    try {
      await _channel.invokeMethod('stopListening');
    } catch (e) {
      print('Error stopping speech recognition: $e');
    }
  }
}
