import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/splash_screen.dart';
import 'package:ircell/screens/community/alumni_blogs.dart';
import 'package:ircell/screens/community/articles_page.dart';
import 'package:ircell/screens/community/japan_facilitation_centre/jfc.dart';
import 'package:ircell/screens/profile_page.dart';
import 'package:ircell/screens/chatbot/chatbot_icon.dart';
import 'package:ircell/screens/info.dart';
import 'package:ircell/screens/notification.dart';
import 'package:ircell/providers/articles_provider.dart';

class Page4 extends StatefulWidget {
  const Page4({super.key});

  @override
  State<Page4> createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final User? user = Auth().currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await Auth().signOut();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Error'),
                content: Text(e.message ?? 'An error occurred'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it!'),
                  ),
                ],
              ),
        );
      }
    }
  }

  Widget userUID() {
    return Text(user?.email ?? 'User email');
  }

  Widget signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          decoration: AppTheme.glassDecoration(context),
          child: IconButton(
            icon: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.onSurface,),
            onPressed: () => PageInfo.showInfoDialog(context, 'Page4'),
          ),
        ),
        title: const Text('IR Community'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: AppTheme.glassDecoration(context),
                    child: IconButton(
                      icon: const Icon(Icons.notifications),
                      onPressed:
                          () => PageNotification.showNotificationDialog(
                            context,
                            'Page4',
                          ),
                      // onPressed: () => PageNotification.showSameNotification(context);
                    ),
                  ),
                  const SizedBox(width: 8),
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
                        backgroundColor: AppTheme.accentBlue,
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: AppTheme.textPrimary(context),
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
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Resources'),
                  Tab(text: 'Articles'),
                  Tab(text: 'Videos'),
                ],
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _buildResourcesTab(),
              _buildArticlesTab(),
              _buildVideosTab(),
            ],
          ),
          // Chatbot icon positioned in the bottom right corner
          Positioned(bottom: 20, right: 20, child: FloatingButtonsStack()),
        ],
      ),
    );
  }

  Widget _buildResourcesTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = screenWidth > 600 ? 24.0 : 16.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Japan Facilitation Centre',
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JapanFacilitationCentre(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image from assets
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/jfc.jpg',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Text(
                        'Get support for your study and career in Japan.',
                        style: TextStyle(color: AppTheme.textSecondary(context)),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const JapanFacilitationCentre(),
                            ),
                          );
                        },
                        child: const Text('Learn More'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Text('Higher Studies Archive'),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildArchiveItem(
                    title: 'Colleges in Germany',
                    icon: Icons.school,
                  ),
                  const SizedBox(width: 16),
                  _buildArchiveItem(
                    title: 'US Scholarships',
                    icon: Icons.attach_money,
                  ),
                  const SizedBox(width: 16),
                  _buildArchiveItem(
                    title: 'UK Universities',
                    icon: Icons.account_balance,
                  ),
                  const SizedBox(width: 16),
                  _buildArchiveItem(
                    title: 'Australia Education',
                    icon: Icons.menu_book,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            userUID(),
            const SizedBox(height: 20),
            signOutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildArticlesTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = screenWidth > 600 ? 24.0 : 16.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                // Navigate to Alumni Blogs page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AlumniBlogsPage(),
                  ),
                );
              },
              child: Row(
                children: [
                  const Text('Alumni Blogs', style: TextStyle(fontSize: 16)),

                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: _buildBlogItem(
                      title: 'My Experience at Tokyo University',
                      author: 'Akira Tanaka',
                      date: 'May 10, 2025',
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: _buildBlogItem(
                      title: 'Navigating Student Life in Osaka',
                      author: 'Chen Wei',
                      date: 'April 22, 2025',
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: _buildBlogItem(
                      title: 'From Engineering Student to Tech Lead in Tokyo',
                      author: 'Kim Soo-jin',
                      date: 'March 15, 2025',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(color: AppTheme.textSecondary(context), thickness: 1),
            const SizedBox(height: 16),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ArticlesPage()),
                );
              },
              child: Row(
                children: [
                  const Text('Articles', style: TextStyle(fontSize: 16)),

                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Show only 3 articles here as preview
            buildArticlesList(context, limit: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = screenWidth > 600 ? 24.0 : 16.0;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Videos',
              style: TextStyle(
                color: AppTheme.textPrimary(context),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildVideoCard(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoCard(int index) {
    return Container(
      decoration: AppTheme.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.accentBlue.withOpacity(0.7),
                      AppTheme.darkTeal.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 40,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video Title ${index + 1}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '2:45 • May ${10 + index}, 2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlogItem({
    required String title,
    required String author,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person, size: 30, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'By $author • $date',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: AppTheme.textSecondary(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Read more',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchiveItem({required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
