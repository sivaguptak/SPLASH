import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../data/models/shop_daily_update.dart';
import '../../../widgets/lo_buttons.dart';
import 'public_display_screen.dart';

class EnhancedDailyUpdatesScreen extends StatefulWidget {
  const EnhancedDailyUpdatesScreen({super.key});

  @override
  State<EnhancedDailyUpdatesScreen> createState() => _EnhancedDailyUpdatesScreenState();
}

class _EnhancedDailyUpdatesScreenState extends State<EnhancedDailyUpdatesScreen>
    with TickerProviderStateMixin {
  final List<ShopDailyUpdate> _updates = [
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
      title: '⚠️ Shop Closed Tomorrow',
      content: 'We will be closed tomorrow for maintenance. Sorry for the inconvenience.',
      isActive: false,
      priority: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Active', 'Inactive', 'High Priority', 'Published'];
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    final filteredUpdates = _getFilteredUpdates();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Updates & Offers'),
        backgroundColor: LocsyColors.orange,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: _showPublishOptions,
            icon: const Icon(Icons.publish),
            tooltip: 'Publish Options',
          ),
          IconButton(
            onPressed: _addUpdate,
            icon: const Icon(Icons.add),
            tooltip: 'Add Update',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              // Enhanced Filter Section with Publish Status
              _buildEnhancedFilterSection(),
              
              // Updates List with Animations
              Expanded(
                child: filteredUpdates.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredUpdates.length,
                        itemBuilder: (context, index) {
                          final update = filteredUpdates[index];
                          return _buildEnhancedUpdateCard(update, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addUpdate,
        icon: const Icon(Icons.add),
        label: const Text('Add Update'),
        backgroundColor: LocsyColors.orange,
      ),
    );
  }

  Widget _buildEnhancedFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LocsyColors.orange.withOpacity(0.1), LocsyColors.lightOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: LocsyColors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_list, color: LocsyColors.orange),
              const SizedBox(width: 8),
              const Text(
                'Filter Updates:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    backgroundColor: LocsyColors.white,
                    selectedColor: LocsyColors.orange,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : LocsyColors.slate,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    elevation: isSelected ? 4 : 1,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 80,
            color: LocsyColors.slate.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No updates found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LocsyColors.slate,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first daily update',
            style: TextStyle(
              fontSize: 14,
              color: LocsyColors.slate,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _addUpdate,
            icon: const Icon(Icons.add),
            label: const Text('Add Update'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedUpdateCard(ShopDailyUpdate update, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 8,
              shadowColor: LocsyColors.orange.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () => _editUpdate(update),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: update.isActive 
                        ? LinearGradient(
                            colors: [Colors.white, LocsyColors.lightOrange.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with Enhanced Badges
                        Row(
                          children: [
                            // Priority Badge with Animation
                            _buildAnimatedBadge(
                              'Priority ${update.priority}',
                              _getPriorityColor(update.priority),
                              Icons.flag,
                            ),
                            const SizedBox(width: 8),
                            
                            // Status Badge
                            _buildAnimatedBadge(
                              update.isActive ? 'Active' : 'Inactive',
                              update.isActive ? LocsyColors.success : LocsyColors.error,
                              update.isActive ? Icons.visibility : Icons.visibility_off,
                            ),
                            
                            const Spacer(),
                            
                            // Time with Icon
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 14, color: LocsyColors.slate),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(update.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: LocsyColors.slate,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Title with Emoji Support
                        Text(
                          update.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Content with Better Typography
                        Text(
                          update.content,
                          style: TextStyle(
                            fontSize: 15,
                            color: LocsyColors.slate,
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        
                        // Enhanced Actions Row
                        Row(
                          children: [
                            // Quick Actions with Better Icons
                            _buildActionButton(
                              update.isActive ? Icons.visibility_off : Icons.visibility,
                              update.isActive ? 'Hide' : 'Show',
                              update.isActive ? LocsyColors.warning : LocsyColors.success,
                              () => _toggleUpdateStatus(update),
                            ),
                            const SizedBox(width: 8),
                            
                            _buildActionButton(
                              Icons.copy,
                              'Duplicate',
                              LocsyColors.info,
                              () => _duplicateUpdate(update),
                            ),
                            const SizedBox(width: 8),
                            
                            _buildActionButton(
                              Icons.share,
                              'Share',
                              Colors.green,
                              () => _shareUpdate(update),
                            ),
                            
                            const Spacer(),
                            
                            // Publish Button
                            if (update.isActive)
                              ElevatedButton.icon(
                                onPressed: () => _publishUpdate(update),
                                icon: const Icon(Icons.publish, size: 16),
                                label: const Text('Publish'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: LocsyColors.orange,
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            
                            // More Actions
                            PopupMenuButton<String>(
                              onSelected: (value) => _handleMenuAction(value, update),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 16),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'duplicate',
                                  child: Row(
                                    children: [
                                      Icon(Icons.copy, size: 16),
                                      SizedBox(width: 8),
                                      Text('Duplicate'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(
                                        update.isActive ? Icons.visibility_off : Icons.visibility,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(update.isActive ? 'Hide' : 'Show'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 16, color: LocsyColors.error),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: LocsyColors.error)),
                                    ],
                                  ),
                                ),
                              ],
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: LocsyColors.slate.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.more_vert, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBadge(String text, Color color, IconData icon) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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

  List<ShopDailyUpdate> _getFilteredUpdates() {
    switch (_selectedFilter) {
      case 'Active':
        return _updates.where((update) => update.isActive).toList();
      case 'Inactive':
        return _updates.where((update) => !update.isActive).toList();
      case 'High Priority':
        return _updates.where((update) => update.priority >= 4).toList();
      case 'Published':
        return _updates.where((update) => update.isActive).toList(); // In real app, check published status
      default:
        return _updates;
    }
  }

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

  void _addUpdate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddEditUpdateScreen(),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          _updates.insert(0, result);
        });
      }
    });
  }

  void _editUpdate(ShopDailyUpdate update) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _AddEditUpdateScreen(update: update),
      ),
    ).then((result) {
      if (result != null) {
        setState(() {
          final index = _updates.indexWhere((u) => u.id == update.id);
          if (index != -1) {
            _updates[index] = result;
          }
        });
      }
    });
  }

  void _toggleUpdateStatus(ShopDailyUpdate update) {
    setState(() {
      final index = _updates.indexWhere((u) => u.id == update.id);
      if (index != -1) {
        _updates[index] = update.copyWith(
          isActive: !update.isActive,
          updatedAt: DateTime.now(),
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${update.isActive ? 'Hidden' : 'Shown'} "${update.title}"'),
        backgroundColor: LocsyColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _duplicateUpdate(ShopDailyUpdate update) {
    final duplicatedUpdate = update.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${update.title} (Copy)',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    setState(() {
      _updates.insert(0, duplicatedUpdate);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update duplicated successfully!'),
        backgroundColor: LocsyColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _shareUpdate(ShopDailyUpdate update) {
    final shopLink = 'https://locsy.app/shop/1/update/${update.id}';
    final message = 'Check out this update from Mahalakshmi Sweets:\n\n${update.title}\n\n${update.content}\n\nView more: $shopLink';
    
    Clipboard.setData(ClipboardData(text: message));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update link copied to clipboard!'),
        backgroundColor: LocsyColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _publishUpdate(ShopDailyUpdate update) {
    showDialog(
      context: context,
      builder: (context) => _PublishDialog(update: update),
    );
  }

  void _showPublishOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PublishOptionsSheet(),
    );
  }

  void _handleMenuAction(String action, ShopDailyUpdate update) {
    switch (action) {
      case 'edit':
        _editUpdate(update);
        break;
      case 'duplicate':
        _duplicateUpdate(update);
        break;
      case 'toggle':
        _toggleUpdateStatus(update);
        break;
      case 'delete':
        _deleteUpdate(update);
        break;
    }
  }

  void _deleteUpdate(ShopDailyUpdate update) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Update'),
        content: Text('Are you sure you want to delete "${update.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _updates.removeWhere((u) => u.id == update.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${update.title}" deleted successfully!'),
                  backgroundColor: LocsyColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: LocsyColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PublishDialog extends StatelessWidget {
  final ShopDailyUpdate update;
  
  const _PublishDialog({required this.update});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
            _showPublishSuccess(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: LocsyColors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Publish'),
        ),
      ],
    );
  }

  void _showPublishSuccess(BuildContext context) {
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
              _shareViaWhatsApp(context, publicLink);
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

  void _shareViaWhatsApp(BuildContext context, String link) {
    final message = 'Check out this update from Mahalakshmi Sweets:\n\n${update.title}\n\n${update.content}\n\nView: $link';
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    
    launchUrl(Uri.parse(whatsappUrl));
  }
}

class _PublishOptionsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              'Publish Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildOptionTile(
              context,
              'View Public Display',
              'See how your updates look to customers',
              Icons.visibility,
              LocsyColors.info,
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PublicDisplayScreen(),
                  ),
                );
              },
            ),
            _buildOptionTile(
              context,
              'Share Shop Link',
              'Share your shop with customers',
              Icons.share,
              Colors.green,
              () {
                Navigator.pop(context);
                _shareShopLink(context);
              },
            ),
            _buildOptionTile(
              context,
              'Generate QR Code',
              'Create QR code for easy sharing',
              Icons.qr_code,
              LocsyColors.orange,
              () {
                Navigator.pop(context);
                // TODO: Implement QR code generation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('QR Code generation coming soon!'),
                    backgroundColor: LocsyColors.info,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _shareShopLink(BuildContext context) {
    final shopLink = 'https://locsy.app/shop/1';
    final message = 'Check out Mahalakshmi Sweets - Traditional Indian sweets and snacks!\n\n$shopLink';
    final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
    
    launchUrl(Uri.parse(whatsappUrl));
  }
}

// Enhanced Add/Edit Update Screen
class _AddEditUpdateScreen extends StatefulWidget {
  final ShopDailyUpdate? update;
  
  const _AddEditUpdateScreen({this.update});

  @override
  State<_AddEditUpdateScreen> createState() => _AddEditUpdateScreenState();
}

class _AddEditUpdateScreenState extends State<_AddEditUpdateScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  int _selectedPriority = 3;
  bool _isActive = true;
  bool _autoPublish = false;

  final List<int> _priorities = [1, 2, 3, 4, 5];
  final List<String> _priorityLabels = [
    'Low', 'Medium', 'High', 'Urgent', 'Critical'
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.update != null) {
      _populateFields();
    }
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final update = widget.update!;
    _titleController.text = update.title;
    _contentController.text = update.content;
    _selectedPriority = update.priority;
    _isActive = update.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.update == null ? 'Add Update' : 'Edit Update'),
        backgroundColor: LocsyColors.orange,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveUpdate,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Priority Selection with Enhanced UI
                _buildSectionTitle('Priority Level', Icons.flag),
                const SizedBox(height: 16),
                
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _priorities.asMap().entries.map((entry) {
                    final priority = entry.key + 1;
                    final label = _priorityLabels[entry.key];
                    final isSelected = _selectedPriority == priority;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPriority = priority;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? _getPriorityColor(priority) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _getPriorityColor(priority) : Colors.grey[300]!,
                            width: 2,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: _getPriorityColor(priority).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ] : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flag,
                              color: isSelected ? Colors.white : _getPriorityColor(priority),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$label ($priority)',
                              style: TextStyle(
                                color: isSelected ? Colors.white : LocsyColors.slate,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                
                // Update Content with Enhanced Fields
                _buildSectionTitle('Update Content', Icons.edit),
                const SizedBox(height: 16),
                
                _buildEnhancedTextField(
                  controller: _titleController,
                  label: 'Title',
                  hint: 'Enter update title (e.g., 🎉 Special Offer)',
                  icon: Icons.title,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                _buildEnhancedTextField(
                  controller: _contentController,
                  label: 'Content',
                  hint: 'Enter update content...',
                  icon: Icons.description,
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Settings with Enhanced UI
                _buildSectionTitle('Settings', Icons.settings),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: LocsyColors.lightOrange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: LocsyColors.orange.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Active'),
                        subtitle: const Text('Update will be visible to customers'),
                        value: _isActive,
                        onChanged: (value) {
                          setState(() {
                            _isActive = value;
                          });
                        },
                        activeColor: LocsyColors.orange,
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_isActive) ...[
                        const Divider(),
                        SwitchListTile(
                          title: const Text('Auto Publish'),
                          subtitle: const Text('Automatically publish to public display'),
                          value: _autoPublish,
                          onChanged: (value) {
                            setState(() {
                              _autoPublish = value;
                            });
                          },
                          activeColor: LocsyColors.orange,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Save Button with Enhanced Design
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _saveUpdate,
                    icon: const Icon(Icons.save),
                    label: Text(
                      widget.update == null ? 'Create Update' : 'Update Changes',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LocsyColors.orange,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: LocsyColors.orange.withOpacity(0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: LocsyColors.orange, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: LocsyColors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: LocsyColors.orange),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: LocsyColors.orange.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: LocsyColors.orange, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

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

  void _saveUpdate() {
    if (_formKey.currentState!.validate()) {
      final update = ShopDailyUpdate(
        id: widget.update?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        shopId: '1', // TODO: Get from auth
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        priority: _selectedPriority,
        isActive: _isActive,
        createdAt: widget.update?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      Navigator.pop(context, update);
      
      if (_autoPublish && _isActive) {
        // TODO: Auto-publish logic
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update created and published automatically!'),
            backgroundColor: LocsyColors.success,
          ),
        );
      }
    }
  }
}
