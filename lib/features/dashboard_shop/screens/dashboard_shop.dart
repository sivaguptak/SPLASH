import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../widgets/lo_cards.dart';
import '../../../widgets/lo_buttons.dart';
import '../../../app.dart';
import '../../../core/theme.dart';
import '../../../data/models/shop.dart';
import '../../../data/models/service_product.dart';
import '../../../data/models/shop_daily_update.dart';
import 'shop_profile_screen.dart';
import 'services_products_screen.dart';
import 'daily_updates_screen.dart';
import 'enhanced_daily_updates_screen.dart';
import 'public_display_screen.dart';

class DashboardShopScreen extends StatefulWidget {
  const DashboardShopScreen({super.key});

  @override
  State<DashboardShopScreen> createState() => _DashboardShopScreenState();
}

class _DashboardShopScreenState extends State<DashboardShopScreen> {
  // Mock data - in real app, this would come from Firebase/API
  final ShopModel _shop = ShopModel(
    id: '1',
    name: 'Mahalakshmi Sweets',
    city: 'Mumbai',
    approved: true,
    shopType: 'Sweet Shop',
    phoneNumber: '+91 98765 43210',
    alternatePhone: '+91 98765 43211',
    latitude: 19.0760,
    longitude: 72.8777,
    address: '123 MG Road, Mumbai',
    description: 'Traditional Indian sweets and snacks',
    ownerName: 'Rajesh Kumar',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  final List<ServiceProductModel> _servicesProducts = [
    ServiceProductModel(
      id: '1',
      shopId: '1',
      name: 'Gulab Jamun',
      description: 'Soft and delicious gulab jamun',
      type: 'product',
      category: 'sweets',
      price: 50.0,
      unit: 'piece',
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now(),
    ),
    ServiceProductModel(
      id: '2',
      shopId: '1',
      name: 'Rasgulla',
      description: 'Fresh and soft rasgulla',
      type: 'product',
      category: 'sweets',
      price: 40.0,
      unit: 'piece',
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now(),
    ),
    ServiceProductModel(
      id: '3',
      shopId: '1',
      name: 'Home Delivery',
      description: 'Free home delivery within 5km',
      type: 'service',
      category: 'delivery',
      price: 0.0,
      unit: 'order',
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
    ),
  ];

  final List<ShopDailyUpdate> _dailyUpdates = [
    ShopDailyUpdate(
      id: '1',
      shopId: '1',
      title: 'Fresh Sweets Available',
      content: 'Today we have fresh gulab jamun, rasgulla, and kaju katli available. Order now!',
      isActive: true,
      priority: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ShopDailyUpdate(
      id: '2',
      shopId: '1',
      title: 'Special Offer',
      content: 'Buy 2 kg of any sweets and get 10% discount. Valid till this weekend!',
      isActive: true,
      priority: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final TextEditingController _customerPhoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Dashboard'),
        backgroundColor: LocsyColors.orange,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop Profile Card
            _buildShopProfileCard(),
            const SizedBox(height: 20),
            
            // Quick Actions
            _buildQuickActions(),
            const SizedBox(height: 20),
            
            // Services/Products Section
            _buildServicesProductsSection(),
            const SizedBox(height: 20),
            
            // Daily Updates Section
            _buildDailyUpdatesSection(),
            const SizedBox(height: 20),
            
            // Customer Engagement Section
            _buildCustomerEngagementSection(),
            const SizedBox(height: 20),
            
            // Additional Features
            _buildAdditionalFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildShopProfileCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: LocsyColors.orange,
                  child: Text(
                    _shop.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _shop.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _shop.shopType ?? 'Shop',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (_shop.phoneNumber != null)
                        Text(
                          _shop.phoneNumber!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _editShopProfile(),
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_shop.address != null)
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _shop.address!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openNavigation,
                    icon: const Icon(Icons.navigation, size: 16),
                    label: const Text('Navigate'),
                  ),
                ],
              ),
            if (_shop.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _shop.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: double.infinity,
              child: LoPrimaryButton(
                text: 'Create Offer',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.createOffer),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: LoPrimaryButton(
                text: 'My Offers',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.myOffers),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: LoPrimaryButton(
                text: 'Distribute',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.distribute),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: LoPrimaryButton(
                text: 'Scan/Redeem',
                onPressed: () => Navigator.pushNamed(context, AppRoutes.redeem),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServicesProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Services & Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addServiceProduct,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._servicesProducts.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: item.type == 'service' 
                  ? Colors.blue[100] 
                  : Colors.green[100],
              child: Icon(
                item.type == 'service' ? Icons.build : Icons.shopping_bag,
                color: item.type == 'service' ? Colors.blue : Colors.green,
              ),
            ),
            title: Text(item.name),
            subtitle: Text(item.description),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (item.price != null && item.price! > 0)
                  Text(
                    '₹${item.price!.toStringAsFixed(0)}/${item.unit ?? 'item'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                Text(
                  item.isAvailable ? 'Available' : 'Unavailable',
                  style: TextStyle(
                    color: item.isAvailable ? Colors.green : Colors.red,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () => _editServiceProduct(item),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildDailyUpdatesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.campaign, color: LocsyColors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Daily Updates & Offers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton.icon(
                  onPressed: _viewPublicDisplay,
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Preview'),
                  style: TextButton.styleFrom(
                    foregroundColor: LocsyColors.info,
                  ),
                ),
                TextButton.icon(
                  onPressed: _addDailyUpdate,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Update'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._dailyUpdates.map((update) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shadowColor: LocsyColors.orange.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _editDailyUpdate(update),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getPriorityColor(update.priority),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _getPriorityColor(update.priority).withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getPriorityIcon(update.priority),
                              size: 12,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Priority ${update.priority}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: update.isActive 
                              ? LocsyColors.success.withOpacity(0.2)
                              : LocsyColors.error.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          update.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: update.isActive ? LocsyColors.success : LocsyColors.error,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatTime(update.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    update.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    update.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionButton(
                        Icons.edit,
                        'Edit',
                        LocsyColors.info,
                        () => _editDailyUpdate(update),
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        update.isActive ? Icons.visibility_off : Icons.visibility,
                        update.isActive ? 'Hide' : 'Show',
                        update.isActive ? LocsyColors.warning : LocsyColors.success,
                        () => _toggleUpdateStatus(update),
                      ),
                      const SizedBox(width: 8),
                      if (update.isActive)
                        _buildActionButton(
                          Icons.publish,
                          'Publish',
                          LocsyColors.orange,
                          () => _publishUpdate(update),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildCustomerEngagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Engagement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Share Shop Link via WhatsApp',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _customerPhoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Customer Phone Number',
                    hintText: '+91 98765 43210',
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _shareShopLink,
                    icon: const Icon(Icons.share),
                    label: const Text('Share Shop Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Additional Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildFeatureCard(
              'Analytics',
              Icons.analytics,
              'View shop performance',
              () => _showAnalytics(),
            ),
            _buildFeatureCard(
              'Reviews',
              Icons.star,
              'Customer reviews',
              () => _showReviews(),
            ),
            _buildFeatureCard(
              'Inventory',
              Icons.inventory,
              'Stock management',
              () => _showInventory(),
            ),
            _buildFeatureCard(
              'Orders',
              Icons.shopping_cart,
              'Order management',
              () => _showOrders(),
            ),
            _buildFeatureCard(
              'Demo',
              Icons.play_circle,
              'View enhanced features',
              () => _showDemo(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1: return Colors.grey;
      case 2: return Colors.blue;
      case 3: return Colors.orange;
      case 4: return Colors.red;
      case 5: return Colors.purple;
      default: return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Action methods
  void _editShopProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShopProfileScreen(shop: _shop),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          // Update shop data if returned
        });
      }
    });
  }

  void _openNavigation() {
    if (_shop.latitude != null && _shop.longitude != null) {
      final url = 'https://www.google.com/maps/dir/?api=1&destination=${_shop.latitude},${_shop.longitude}';
      launchUrl(Uri.parse(url));
    }
  }

  void _addServiceProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServicesProductsScreen(),
      ),
    );
  }

  void _editServiceProduct(ServiceProductModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServicesProductsScreen(),
      ),
    );
  }

  void _addDailyUpdate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedDailyUpdatesScreen(),
      ),
    );
  }

  void _editDailyUpdate(ShopDailyUpdate update) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedDailyUpdatesScreen(),
      ),
    );
  }

  void _toggleUpdateStatus(ShopDailyUpdate update) {
    setState(() {
      // In real app, this would update the database
      // For now, just show a message
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${update.isActive ? 'Hidden' : 'Shown'} ${update.title}')),
    );
  }

  void _shareShopLink() {
    final phone = _customerPhoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    final shopLink = 'https://locsy.app/shop/${_shop.id}';
    final message = 'Hi! Check out ${_shop.name} - $shopLink';
    final whatsappUrl = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
    
    launchUrl(Uri.parse(whatsappUrl));
  }

  void _showAnalytics() {
    Navigator.pushNamed(context, AppRoutes.shopAnalytics);
  }

  void _showReviews() {
    Navigator.pushNamed(context, AppRoutes.shopReviews);
  }

  void _showInventory() {
    Navigator.pushNamed(context, AppRoutes.shopInventory);
  }

  void _showOrders() {
    Navigator.pushNamed(context, AppRoutes.shopOrders);
  }

  void _showDemo() {
    Navigator.pushNamed(context, AppRoutes.shopAdminDemo);
  }

  void _viewPublicDisplay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PublicDisplayScreen(),
      ),
    );
  }

  void _publishUpdate(ShopDailyUpdate update) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Publish "${update.title}" to public?'),
            const SizedBox(height: 16),
            const Text('This will make the update visible to customers and generate a shareable link.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPublishSuccess(update);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LocsyColors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _showPublishSuccess(ShopDailyUpdate update) {
    final publicLink = 'https://locsy.app/public/shop/1/update/${update.id}';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: LocsyColors.success),
            const SizedBox(width: 8),
            const Text('Published!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your update has been published successfully!'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: LocsyColors.lightOrange,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: LocsyColors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Public Link:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  SelectableText(
                    publicLink,
                    style: TextStyle(
                      fontSize: 12,
                      color: LocsyColors.slate,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: publicLink));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link copied to clipboard!'),
                  backgroundColor: LocsyColors.success,
                ),
              );
            },
            child: const Text('Copy Link'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _shareViaWhatsApp(update, publicLink);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Share via WhatsApp'),
          ),
        ],
      ),
    );
  }

  void _shareViaWhatsApp(ShopDailyUpdate update, String link) {
    final message = 'Check out this update from Mahalakshmi Sweets:\n\n${update.title}\n\n${update.content}\n\nView: $link';
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    
    launchUrl(Uri.parse(whatsappUrl));
  }

  Widget _buildActionButton(IconData icon, String tooltip, Color color, VoidCallback onPressed) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  IconData _getPriorityIcon(int priority) {
    switch (priority) {
      case 1: return Icons.info;
      case 2: return Icons.star;
      case 3: return Icons.warning;
      case 4: return Icons.error;
      case 5: return Icons.priority_high;
      default: return Icons.info;
    }
  }

  @override
  void dispose() {
    _customerPhoneController.dispose();
    super.dispose();
  }
}
