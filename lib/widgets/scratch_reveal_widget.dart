import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class ScratchRevealWidget extends StatefulWidget {
  final Widget child;
  final Widget scratchLayer;
  final VoidCallback? onScratchComplete;
  final bool isScratched;
  final double scratchThreshold;

  const ScratchRevealWidget({
    super.key,
    required this.child,
    required this.scratchLayer,
    this.onScratchComplete,
    this.isScratched = false,
    this.scratchThreshold = 0.3, // 30% of area needs to be scratched
  });

  @override
  State<ScratchRevealWidget> createState() => _ScratchRevealWidgetState();
}

class _ScratchRevealWidgetState extends State<ScratchRevealWidget>
    with TickerProviderStateMixin {
  late AnimationController _scratchController;
  late AnimationController _revealController;
  late Animation<double> _scratchAnimation;
  late Animation<double> _revealAnimation;
  
  List<Offset> _scratchPoints = [];
  bool _isScratching = false;
  bool _isRevealed = false;
  double _scratchProgress = 0.0;

  @override
  void initState() {
    super.initState();
    
    _scratchController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scratchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scratchController,
      curve: Curves.easeInOut,
    ));

    _revealAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _revealController,
      curve: Curves.elasticOut,
    ));

    _scratchController.addListener(() {
      setState(() {
        _scratchProgress = _scratchAnimation.value;
      });
    });

    _scratchController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isRevealed) {
        _isRevealed = true;
        _revealController.forward();
        widget.onScratchComplete?.call();
      }
    });

    if (widget.isScratched) {
      _isRevealed = true;
      _scratchProgress = 1.0;
      _revealController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _scratchController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  void _onPanStart(DragStartDetails details) {
    if (_isRevealed) return;
    
    setState(() {
      _isScratching = true;
      _scratchPoints.clear();
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isRevealed || !_isScratching) return;
    
    setState(() {
      _scratchPoints.add(details.localPosition);
    });

    // Calculate scratch progress based on scratched area
    final progress = _calculateScratchProgress();
    if (progress >= widget.scratchThreshold && !_isRevealed) {
      _scratchController.forward();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isScratching = false;
    });
    
    // Check if enough scratching has been done
    final progress = _calculateScratchProgress();
    if (progress >= widget.scratchThreshold && !_isRevealed) {
      _isRevealed = true;
      _revealController.forward();
      widget.onScratchComplete?.call();
    }
  }

  double _calculateScratchProgress() {
    if (_scratchPoints.isEmpty) return 0.0;
    
    // Simple progress calculation based on number of points
    // In a real implementation, you'd calculate the actual scratched area
    final maxPoints = 50; // Adjust based on your needs
    return math.min(_scratchPoints.length / maxPoints, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base content (always visible)
        widget.child,
        
        // Scratch layer (only visible if not revealed)
        if (!_isRevealed)
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: CustomPaint(
              painter: ScratchPainter(
                scratchPoints: _scratchPoints,
                scratchProgress: _scratchProgress,
                scratchColor: const Color(0xFFFF7A00),
              ),
              child: widget.scratchLayer,
            ),
          ),
        
        // Reveal animation overlay
        if (_isRevealed)
          AnimatedBuilder(
            animation: _revealAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * _revealAnimation.value),
                child: Opacity(
                  opacity: _revealAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.blue.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.celebration,
                            color: Colors.orange,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Congratulations!',
                            style: TextStyle(
                              color: Color(0xFF2C3E50),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
    );
  }
}

class ScratchPainter extends CustomPainter {
  final List<Offset> scratchPoints;
  final double scratchProgress;
  final Color scratchColor;

  ScratchPainter({
    required this.scratchPoints,
    required this.scratchProgress,
    required this.scratchColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = scratchColor
      ..style = PaintingStyle.fill;

    // Create scratch pattern
    final random = math.Random(42); // Fixed seed for consistent pattern
    
    // Base scratch layer
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Add scratch texture
    for (int i = 0; i < 150; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 2 + 1;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.4)
          ..style = PaintingStyle.fill,
      );
    }

    // Remove scratched areas
    if (scratchPoints.isNotEmpty) {
      final scratchPaint = Paint()
        ..blendMode = BlendMode.clear;

      for (final point in scratchPoints) {
        canvas.drawCircle(point, 20, scratchPaint);
      }
    }

    // Progressive reveal based on scratch progress
    if (scratchProgress > 0) {
      final revealPaint = Paint()
        ..blendMode = BlendMode.clear;
      
      final revealRect = Rect.fromLTWH(
        0,
        0,
        size.width * scratchProgress,
        size.height,
      );
      
      canvas.drawRect(revealRect, revealPaint);
    }
  }

  @override
  bool shouldRepaint(ScratchPainter oldDelegate) {
    return scratchPoints != oldDelegate.scratchPoints ||
           scratchProgress != oldDelegate.scratchProgress;
  }
}
