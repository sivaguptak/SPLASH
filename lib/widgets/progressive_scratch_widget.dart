import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

class ProgressiveScratchWidget extends StatefulWidget {
  final Widget child;
  final Widget scratchLayer;
  final VoidCallback? onScratchComplete;
  final bool isScratched;
  final double scratchThreshold1; // 20%
  final double scratchThreshold2; // 70%
  final double scratchThreshold3; // 100%

  const ProgressiveScratchWidget({
    super.key,
    required this.child,
    required this.scratchLayer,
    this.onScratchComplete,
    this.isScratched = false,
    this.scratchThreshold1 = 0.2,
    this.scratchThreshold2 = 0.7,
    this.scratchThreshold3 = 1.0,
  });

  @override
  State<ProgressiveScratchWidget> createState() => _ProgressiveScratchWidgetState();
}

class _ProgressiveScratchWidgetState extends State<ProgressiveScratchWidget>
    with TickerProviderStateMixin {
  late AnimationController _scratchController;
  late AnimationController _revealController;
  late Animation<double> _scratchAnimation;
  late Animation<double> _revealAnimation;
  
  List<Offset> _scratchPoints = [];
  bool _isScratching = false;
  bool _isRevealed = false;
  double _scratchProgress = 0.0;
  int _currentStep = 0; // 0, 1, 2, 3

  @override
  void initState() {
    super.initState();
    
    _scratchController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      _currentStep = 3;
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

    // Calculate scratch progress and update step
    final progress = _calculateScratchProgress();
    _updateScratchStep(progress);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isScratching = false;
    });
    
    // Check if enough scratching has been done
    final progress = _calculateScratchProgress();
    if (progress >= widget.scratchThreshold3 && !_isRevealed) {
      _isRevealed = true;
      _revealController.forward();
      widget.onScratchComplete?.call();
    }
  }

  void _updateScratchStep(double progress) {
    int newStep = 0;
    if (progress >= widget.scratchThreshold3) {
      newStep = 3;
    } else if (progress >= widget.scratchThreshold2) {
      newStep = 2;
    } else if (progress >= widget.scratchThreshold1) {
      newStep = 1;
    }

    if (newStep != _currentStep) {
      setState(() {
        _currentStep = newStep;
      });
      
      // Trigger step animation
      _scratchController.forward();
    }
  }

  double _calculateScratchProgress() {
    if (_scratchPoints.isEmpty) return 0.0;
    
    // Calculate progress based on scratch area coverage
    // More realistic calculation considering the actual scratched area
    final totalPoints = _scratchPoints.length;
    
    // Each scratch point covers approximately 15px radius
    // Calculate estimated coverage area
    final estimatedCoverage = totalPoints * 15 * 15; // rough area calculation
    
    // Assume total area is roughly 300x400 = 120,000 pixels
    // Adjust these values based on your actual card size
    final totalArea = 300 * 400;
    
    final progress = math.min(estimatedCoverage / totalArea, 1.0);
    
    // Ensure minimum progress for better user experience
    return math.max(progress, totalPoints / 200.0);
  }

  String _getStepText() {
    final progress = _calculateScratchProgress();
    
    if (progress < 0.2) {
      return 'Start scratching...';
    } else if (progress < 0.5) {
      return 'Good! Keep going...';
    } else if (progress < 0.8) {
      return 'Almost there!';
    } else if (progress < 1.0) {
      return 'Just a bit more...';
    } else {
      return 'Revealed!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base content (always visible)
        widget.child,
        
        // Scratch layer with progressive opacity
        if (!_isRevealed)
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: AnimatedOpacity(
              opacity: _calculateLayerOpacity(),
              duration: const Duration(milliseconds: 300),
              child: CustomPaint(
                painter: ProgressiveScratchPainter(
                  scratchPoints: _scratchPoints,
                  scratchProgress: _scratchProgress,
                  currentStep: _currentStep,
                  scratchColor: const Color(0xFFFF7A00),
                ),
                child: Stack(
                  children: [
                    widget.scratchLayer,
                    // Step indicator
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStepText(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

  double _calculateLayerOpacity() {
    // Calculate opacity based on scratch progress
    // 0% scratched = 100% opacity (fully covered)
    // 100% scratched = 0% opacity (fully revealed)
    final progress = _calculateScratchProgress();
    return math.max(0.0, 1.0 - progress);
  }
}

class ProgressiveScratchPainter extends CustomPainter {
  final List<Offset> scratchPoints;
  final double scratchProgress;
  final int currentStep;
  final Color scratchColor;

  ProgressiveScratchPainter({
    required this.scratchPoints,
    required this.scratchProgress,
    required this.currentStep,
    required this.scratchColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create a gradient background for the scratch layer
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        scratchColor,
        scratchColor.withOpacity(0.8),
        scratchColor.withOpacity(0.9),
      ],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Base scratch layer
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Add scratch texture pattern
    final random = math.Random(42); // Fixed seed for consistent pattern
    final textureCount = 200 + (currentStep * 100); // More texture as steps progress
    
    for (int i = 0; i < textureCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 4 + 1;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.2 + (currentStep * 0.15))
          ..style = PaintingStyle.fill,
      );
    }

    // Create scratch marks (removed areas)
    if (scratchPoints.isNotEmpty) {
      final scratchPaint = Paint()
        ..blendMode = BlendMode.clear
        ..strokeWidth = 25.0
        ..strokeCap = StrokeCap.round;

      // Draw connected scratch lines
      for (int i = 0; i < scratchPoints.length - 1; i++) {
        canvas.drawLine(
          scratchPoints[i],
          scratchPoints[i + 1],
          scratchPaint,
        );
      }
      
      // Draw individual scratch circles for better coverage
      for (final point in scratchPoints) {
        canvas.drawCircle(point, 15, scratchPaint);
      }
    }

    // Progressive reveal based on scratch progress
    final progress = scratchProgress;
    if (progress > 0) {
      final revealPaint = Paint()
        ..blendMode = BlendMode.clear;
      
      // Create a mask that reveals more content as progress increases
      final revealWidth = size.width * progress;
      final revealHeight = size.height * progress;
      
      // Create a diagonal reveal effect
      final path = Path();
      path.moveTo(0, 0);
      path.lineTo(revealWidth, 0);
      path.lineTo(revealWidth, revealHeight);
      path.lineTo(0, revealHeight);
      path.close();
      
      canvas.drawPath(path, revealPaint);
    }
  }

  @override
  bool shouldRepaint(ProgressiveScratchPainter oldDelegate) {
    return scratchPoints != oldDelegate.scratchPoints ||
           scratchProgress != oldDelegate.scratchProgress ||
           currentStep != oldDelegate.currentStep;
  }
}
