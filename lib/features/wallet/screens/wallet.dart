import 'package:flutter/material.dart';
import '../../../widgets/scratch_coupon_widget.dart';
import '../../../core/theme.dart';
import '../../../app.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<Map<String, dynamic>> _coupons = [
    {
      'id': '1',
      'title': 'Pizza Palace',
      'description': 'Get 20% off on any pizza order',
      'discount': '20%',
      'expiryDate': 'Dec 31, 2024',
      'isScratched': false,
    },
    {
      'id': '2',
      'title': 'Coffee Corner',
      'description': 'Buy 2 get 1 free on all beverages',
      'discount': 'B2G1',
      'expiryDate': 'Jan 15, 2025',
      'isScratched': false,
    },
    {
      'id': '3',
      'title': 'Fashion Store',
      'description': 'Flat ₹500 off on orders above ₹2000',
      'discount': '₹500',
      'expiryDate': 'Feb 28, 2025',
      'isScratched': true,
    },
  ];

  void _onCouponScratched(String couponId) {
    setState(() {
      final couponIndex = _coupons.indexWhere((c) => c['id'] == couponId);
      if (couponIndex != -1) {
        _coupons[couponIndex]['isScratched'] = true;
      }
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🎉 Coupon revealed! You can now use it.'),
        backgroundColor: LocsyColors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        backgroundColor: LocsyColors.navy,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.scratchDemo),
            tooltip: 'Scratch Demo',
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
            stops: const [0.0, 0.3],
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: LocsyColors.orange,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.card_giftcard,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'My Coupons',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: LocsyColors.navy,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_coupons.length} coupons available',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LocsyColors.slate,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
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
                child: _coupons.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.card_giftcard_outlined,
                              size: 64,
                              color: LocsyColors.slate,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No coupons yet',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: LocsyColors.slate,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Visit nearby shops to collect coupons!',
                              style: TextStyle(
                                fontSize: 14,
                                color: LocsyColors.slate,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 16),
                        itemCount: _coupons.length,
                        itemBuilder: (context, index) {
                          final coupon = _coupons[index];
                          return ScratchCouponWidget(
                            title: coupon['title'],
                            description: coupon['description'],
                            discount: coupon['discount'],
                            expiryDate: coupon['expiryDate'],
                            isScratched: coupon['isScratched'],
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
