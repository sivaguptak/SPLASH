import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/daily_update.dart';
import '../data/services/daily_updates_service.dart';
import '../core/theme.dart';

class DailyUpdatesStoryViewer extends StatefulWidget {
  final List<DailyUpdate> updates;
  final int initialIndex;

  const DailyUpdatesStoryViewer({
    Key? key,
    required this.updates,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<DailyUpdatesStoryViewer> createState() => _DailyUpdatesStoryViewerState();
}

class _DailyUpdatesStoryViewerState extends State<DailyUpdatesStoryViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentIndex = 0;
  bool _isPlaying = true;
  bool _isUserInteracting = false;
  Timer? _autoPlayTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    
    _progressController = AnimationController(
      duration: const Duration(seconds: 5), // 5 seconds per story
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.linear,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _nextStory();
      }
    });

    _startAutoPlay();
    _startContentAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _autoPlayTimer?.cancel();
    super.dispose();
  }

  void _startAutoPlay() {
    if (_isPlaying && !_isUserInteracting) {
      _progressController.forward();
    }
  }

  void _startContentAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  void _resetContentAnimations() {
    _fadeController.reset();
    _scaleController.reset();
    _slideController.reset();
    _startContentAnimations();
  }

  void _pauseAutoPlay() {
    _isPlaying = false;
    _progressController.stop();
    _autoPlayTimer?.cancel();
  }

  void _resumeAutoPlay() {
    _isPlaying = true;
    _progressController.forward();
  }

  void _nextStory() {
    if (_currentIndex < widget.updates.length - 1) {
      _currentIndex++;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetProgress();
    } else {
      // End of stories, go back to daily updates
      Navigator.pop(context);
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _currentIndex--;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _resetProgress();
    }
  }

  void _resetProgress() {
    _progressController.reset();
    _startAutoPlay();
    _resetContentAnimations();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _resetProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Story Content
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: widget.updates.length,
              itemBuilder: (context, index) {
                return _buildStoryContent(widget.updates[index]);
              },
            ),

            // Progress Indicators
            _buildProgressIndicators(),

            // Header with close button
            _buildHeader(),

            // Gesture Detector for tap interactions
            _buildGestureDetector(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryContent(DailyUpdate update) {
    return AnimatedBuilder(
      animation: Listenable.merge([_fadeAnimation, _scaleAnimation, _slideAnimation]),
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getCategoryColor(update.category).withOpacity(0.9),
                _getCategoryColor(update.category).withOpacity(0.7),
                _getCategoryColor(update.category).withOpacity(0.5),
                Colors.black.withOpacity(0.9),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60), // Space for header
                
                // Category Icon and Title with Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Text(
                              _getCategoryIcon(update.category),
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  update.category,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  _formatTime(update.timestamp),
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (update.isUrgent)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'URGENT',
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
                  ),
                ),

                const SizedBox(height: 30),

                // Main Title with Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      update.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description with Animation
                Expanded(
                  child: SingleChildScrollView(
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.white.withOpacity(0.2)),
                              ),
                              child: Text(
                                update.description,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Location
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    update.location,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Source
                            Row(
                              children: [
                                Icon(
                                  Icons.source,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Source: ${update.source}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            // Contact Info
                            if (update.contactInfo != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    update.contactInfo!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            // Additional Data
                            if (update.additionalData != null) ...[
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: update.additionalData!.entries.map((entry) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${entry.key}: ',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              entry.value.toString(),
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(0.9),
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Actions with Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          icon: Icons.share_rounded,
                          label: 'Share',
                          onTap: () => _shareUpdate(update),
                        ),
                        _buildActionButton(
                          icon: Icons.phone_rounded,
                          label: 'Call',
                          onTap: () => _callContact(update.contactInfo),
                        ),
                        _buildActionButton(
                          icon: Icons.bookmark_add_rounded,
                          label: 'Save',
                          onTap: () => _saveUpdate(update),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.25),
              Colors.white.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicators() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        children: List.generate(widget.updates.length, (index) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: index < widget.updates.length - 1 ? 6 : 0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: index == _currentIndex
                  ? AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          width: MediaQuery.of(context).size.width * _progressAnimation.value / widget.updates.length,
                        );
                      },
                    )
                  : index < _currentIndex
                      ? Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.white.withOpacity(0.9)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        )
                      : null,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '${_currentIndex + 1} / ${widget.updates.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGestureDetector() {
    return GestureDetector(
      onTapDown: (details) {
        _pauseAutoPlay();
        _isUserInteracting = true;
      },
      onTapUp: (details) {
        _isUserInteracting = false;
        _resumeAutoPlay();
        
        // Handle tap navigation
        final screenWidth = MediaQuery.of(context).size.width;
        if (details.globalPosition.dx < screenWidth / 3) {
          _previousStory();
        } else if (details.globalPosition.dx > screenWidth * 2 / 3) {
          _nextStory();
        }
        // Center tap does nothing (just pause/resume)
      },
      onTapCancel: () {
        _isUserInteracting = false;
        _resumeAutoPlay();
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Banks':
        return '🏦';
      case 'Bus Depots':
        return '🚌';
      case 'Schools':
        return '🏫';
      case 'Auto Drivers':
        return '🛺';
      case 'Religious Institutions':
        return '🛕';
      case 'Government Departments':
        return '🏛️';
      case 'Local Businesses':
        return '🏪';
      case 'Job Alerts':
        return '💼';
      case 'Town Re-sale':
        return '🛒';
      case 'Travel Information':
        return '🚗';
      case 'Daily Labour Required':
        return '👷';
      case 'Daily Foods':
        return '🍽️';
      case 'Daily Essentials':
        return '🛍️';
      case 'Street Vendors Today':
        return '🛵';
      case 'Health Camp Info':
        return '🏥';
      case 'Melas In Town':
        return '🎪';
      case 'Birthday & Events':
        return '🎂';
      case 'Condolences':
        return '🕊️';
      case 'Movies in Town':
        return '🎬';
      case 'Latest Movies in OTTs':
        return '📺';
      case 'Functions in Function Halls':
        return '🎉';
      case 'Digital Pamphlets':
        return '📱';
      default:
        return '📢';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Banks':
        return const Color(0xFF4CAF50);
      case 'Bus Depots':
        return const Color(0xFF2196F3);
      case 'Schools':
        return const Color(0xFFFF9800);
      case 'Auto Drivers':
        return const Color(0xFF9C27B0);
      case 'Religious Institutions':
        return const Color(0xFFFF5722);
      case 'Government Departments':
        return const Color(0xFF607D8B);
      case 'Local Businesses':
        return const Color(0xFF795548);
      case 'Job Alerts':
        return const Color(0xFF3F51B5);
      case 'Town Re-sale':
        return const Color(0xFF009688);
      case 'Travel Information':
        return const Color(0xFFE91E63);
      case 'Daily Labour Required':
        return const Color(0xFFFFC107);
      case 'Daily Foods':
        return const Color(0xFFFF5722);
      case 'Daily Essentials':
        return const Color(0xFF4CAF50);
      case 'Street Vendors Today':
        return const Color(0xFF9E9E9E);
      case 'Health Camp Info':
        return const Color(0xFFF44336);
      case 'Melas In Town':
        return const Color(0xFFE91E63);
      case 'Birthday & Events':
        return const Color(0xFFFF9800);
      case 'Condolences':
        return const Color(0xFF9E9E9E);
      case 'Movies in Town':
        return const Color(0xFF673AB7);
      case 'Latest Movies in OTTs':
        return const Color(0xFF3F51B5);
      case 'Functions in Function Halls':
        return const Color(0xFFFF5722);
      case 'Digital Pamphlets':
        return const Color(0xFF00BCD4);
      default:
        return LocsyColors.orange;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _shareUpdate(DailyUpdate update) {
    // TODO: Implement sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${update.title}'),
        backgroundColor: LocsyColors.orange,
      ),
    );
  }

  void _callContact(String? contactInfo) {
    if (contactInfo != null) {
      // TODO: Implement calling functionality
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calling: $contactInfo'),
          backgroundColor: LocsyColors.orange,
        ),
      );
    }
  }

  void _saveUpdate(DailyUpdate update) {
    // TODO: Implement saving functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved: ${update.title}'),
        backgroundColor: LocsyColors.orange,
      ),
    );
  }
}