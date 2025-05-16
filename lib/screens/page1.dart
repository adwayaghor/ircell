import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ircell/app_theme.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // For horizontal auto-scrolling
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  int _currentCardIndex = 0;
  final int _totalCards = 5; // Number of featured suggestion cards
  bool _isAutoScrolling = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // Add scroll listener to update pagination dots on manual scroll
    _scrollController.addListener(_updateCurrentCardIndex);

    // Initialize auto-scroll timer after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  // Calculate current visible card from scroll position
  void _updateCurrentCardIndex() {
    if (_scrollController.positions.isNotEmpty &&
        _scrollController.position.hasContentDimensions) {
      // Calculate which card is most visible
      final double cardWidth = MediaQuery.of(context).size.width * 0.8 + 16; // card width + padding
      int index = (_scrollController.offset / cardWidth).round();

      // Ensure index is within valid range
      index = index.clamp(0, _totalCards - 1);

      if (index != _currentCardIndex) {
        setState(() {
          _currentCardIndex = index;
        });
      }
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (!_isAutoScrolling) return;

    // Auto scroll every 3 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients && _isAutoScrolling) {
        _currentCardIndex = (_currentCardIndex + 1) % _totalCards;

        final double cardWidth = MediaQuery.of(context).size.width * 0.8 + 16;

        _scrollController.animateTo(
          _currentCardIndex * cardWidth,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Method to manually navigate to a specific card when dot is tapped
  void _scrollToCard(int index) {
    if (_scrollController.hasClients) {
      // Cancel the auto-scroll timer temporarily
      _autoScrollTimer?.cancel();

      final double cardWidth = MediaQuery.of(context).size.width * 0.8 + 16;

      // Scroll to the selected card
      _scrollController.animateTo(
        index * cardWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {
        _currentCardIndex = index;
      });

      // Restart the auto-scroll timer after a short delay if auto-scrolling enabled
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isAutoScrolling) {
          _startAutoScroll();
        }
      });
    }
  }

  void _toggleAutoScroll() {
    setState(() {
      _isAutoScrolling = !_isAutoScrolling;
    });

    if (_isAutoScrolling) {
      _startAutoScroll();
    } else {
      _autoScrollTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.8;
    // Get available height for content (minus app bar and tab bar)
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double tabBarHeight = 48.0; // Approximate tab bar height
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Featured Suggestions'),
            Tab(text: 'Liked'),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeaturedSuggestions(cardWidth),
          _buildLikedEvents(),
        ],
      ),
    );
  }

  Widget _buildFeaturedSuggestions(double cardWidth) {
    // Calculate responsive feature card height based on screen size
    final double screenHeight = MediaQuery.of(context).size.height;
    final double featureCardHeight = screenHeight * 0.25; // Adaptive height based on screen size
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Events - Horizontal Scrollable Container with pause/start button overlay
                  Stack(
                    children: [
                      SizedBox(
                        height: featureCardHeight, // Dynamic height based on screen size
                        child: ListView.builder(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          itemCount: _totalCards,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _buildFeatureCard(index, cardWidth, featureCardHeight),
                          ),
                        ),
                      ),
                      // Pause/Play button overlay
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: _toggleAutoScroll,
                            icon: Icon(
                              _isAutoScrolling ? Icons.pause_circle_filled : Icons.play_circle_fill,
                              color: Colors.white,
                              size: 24,
                            ),
                            tooltip: _isAutoScrolling ? 'Pause Auto Scroll' : 'Start Auto Scroll',
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Pagination Indicators - interactive for manual navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalCards,
                        (index) => GestureDetector(
                          onTap: () => _scrollToCard(index),
                          child: Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentCardIndex == index
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Suggestions Header
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Suggestions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Suggestion List - Now using ListView.builder directly
                  _buildSuggestionList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Separate suggestion list to improve code organization
  Widget _buildSuggestionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Row(
            children: [
              // Event Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.event_note,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              
              // Event Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event ${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Event details for item ${index + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action button
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(int index, double cardWidth, double cardHeight) {
    // List of gradient colors for different cards
    final List<List<Color>> gradients = [
      [Colors.blue.shade300, Colors.blue.shade600],
      [Colors.purple.shade300, Colors.purple.shade700],
      [Colors.teal.shade300, Colors.teal.shade700],
      [Colors.orange.shade300, Colors.orange.shade700],
      [Colors.green.shade300, Colors.green.shade700],
    ];

    // List of icons for different cards
    final List<IconData> icons = [
      Icons.event,
      Icons.music_note,
      Icons.sports_soccer,
      Icons.movie,
      Icons.theater_comedy,
    ];

    // Calculate image height to be proportional to card height
    final double imageHeight = cardHeight * 0.65;
    final double detailsHeight = cardHeight - imageHeight;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Image/Banner with dynamic height
          Container(
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              gradient: LinearGradient(
                colors: gradients[index % gradients.length],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Icon(
                icons[index % icons.length],
                size: MediaQuery.of(context).size.width * 0.15, // Responsive icon size
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          // Event Details with flexible height
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Featured Event ${index + 1}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Event date ${index + 1}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikedEvents() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            color: Colors.white.withOpacity(0.7),
            size: 64,
          ),
          const SizedBox(height: 16),
          const Text(
            'No liked events yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your liked events will appear here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}