import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/screens/profile_page.dart';
import 'package:ircell/screens/chatbot/chatbot_icon.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: const Icon(
                  Icons.info_outline,
                  color: AppTheme.textPrimary,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Information"),
                      content: const Text(
                        "This is the International Relations Cell app.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: AppTheme.glassDecoration,
                  child: IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary),
                    onPressed: () {},
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
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with IR image and "Book a ticket" text
                _buildHeaderSection(),
                
                const SizedBox(height: 20),
                
                // Currently Booked & Past Tickets tabs
                _buildTabSelector(),
                
                const SizedBox(height: 16),
                
                // Main content area based on selected tab
                Expanded(
                  child: _selectedTab == 0 
                    ? _buildCurrentlyBookedContent() 
                    : _buildPastTicketsContent(),
                ),
                
                // Internships section at bottom
                _buildInternshipsSection(),
              ],
            ),
          ),
          
          // Chatbot icon positioned in the bottom right corner
          Positioned(
            bottom: 20,
            right: 20,
            child: ChatbotIcon(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildHeaderSection() {
    return Row(
      children: [
        // IR Logo/Image Placeholder with glass decoration
        Container(
          width: 80,
          height: 80,
          decoration: AppTheme.glassDecoration.copyWith(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'IR',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // "Book a ticket for an event" text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book a',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'ticket for',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'an event',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Currently Booked Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 0 ? AppTheme.accentBlue.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Currently Booked',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _selectedTab == 0 ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
          
          // Past Tickets Tab
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _selectedTab == 1 ? AppTheme.accentBlue.withOpacity(0.3) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Past Tickets',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _selectedTab == 1 ? AppTheme.textPrimary : AppTheme.textSecondary,
                    fontWeight: _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentlyBookedContent() {
    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event ticket content
          Text(
            'Event name',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          
          const SizedBox(height: 16),
          
          // Event details row with icon and info
          Row(
            children: [
              // Event icon/image
              Container(
                width: 60,
                height: 60,
                decoration: AppTheme.glassDecoration.copyWith(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_today,
                    color: AppTheme.textPrimary,
                    size: 28,
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEventDetailRow(Icons.access_time, 'Time details'),
                    const SizedBox(height: 8),
                    _buildEventDetailRow(Icons.location_on, 'Location details'),
                    const SizedBox(height: 8),
                    _buildEventDetailRow(Icons.confirmation_number, 'Ticket info'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildEventDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondary,
          size: 14,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
  
  Widget _buildPastTicketsContent() {
    return Container(
      width: double.infinity,
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            color: AppTheme.textSecondary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Past event tickets will appear here',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInternshipsSection() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Internships header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.textSecondary.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Text(
              'Internships',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          
          // Internship content placeholder
          Container(
            height: 80,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            decoration: AppTheme.glassDecoration.copyWith(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Internship opportunities will appear here',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}