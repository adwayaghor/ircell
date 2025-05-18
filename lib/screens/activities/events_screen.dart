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
    // Simulate loading events from API or database
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _events = _generateMockEvents();
        _isLoading = false;
      });
    });
  }

  List<Event> _generateMockEvents() {
    final List<Event> mockEvents = [];
    
    // Event titles
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
    
    // Speakers
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
    
    // Locations
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
    
    // Descriptions
    final descriptions = [
      'Join us for an exciting exploration of cutting-edge AI technologies and their global impact. Network with international researchers and industry experts.',
      'Develop your cross-cultural leadership skills in this interactive summit featuring speakers from diverse backgrounds and industries.',
      'Learn how you can contribute to the UN\'s Sustainable Development Goals through student-led initiatives and international partnerships.',
      'Showcase your innovative ideas to potential investors and mentors from around the world in this exciting expo.',
      'Connect with researchers from partner universities abroad and explore opportunities for collaborative projects and exchange programs.',
      'Discover the variety of cultural exchange programs available to students and how you can participate in these enriching experiences.',
      'Learn about volunteer opportunities in global health initiatives and how you can make a difference while gaining valuable experience.',
      'Meet representatives from multinational companies and international organizations looking to recruit talented students and graduates.',
      'Get comprehensive information about study abroad opportunities, application processes, scholarships, and student experiences.',
      'Practice language skills and make international friends in our popular language exchange program. All proficiency levels welcome.'
    ];
    
    // Create dates: mix of past and upcoming events
    final random = math.Random();
    
    for (int i = 0; i < 10; i++) {
      // Generate random dates between 2 months ago and 2 months from now
      final daysOffset = random.nextInt(120) - 60;
      final eventDate = DateTime.now().add(Duration(days: daysOffset));
      
      // Format date and time
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
    
    // Sort events by date (newest first)
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
    
    // Show a snackbar to confirm the action
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isInterested ? 'Removed from favorites' : 'Added to favorites',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppTheme.primaryBlue,
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
    return Scaffold(
      body: Container(
        decoration: AppTheme.gradientBackground,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildSearchBar(),
              _buildTabBar(),
              Expanded(
                child: _isLoading 
                  ? _buildLoadingView() 
                  : _buildEventList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const Text(
            'Events',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.2),
            child: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search events...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.7),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_available),
                const SizedBox(width: 8),
                const Text('Upcoming'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 0 
                        ? AppTheme.tealAccent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_upcomingEvents.length}',
                    style: TextStyle(
                      color: _selectedTabIndex == 0 
                          ? AppTheme.primaryBlue
                          : Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
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
                const Icon(Icons.history),
                const SizedBox(width: 8),
                const Text('Past'),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _selectedTabIndex == 1 
                        ? AppTheme.tealAccent
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_pastEvents.length}',
                    style: TextStyle(
                      color: _selectedTabIndex == 1 
                          ? AppTheme.primaryBlue
                          : Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading events...',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    final currentEvents = _selectedTabIndex == 0 ? _upcomingEvents : _pastEvents;
    
    if (currentEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _selectedTabIndex == 0 ? Icons.event_busy : Icons.history,
              color: Colors.white.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedTabIndex == 0 
                  ? 'No upcoming events found'
                  : 'No past events found',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Try changing your search query',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8.0),
        itemCount: currentEvents.length,
        itemBuilder: (context, index) {
          final event = currentEvents[index];
          
          // Add date header if this is the first event or if the date is different
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
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    headerDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              _buildEventCard(event),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    // Parse the date for displaying
    DateTime? eventDate;
    try {
      eventDate = DateFormat('dd/MM/yyyy').parse(event.date);
    } catch (e) {
      // Handle parsing error
    }
    
    // Get gradient colors based on event id to have variety
    final List<List<Color>> gradients = [
      [Colors.blue.shade300, Colors.blue.shade600],
      [Colors.purple.shade300, Colors.purple.shade700],
      [Colors.teal.shade300, Colors.teal.shade700],
      [Colors.orange.shade300, Colors.orange.shade700],
      [Colors.green.shade300, Colors.green.shade700],
    ];
    
    final gradientIndex = int.parse(event.id.split('-')[1]) % gradients.length;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.white.withOpacity(0.1),
      child: InkWell(
        onTap: () {
          // Navigate to event details page
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => EventDetailScreen(event: event),
          //   ),
          // );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event image/header
              Container(
                height: 120,
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
                    // Date display
                    if (eventDate != null)
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd MMM').format(eventDate),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    // Favorite button
                    Positioned(
                      top: 16,
                      right: 16,
                      child: GestureDetector(
                        onTap: () => _toggleInterest(event),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            event.isInterested ? Icons.favorite : Icons.favorite_border,
                            color: event.isInterested ? Colors.red : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    
                    // Event icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.event_note,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Event details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Speaker
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Speaker: ${event.speaker}',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.location,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    
                    // Time
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          event.time,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Description preview
                    Text(
                      event.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    // View details button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to event details
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EventDetailScreen(event: event),
                          //   ),
                          // );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppTheme.lightBlue,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('View details'),
                            Icon(Icons.arrow_forward, size: 16),
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