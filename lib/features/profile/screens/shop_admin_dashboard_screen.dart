import 'package:flutter/material.dart';
import 'shop_coupon_management_screen.dart';

class ShopAdminDashboardScreen extends StatelessWidget {
  const ShopAdminDashboardScreen({super.key});

  void _showCouponManagement(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ShopCouponManagementScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buildStoreProfileCard(),
            _buildManagementGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const SizedBox.shrink(); // Header is now in the main profile screen
  }

  Widget _buildStoreProfileCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Shop Photo Placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(35),
              border: Border.all(color: Colors.grey[400]!, width: 2),
            ),
            child: Icon(
              Icons.store,
              size: 35,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sai General Store',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'General Store',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.phone,
                      size: 18,
                      color: Color(0xFFFF7A00),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '9876543210',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagementGrid(BuildContext context) {
    final actions = [
      _ActionItem('Products', Icons.inventory, const Color(0xFF2196F3), () {}),
      _ActionItem('Orders', Icons.shopping_cart, const Color(0xFF4CAF50), () {}),
      _ActionItem('Coupons', Icons.confirmation_number, const Color(0xFF9C27B0), () {
        _showCouponManagement(context);
      }),
      _ActionItem('Analytics', Icons.analytics, const Color(0xFFFF7A00), () {}),
      _ActionItem('Promotions', Icons.local_offer, const Color(0xFFE91E63), () {}),
      _ActionItem('Settings', Icons.settings, const Color(0xFF607D8B), () {}),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          return _buildActionCard(actions[index]);
        },
      ),
    );
  }

  Widget _buildActionCard(_ActionItem action) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                action.icon,
                color: action.color,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              action.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ActionItem(this.title, this.icon, this.color, this.onTap);
}
