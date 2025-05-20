import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ircell/app_theme.dart';
import 'package:ircell/providers/event_provider.dart';
import 'package:ircell/screens/events/event_details.dart';
import 'package:ircell/screens/profile_page.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> with SingleTickerProviderStateMixin {
  late Future<List<Event>> _eventsFuture;

  late TabController _tabController;
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentCardIndex = 1;
  final int _originalCardCount = 5;
  final _isAutoScrolling = true;

  List<int> get _cardIndexes {
    return [
      _originalCardCount - 1,
      ...List.generate(_originalCardCount, (index) => index),
      0,
    ];
  }

  @override
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(
      initialPage: _currentCardIndex,
      viewportFraction: 0.8,
    );
    _pageController.addListener(_handlePageChange);
    _eventsFuture = fetchAllEvents(); // fetch events
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
    if (!_pageController.hasClients || !_pageController.position.haveDimensions)
      return;

    final double page = _pageController.page ?? 0;

    if (page >= _cardIndexes.length - 1) {
      _pageController.jumpToPage(1);
      setState(() => _currentCardIndex = 1);
    } else if (page <= 0) {
      _pageController.jumpToPage(_originalCardCount);
      setState(() => _currentCardIndex = _originalCardCount);
    } else {
      setState(() => _currentCardIndex = page.round());
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (!_isAutoScrolling) return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
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
                    builder:
                        (context) => AlertDialog(
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
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppTheme.textPrimary,
                    ),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  color: Colors.transparent, // to keep your design intact
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Featured'), Tab(text: 'Liked')],
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
    return FutureBuilder<List<Event>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No events available.'));
        }

        final events = snapshot.data!;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double featureCardHeight = screenHeight * 0.35;
        final double maxHeight = screenHeight * 0.45;
        final double minHeight = screenHeight * 0.25;
        final double adaptiveHeight = featureCardHeight.clamp(
          minHeight,
          maxHeight,
        );

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
                      SizedBox(
                        height: adaptiveHeight,
                        child: CarouselSlider.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index, realIndex) {
                            final event = events[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: _buildFeatureCard(
                                event,
                                constraints.maxWidth * 0.8,
                                adaptiveHeight,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: adaptiveHeight,
                            enlargeCenterPage: true,
                            autoPlay:
                                events.length >=
                                3, // Enable auto-play only if enough events
                            autoPlayInterval: const Duration(seconds: 6),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            autoPlayCurve: Curves.easeInOut,
                            enableInfiniteScroll: events.length >= 3,
                            viewportFraction: 0.8,
                            initialPage: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Suggestions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      _buildSuggestionList(events),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSuggestionList(List<Event> events) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: AppTheme.glassDecoration,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.cardColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.event_note),
                  color: AppTheme.textPrimary,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(Event event, double cardWidth, double cardHeight) {
    final double imageHeight = cardHeight * 0.65;

    return InkWell(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: imageHeight,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(event.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryDarkBlue.withOpacity(0.7),
                      AppTheme.accentBlue.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppTheme.textSecondary,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.date,
                              style: Theme.of(context).textTheme.bodyMedium,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikedEvents() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, color: AppTheme.textSecondary, size: 64),
          const SizedBox(height: 16),
          Text(
            'No liked events yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Your liked events will appear here',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}