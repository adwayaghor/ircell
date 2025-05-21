import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final String pageTitle;
  final String notificationText;

  const NotificationDialog({
    super.key,
    required this.pageTitle,
    required this.notificationText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.5, // Adjustable
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/notif.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // Dark Overlay for readability
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

              //  Notification Content
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: _buildContent(),
              ),

              // Close Button
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pageTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    notificationText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PageNotification {
  static Map<String, Map<String, String>> notificationData = {
    'Page1': {
      'title': 'Featured Events Updates',
      'text': '2 new events have been added recently. Tap to explore!',
    },
    'Page2': {
      'title': 'Activities Hub Notifications',
      'text': 'New internships and exchange opportunities are live now.',
    },
    'Page3': {
      'title': 'Ticket Alerts',
      'text': 'Your upcoming event ticket has been updated. Check details.',
    },
    'Page4': {
      'title': 'Community Announcements',
      'text': 'Join our next IR Alumni Q&A webinar this weekend!',
    },
  };

  static void showNotificationDialog(BuildContext context, String pageKey) {
    final data = notificationData[pageKey];
    if (data != null) {
      showDialog(
        context: context,
        builder: (context) => NotificationDialog(
          pageTitle: data['title']!,
          notificationText: data['text']!,
        ),
      );
    }
  }

  /* For common screen
  static void showSameNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const NotificationDialog(
        pageTitle: 'General Notification',
        notificationText: 'Here is a universal notification for all pages.',
      ),
    );
  }
  */
}
