import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Info icon with circular background
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.info_rounded, color: Colors.white),
            ),
            
            // Right side icons 
            Row(
              children: [
                // Notification icon with circular background
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(Icons.notifications_outlined, color: Colors.white),
                ),
                const SizedBox(width: 8),
                
                // User avatar
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      
      backgroundColor: Colors.transparent,
      body: Container(
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
    );
  }
  
  Widget _buildHeaderSection() {
    return Row(
      children: [
        // IR Logo/Image Placeholder
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              'IR',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ticket for',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'an event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildTabSelector() {
    return Row(
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
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedTab == 0 
                      ? Colors.white 
                      : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Currently Booked',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selectedTab == 0 
                    ? Colors.white 
                    : Colors.white.withOpacity(0.6),
                  fontWeight: _selectedTab == 0 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                  fontSize: 16,
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
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: _selectedTab == 1 
                      ? Colors.white 
                      : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Past Tickets',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _selectedTab == 1 
                    ? Colors.white 
                    : Colors.white.withOpacity(0.6),
                  fontWeight: _selectedTab == 1 
                    ? FontWeight.bold 
                    : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildCurrentlyBookedContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event ticket content
          const Text(
            'Event name',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Event details row with icon and info
          Row(
            children: [
              // Event icon/image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white,
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
          color: Colors.white.withOpacity(0.7),
          size: 14,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPastTicketsContent() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            color: Colors.white.withOpacity(0.7),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Past event tickets will appear here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
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
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: const Text(
              'Internships',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // This would be populated with internship content
          // For now keeping it empty as per the sketch
          Container(
            height: 80,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}