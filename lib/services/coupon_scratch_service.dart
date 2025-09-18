import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../data/models/enhanced_coupon.dart';

class CouponScratchService extends ChangeNotifier {
  final Map<String, EnhancedCoupon> _coupons = {};
  final Map<String, bool> _scratchStates = {};
  final Map<String, double> _scratchProgress = {};
  final Map<String, List<DateTime>> _scratchAttempts = {};

  // Get all coupons
  List<EnhancedCoupon> get coupons => _coupons.values.toList();

  // Get coupon by ID
  EnhancedCoupon? getCoupon(String id) => _coupons[id];

  // Get scratch state for a coupon
  bool isScratched(String couponId) => _scratchStates[couponId] ?? false;

  // Get scratch progress for a coupon
  double getScratchProgress(String couponId) => _scratchProgress[couponId] ?? 0.0;

  // Add a coupon
  void addCoupon(EnhancedCoupon coupon) {
    _coupons[coupon.couponInstance.id] = coupon;
    _scratchStates[coupon.couponInstance.id] = coupon.isScratched;
    _scratchProgress[coupon.couponInstance.id] = coupon.isScratched ? 1.0 : 0.0;
    notifyListeners();
  }

  // Add multiple coupons
  void addCoupons(List<EnhancedCoupon> coupons) {
    for (final coupon in coupons) {
      addCoupon(coupon);
    }
  }

  // Update scratch progress
  void updateScratchProgress(String couponId, double progress) {
    _scratchProgress[couponId] = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  // Complete scratch animation
  Future<void> completeScratch(String couponId) async {
    final coupon = _coupons[couponId];
    if (coupon == null) return;

    // Record scratch attempt
    _scratchAttempts[couponId] ??= [];
    _scratchAttempts[couponId]!.add(DateTime.now());

    // Update states
    _scratchStates[couponId] = true;
    _scratchProgress[couponId] = 1.0;

    // Update coupon
    final updatedCoupon = coupon.copyWith(
      isScratched: true,
      isRevealed: true,
    );
    _coupons[couponId] = updatedCoupon;

    notifyListeners();

    // Simulate network delay for reveal animation
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // Reset scratch state (for testing)
  void resetScratch(String couponId) {
    _scratchStates[couponId] = false;
    _scratchProgress[couponId] = 0.0;
    _scratchAttempts[couponId] = [];
    
    final coupon = _coupons[couponId];
    if (coupon != null) {
      _coupons[couponId] = coupon.copyWith(
        isScratched: false,
        isRevealed: false,
      );
    }
    
    notifyListeners();
  }

  // Get scratch statistics
  Map<String, dynamic> getScratchStats(String couponId) {
    final attempts = _scratchAttempts[couponId] ?? [];
    return {
      'attempts': attempts.length,
      'lastAttempt': attempts.isNotEmpty ? attempts.last : null,
      'isScratched': isScratched(couponId),
      'progress': getScratchProgress(couponId),
    };
  }

  // Generate scratch token (for security)
  String generateScratchToken(String couponId) {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomValue = random.nextInt(999999);
    return '${couponId}_${timestamp}_$randomValue';
  }

  // Validate scratch token
  bool validateScratchToken(String couponId, String token) {
    // Simple validation - in production, this would be more secure
    return token.startsWith(couponId);
  }

  // Get available coupons (not scratched, not expired)
  List<EnhancedCoupon> getAvailableCoupons() {
    return _coupons.values.where((coupon) {
      return !coupon.isExpired && 
             coupon.couponInstance.state == 'issued' && 
             !isScratched(coupon.couponInstance.id);
    }).toList();
  }

  // Get scratched coupons
  List<EnhancedCoupon> getScratchedCoupons() {
    return _coupons.values.where((coupon) {
      return isScratched(coupon.couponInstance.id);
    }).toList();
  }

  // Get expired coupons
  List<EnhancedCoupon> getExpiredCoupons() {
    return _coupons.values.where((coupon) {
      return coupon.isExpired;
    }).toList();
  }

  // Get redeemed coupons
  List<EnhancedCoupon> getRedeemedCoupons() {
    return _coupons.values.where((coupon) {
      return coupon.couponInstance.state == 'redeemed';
    }).toList();
  }

  // Clear all data (for testing)
  void clearAll() {
    _coupons.clear();
    _scratchStates.clear();
    _scratchProgress.clear();
    _scratchAttempts.clear();
    notifyListeners();
  }

  // Simulate scratch animation with haptic feedback
  Future<void> simulateScratchAnimation(String couponId) async {
    const steps = 20;
    const duration = Duration(milliseconds: 2000);
    const stepDuration = Duration(milliseconds: 100);

    for (int i = 0; i <= steps; i++) {
      final progress = i / steps;
      updateScratchProgress(couponId, progress);
      
      if (i < steps) {
        await Future.delayed(stepDuration);
      }
    }

    await completeScratch(couponId);
  }

  // Check if coupon can be scratched
  bool canScratch(String couponId) {
    final coupon = _coupons[couponId];
    if (coupon == null) return false;
    
    return coupon.canBeScratched && !isScratched(couponId);
  }

  // Get coupon count by status
  Map<String, int> getCouponCounts() {
    return {
      'total': _coupons.length,
      'available': getAvailableCoupons().length,
      'scratched': getScratchedCoupons().length,
      'expired': getExpiredCoupons().length,
      'redeemed': getRedeemedCoupons().length,
    };
  }
}
