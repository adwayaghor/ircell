import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> with WidgetsBindingObserver {
  final TextEditingController _controller = TextEditingController();
  bool _showGif = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(() {
      if (_controller.text.trim().isNotEmpty && _showGif) {
        setState(() {
          _showGif = false;
        });
      } else if (_controller.text.trim().isEmpty &&
          MediaQuery.of(context).viewInsets.bottom == 0) {
        setState(() {
          _showGif = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset == 0 && _controller.text.trim().isEmpty) {
      setState(() {
        _showGif = true;
      });
    } else if (bottomInset > 0) {
      // When keyboard opens, hide GIF regardless of input text
      if (_showGif) {
        setState(() {
          _showGif = false;
        });
      }
    }
  }

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      print("User typed: ${_controller.text.trim()}");
      _controller.clear();
      setState(() {
        _showGif = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // <-- Prevent zooming/resize when keyboard appears
      body: Stack(
        children: [
          // Black background for status bar area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.black),
          ),
          
          // Background Image covering screen below status bar
          Positioned.fill(
            top: MediaQuery.of(context).padding.top,
            child: Image.asset(
              'assets/images/chatbot_bg.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // GIF overlay when enabled
          if (_showGif)
            Positioned.fill(
              child: Center(
                child: Image.asset('assets/images/chatbot.gif'),
              ),
            ),

          // Main content with SafeArea for status bar padding
          SafeArea(
            child: Column(
              children: [
                // Chatbot strip (app bar style)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDarkBlue,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Back button with circular background
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Chatbot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                // Expanded chat area (currently empty)
                const Expanded(child: SizedBox()),

                // Input bar at bottom with fully curved container
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? MediaQuery.of(context).viewInsets.bottom : 16, left: 16, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDarkBlue,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // Expanded TextField inside the curved container
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              cursorColor: AppTheme.lightTeal,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 16),
                                hintText: "Type your message...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.transparent,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                        ),

                        // Send button inside the same curved container
                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          height: 40,
                          width: 40,
                          child: ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentBlue,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Icon(Icons.send, size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
