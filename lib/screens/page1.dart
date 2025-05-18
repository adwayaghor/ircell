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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(initialPage: _currentCardIndex, viewportFraction: 0.8);
    _pageController.addListener(_handlePageChange);
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
    if (!_pageController.hasClients || !_pageController.position.haveDimensions) return;

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
        automaticallyImplyLeading: false, // ✅ Removes back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: AppTheme.glassDecoration,
              child: IconButton(
                icon: const Icon(Icons.info_rounded, color: AppTheme.textPrimary),
                onPressed: () {},
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
                CircleAvatar(
                  backgroundColor: AppTheme.accentBlue,
                  child: const Text('A', style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Featured Suggestions'), Tab(text: 'Liked')],
          labelColor: AppTheme.textPrimary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.accentBlue,
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double featureCardHeight = screenHeight * 0.35;
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
                  SizedBox(
                    height: adaptiveHeight,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _cardIndexes.length,
                      onPageChanged: (index) {
                        setState(() => _currentCardIndex = index);
                      },
                      itemBuilder: (context, index) {
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
                              color: (_currentCardIndex - 1) % _originalCardCount == index
                                  ? AppTheme.accentBlue
                                  : AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Suggestions', style: Theme.of(context).textTheme.titleLarge),
                  ),
                  _buildSuggestionList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _scrollToCard(int index) {
    if (_pageController.hasClients) {
      _autoScrollTimer?.cancel();
      final adjustedIndex = index + 1;
      _pageController.animateToPage(
        adjustedIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isAutoScrolling) {
          _startAutoScroll();
        }
      });
    }
  }

  Widget _buildSuggestionList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
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
                  splashColor: AppTheme.accentBlue.withOpacity(0.3),
                  highlightColor: AppTheme.accentBlue.withOpacity(0.2),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event ${index + 1}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Event details for item ${index + 1}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios, color: AppTheme.textSecondary, size: 16),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(int index, double cardWidth, double cardHeight) {
    final double imageHeight = cardHeight * 0.65;

    return Container(
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
                image: NetworkImage('https://images.unsplash.com/photo-1545569341-9eb8b30979d9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
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
                      'Featured Event ${index + 1}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: AppTheme.textSecondary, size: 14),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Event date ${index + 1}',
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
    );
  }

  Widget _buildLikedEvents() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, color: AppTheme.textSecondary, size: 64),
          const SizedBox(height: 16),
          Text('No liked events yet', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('Your liked events will appear here', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
