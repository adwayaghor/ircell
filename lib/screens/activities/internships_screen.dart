import 'package:flutter/material.dart';
import 'package:ircell/models/outbound_details.dart';
import 'package:url_launcher/url_launcher.dart';

class InternshipsScreen extends StatefulWidget {
  const InternshipsScreen({super.key});

  @override
  State<InternshipsScreen> createState() => _InternshipsState();
}

class _InternshipsState extends State<InternshipsScreen> {
  // To control which section is currently visible (outbound is default)
  bool showOutbound = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0D1B2A),
        appBar: AppBar(
          title: const Text(
            'Internships',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 4,
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.zero,
            ),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Section toggle buttons at the top
                _buildSectionToggle(),
                
                const SizedBox(height: 16),
                
                // Main content based on which section is active
                Expanded(
                  child: SingleChildScrollView(
                    child: showOutbound ? _buildOutboundSection() : _buildInboundSection(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Toggle buttons to switch between Outbound and Inbound sections
  Widget _buildSectionToggle() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          // Outbound toggle button
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  showOutbound = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: showOutbound 
                      ? Colors.white.withOpacity(0.2) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Outbound',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: showOutbound 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Inbound toggle button
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  showOutbound = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: !showOutbound 
                      ? Colors.white.withOpacity(0.2) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    'Inbound',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: !showOutbound 
                          ? FontWeight.bold 
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Outbound section content
  Widget _buildOutboundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Card for Internships Open
        _buildMainCard(
          title: 'Outbound Internships',
          subtitle: 'Explore international internship opportunities',
          icon: Icons.flight_takeoff,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => const OutboundDetails(),
              ),
            );
          },
        ),
        
        const SizedBox(height: 20),
        
        // Small buttons row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallButton(
                  title: 'International Internships Brochure',
                  icon: Icons.description_outlined,
                  onTap: () {
                    // Handle brochure action
                  },
                ),
                _buildSmallButton(
                  title: 'SOP - International Internships Application',
                  icon: Icons.assignment_outlined,
                  onTap: () {
                    // Handle SOP action
                  },
                ),
                _buildSmallButton(
                  title: 'Gallery',
                  icon: Icons.photo_library_outlined,
                  onTap: () {
                    // Handle gallery action
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Inbound section content
  Widget _buildInboundSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Card for Internships Open
        _buildMainCard(
          title: 'Inbound Internships',
          subtitle: 'International students seeking internships here',
          icon: Icons.flight_land,
          onTap: () {
            // Navigate to inbound details page
            // This would be similar to OutboundDetails but for inbound
          },
        ),
        
        const SizedBox(height: 20),
        
        // Small buttons row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.5),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSmallButton(
                  title: 'Students\' Experience',
                  icon: Icons.people_outlined,
                  onTap: () {
                    // Handle students' experience action
                  },
                ),
                _buildSmallButton(
                  title: 'Registration',
                  icon: Icons.app_registration_outlined,
                  onTap: () async {
                    final Uri url = Uri.parse(
                      'https://docs.google.com/forms/d/e/1FAIpQLSeCnycTFNv6EteUOEuwq6OV5G33KQPU_NUarqRlc8yb3nf4bA/viewform',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not launch the URL.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Main card for the primary action (Internships Open)
  Widget _buildMainCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2A47), Color(0xFF3D5A80)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Explore',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Small button for secondary actions
  Widget _buildSmallButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (screenWidth - 64) / 3; // 64 = total horizontal padding + spacing
    return InkWell(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        // height: 100,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2A47),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}