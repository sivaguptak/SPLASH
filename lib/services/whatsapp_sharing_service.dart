import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/shop_daily_update.dart';
import '../data/models/shop.dart';

class WhatsAppSharingService {
  static const String _baseUrl = 'https://locsy.app';
  
  /// Share a single update via WhatsApp
  static Future<void> shareUpdate({
    required ShopDailyUpdate update,
    required ShopModel shop,
    String? customMessage,
  }) async {
    final publicLink = '$_baseUrl/public/shop/${shop.id}/update/${update.id}';
    final message = customMessage ?? _generateUpdateMessage(update, shop, publicLink);
    
    await _launchWhatsApp(message);
  }
  
  /// Share shop link via WhatsApp
  static Future<void> shareShop({
    required ShopModel shop,
    String? customMessage,
  }) async {
    final shopLink = '$_baseUrl/shop/${shop.id}';
    final message = customMessage ?? _generateShopMessage(shop, shopLink);
    
    await _launchWhatsApp(message);
  }
  
  /// Share shop link to specific phone number
  static Future<void> shareShopToPhone({
    required ShopModel shop,
    required String phoneNumber,
    String? customMessage,
  }) async {
    final shopLink = '$_baseUrl/shop/${shop.id}';
    final message = customMessage ?? _generateShopMessage(shop, shopLink);
    
    await _launchWhatsAppToPhone(phoneNumber, message);
  }
  
  /// Share multiple updates as a collection
  static Future<void> shareUpdatesCollection({
    required List<ShopDailyUpdate> updates,
    required ShopModel shop,
    String? customMessage,
  }) async {
    final collectionLink = '$_baseUrl/public/shop/${shop.id}/updates';
    final message = customMessage ?? _generateCollectionMessage(updates, shop, collectionLink);
    
    await _launchWhatsApp(message);
  }
  
  /// Copy update link to clipboard
  static Future<void> copyUpdateLink({
    required ShopDailyUpdate update,
    required ShopModel shop,
  }) async {
    final publicLink = '$_baseUrl/public/shop/${shop.id}/update/${update.id}';
    await Clipboard.setData(ClipboardData(text: publicLink));
  }
  
  /// Copy shop link to clipboard
  static Future<void> copyShopLink({
    required ShopModel shop,
  }) async {
    final shopLink = '$_baseUrl/shop/${shop.id}';
    await Clipboard.setData(ClipboardData(text: shopLink));
  }
  
  /// Generate QR code data for sharing
  static String generateQRData({
    required ShopModel shop,
    ShopDailyUpdate? update,
  }) {
    if (update != null) {
      return '$_baseUrl/public/shop/${shop.id}/update/${update.id}';
    } else {
      return '$_baseUrl/shop/${shop.id}';
    }
  }
  
  /// Generate update message
  static String _generateUpdateMessage(ShopDailyUpdate update, ShopModel shop, String link) {
    final emoji = _getPriorityEmoji(update.priority);
    return '''$emoji *${update.title}*

${update.content}

📍 *${shop.name}*
${shop.address != null ? '${shop.address}\n' : ''}${shop.phoneNumber != null ? '📞 ${shop.phoneNumber}\n' : ''}
🔗 View Details: $link

#${shop.name.replaceAll(' ', '')} #Sweets #Offers #LocalBusiness''';
  }
  
  /// Generate shop message
  static String _generateShopMessage(ShopModel shop, String link) {
    return '''🏪 *${shop.name}*

${shop.description ?? 'Traditional Indian sweets and snacks'}

📍 *Location:* ${shop.address ?? 'Mumbai, Maharashtra'}
${shop.phoneNumber != null ? '📞 *Phone:* ${shop.phoneNumber}\n' : ''}
🕒 *Hours:* 9:00 AM - 10:00 PM

🔗 Visit our shop: $link

#${shop.name.replaceAll(' ', '')} #Sweets #LocalBusiness #Mumbai''';
  }
  
  /// Generate collection message
  static String _generateCollectionMessage(List<ShopDailyUpdate> updates, ShopModel shop, String link) {
    final activeUpdates = updates.where((u) => u.isActive).take(3).toList();
    
    String message = '''🏪 *${shop.name} - Latest Updates*

''';
    
    for (final update in activeUpdates) {
      final emoji = _getPriorityEmoji(update.priority);
      message += '''$emoji *${update.title}*
${update.content}

''';
    }
    
    if (activeUpdates.length < updates.length) {
      message += '... and ${updates.length - activeUpdates.length} more updates!\n\n';
    }
    
    message += '''📍 *${shop.name}*
${shop.address != null ? '${shop.address}\n' : ''}${shop.phoneNumber != null ? '📞 ${shop.phoneNumber}\n' : ''}
🔗 View All Updates: $link

#${shop.name.replaceAll(' ', '')} #Sweets #Offers #LocalBusiness''';
    
    return message;
  }
  
  /// Get emoji based on priority
  static String _getPriorityEmoji(int priority) {
    switch (priority) {
      case 1: return 'ℹ️';
      case 2: return '⭐';
      case 3: return '⚠️';
      case 4: return '🔥';
      case 5: return '🚨';
      default: return '📢';
    }
  }
  
  /// Launch WhatsApp with message
  static Future<void> _launchWhatsApp(String message) async {
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    final uri = Uri.parse(whatsappUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch WhatsApp');
    }
  }
  
  /// Launch WhatsApp to specific phone number
  static Future<void> _launchWhatsAppToPhone(String phoneNumber, String message) async {
    // Clean phone number
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final whatsappUrl = 'https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}';
    final uri = Uri.parse(whatsappUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch WhatsApp');
    }
  }
  
  /// Generate shareable text for different platforms
  static String generateShareableText({
    required ShopDailyUpdate update,
    required ShopModel shop,
    String platform = 'whatsapp',
  }) {
    final publicLink = '$_baseUrl/public/shop/${shop.id}/update/${update.id}';
    
    switch (platform.toLowerCase()) {
      case 'whatsapp':
        return _generateUpdateMessage(update, shop, publicLink);
      case 'telegram':
        return '''${update.title}

${update.content}

📍 ${shop.name}
${shop.address != null ? '${shop.address}\n' : ''}${shop.phoneNumber != null ? '📞 ${shop.phoneNumber}\n' : ''}
🔗 $publicLink''';
      case 'facebook':
        return '''${update.title}

${update.content}

Visit ${shop.name} for more details: $publicLink''';
      case 'twitter':
        return '''${update.title} - ${shop.name}

${update.content.length > 100 ? '${update.content.substring(0, 100)}...' : update.content}

$publicLink''';
      default:
        return '''${update.title}

${update.content}

${shop.name}
${shop.address ?? ''}
${shop.phoneNumber ?? ''}

$publicLink''';
    }
  }
  
  /// Validate phone number format
  static bool isValidPhoneNumber(String phoneNumber) {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(cleanPhone);
  }
  
  /// Format phone number for WhatsApp
  static String formatPhoneForWhatsApp(String phoneNumber) {
    String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Add +91 if it's an Indian number without country code
    if (cleanPhone.length == 10 && cleanPhone.startsWith(RegExp(r'[6-9]'))) {
      cleanPhone = '+91$cleanPhone';
    }
    
    // Remove + if it exists for WhatsApp URL
    return cleanPhone.replaceFirst('+', '');
  }
}
