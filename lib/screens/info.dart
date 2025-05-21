import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  final String pageTitle;
  final String pageDescription;

  const InfoDialog({
    super.key,
    required this.pageTitle,
    required this.pageDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          maxHeight: MediaQuery.of(context).size.height * 0.7 , // +80 pixels
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // 🔹 Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/screen.jpg',
                  fit: BoxFit.cover,
                ),
              ),

              // 🔹 Dark Overlay
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),

              // 🔹 Content Area
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Center(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - 70, // ensures vertical centering if content is small
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  pageDescription,
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
                      ),
                    );
                  },
                ),
              ),

              // 🔹 Close Button
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
}

class PageInfo {
  static Map<String, Map<String, String>> infoData = {
    'Page1': {
      'title': 'Welcome to the Featured Events Page!',
      'description':
          'Here you can browse top events, view suggestions, and navigate to full event details. Swipe to explore or tap on a card to learn more.',
    },
    'Page2': {
      'title': 'Activities Hub',
      'description':
          'Access various international activities including internships, student exchanges, and alumni connections. Navigate through different categories.',
    },
    'Page3': {
      'title': 'My Tickets',
      'description':
          'View your currently booked event tickets and past attendance history. Generate QR codes for event check-ins.',
    },
    'Page4': {
      'title': 'IR Community',
      'description':
          'Explore resources, articles, and videos about international relations. Connect with alumni and access study abroad materials.',
    },
  };

  static void showInfoDialog(BuildContext context, String pageKey) {
    final info = infoData[pageKey];
    if (info != null) {
      showDialog(
        context: context,
        builder: (context) => InfoDialog(
          pageTitle: info['title']!,
          pageDescription: info['description']!,
        ),
      );
    }
  }
}