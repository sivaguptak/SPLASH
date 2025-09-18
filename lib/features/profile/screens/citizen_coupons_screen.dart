import 'package:flutter/material.dart';
import 'dart:math';
import '../../../widgets/scratch_reveal_widget.dart';
import '../../../widgets/progressive_scratch_widget.dart';
import '../../../widgets/back_button_handler.dart';

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
      expiryDate: DateTime.now().add(const Duration(days: 5)),
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
      expiryDate: DateTime.now().add(const Duration(days: 2)),
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
      expiryDate: DateTime.now().add(const Duration(days: 10)),
      isScratched: false,
      isUsed: false,
      shopName: 'Power Solutions',
      shopAddress: 'Industrial Area',
    ),
    CouponModel(
      id: '4',
      title: 'MediCare Plus',
      description: '₹100 OFF on Medicines',
      discount: '₹100',
      code: 'MED100',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      isScratched: true,
      isUsed: true,
      shopName: 'MediCare Plus',
      shopAddress: 'Health Center',
    ),
    CouponModel(
      id: '5',
      title: 'Tech Hub',
      description: '30% OFF on Repairs',
      discount: '30%',
      code: 'TECH30',
      expiryDate: DateTime.now().add(const Duration(days: 3)),
      isScratched: false,
      isUsed: false,
      shopName: 'Tech Hub',
      shopAddress: 'IT Park',
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
    return BackButtonHandler(
      behavior: BackButtonBehavior.navigate, // Coupons screen should navigate back
      child: Scaffold(
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
    final daysLeft = _getDaysLeft(coupon.expiryDate);
    final isExpiringSoon = daysLeft <= 3;
    final isExpired = daysLeft <= 0;
    
    return GestureDetector(
      onTap: () => _showFullScreenScratch(coupon),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 80, // Smaller card like Google Rewards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isExpiringSoon ? Colors.orange.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Left side - Shop icon
            Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.store,
                color: Color(0xFFFF7A00),
                size: 24,
              ),
            ),
            
            // Center - Coupon info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (coupon.isScratched) ...[
                    Text(
                      coupon.shopName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      coupon.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ] else ...[
                    const Text(
                      'Mystery Coupon',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tap to scratch and reveal',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Right side - Status and action
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIndicator(coupon, daysLeft, isExpiringSoon, isExpired),
                  const SizedBox(height: 4),
                  if (coupon.isScratched && !coupon.isUsed)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'USE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (!coupon.isScratched)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'SCRATCH',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(CouponModel coupon, int daysLeft, bool isExpiringSoon, bool isExpired) {
    if (coupon.isUsed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'USED',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      );
    } else if (coupon.isScratched) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'REVEALED',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'NEW',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      );
    }
  }

  Widget _buildScratchArea(CouponModel coupon) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFF7A00),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.touch_app,
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 6),
          Text(
            'DRAG TO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'SCRATCH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedContent(CouponModel coupon) {
    return Container(
      decoration: BoxDecoration(
        color: coupon.isUsed ? Colors.grey.withOpacity(0.1) : const Color(0xFFFF7A00).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            coupon.discount,
            style: TextStyle(
              color: coupon.isUsed ? Colors.grey : const Color(0xFFFF7A00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: coupon.isUsed ? Colors.grey.withOpacity(0.2) : const Color(0xFFFF7A00).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              coupon.code,
              style: TextStyle(
                color: coupon.isUsed ? Colors.grey : const Color(0xFFFF7A00),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (!coupon.isUsed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A00),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'TAP TO USE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showFullScreenScratch(CouponModel coupon) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => FullScreenScratchModal(
        coupon: coupon,
        onScratch: () => _scratchCoupon(coupon),
        onUse: () => _useCoupon(coupon),
        onClose: () => Navigator.pop(context),
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

  int _getDaysLeft(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    return difference < 0 ? 0 : difference;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class FullScreenScratchModal extends StatefulWidget {
  final CouponModel coupon;
  final VoidCallback onScratch;
  final VoidCallback onUse;
  final VoidCallback onClose;

  const FullScreenScratchModal({
    super.key,
    required this.coupon,
    required this.onScratch,
    required this.onUse,
    required this.onClose,
  });

  @override
  State<FullScreenScratchModal> createState() => _FullScreenScratchModalState();
}

class _FullScreenScratchModalState extends State<FullScreenScratchModal>
    with TickerProviderStateMixin {
  late AnimationController _scratchController;
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;
  bool _isScratched = false;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _scratchController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    ));
    _isScratched = widget.coupon.isScratched;
  }

  @override
  void dispose() {
    _scratchController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            // Close button (top left)
            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Main content
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _isScratched ? _buildRevealedContent() : _buildScratchContent(),
                ),
              ),
            ),
            
            // Celebration overlay
            if (_showCelebration)
              AnimatedBuilder(
                animation: _revealAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _revealAnimation.value,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.8),
                      child: Center(
                        child: Transform.scale(
                          scale: 0.8 + (0.2 * _revealAnimation.value),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.celebration,
                                color: Colors.orange,
                                size: 80,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Congratulations!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'You got ${widget.coupon.discount} OFF',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildScratchContent() {
    return Column(
      children: [
        // LOCSY Logo Header
        Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            color: Color(0xFFFF7A00),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              const Text(
                'LOCSY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Scratch & Win',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Scratch area
        Expanded(
          child: ProgressiveScratchWidget(
            isScratched: _isScratched,
            onScratchComplete: _scratchCoupon,
            scratchThreshold1: 0.2, // 20%
            scratchThreshold2: 0.7, // 70%
            scratchThreshold3: 1.0, // 100%
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF7A00),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: _buildScratchArea(),
            ),
            scratchLayer: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF7A00),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: _buildScratchArea(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScratchArea() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.touch_app,
          color: Colors.white,
          size: 60,
        ),
        SizedBox(height: 20),
        Text(
          'SCRATCH HERE',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Drag your finger to reveal the coupon',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildRevealedContent() {
    final daysLeft = _getDaysLeft(widget.coupon.expiryDate);
    final isExpiringSoon = daysLeft <= 3;
    final isExpired = daysLeft <= 0;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with shop info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFFF7A00),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.store,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.coupon.shopName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.coupon.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Coupon details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Discount amount
                Text(
                  widget.coupon.discount,
                  style: TextStyle(
                    color: widget.coupon.isUsed ? Colors.grey : const Color(0xFFFF7A00),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                
                // Coupon code
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: widget.coupon.isUsed ? Colors.grey.withOpacity(0.2) : const Color(0xFFFF7A00).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.coupon.isUsed ? Colors.grey : const Color(0xFFFF7A00),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    widget.coupon.code,
                    style: TextStyle(
                      color: widget.coupon.isUsed ? Colors.grey : const Color(0xFFFF7A00),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                
                // Days left
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isExpired 
                        ? Colors.red.withOpacity(0.1)
                        : isExpiringSoon 
                            ? Colors.orange.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isExpired 
                        ? 'EXPIRED'
                        : daysLeft == 1 
                            ? 'Expires Today!'
                            : '$daysLeft days left',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isExpired 
                          ? Colors.red
                          : isExpiringSoon 
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                
                // Shop address
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        widget.coupon.shopAddress,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Redeem button
                if (!widget.coupon.isUsed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onUse();
                        widget.onClose();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF7A00),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'REDEEM NOW',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _scratchCoupon() {
    setState(() {
      _isScratched = true;
      _showCelebration = true;
    });
    _scratchController.forward();
    _revealController.forward();
    widget.onScratch();
    
    // Hide celebration after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showCelebration = false;
        });
      }
    });
  }

  int _getDaysLeft(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    return difference < 0 ? 0 : difference;
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
