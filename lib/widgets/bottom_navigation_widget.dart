import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/voice_search_service.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final Function(String)? onVoiceSearchResult;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.onVoiceSearchResult,
  });

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget>
    with TickerProviderStateMixin {
  bool _isListening = false;
  bool _isAvailable = false;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  
  // For real voice recognition
  String _lastRecognizedText = "";

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initAnimations();
  }

  void _initAnimations() {
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _initSpeech() async {
    _isAvailable = await VoiceSearchService.isAvailable();
    setState(() {});
  }

  void _startListening() async {
    if (!_isAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Speech recognition not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() {
      _isListening = true;
    });

    // Start wave animation
    _waveController.repeat(reverse: true);

    try {
      // Start listening for speech using our custom service
      final recognizedText = await VoiceSearchService.startListening();
      
      setState(() {
        _isListening = false;
        _lastRecognizedText = recognizedText ?? '';
      });
      
      _waveController.stop();
      
      if (recognizedText != null && recognizedText.isNotEmpty) {
        widget.onVoiceSearchResult?.call(recognizedText);
      }
    } catch (e) {
      setState(() {
        _isListening = false;
      });
      _waveController.stop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice recognition error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showVoiceInputDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 150,
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated microphone icon
                AnimatedBuilder(
                  animation: _waveAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Wave rings
                          Container(
                            width: 50 + (_waveAnimation.value * 12),
                            height: 50 + (_waveAnimation.value * 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red.withOpacity(0.6 - (_waveAnimation.value * 0.4)),
                                width: 2,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.mic,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Voice Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _isListening ? 'Listening... Speak now' : 'Tap microphone to start',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                if (_lastRecognizedText.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '"$_lastRecognizedText"',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                // Quick search buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildQuickSearchButton("Restaurants", context),
                    _buildQuickSearchButton("Lawyers", context),
                    _buildQuickSearchButton("Electricians", context),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                _showTextInputDialog(context); // Type custom
              },
              child: const Text(
                'Type Custom',
                style: TextStyle(color: Color(0xFFFF7A00)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuickSearchButton(String text, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFF7A00),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showTextInputDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Search Term'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Type what you want to search for...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final text = textController.text.trim();
                if (text.isNotEmpty) {
                  widget.onVoiceSearchResult?.call(text);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }

  void _stopListening() {
    VoiceSearchService.stopListening();
    setState(() {
      _isListening = false;
    });
    _waveController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF2C3E50),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.search, 'Explore', 1),
              _buildVoiceSearchButton(),
              _buildNavItem(Icons.history, 'My Activity', 3),
              _buildNavItem(Icons.person, 'Profile', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceSearchButton() {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wave animation rings
          if (_isListening)
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  width: 50 + (_waveAnimation.value * 20),
                  height: 50 + (_waveAnimation.value * 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.withOpacity(0.6 - (_waveAnimation.value * 0.4)),
                      width: 2,
                    ),
                  ),
                );
              },
            ),
          
          // Second wave ring
          if (_isListening)
            AnimatedBuilder(
              animation: _waveAnimation,
              builder: (context, child) {
                return Container(
                  width: 50 + ((1 - _waveAnimation.value) * 15),
                  height: 50 + ((1 - _waveAnimation.value) * 15),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.withOpacity(0.4 - ((1 - _waveAnimation.value) * 0.2)),
                      width: 1.5,
                    ),
                  ),
                );
              },
            ),
          
          // Main button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _isListening ? Colors.red : const Color(0xFFFF7A00),
            shape: BoxShape.circle,
              boxShadow: _isListening ? [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.red.withOpacity(0.2),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
              ] : [
                BoxShadow(
                  color: const Color(0xFFFF7A00).withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                key: ValueKey(_isListening),
            color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
        ),
      );
    }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = widget.selectedIndex == index;

    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF7A00) : Colors.grey,
            size: 18,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF7A00) : Colors.grey,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
