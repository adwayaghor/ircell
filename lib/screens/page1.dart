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

  // For horizontal auto-scrolling
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentCardIndex =
      1; // Start at 1 since we add dummy cards at beginning and end
  final int _originalCardCount = 5; // Number of featured suggestion cards
  final _isAutoScrolling = true;

  // Generate list of cards with dummy cards for infinite scroll
  List<int> get _cardIndexes {
    return [
      _originalCardCount - 1, // Add last card at beginning
      ...List.generate(_originalCardCount, (index) => index),
      0, // Add first card at end
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize PageController with initial page being 1 (the first real card)
    _pageController = PageController(
      initialPage: _currentCardIndex,
      viewportFraction: 0.8, // To show a bit of next card
    );

    // Add page change listener to handle infinite scroll
    _pageController.addListener(_handlePageChange);

    // Initialize auto-scroll timer after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _autoScrollTimer?.cancel();
    super.dispose();
  }

  void _handlePageChange() {
    if (!_pageController.hasClients ||
        _pageController.position.haveDimensions == false) {
      return;
    }

    final double page = _pageController.page ?? 0;

    // Handle when reaching the end (loop back to start)
    if (page >= _cardIndexes.length - 1) {
      // When it reaches the end (duplicate first card), jump to the real first card
      _pageController.jumpToPage(1);
      setState(() {
        _currentCardIndex = 1;
      });
    }
    // Handle when reaching the beginning (loop back to end)
    else if (page <= 0) {
      // When it reaches the beginning (duplicate last card), jump to the real last card
      _pageController.jumpToPage(_originalCardCount);
      setState(() {
        _currentCardIndex = _originalCardCount;
      });
    } else {
      setState(() {
        _currentCardIndex = page.round();
      });
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (!_isAutoScrolling) return;

    // Auto scroll every 6 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_pageController.hasClients && _isAutoScrolling) {
        int nextPage = _currentCardIndex + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Method to manually navigate to a specific card when dot is tapped
  void _scrollToCard(int index) {
    if (_pageController.hasClients) {
      // Cancel the auto-scroll timer temporarily
      _autoScrollTimer?.cancel();

      // Account for the extra first item in the PageView
      final adjustedIndex = index + 1;

      // Scroll to the selected card
      _pageController.animateToPage(
        adjustedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Restart the auto-scroll timer after a short delay if auto-scrolling enabled
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isAutoScrolling) {
          _startAutoScroll();
        }
      });
    }
  }

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

            // Right side icons
            Row(
              children: [
                // Notification icon with circular background
                CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
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
          tabs: const [Tab(text: 'Featured Suggestions'), Tab(text: 'Liked')],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFeaturedSuggestions(), _buildLikedEvents()],
      ),
    );
  }

  Widget _buildFeaturedSuggestions() {
    // Calculate responsive feature card height based on screen size
    final double screenHeight = MediaQuery.of(context).size.height;

    // Make feature card height responsive to both screen dimensions
    // Adjust the multiplier to ensure it fits well on different devices
    final double featureCardHeight = screenHeight * 0.35;
    // Cap the height to prevent overflow on smaller devices
    final double maxHeight = screenHeight * 0.45;
    final double minHeight = screenHeight * 0.25;
    final double adaptiveHeight = featureCardHeight.clamp(minHeight, maxHeight);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Featured Events with PageView for infinite scrolling
                  SizedBox(
                    height:
                        adaptiveHeight, // Dynamic height based on screen size
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _cardIndexes.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentCardIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        // Get the actual card index (accounting for the duplicates)
                        final actualIndex = _cardIndexes[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _buildFeatureCard(
                            actualIndex,
                            constraints.maxWidth * 0.8,
                            adaptiveHeight,
                          ),
                        );
                      },
                    ),
                  ),

                  // Pagination Indicators - interactive for manual navigation
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _originalCardCount,
                        (index) => GestureDetector(
                          onTap: () => _scrollToCard(index),
                          child: Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  (_currentCardIndex - 1) %
                                              _originalCardCount ==
                                          index
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
            border: Border.all(color: Colors.white.withOpacity(0.1)),
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
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
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
                size:
                    MediaQuery.of(context).size.width *
                    0.15, // Responsive icon size
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
