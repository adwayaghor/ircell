import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:ircell/app_theme.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryDarkBlue.withOpacity(0.9),
        elevation: 0,
      ),
      body: Container(
        color: AppTheme.primaryDarkBlue,  // Changed to solid primaryDarkBlue color
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle('Our Team'),
                const SizedBox(height: 20),
                _buildDevelopersGrid(),  // Changed for grid layout instead of horizontal scroll
                const SizedBox(height: 20),
                _buildSectionTitle('About IR'),
                const SizedBox(height: 20),
                _buildAboutIRSection(),
                const SizedBox(height: 40),
                _buildSectionTitle('IR Coordinators'),
                const SizedBox(height: 20),
                _buildCoordinatorsSection(),
                const SizedBox(height: 40),
                _buildSectionTitle('Partnerships'),
                const SizedBox(height: 20),
                _buildPartnershipsSection(),
                const SizedBox(height: 40),
                _buildSectionTitle('Contact Us'),
                const SizedBox(height: 20),
                _buildContactUsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Changed developers section to a 2-column Grid instead of horizontal ListView
  Widget _buildDevelopersGrid() {
    const developers = [
      {
        'name': 'Alex Johnson',
        'role': 'Flutter Developer',
        'image': 'assets/dev1.jpg',
      },
      {
        'name': 'Maria Garcia',
        'role': 'UI/UX Designer',
        'image': 'assets/dev2.jpg',
      },
      {
        'name': 'James Smith',
        'role': 'Backend Developer',
        'image': 'assets/dev3.jpg',
      },
      {
        'name': 'Sarah Williams',
        'role': 'Project Manager',
        'image': 'assets/dev4.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: developers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // 2 cards per row
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3 / 4, // Adjust height/width ratio
        ),
        itemBuilder: (context, index) {
          final dev = developers[index];
          return _buildGlassCard(
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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dev['role']!,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
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

  Widget _buildAboutIRSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildGlassCard(
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'IR (Investor Relations) integrates finance, communication, marketing, and legal compliance to foster effective communication between companies and investors, enabling fair market valuation.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCoordinatorsSection() {
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
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coordinator['position']!,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coordinator['department']!,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
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

  Widget _buildPartnershipsSection() {
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Our Valued Partners',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: partners.map((partner) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.business, size: 20, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          partner,
                          style: const TextStyle(color: AppTheme.textPrimary),
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

  Widget _buildContactUsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildGlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Get in Touch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(Icons.email, 'Email', 'contact@irplatform.com'),
              const SizedBox(height: 12),
              _buildContactItem(Icons.phone, 'Phone', '+1 (555) 123-4567'),
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.location_on,
                'Address',
                '123 Financial District,\nNew York, NY 10005',  // Inserted \n for line break
              ),
              const SizedBox(height: 16),
              const Text(
                'Follow Us',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.camera_alt),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.link),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: 12),
        Expanded( // Add Expanded to prevent overflow horizontally
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(value,
                style: const TextStyle(color: AppTheme.textSecondary),
                softWrap: true,  // allow wrapping text
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppTheme.textPrimary),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: AppTheme.glassDecoration,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}
