import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/login/splash_screen.dart';

class Page4 extends StatelessWidget {
  Page4({super.key});

  final User? user = Auth().currentUser;

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
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
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
        automaticallyImplyLeading: false,
        title: const Text('IR Community'),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                'A',
                style: TextStyle(
                  //color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onPressed: () {
              // Profile action
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Resources', isSelected: true),
                    _buildCategoryChip('Articles'),
                    _buildCategoryChip('Videos'),
                    _buildCategoryChip('Guides'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Japan Facilitation Centre
              const Text(
                'Japan Facilitation Centre',
                //style: AppTheme.headingStyle,
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFacilitationCard(),
                    const SizedBox(width: 16),
                    _buildFacilitationCard(
                      title: 'Job Placement in Japan',
                      description:
                          'Connect with top Japanese companies and get placed in your dream job.',
                    ),
                    const SizedBox(width: 16),
                    _buildFacilitationCard(
                      title: 'Language Training',
                      description:
                          'Intensive Japanese language courses for international students and professionals.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Alumni Blogs
              const Text(
                'Alumni Blogs',
                //style: AppTheme.headingStyle
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

              const SizedBox(height: 32),

              // Higher Studies Archive
              const Text(
                'Higher Studies Archive',
                //style: AppTheme.headingStyle,
              ),
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

              const SizedBox(height: 32),

              // Guidance Section
              const Text(
                'Guidance',
                //style: AppTheme.headingStyle
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildGuidanceItem(
                      title: 'SOP Writing',
                      description:
                          'Learn how to write effective statements of purpose',
                      icon: Icons.edit_document,
                    ),
                    const SizedBox(width: 16),
                    _buildGuidanceItem(
                      title: 'Visa Registration',
                      description:
                          'Step-by-step guide to student visa applications',
                      icon: Icons.card_travel,
                    ),
                    const SizedBox(width: 16),
                    _buildGuidanceItem(
                      title: 'Interview Prep',
                      description: 'Tips for university admission interviews',
                      icon: Icons.record_voice_over,
                    ),
                    const SizedBox(width: 16),
                    _buildGuidanceItem(
                      title: 'Scholarship Apps',
                      description: 'How to find and apply for scholarships',
                      icon: Icons.school,
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
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        //backgroundColor: isSelected ? AppTheme.primaryBlue : Colors.grey[200],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildFacilitationCard({
    String title = 'Japan Study & Career Support',
    String description =
        'Get guidance on studying and working in Japan with our specialized support services.',
  }) {
    return SizedBox(
      width: 280,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                //style: AppTheme.subHeadingStyl
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: const Text('Learn More')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlogItem({
    required String title,
    required String author,
    required String date,
  }) {
    return Container(
      //decoration: AppTheme.successStoryDecoration,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'By $author • $date',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 8,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Read more',
                      style: TextStyle(
                        fontSize: 12,
                        //color: AppTheme.primaryBlue,
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
      //decoration: AppTheme.successStoryDecoration,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidanceItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}