import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      print("User typed: ${_controller.text.trim()}");
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                // Expanded chat area (now completely empty)
                const Expanded(child: SizedBox()),

                // Input bar at bottom with fully curved container
                Container(
                  margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
