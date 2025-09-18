import 'coupon_instance.dart';
import 'offer.dart';

class EnhancedCoupon {
  final CouponInstance couponInstance;
  final OfferModel offer;
  final String shopName;
  final String? shopImageUrl;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final bool isScratched;
  final bool isRevealed;
  final String? scratchToken;
  final Map<String, dynamic>? metadata;

  const EnhancedCoupon({
    required this.couponInstance,
    required this.offer,
    required this.shopName,
    this.shopImageUrl,
    required this.issuedAt,
    this.expiresAt,
    this.isScratched = false,
    this.isRevealed = false,
    this.scratchToken,
    this.metadata,
  });

  // Factory constructor from JSON
  factory EnhancedCoupon.fromJson(Map<String, dynamic> json) {
    return EnhancedCoupon(
      couponInstance: CouponInstance.fromJson(json['coupon_instance']),
      offer: OfferModel.fromJson(json['offer']),
      shopName: json['shop_name'] ?? 'Unknown Shop',
      shopImageUrl: json['shop_image_url'],
      issuedAt: DateTime.parse(json['issued_at']),
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
      isScratched: json['is_scratched'] ?? false,
      isRevealed: json['is_revealed'] ?? false,
      scratchToken: json['scratch_token'],
      metadata: json['metadata'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'coupon_instance': {
        'id': couponInstance.id,
        'offer_id': couponInstance.offerId,
        'issuer_shop_id': couponInstance.issuerShopId,
        'distributor_shop_id': couponInstance.distributorShopId,
        'state': couponInstance.state,
      },
      'offer': {
        'id': offer.id,
        'shop_id': offer.shopId,
        'title': offer.title,
        'pricing_mode': offer.pricingMode,
        'actual_price': offer.actualPrice,
        'offer_price': offer.offerPrice,
        'flat_off_amount': offer.flatOffAmount,
        'percent_off': offer.percentOff,
        'min_purchase_amt': offer.minPurchaseAmt,
      },
      'shop_name': shopName,
      'shop_image_url': shopImageUrl,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
      'is_scratched': isScratched,
      'is_revealed': isRevealed,
      'scratch_token': scratchToken,
      'metadata': metadata,
    };
  }

  // Copy with method for immutable updates
  EnhancedCoupon copyWith({
    CouponInstance? couponInstance,
    OfferModel? offer,
    String? shopName,
    String? shopImageUrl,
    DateTime? issuedAt,
    DateTime? expiresAt,
    bool? isScratched,
    bool? isRevealed,
    String? scratchToken,
    Map<String, dynamic>? metadata,
  }) {
    return EnhancedCoupon(
      couponInstance: couponInstance ?? this.couponInstance,
      offer: offer ?? this.offer,
      shopName: shopName ?? this.shopName,
      shopImageUrl: shopImageUrl ?? this.shopImageUrl,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isScratched: isScratched ?? this.isScratched,
      isRevealed: isRevealed ?? this.isRevealed,
      scratchToken: scratchToken ?? this.scratchToken,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get formatted discount text for display
  String get discountText {
    switch (offer.pricingMode) {
      case 'percent':
        return '${offer.percentOff}%';
      case 'flat':
        return '₹${offer.flatOffAmount?.toStringAsFixed(0)}';
      case 'actual_offer':
        if (offer.actualPrice != null && offer.offerPrice != null) {
          final discount = offer.actualPrice! - offer.offerPrice!;
          return '₹${discount.toStringAsFixed(0)}';
        }
        return 'Special';
      default:
        return 'Special';
    }
  }

  // Get description text for display
  String get descriptionText {
    switch (offer.pricingMode) {
      case 'percent':
        return 'Get ${offer.percentOff}% off on your purchase';
      case 'flat':
        return 'Get ₹${offer.flatOffAmount?.toStringAsFixed(0)} off on orders above ₹${offer.minPurchaseAmt?.toStringAsFixed(0) ?? '0'}';
      case 'actual_offer':
        if (offer.actualPrice != null && offer.offerPrice != null) {
          return 'Pay ₹${offer.offerPrice!.toStringAsFixed(0)} instead of ₹${offer.actualPrice!.toStringAsFixed(0)}';
        }
        return offer.title;
      default:
        return offer.title;
    }
  }

  // Get formatted expiry date
  String get formattedExpiryDate {
    if (expiresAt == null) return 'No expiry';
    
    final now = DateTime.now();
    final difference = expiresAt!.difference(now);
    
    if (difference.isNegative) {
      return 'Expired';
    } else if (difference.inDays == 0) {
      return 'Expires today';
    } else if (difference.inDays == 1) {
      return 'Expires tomorrow';
    } else if (difference.inDays < 7) {
      return 'Expires in ${difference.inDays} days';
    } else {
      return 'Expires ${expiresAt!.day}/${expiresAt!.month}/${expiresAt!.year}';
    }
  }

  // Check if coupon is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // Check if coupon can be scratched
  bool get canBeScratched {
    return !isScratched && !isRevealed && !isExpired && couponInstance.state == 'issued';
  }

  // Check if coupon can be redeemed
  bool get canBeRedeemed {
    return isRevealed && !isExpired && couponInstance.state == 'issued';
  }

  // Get coupon status for display
  String get statusText {
    if (isExpired) return 'Expired';
    if (couponInstance.state == 'redeemed') return 'Redeemed';
    if (couponInstance.state == 'void') return 'Void';
    if (isRevealed) return 'Ready to use';
    if (isScratched) return 'Scratched';
    return 'Available';
  }

  // Get status color for UI
  String get statusColor {
    if (isExpired || couponInstance.state == 'void') return 'red';
    if (couponInstance.state == 'redeemed') return 'green';
    if (isRevealed) return 'blue';
    if (isScratched) return 'orange';
    return 'grey';
  }
}
