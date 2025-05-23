import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/models/dashed_line_painter.dart';
import 'package:ircell/screens/activities/alumni.dart';
import 'package:ircell/screens/chatbot/chatbot_icon.dart';
import 'package:ircell/screens/events/events_screen.dart';
import 'package:ircell/screens/internships/internships_screen.dart';
import 'package:ircell/screens/activities/about_us.dart';
import 'package:ircell/screens/profile_page.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Page2> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildQuickAccessButton(
    String title,
    IconData icon,
    VoidCallback onTap,
    Color accentColor,
    Size screenSize,
  ) {
    double buttonHeight = screenSize.height * 0.12;
    double iconSize = screenSize.width * 0.055;
    double fontSize = screenSize.width * 0.028;
    double padding = screenSize.width * 0.03;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: buttonHeight.clamp(80.0, 120.0),
        padding: EdgeInsets.all(padding.clamp(12.0, 20.0)),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withOpacity(0.8),
              accentColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(screenSize.width * 0.04),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(screenSize.width * 0.025),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: iconSize.clamp(18.0, 28.0),
              ),
            ),
            SizedBox(height: screenSize.height * 0.008),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize.clamp(10.0, 14.0),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(Size screenSize) {
    double horizontalPadding = screenSize.width * 0.04;
    double verticalPadding = screenSize.height * 0.01;
    double titleFontSize = screenSize.width * 0.045;
    double buttonSpacing = screenSize.width * 0.03;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: horizontalPadding.clamp(12.0, 20.0),
        vertical: verticalPadding.clamp(6.0, 12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: titleFontSize.clamp(16.0, 20.0),
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: screenSize.height * 0.015),
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessButton(
                  'Events',
                  Icons.event,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventsScreen(),
                    ),
                  ),
                  AppTheme.accentBlue,
                  screenSize,
                ),
              ),
              SizedBox(width: buttonSpacing.clamp(8.0, 16.0)),
              Expanded(
                child: _buildQuickAccessButton(
                  'Internships',
                  Icons.work_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InternshipsScreen(),
                    ),
                  ),
                  Colors.deepOrange,
                  screenSize,
                ),
              ),
              SizedBox(width: buttonSpacing.clamp(8.0, 16.0)),
              Expanded(
                child: _buildQuickAccessButton(
                  'My Profile',
                  Icons.person_outline,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  ),
                  Colors.green,
                  screenSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    String imagePath,
    double heightRatio,
    Size screenSize, {
    VoidCallback? onTap,
    bool isLarge = false,
  }) {
    double cardHeight = screenSize.height * heightRatio;
    double titleFontSize =
        isLarge ? screenSize.width * 0.045 : screenSize.width * 0.04;
    double subtitleFontSize =
        isLarge ? screenSize.width * 0.035 : screenSize.width * 0.03;
    double borderRadius = screenSize.width * 0.04;
    double bottomPadding = screenSize.width * 0.04;

    return Container(
      height: cardHeight.clamp(100.0, 200.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: bottomPadding.clamp(12.0, 20.0),
                left: bottomPadding.clamp(12.0, 20.0),
                right: bottomPadding.clamp(12.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFontSize.clamp(14.0, 20.0),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      SizedBox(height: screenSize.height * 0.005),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: subtitleFontSize.clamp(11.0, 16.0),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final double headerPadding = screenSize.height * 0.02;
    final double titleFontSize =
        isSmallScreen ? screenSize.width * 0.05 : screenSize.width * 0.055;
    final double sectionTitleFontSize = screenSize.width * 0.045;
    final double cardSpacing = screenSize.width * 0.03;
    final double sectionPadding = screenSize.width * 0.04;

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
                icon: Icon(
                  Icons.info_outline,
                  color: AppTheme.textPrimary,
                  size: screenSize.width * 0.06,
                ),
                onPressed: () => PageInfo.showInfoDialog(context, 'Page2'),
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: AppTheme.glassDecoration,
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications,
                      size: screenSize.width * 0.06,
                    ),
                    onPressed:
                        () => PageNotification.showNotificationDialog(
                          context,
                          'Page2',
                        ),
                  ),
                ),
                SizedBox(width: screenSize.width * 0.02),
                Material(
                  color: Colors.transparent,
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
                      radius: screenSize.width * 0.05,
                      backgroundColor: AppTheme.accentBlue,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: screenSize.width * 0.04,
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
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  // Enhanced header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.cardColor,
                          AppTheme.cardColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: headerPadding.clamp(12.0, 20.0),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "International Relations Cell",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: titleFontSize.clamp(18.0, 24.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenSize.height * 0.005),
                              // Text(
                              //   "Connecting Minds, Building Futures",
                              //   style: TextStyle(
                              //     color: Colors.white.withOpacity(0.9),
                              //     fontSize: subtitleFontSize.clamp(12.0, 16.0),
                              //     fontStyle: FontStyle.italic,
                              //   ),
                              //   textAlign: TextAlign.center,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenSize.height * 0.02),
                          _buildQuickAccessSection(screenSize),

                          // Separator
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenSize.height * 0.025,
                              ),
                              child: CustomPaint(
                                size: Size(screenSize.width * 0.8, 1),
                                painter: DashedLinePainter(),
                              ),
                            ),
                          ),

                          // _buildStatsSection(screenSize),

                          // Feature cards section
                          Padding(
                            padding: EdgeInsets.all(
                              sectionPadding.clamp(12.0, 20.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Explore Opportunities',
                                  style: TextStyle(
                                    fontSize: sectionTitleFontSize.clamp(
                                      16.0,
                                      20.0,
                                    ),
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.02),
                                // First row - Two equal columns
                                _buildFeatureCard(
                                  "Higher Studies",
                                  "Explore global education opportunities",
                                  'assets/images/higher_studies2.png',
                                  0.18,
                                  screenSize,
                                  // isLarge: true,
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const AboutUsPage(),
                                        ),
                                      ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFeatureCard(
                                        "Higher Studies",
                                        "Explore global education opportunities",
                                        'assets/images/higher_studies2.png',
                                        0.2,
                                        screenSize,
                                        isLarge: true,
                                      ),
                                    ),
                                    SizedBox(
                                      width: cardSpacing.clamp(8.0, 16.0),
                                    ),
                                    Expanded(
                                      child: _buildFeatureCard(
                                        "Student Mobility",
                                        "Semester abroad programs",
                                        'assets/images/student_mobility3.png',
                                        0.2,
                                        screenSize,
                                        isLarge: true,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: cardSpacing.clamp(8.0, 16.0)),
                                // Second row - Two equal columns
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildFeatureCard(
                                        "Alumni Network",
                                        "Connect with global alumni",
                                        'assets/images/international_alumini2.png',
                                        0.18,
                                        screenSize,
                                        onTap:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) =>
                                                        const AlumniScreen(),
                                              ),
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: cardSpacing.clamp(8.0, 16.0),
                                    ),
                                    Expanded(
                                      child: _buildFeatureCard(
                                        "International Community",
                                        "Support for international students",
                                        'assets/images/international_students2.png',
                                        0.18,
                                        screenSize,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: cardSpacing.clamp(8.0, 16.0)),
                                // Third row - Single full-width card
                                _buildFeatureCard(
                                  "About International Relations Cell",
                                  "Learn about our mission, vision and impact on global education",
                                  'assets/images/about_us2.png',
                                  0.18,
                                  screenSize,
                                  // isLarge: true,
                                  onTap:
                                      () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const AboutUsPage(),
                                        ),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.1,
                          ), // Space for floating action button
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: screenSize.height * 0.025,
              right: screenSize.width * 0.05,
              child: FloatingButtonsStack(),
            ),
          ],
        ),
      ),
    );
  }
}
