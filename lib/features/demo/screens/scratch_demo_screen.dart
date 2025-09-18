import 'package:flutter/material.dart';
import '../../../widgets/scratch_coupon_widget.dart';
import '../../../core/theme.dart';

class ScratchDemoScreen extends StatefulWidget {
  const ScratchDemoScreen({super.key});

  @override
  State<ScratchDemoScreen> createState() => _ScratchDemoScreenState();
}

class _ScratchDemoScreenState extends State<ScratchDemoScreen> {
  final List<Map<String, dynamic>> _demoCoupons = [
    {
      'id': '1',
      'title': 'Pizza Palace',
      'description': 'Get 20% off on any pizza order above ₹500',
      'discount': '20%',
      'expiryDate': 'Dec 31, 2024',
      'isScratched': false,
      'backgroundColor': LocsyColors.cream,
      'scratchColor': LocsyColors.slate,
    },
    {
      'id': '2',
      'title': 'Coffee Corner',
      'description': 'Buy 2 get 1 free on all beverages',
      'discount': 'B2G1',
      'expiryDate': 'Jan 15, 2025',
      'isScratched': false,
      'backgroundColor': LocsyColors.cream,
      'scratchColor': LocsyColors.navy,
    },
    {
      'id': '3',
      'title': 'Fashion Store',
      'description': 'Flat ₹500 off on orders above ₹2000',
      'discount': '₹500',
      'expiryDate': 'Feb 28, 2025',
      'isScratched': true,
      'backgroundColor': LocsyColors.cream,
      'scratchColor': LocsyColors.orange,
    },
    {
      'id': '4',
      'title': 'Tech Gadgets',
      'description': 'Special discount on latest smartphones',
      'discount': '15%',
      'expiryDate': 'Mar 10, 2025',
      'isScratched': false,
      'backgroundColor': LocsyColors.cream,
      'scratchColor': LocsyColors.slate,
    },
  ];

  void _onCouponScratched(String couponId) {
    setState(() {
      final couponIndex = _demoCoupons.indexWhere((c) => c['id'] == couponId);
      if (couponIndex != -1) {
        _demoCoupons[couponIndex]['isScratched'] = true;
      }
    });
    
    // Show success message with haptic feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.white),
            SizedBox(width: 8),
            Text('🎉 Coupon revealed! You can now use it.'),
          ],
        ),
        backgroundColor: LocsyColors.orange,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _resetAllCoupons() {
    setState(() {
      for (var coupon in _demoCoupons) {
        coupon['isScratched'] = false;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All coupons reset! You can scratch them again.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scratchedCount = _demoCoupons.where((c) => c['isScratched']).length;
    final totalCount = _demoCoupons.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scratch Coupon Demo'),
        backgroundColor: LocsyColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetAllCoupons,
            tooltip: 'Reset all coupons',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              LocsyColors.navy,
              LocsyColors.cream,
            ],
            stops: const [0.0, 0.2],
          ),
        ),
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: LocsyColors.orange,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Icon(
                            Icons.card_giftcard,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Scratch & Win!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: LocsyColors.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scratch the silver layer to reveal your coupon',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: LocsyColors.slate,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: LocsyColors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$scratchedCount of $totalCount coupons revealed',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: LocsyColors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Instructions
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: LocsyColors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.touch_app,
                    color: LocsyColors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'How to scratch:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: LocsyColors.navy,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Touch and drag your finger across the silver layer to reveal the coupon underneath',
                          style: TextStyle(
                            fontSize: 12,
                            color: LocsyColors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Coupons list
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: LocsyColors.cream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 20),
                  itemCount: _demoCoupons.length,
                  itemBuilder: (context, index) {
                    final coupon = _demoCoupons[index];
                    return ScratchCouponWidget(
                      title: coupon['title'],
                      description: coupon['description'],
                      discount: coupon['discount'],
                      expiryDate: coupon['expiryDate'],
                      isScratched: coupon['isScratched'],
                      backgroundColor: coupon['backgroundColor'],
                      scratchColor: coupon['scratchColor'],
                      onScratchComplete: () => _onCouponScratched(coupon['id']),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
