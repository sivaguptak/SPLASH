import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import '../core/theme.dart';

class ScratchCouponWidget extends StatefulWidget {
  final String title;
  final String description;
  final String discount;
  final String expiryDate;
  final bool isScratched;
  final VoidCallback? onScratchComplete;
  final Color? backgroundColor;
  final Color? scratchColor;

  const ScratchCouponWidget({
    super.key,
    required this.title,
    required this.description,
    required this.discount,
    required this.expiryDate,
    this.isScratched = false,
    this.onScratchComplete,
    this.backgroundColor,
    this.scratchColor,
  });

  @override
  State<ScratchCouponWidget> createState() => _ScratchCouponWidgetState();
}

class _ScratchCouponWidgetState extends State<ScratchCouponWidget>
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
    if (_scratchPoints.length > 5) {
      _scratchController.forward();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isScratching = false;
    });
    
    // If enough scratching has been done, complete the reveal
    if (_scratchPoints.length > 5 && !_isRevealed) {
      _isRevealed = true;
      _revealController.forward();
      widget.onScratchComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          // Base coupon card
          _buildCouponCard(),
          
          // Scratch layer
          if (!_isRevealed)
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              onTap: () {
                // Simple tap to scratch for testing
                if (!_isRevealed) {
                  setState(() {
                    _scratchPoints = [
                      const Offset(50, 50),
                      const Offset(100, 50),
                      const Offset(150, 50),
                      const Offset(200, 50),
                      const Offset(250, 50),
                      const Offset(300, 50),
                    ];
                    _isRevealed = true;
                    _scratchProgress = 1.0;
                  });
                  _revealController.forward();
                  widget.onScratchComplete?.call();
                }
              },
              child: CustomPaint(
                painter: ScratchPainter(
                  scratchPoints: _scratchPoints,
                  scratchProgress: _scratchProgress,
                  scratchColor: widget.scratchColor ?? LocsyColors.slate,
                ),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
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
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            LocsyColors.orange.withOpacity(0.1),
                            LocsyColors.cream.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.celebration,
                              color: LocsyColors.orange,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Congratulations!',
                              style: TextStyle(
                                color: LocsyColors.navy,
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
      ),
    );
  }

  Widget _buildCouponCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.backgroundColor ?? LocsyColors.cream,
        border: Border.all(color: LocsyColors.orange, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Left side - Discount info
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: LocsyColors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.discount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Text(
                      'OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Right side - Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: LocsyColors.navy,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: LocsyColors.slate,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: LocsyColors.slate,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Expires: ${widget.expiryDate}',
                        style: TextStyle(
                          color: LocsyColors.slate,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Scratch instruction
            if (!_isRevealed)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: LocsyColors.slate.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: LocsyColors.slate,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap/Scratch',
                      style: TextStyle(
                        color: LocsyColors.slate,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
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
    for (int i = 0; i < 200; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 3 + 1;
      
      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill,
      );
    }

    // Remove scratched areas
    if (scratchPoints.isNotEmpty) {
      final scratchPaint = Paint()
        ..blendMode = BlendMode.clear;

      for (final point in scratchPoints) {
        canvas.drawCircle(point, 15, scratchPaint);
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
