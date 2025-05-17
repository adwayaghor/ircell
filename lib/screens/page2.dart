import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> with SingleTickerProviderStateMixin {
  // Tab controller for the category tabs at the top
  int _selectedCategoryIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
            
            // Title text
            const Text(
              'International Relations Cell',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // User avatar on right
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
      ),
      body: Column(
        children: [
          // Top category selection buttons (Events, Internships, User)
          _buildCategoryButtons(),
          
          // Main content area
          Expanded(
            child: _buildMainContent(),
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
          // Horizontal category buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryButton(0, 'Events', Icons.event),
              _buildCategoryButton(1, 'Internships', Icons.work),
              _buildCategoryButton(2, 'User', Icons.person),
            ],
          ),
          
          // Separator line (dashed)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width - 32, 1),
              painter: DashedLinePainter(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoryButton(int index, String title, IconData icon) {
    final bool isSelected = _selectedCategoryIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: Column(
        children: [
          // Circular icon container
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
              border: Border.all(
                color: isSelected ? AppTheme.primaryBlue : Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: isSelected ? AppTheme.primaryBlue : Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          // Category title
          Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent() {
    // Show different content based on selected category
    switch (_selectedCategoryIndex) {
      case 0:
        return _buildEventsContent();
      case 1:
        return _buildInternshipsContent();
      case 2:
        return _buildUserContent();
      default:
        return _buildEventsContent();
    }
  }
  
  Widget _buildEventsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Large event card
          _buildLargeCard('Upcoming Event'),
          
          // Two stacked event cards
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildMediumCard('Event 1'),
                    const SizedBox(height: 12),
                    _buildMediumCard('Event 2'),
                    const SizedBox(height: 12),
                    _buildMediumCard('Event 3'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildLargeVerticalCard('Featured Event'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInternshipsContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Internship cards in 2 columns layout
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildMediumCard('Internship 1'),
                    const SizedBox(height: 12),
                    _buildMediumCard('Internship 2'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildMediumWideCard('Top Internship'),
                    const SizedBox(height: 12),
                    _buildMediumCard('Internship 3'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_outline,
            color: Colors.white.withOpacity(0.7),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'User Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'User profile information will appear here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLargeCard(String title) {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.only(bottom: 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withOpacity(0.7),
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'May 20, 2025',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildMediumCard(String title) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMediumWideCard(String title) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLargeVerticalCard(String title) {
    return Container(
      width: double.infinity,
      height: 264, // Height of 3 medium cards + 2 spacings
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Center(
              child: Icon(
                Icons.event_available,
                size: 48,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.white.withOpacity(0.7),
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'Event Location',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for drawing dashed lines
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    const double dashWidth = 5;
    const double dashSpace = 5;
    
    double currentX = 0;
    final path = Path();
    
    while (currentX < size.width) {
      path.moveTo(currentX, 0);
      currentX += dashWidth;
      path.lineTo(currentX, 0);
      currentX += dashSpace;
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}