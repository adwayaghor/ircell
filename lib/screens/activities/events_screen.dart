import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:ircell/models/event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;
  bool _isLoading = true;
  List<Event> _events = [];
  late TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _searchController = TextEditingController();
    _loadEvents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadEvents() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _events = _generateMockEvents();
        _isLoading = false;
      });
    });
  }

  List<Event> _generateMockEvents() {
    final List<Event> mockEvents = [];
    
    final titles = [
      'International Conference on AI and Future Technologies',
      'Global Leadership Summit: Building Cross-Cultural Connections',
      'Sustainable Development Goals: Student Workshop',
      'Innovation Expo: Showcase Your Startups',
      'Research Collaboration Forum with International Universities',
      'Cultural Exchange Program Introduction',
      'Global Health Initiatives: Volunteering Opportunities',
      'International Career Fair',
      'Study Abroad Information Session',
      'Language Exchange Program Kickoff'
    ];
    
    final speakers = [
      'Dr. Sarah Johnson',
      'Prof. Michael Zhang',
      'Ms. Aisha Patel',
      'Dr. Robert Chen',
      'Prof. Elena Rodriguez',
      'Mr. James Wilson',
      'Dr. Olivia Kim',
      'Prof. David Miller',
      'Ms. Sophia Lee',
      'Dr. Thomas Brown'
    ];
    
    final locations = [
      'Main Auditorium',
      'Seminar Hall A',
      'Conference Room 102',
      'Innovation Lab',
      'Central Library',
      'Student Center',
      'Virtual Meeting Room',
      'Campus Grounds',
      'International Office',
      'Department of Computer Science'
    ];
    
    final descriptions = [
      'Join us for an exciting exploration of cutting-edge AI technologies and their global impact.',
      'Develop your cross-cultural leadership skills in this interactive summit.',
      'Learn how you can contribute to the UN\'s Sustainable Development Goals.',
      'Showcase your innovative ideas to potential investors and mentors.',
      'Connect with researchers from partner universities abroad.',
      'Discover the variety of cultural exchange programs available.',
      'Learn about volunteer opportunities in global health initiatives.',
      'Meet representatives from multinational companies.',
      'Get comprehensive information about study abroad opportunities.',
      'Practice language skills and make international friends.'
    ];
    
    final random = math.Random();
    
    for (int i = 0; i < 10; i++) {
      final daysOffset = random.nextInt(120) - 60;
      final eventDate = DateTime.now().add(Duration(days: daysOffset));
      
      final date = DateFormat('dd/MM/yyyy').format(eventDate);
      final time = '${random.nextInt(12) + 1}:${random.nextInt(6)}0 ${random.nextBool() ? 'AM' : 'PM'}';
      
      mockEvents.add(
        Event(
          id: 'event-$i',
          title: titles[i % titles.length],
          imageUrl: 'event-image-$i',
          speaker: speakers[i % speakers.length],
          location: locations[i % locations.length],
          date: date,
          time: time,
          description: descriptions[i % descriptions.length],
          isInterested: random.nextBool(),
        ),
      );
    }
    
    mockEvents.sort((a, b) {
      try {
        final dateA = DateFormat('dd/MM/yyyy').parse(a.date);
        final dateB = DateFormat('dd/MM/yyyy').parse(b.date);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });
    
    return mockEvents;
  }

  List<Event> get _filteredEvents {
    return _events.where((event) {
      final query = _searchQuery.toLowerCase();
      if (query.isEmpty) return true;
      return event.title.toLowerCase().contains(query) ||
             event.speaker.toLowerCase().contains(query) ||
             event.location.toLowerCase().contains(query) ||
             event.description.toLowerCase().contains(query);
    }).toList();
  }

  List<Event> get _upcomingEvents {
    return _filteredEvents.where((event) => !event.isPast()).toList();
  }

  List<Event> get _pastEvents {
    return _filteredEvents.where((event) => event.isPast()).toList();
  }

  void _toggleInterest(Event event) {
    setState(() {
      final index = _events.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        _events[index] = event.copyWith(isInterested: !event.isInterested);
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isInterested ? 'Removed from favorites' : 'Added to favorites',
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        backgroundColor: AppTheme.accentBlue,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(screenSize),
              _buildSearchBar(screenSize),
              _buildTabBar(screenSize),
              Expanded(
                child: _isLoading 
                  ? _buildLoadingView() 
                  : _buildEventList(screenSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: AppTheme.glassDecoration.copyWith(
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
                onPressed: () {},
              ),
            ),
          ),
          Text(
            'Events',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Container(
            decoration: AppTheme.glassDecoration.copyWith(
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: AppTheme.textPrimary),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.01,
      ),
      child: Container(
        decoration: AppTheme.glassDecoration.copyWith(
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle: TextStyle(color: AppTheme.textSecondary),
            prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.015,
            ),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildTabBar(Size screenSize) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.04,
        vertical: screenSize.height * 0.01,
      ),
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.accentBlue.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppTheme.textPrimary,
        unselectedLabelColor: AppTheme.textSecondary,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: screenSize.width * 0.04),
                SizedBox(width: screenSize.width * 0.02),
                const Text('Upcoming'),
                SizedBox(width: screenSize.width * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.02,
                    vertical: screenSize.height * 0.003,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 0 
                        ? AppTheme.lightTeal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_upcomingEvents.length}',
                    style: TextStyle(
                      color: _selectedTabIndex == 0 
                          ? AppTheme.primaryDarkBlue
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: screenSize.width * 0.04),
                SizedBox(width: screenSize.width * 0.02),
                const Text('Past'),
                SizedBox(width: screenSize.width * 0.01),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.02,
                    vertical: screenSize.height * 0.003,
                  ),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 1 
                        ? AppTheme.lightTeal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_pastEvents.length}',
                    style: TextStyle(
                      color: _selectedTabIndex == 1 
                          ? AppTheme.primaryDarkBlue
                          : AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentBlue),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading events...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(Size screenSize) {
    final currentEvents = _selectedTabIndex == 0 ? _upcomingEvents : _pastEvents;
    
    if (currentEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedTabIndex == 0 ? Icons.event_busy : Icons.history,
              color: AppTheme.textSecondary,
              size: screenSize.width * 0.15,
            ),
            SizedBox(height: screenSize.height * 0.02),
            Text(
              _selectedTabIndex == 0 
                  ? 'No upcoming events found'
                  : 'No past events found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: screenSize.height * 0.01),
                child: Text(
                  'Try changing your search query',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
      child: ListView.builder(
        padding: EdgeInsets.only(top: screenSize.height * 0.01),
        itemCount: currentEvents.length,
        itemBuilder: (context, index) {
          final event = currentEvents[index];
          
          String? headerDate;
          if (index == 0 || 
              currentEvents[index].date != currentEvents[index - 1].date) {
            try {
              final date = DateFormat('dd/MM/yyyy').parse(event.date);
              headerDate = DateFormat('MMMM yyyy').format(date);
            } catch (e) {
              headerDate = event.date;
            }
          }
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (headerDate != null)
                Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.02, 
                    bottom: screenSize.height * 0.01
                  ),
                  child: Text(
                    headerDate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              _buildEventCard(event, screenSize),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventCard(Event event, Size screenSize) {
    DateTime? eventDate;
    try {
      eventDate = DateFormat('dd/MM/yyyy').parse(event.date);
    } catch (e) {
      // Handle parsing error
    }
    
    final List<List<Color>> gradients = [
      [AppTheme.primaryDarkBlue, AppTheme.accentBlue],
      [AppTheme.darkTeal, AppTheme.lightTeal],
      [const Color(0xFF1E3A8A), AppTheme.accentBlue],
      [const Color(0xFF0A1E3D), const Color(0xFF00BFA5)],
      [const Color(0xFF1A237E), const Color(0xFF00E5FF)],
    ];
    
    final gradientIndex = int.parse(event.id.split('-')[1]) % gradients.length;
    //final cardHeight = screenSize.height * 0.3;
    
    return Card(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: AppTheme.cardColor,
      child: InkWell(
        onTap: () {
          // Navigate to event details
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: AppTheme.cardDecoration.copyWith(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image/header
              Container(
                height: screenSize.height * 0.15,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: gradients[gradientIndex],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    if (eventDate != null)
                      Positioned(
                        top: screenSize.height * 0.02,
                        left: screenSize.width * 0.04,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: screenSize.height * 0.008, 
                            horizontal: screenSize.width * 0.03,
                          ),
                          decoration: AppTheme.glassDecoration.copyWith(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: AppTheme.textPrimary,
                                size: screenSize.width * 0.035,
                              ),
                              SizedBox(width: screenSize.width * 0.01),
                              Text(
                                DateFormat('dd MMM').format(eventDate),
                                style: TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenSize.width * 0.033,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    Positioned(
                      top: screenSize.height * 0.02,
                      right: screenSize.width * 0.04,
                      child: GestureDetector(
                        onTap: () => _toggleInterest(event),
                        child: Container(
                          padding: EdgeInsets.all(screenSize.width * 0.02),
                          decoration: AppTheme.glassDecoration.copyWith(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            event.isInterested ? Icons.favorite : Icons.favorite_border,
                            color: event.isInterested ? Colors.red : AppTheme.textPrimary,
                            size: screenSize.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(screenSize.width * 0.04),
                        decoration: AppTheme.glassDecoration.copyWith(
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.event_note,
                          color: AppTheme.textPrimary,
                          size: screenSize.width * 0.09,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: EdgeInsets.all(screenSize.width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: AppTheme.textSecondary,
                          size: screenSize.width * 0.04,
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        Expanded(
                          child: Text(
                            'Speaker: ${event.speaker}',
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppTheme.textSecondary,
                          size: screenSize.width * 0.04,
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        Expanded(
                          child: Text(
                            event.location,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppTheme.textSecondary,
                          size: screenSize.width * 0.04,
                        ),
                        SizedBox(width: screenSize.width * 0.02),
                        Text(
                          event.time,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: screenSize.height * 0.01),
                    
                    Text(
                      event.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to event details
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.lightTeal,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View details',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Icon(
                              Icons.arrow_forward, 
                              size: screenSize.width * 0.04,
                            ),
                          ],
                        ),
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
  }
}