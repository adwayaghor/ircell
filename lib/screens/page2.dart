import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/models/dashed_line_painter.dart';
import 'package:ircell/screens/chatbot/chatbot_icon.dart';
import 'package:ircell/screens/events/events_screen.dart';
import 'package:ircell/screens/internships/internships_screen.dart';
import 'package:ircell/screens/activities/user.dart';
import 'package:ircell/activities/about_us.dart';
import 'package:ircell/screens/profile_page.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Page2> {
  Widget _buildCategoryButton(int index, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventsScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InternshipsScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const User()),
          );
        }
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryButton(0, 'Events', Icons.event),
              _buildCategoryButton(1, 'Internships', Icons.work),
              _buildCategoryButton(2, 'User', Icons.person),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCard(
    String title,
    String imagePath,
    double height, {
    VoidCallback? onTap,
  }) {
    return SizedBox(
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                      decoration: AppTheme.glassDecoration,
                       child: IconButton(
                        icon: const Icon(Icons.info_outline, color: AppTheme.textPrimary),
                        onPressed: () => PageInfo.showInfoDialog(context, 'Page2'), 
                        ),
                      ),
            Row(
              children: [
                Container(
                  decoration: AppTheme.glassDecoration,
                  child: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () => PageNotification.showNotificationDialog(context, 'Page2'),
                    // onPressed: () => PageNotification.showSameNotification(context);
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent, // to keep your design intact
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: AppTheme.accentBlue,
                      child: const Text(
                        'A',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children:[

          Column(
            children: [
              // Top strip with text below app bar
              Container(
                width: double.infinity,
                height: 50,
                color: AppTheme.accentBlue,
                alignment: Alignment.center,
                child: const Text(
                  "International Relations Cell",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryButtons(),
                        // Separator line (dashed)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: CustomPaint(
                              size: Size(MediaQuery.of(context).size.width * 0.8, 1),
                              painter: DashedLinePainter(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: buildCard(
                                    "Events",
                                    'assets/images/events.png',
                                    190,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      buildCard(
                                        "Student Mobility",
                                        'assets/images/student_mobility.png',
                                        90,
                                      ),
                                      const SizedBox(height: 10),
                                      buildCard(
                                        "International Alumni",
                                        'assets/images/international_alumini.png',
                                        90,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      buildCard(
                                        "About Us",
                                        'assets/images/about_us.png',
                                        95,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const AboutUsPage(),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      buildCard(
                                        "International Students",
                                        'assets/images/international_students.png',
                                        95,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: buildCard(
                                    "Higher Studies",
                                    'assets/images/higher_studies.png',
                                    200,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ChatbotIcon(),
          ),
          ] 
        ),
      ),
    );
  }
}
