import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(
            color: AppTheme.textPrimary(context),
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark 
            ? AppTheme.primaryDarkBlue.withOpacity(0.9)
            : AppTheme.accentBlue.withOpacity(0.9),
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.textPrimary(context)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppTheme.blueGradient(context)
              : LinearGradient(
                  colors: [Colors.blue.shade50, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle('Our Team', context),
                const SizedBox(height: 20),
                _buildDevelopersGrid(context),
                const SizedBox(height: 20),
                _buildSectionTitle('About IR', context),
                const SizedBox(height: 20),
                _buildAboutIRSection(context),
                const SizedBox(height: 40),
                _buildSectionTitle('IR Coordinators', context),
                const SizedBox(height: 20),
                _buildCoordinatorsSection(context),
                const SizedBox(height: 40),
                _buildSectionTitle('Partnerships', context),
                const SizedBox(height: 20),
                _buildPartnershipsSection(context),
                const SizedBox(height: 40),
                _buildSectionTitle('Contact Us', context),
                const SizedBox(height: 20),
                _buildContactUsSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            color: AppTheme.textPrimary(context),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDevelopersGrid(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    const developers = [
      {'name': 'Alex Johnson', 'role': 'Flutter Developer', 'image': 'assets/dev1.jpg'},
      {'name': 'Maria Garcia', 'role': 'UI/UX Designer', 'image': 'assets/dev2.jpg'},
      {'name': 'James Smith', 'role': 'Backend Developer', 'image': 'assets/dev3.jpg'},
      {'name': 'Sarah Williams', 'role': 'Project Manager', 'image': 'assets/dev4.jpg'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: developers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (context, index) {
          final dev = developers[index];
          return _buildGlassCard(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(dev['image']!),
                    backgroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dev['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dev['role']!,
                    style: TextStyle(
                      color: AppTheme.textSecondary(context),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutIRSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildGlassCard(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'IR (Investor Relations) integrates finance, communication, marketing, and legal compliance to foster effective communication between companies and investors, enabling fair market valuation.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppTheme.textPrimary(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinatorsSection(BuildContext context) {
    const coordinators = [
      {
        'name': 'Dr. Robert Chen',
        'position': 'Head of Investor Relations',
        'department': 'Finance Department',
        'image': 'assets/coordinator1.jpg',
      },
      {
        'name': 'Emily Wilson',
        'position': 'IR Communications Manager',
        'department': 'Marketing Department',
        'image': 'assets/coordinator2.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: coordinators.map((coordinator) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildGlassCard(
              context: context,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(coordinator['image']!),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coordinator['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.textPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coordinator['position']!,
                            style: TextStyle(
                              color: AppTheme.textSecondary(context),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coordinator['department']!,
                            style: TextStyle(
                              color: AppTheme.textSecondary(context),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPartnershipsSection(BuildContext context) {
    const partners = [
      'Goldman Sachs',
      'Morgan Stanley',
      'J.P. Morgan',
      'BlackRock',
      'Bloomberg',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildGlassCard(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Our Valued Partners',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: partners.map((partner) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 20,
                          color: AppTheme.textSecondary(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          partner,
                          style: TextStyle(
                            color: AppTheme.textPrimary(context),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactUsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildGlassCard(
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Get in Touch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                Icons.email,
                'Email',
                'contact@irplatform.com',
                context,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.phone,
                'Phone',
                '+1 (555) 123-4567',
                context,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.location_on,
                'Address',
                '123 Financial District,\nNew York, NY 10005',
                context,
              ),
              const SizedBox(height: 16),
              Text(
                'Follow Us',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook, context),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.camera_alt, context),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.link, context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.textSecondary(context),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: AppTheme.textSecondary(context),
                ),
                softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon, BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppTheme.textPrimary(context),
      ),
    );
  }

  Widget _buildGlassCard({
    required BuildContext context,
    required Widget child,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.2)
                : Colors.blue.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.1 : 0.05),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}