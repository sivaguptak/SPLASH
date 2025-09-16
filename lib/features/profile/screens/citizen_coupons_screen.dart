import 'package:flutter/material.dart';
import 'dart:math';

class CitizenCouponsScreen extends StatefulWidget {
  const CitizenCouponsScreen({super.key});

  @override
  State<CitizenCouponsScreen> createState() => _CitizenCouponsScreenState();
}

class _CitizenCouponsScreenState extends State<CitizenCouponsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scratchController;
  late AnimationController _revealController;
  final List<CouponModel> _coupons = [
    CouponModel(
      id: '1',
      title: 'Fresh Mart',
      description: '20% OFF on Groceries',
      discount: '20%',
      code: 'FRESH20',
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      isScratched: false,
      isUsed: false,
      shopName: 'Fresh Mart',
      shopAddress: 'Main Road, Near Temple',
    ),
    CouponModel(
      id: '2',
      title: 'Quick Cuts',
      description: '₹50 OFF on Haircut',
      discount: '₹50',
      code: 'CUT50',
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      isScratched: true,
      isUsed: false,
      shopName: 'Quick Cuts',
      shopAddress: 'Market Street',
    ),
    CouponModel(
      id: '3',
      title: 'Power Solutions',
      description: '15% OFF on Electrical Work',
      discount: '15%',
      code: 'POWER15',
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      isScratched: false,
      isUsed: false,
      shopName: 'Power Solutions',
      shopAddress: 'Industrial Area',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scratchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scratchController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A00),
        elevation: 0,
        title: const Text(
          'My Coupons',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _coupons.length,
              itemBuilder: (context, index) {
                return _buildCouponCard(_coupons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFFF7A00),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Scratch & Reveal Your Coupons',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${_coupons.where((c) => !c.isUsed).length} Active Coupons Available',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(CouponModel coupon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Stack(
        children: [
          // Coupon Card
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                // Left side - Shop info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF7A00).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.store,
                            color: Color(0xFFFF7A00),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          coupon.shopName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coupon.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Expires: ${_formatDate(coupon.expiryDate)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right side - Scratch area
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF7A00),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: coupon.isScratched
                        ? _buildRevealedContent(coupon)
                        : _buildScratchArea(coupon),
                  ),
                ),
              ],
            ),
          ),
          // Used overlay
          if (coupon.isUsed)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'USED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScratchArea(CouponModel coupon) {
    return GestureDetector(
      onTap: () => _scratchCoupon(coupon),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFF7A00),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.touch_app,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(height: 8),
            Text(
              'SCRATCH',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'HERE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevealedContent(CouponModel coupon) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF7A00),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            coupon.discount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              coupon.code,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (!coupon.isUsed)
            ElevatedButton(
              onPressed: () => _useCoupon(coupon),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFF7A00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'USE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _scratchCoupon(CouponModel coupon) {
    setState(() {
      coupon.isScratched = true;
    });
    _scratchController.forward();
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon revealed! You got ${coupon.discount} OFF'),
        backgroundColor: const Color(0xFFFF7A00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _useCoupon(CouponModel coupon) {
    setState(() {
      coupon.isUsed = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Coupon ${coupon.code} used successfully!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class CouponModel {
  final String id;
  final String title;
  final String description;
  final String discount;
  final String code;
  final DateTime expiryDate;
  bool isScratched;
  bool isUsed;
  final String shopName;
  final String shopAddress;

  CouponModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.code,
    required this.expiryDate,
    required this.isScratched,
    required this.isUsed,
    required this.shopName,
    required this.shopAddress,
  });
}
