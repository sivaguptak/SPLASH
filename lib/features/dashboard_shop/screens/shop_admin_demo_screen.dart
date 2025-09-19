import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme.dart';
import '../../../data/models/shop_daily_update.dart';
import '../../../data/models/shop.dart';
import '../../../services/whatsapp_sharing_service.dart';
import 'enhanced_daily_updates_screen.dart';
import 'public_display_screen.dart';

class ShopAdminDemoScreen extends StatefulWidget {
  const ShopAdminDemoScreen({super.key});

  @override
  State<ShopAdminDemoScreen> createState() => _ShopAdminDemoScreenState();
}

class _ShopAdminDemoScreenState extends State<ShopAdminDemoScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ShopModel _demoShop = ShopModel(
    id: '1',
    name: 'Mahalakshmi Sweets',
    city: 'Mumbai',
    approved: true,
    shopType: 'Sweet Shop',
    phoneNumber: '+91 98765 43210',
    alternatePhone: '+91 98765 43211',
    latitude: 19.0760,
    longitude: 72.8777,
    address: '123 MG Road, Mumbai, Maharashtra',
    description: 'Traditional Indian sweets and snacks since 1985',
    ownerName: 'Rajesh Kumar',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    updatedAt: DateTime.now(),
  );

  final List<ShopDailyUpdate> _demoUpdates = [
    ShopDailyUpdate(
      id: '1',
      shopId: '1',
      title: '🎉 Fresh Sweets Available',
      content: 'Today we have fresh gulab jamun, rasgulla, and kaju katli available. Order now!',
      isActive: true,
      priority: 3,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ShopDailyUpdate(
      id: '2',
      shopId: '1',
      title: '🔥 Special Offer - 10% Off',
      content: 'Buy 2 kg of any sweets and get 10% discount. Valid till this weekend!',
      isActive: true,
      priority: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ShopDailyUpdate(
      id: '3',
      shopId: '1',
      title: '🍰 New Sweet Arrivals',
      content: 'Try our new chocolate barfi and pistachio kulfi. Limited time only!',
      isActive: true,
      priority: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Admin Demo'),
        backgroundColor: LocsyColors.orange,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                _buildFeatureCards(),
                const SizedBox(height: 30),
                _buildDemoUpdates(),
                const SizedBox(height: 30),
                _buildSharingOptions(),
                const SizedBox(height: 30),
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LocsyColors.orange, LocsyColors.darkOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: LocsyColors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.store,
                  color: LocsyColors.orange,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shop Admin Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your daily offers and updates',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '✨ Features:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Create and manage daily updates\n• Publish to public display\n• Share via WhatsApp with generated links\n• Beautiful animations and effects\n• Real-time preview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🚀 Key Features',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: [
            _buildFeatureCard(
              '📝 Create Updates',
              'Add daily offers and announcements',
              Icons.edit,
              LocsyColors.info,
              () => _navigateToUpdates(),
            ),
            _buildFeatureCard(
              '👁️ Public Display',
              'Animated public display screen',
              Icons.visibility,
              LocsyColors.success,
              () => _navigateToPublicDisplay(),
            ),
            _buildFeatureCard(
              '📱 WhatsApp Share',
              'Share with generated links',
              Icons.share,
              Colors.green,
              () => _showSharingOptions(),
            ),
            _buildFeatureCard(
              '🎨 Animations',
              'Beautiful UI animations',
              Icons.animation,
              LocsyColors.warning,
              () => _showAnimationDemo(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
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

  Widget _buildDemoUpdates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📢 Sample Updates',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._demoUpdates.map((update) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 4,
          shadowColor: LocsyColors.orange.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(update.priority),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Priority ${update.priority}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
                const SizedBox(height: 8),
                Text(
                  update.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  update.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildSharingOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📱 Sharing Options',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSharingOption(
                  'Share Single Update',
                  'Share a specific update via WhatsApp',
                  Icons.share,
                  Colors.green,
                  () => _shareSingleUpdate(),
                ),
                const Divider(),
                _buildSharingOption(
                  'Share Shop Link',
                  'Share your shop with customers',
                  Icons.store,
                  LocsyColors.orange,
                  () => _shareShopLink(),
                ),
                const Divider(),
                _buildSharingOption(
                  'Share All Updates',
                  'Share collection of all active updates',
                  Icons.collections,
                  LocsyColors.info,
                  () => _shareAllUpdates(),
                ),
                const Divider(),
                _buildSharingOption(
                  'Copy Link to Clipboard',
                  'Copy public link for manual sharing',
                  Icons.copy,
                  LocsyColors.slate,
                  () => _copyLinkToClipboard(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSharingOption(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚡ Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _navigateToUpdates,
                icon: const Icon(Icons.edit),
                label: const Text('Manage Updates'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LocsyColors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _navigateToPublicDisplay,
                icon: const Icon(Icons.visibility),
                label: const Text('View Display'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LocsyColors.info,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Action Methods
  void _navigateToUpdates() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EnhancedDailyUpdatesScreen(),
      ),
    );
  }

  void _navigateToPublicDisplay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PublicDisplayScreen(),
      ),
    );
  }

  void _showSharingOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sharing Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSharingOption(
                'Share Single Update',
                'Share a specific update via WhatsApp',
                Icons.share,
                Colors.green,
                () {
                  Navigator.pop(context);
                  _shareSingleUpdate();
                },
              ),
              _buildSharingOption(
                'Share Shop Link',
                'Share your shop with customers',
                Icons.store,
                LocsyColors.orange,
                () {
                  Navigator.pop(context);
                  _shareShopLink();
                },
              ),
              _buildSharingOption(
                'Share All Updates',
                'Share collection of all active updates',
                Icons.collections,
                LocsyColors.info,
                () {
                  Navigator.pop(context);
                  _shareAllUpdates();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showAnimationDemo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Animation Demo'),
        content: const Text(
          'The app features beautiful animations including:\n\n'
          '• Fade-in effects\n'
          '• Slide transitions\n'
          '• Scale animations\n'
          '• Floating elements\n'
          '• Typewriter text effects\n'
          '• Smooth page transitions',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _shareSingleUpdate() async {
    try {
      await WhatsAppSharingService.shareUpdate(
        update: _demoUpdates.first,
        shop: _demoShop,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing: $e'),
          backgroundColor: LocsyColors.error,
        ),
      );
    }
  }

  void _shareShopLink() async {
    try {
      await WhatsAppSharingService.shareShop(shop: _demoShop);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing: $e'),
          backgroundColor: LocsyColors.error,
        ),
      );
    }
  }

  void _shareAllUpdates() async {
    try {
      await WhatsAppSharingService.shareUpdatesCollection(
        updates: _demoUpdates,
        shop: _demoShop,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing: $e'),
          backgroundColor: LocsyColors.error,
        ),
      );
    }
  }

  void _copyLinkToClipboard() async {
    try {
      await WhatsAppSharingService.copyUpdateLink(
        update: _demoUpdates.first,
        shop: _demoShop,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          backgroundColor: LocsyColors.success,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error copying: $e'),
          backgroundColor: LocsyColors.error,
        ),
      );
    }
  }

  // Helper Methods
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1: return LocsyColors.slate;
      case 2: return LocsyColors.info;
      case 3: return LocsyColors.warning;
      case 4: return LocsyColors.error;
      case 5: return Colors.purple;
      default: return LocsyColors.slate;
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
}
