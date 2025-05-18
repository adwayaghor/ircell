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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0088CC),
              Color(0xFF00BCD4),
              Color(0xFF5CDEFC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Developers Section
                _buildSectionTitle('Our Team'),
                const SizedBox(height: 20),
                _buildDevelopersSection(),
                const SizedBox(height: 40),
                
                // About IR Section
                _buildSectionTitle('About IR'),
                const SizedBox(height: 20),
                _buildAboutIRSection(),
                const SizedBox(height: 40),
                
                // IR Coordinators Section
                _buildSectionTitle('IR Coordinators'),
                const SizedBox(height: 20),
                _buildCoordinatorsSection(),
                const SizedBox(height: 40),
                
                // Partnerships Section
                _buildSectionTitle('Partnerships'),
                const SizedBox(height: 20),
                _buildPartnershipsSection(),
                const SizedBox(height: 40),
                
                // Contact Us Section
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
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDevelopersSection() {
    const developers = [
      {
        'name': 'Alex Johnson',
        'role': 'Flutter Developer',
        'image': 'assets/dev1.jpg', // Replace with actual asset path
      },
      {
        'name': 'Maria Garcia',
        'role': 'UI/UX Designer',
        'image': 'assets/dev2.jpg', // Replace with actual asset path
      },
      {
        'name': 'James Smith',
        'role': 'Backend Developer',
        'image': 'assets/dev3.jpg', // Replace with actual asset path
      },
      {
        'name': 'Sarah Williams',
        'role': 'Project Manager',
        'image': 'assets/dev4.jpg', // Replace with actual asset path
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: developers.length,
        itemBuilder: (context, index) {
          final dev = developers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: 160,
              child: _buildGlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: const AssetImage('assets/placeholder.png'), // Fallback image
                        backgroundColor: Colors.transparent,
                        child: dev['image'] != null 
                            ? ClipOval(child: Image.asset(dev['image']!, fit: BoxFit.cover))
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dev['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dev['role']!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
            'IR (Investor Relations) is a strategic management responsibility that integrates finance, communication, marketing and securities law compliance to enable the most effective two-way communication between a company, the financial community, and other constituencies, which ultimately contributes to a company\'s securities achieving fair valuation.',
            style: TextStyle(
              fontSize: 16, 
              height: 1.5,
              color: Colors.white,
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
        'image': 'assets/coordinator1.jpg', // Replace with actual asset path
      },
      {
        'name': 'Emily Wilson',
        'position': 'IR Communications Manager',
        'department': 'Marketing Department',
        'image': 'assets/coordinator2.jpg', // Replace with actual asset path
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
                      backgroundImage: const AssetImage('assets/placeholder.png'), // Fallback image
                      backgroundColor: Colors.transparent,
                      child: coordinator['image'] != null
                          ? ClipOval(child: Image.asset(coordinator['image']!, fit: BoxFit.cover))
                          : null,
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
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coordinator['position']!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coordinator['department']!,
                            style: const TextStyle(
                              color: Colors.white70,
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
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: partners.map((partner) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.business, size: 20, color: Colors.white70),
                        const SizedBox(width: 8),
                        Text(
                          partner,
                          style: const TextStyle(color: Colors.white),
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
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                icon: Icons.email,
                label: 'Email',
                value: 'contact@irplatform.com',
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                icon: Icons.phone,
                label: 'Phone',
                value: '+1 (555) 123-4567',
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                icon: Icons.location_on,
                label: 'Address',
                value: '123 Financial District, New York, NY 10005',
              ),
              const SizedBox(height: 16),
              const Text(
                'Follow Us',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(Icons.facebook),
                  const SizedBox(width: 16),
                  _buildSocialIcon(Icons.camera_alt), // Instagram alternative
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

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
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