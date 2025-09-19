import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme.dart';
import '../../../data/models/shop_daily_update.dart';

class PublicDisplayScreen extends StatefulWidget {
  const PublicDisplayScreen({super.key});

  @override
  State<PublicDisplayScreen> createState() => _PublicDisplayScreenState();
}

class _PublicDisplayScreenState extends State<PublicDisplayScreen>
    with TickerProviderStateMixin {
  // Mock data - in real app, this would come from API
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
      title: '🍰 New Sweet Arrivals',
      content: 'Try our new chocolate barfi and pistachio kulfi. Limited time only!',
      isActive: true,
      priority: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  late AnimationController _mainAnimationController;
  late AnimationController _textAnimationController;
  late AnimationController _floatingAnimationController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  
  int _currentUpdateIndex = 0;
  bool _isAutoPlay = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.elasticOut,
    ));
    
    _floatingAnimation = Tween<double>(
      begin: -10.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _mainAnimationController.forward();
    _textAnimationController.forward();
    _floatingAnimationController.repeat(reverse: true);
    
    if (_isAutoPlay) {
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _textAnimationController.dispose();
    _floatingAnimationController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_isAutoPlay && mounted) {
        _nextUpdate();
        _startAutoPlay();
      }
    });
  }

  void _nextUpdate() {
    setState(() {
      _currentUpdateIndex = (_currentUpdateIndex + 1) % _updates.length;
    });
    
    _mainAnimationController.reset();
    _textAnimationController.reset();
    _mainAnimationController.forward();
    _textAnimationController.forward();
  }

  void _previousUpdate() {
    setState(() {
      _currentUpdateIndex = (_currentUpdateIndex - 1 + _updates.length) % _updates.length;
    });
    
    _mainAnimationController.reset();
    _textAnimationController.reset();
    _mainAnimationController.forward();
    _textAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final currentUpdate = _updates[_currentUpdateIndex];
    
    return Scaffold(
      backgroundColor: _getBackgroundColor(currentUpdate.priority),
      body: SafeArea(
        child: _isFullScreen 
            ? _buildFullScreenDisplay(currentUpdate)
            : _buildNormalDisplay(currentUpdate),
      ),
    );
  }

  Widget _buildNormalDisplay(ShopDailyUpdate update) {
    return Column(
      children: [
        // Header with Shop Info
        _buildHeader(),
        
        // Main Content
        Expanded(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildUpdateCard(update),
                ),
              ),
            ),
          ),
        ),
        
        // Controls
        _buildControls(),
      ],
    );
  }

  Widget _buildFullScreenDisplay(ShopDailyUpdate update) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFullScreen = false;
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: _getGradientBackground(update.priority),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildFullScreenCard(update),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [LocsyColors.orange, LocsyColors.darkOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: LocsyColors.orange.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        children: [
          // Shop Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.store,
              color: LocsyColors.orange,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          
          // Shop Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mahalakshmi Sweets',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Traditional Indian Sweets & Snacks',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white.withOpacity(0.8), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Mumbai, Maharashtra',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Full Screen Toggle
          IconButton(
            onPressed: () {
              setState(() {
                _isFullScreen = true;
              });
            },
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            tooltip: 'Full Screen',
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateCard(ShopDailyUpdate update) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Priority Badge
          _buildPriorityBadge(update.priority),
          const SizedBox(height: 20),
          
          // Title with Typewriter Effect
          _buildAnimatedTitle(update.title),
          const SizedBox(height: 20),
          
          // Content with Fade In Effect
          _buildAnimatedContent(update.content),
          const SizedBox(height: 20),
          
          // Time Stamp
          _buildTimeStamp(update.createdAt),
        ],
      ),
    );
  }

  Widget _buildFullScreenCard(ShopDailyUpdate update) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Priority Badge
          _buildPriorityBadge(update.priority, isLarge: true),
          const SizedBox(height: 30),
          
          // Title with Typewriter Effect
          _buildAnimatedTitle(update.title, isLarge: true),
          const SizedBox(height: 30),
          
          // Content with Fade In Effect
          _buildAnimatedContent(update.content, isLarge: true),
          const SizedBox(height: 30),
          
          // Time Stamp
          _buildTimeStamp(update.createdAt, isLarge: true),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(int priority, {bool isLarge = false}) {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isLarge ? 20 : 16,
              vertical: isLarge ? 12 : 8,
            ),
            decoration: BoxDecoration(
              color: _getPriorityColor(priority),
              borderRadius: BorderRadius.circular(isLarge ? 20 : 16),
              boxShadow: [
                BoxShadow(
                  color: _getPriorityColor(priority).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getPriorityIcon(priority),
                  color: Colors.white,
                  size: isLarge ? 20 : 16,
                ),
                SizedBox(width: isLarge ? 8 : 6),
                Text(
                  _getPriorityText(priority),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLarge ? 16 : 14,
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

  Widget _buildAnimatedTitle(String title, {bool isLarge = false}) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return TweenAnimationBuilder<String>(
          duration: Duration(milliseconds: (title.length * 50).clamp(500, 2000)),
          tween: Tween(begin: '', end: title),
          builder: (context, value, child) {
            return Text(
              value,
              style: TextStyle(
                fontSize: isLarge ? 32 : 24,
                fontWeight: FontWeight.bold,
                color: LocsyColors.black,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            );
          },
        );
      },
    );
  }

  Widget _buildAnimatedContent(String content, {bool isLarge = false}) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: isLarge ? 20 : 16,
                    color: LocsyColors.slate,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeStamp(DateTime dateTime, {bool isLarge = false}) {
    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLarge ? 16 : 12,
                  vertical: isLarge ? 8 : 6,
                ),
                decoration: BoxDecoration(
                  color: LocsyColors.slate.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isLarge ? 12 : 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: isLarge ? 16 : 14,
                      color: LocsyColors.slate,
                    ),
                    SizedBox(width: isLarge ? 6 : 4),
                    Text(
                      _formatTime(dateTime),
                      style: TextStyle(
                        fontSize: isLarge ? 14 : 12,
                        color: LocsyColors.slate,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Indicator
          Row(
            children: _updates.asMap().entries.map((entry) {
              final index = entry.key;
              final isActive = index == _currentUpdateIndex;
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: index == 0 ? 0 : 4),
                  decoration: BoxDecoration(
                    color: isActive ? LocsyColors.orange : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Previous Button
              _buildControlButton(
                Icons.skip_previous,
                'Previous',
                _previousUpdate,
              ),
              
              // Play/Pause Button
              _buildControlButton(
                _isAutoPlay ? Icons.pause : Icons.play_arrow,
                _isAutoPlay ? 'Pause' : 'Play',
                () {
                  setState(() {
                    _isAutoPlay = !_isAutoPlay;
                  });
                  if (_isAutoPlay) {
                    _startAutoPlay();
                  }
                },
                isPrimary: true,
              ),
              
              // Next Button
              _buildControlButton(
                Icons.skip_next,
                'Next',
                _nextUpdate,
              ),
              
              // Share Button
              _buildControlButton(
                Icons.share,
                'Share',
                _shareCurrentUpdate,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String tooltip, VoidCallback onPressed, {bool isPrimary = false}) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: isPrimary ? LocsyColors.orange : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: isPrimary ? [
            BoxShadow(
              color: LocsyColors.orange.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: isPrimary ? Colors.white : LocsyColors.slate,
            size: 24,
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(int priority) {
    switch (priority) {
      case 1: return LocsyColors.lightOrange;
      case 2: return Colors.blue[50]!;
      case 3: return Colors.orange[50]!;
      case 4: return Colors.red[50]!;
      case 5: return Colors.purple[50]!;
      default: return LocsyColors.lightOrange;
    }
  }

  Gradient _getGradientBackground(int priority) {
    switch (priority) {
      case 1:
        return LinearGradient(
          colors: [LocsyColors.lightOrange, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [Colors.blue[50]!, Colors.blue[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return LinearGradient(
          colors: [Colors.orange[50]!, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 4:
        return LinearGradient(
          colors: [Colors.red[50]!, Colors.red[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 5:
        return LinearGradient(
          colors: [Colors.purple[50]!, Colors.purple[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [LocsyColors.lightOrange, Colors.orange[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
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

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1: return 'Info';
      case 2: return 'Featured';
      case 3: return 'Important';
      case 4: return 'Urgent';
      case 5: return 'Critical';
      default: return 'Info';
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _shareCurrentUpdate() {
    final currentUpdate = _updates[_currentUpdateIndex];
    final publicLink = 'https://locsy.app/public/shop/1/update/${currentUpdate.id}';
    final message = 'Check out this update from Mahalakshmi Sweets:\n\n${currentUpdate.title}\n\n${currentUpdate.content}\n\nView: $publicLink';
    
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
}
