import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/providers/event_provider.dart';
import 'package:ircell/screens/events/event_details.dart';
import 'package:ircell/screens/profile%20page/profile_page.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _searchQuery = '';
  int _selectedTabIndex = 0;

  bool _filterByDate = false;
  String? _filterBySession; // 'morning' or 'afternoon'

  late Future<List<Event>> upcomingEventsFuture;
  late Future<List<Event>> pastEventsFuture;

  @override
  void initState() {
    super.initState();
    upcomingEventsFuture = fetchAllEvents();
    pastEventsFuture = fetchPastEvents();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFuture =
        _selectedTabIndex == 0 ? upcomingEventsFuture : pastEventsFuture;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: AppTheme.glassDecoration(context),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppTheme.textPrimary(context),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text('Events', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: AppTheme.glassDecoration(context),
                  child: IconButton(
                    icon: Icon(
                      Icons.filter_list,
                      color: AppTheme.textPrimary(context),
                    ),
                    onPressed: _showFilterBottomSheet,
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
                      child: Text(
                        createEmailShortForm(),
                        style: TextStyle(
                          color: AppTheme.textPrimary(context),
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
      backgroundColor: AppTheme.backgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildTabSelector(),
                const SizedBox(height: 16),
                FutureBuilder<List<Event>>(
                  future: currentFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildLoadingView();
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.event_note,
                                size: 64,
                                color: AppTheme.accentBlue.withOpacity(0.7),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No past events found',
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary(context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Find completed events here.',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.textSecondary(context),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final filteredEvents =
                        snapshot.data!.where((event) {
                          final matchesTitle = event.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());

                          final eventDate = DateFormat(
                            "yyyy-MM-dd",
                          ).parse(event.date);
                          final now = DateTime.now();
                          final inOneWeek = now.add(const Duration(days: 7));
                          final isWithin7Days =
                              eventDate.isAfter(now) &&
                              eventDate.isBefore(inOneWeek);

                          final eventTime = DateFormat(
                            "hh:mm a",
                          ).parse(event.time);
                          final isMorning = eventTime.hour < 12;
                          final isAfternoon = eventTime.hour >= 12;

                          final matchesDateFilter =
                              !_filterByDate || isWithin7Days;

                          final matchesTimeFilter =
                              _filterBySession == null ||
                              (_filterBySession == 'morning' && isMorning) ||
                              (_filterBySession == 'afternoon' && isAfternoon);

                          return matchesTitle &&
                              matchesDateFilter &&
                              matchesTimeFilter;
                        }).toList();

                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.builder(
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EventDetailScreen(event: event),
                                ),
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.all(12),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    event.imageURL,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      event.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      "${event.date} | ${event.time}",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 4,
                                    ),
                                    child: Text("Location: ${event.location}"),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: AppTheme.cardColor(context),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter Events',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: _filterByDate,
                        onChanged: (val) {
                          setModalState(() => _filterByDate = val!);
                        },
                      ),
                      const Text("Within 1 week"),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("Session:"),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text("Morning"),
                        selected: _filterBySession == 'morning',
                        onSelected: (_) {
                          setModalState(() {
                            _filterBySession = 'morning';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text("Afternoon"),
                        selected: _filterBySession == 'afternoon',
                        onSelected: (_) {
                          setModalState(() {
                            _filterBySession = 'afternoon';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text("Clear"),
                        selected: _filterBySession == null,
                        onSelected: (_) {
                          setModalState(() {
                            _filterBySession = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text("Apply Filter"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: AppTheme.glassDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppTheme.textPrimary(context)),
        decoration: InputDecoration(
          hintText: 'Search events...',
          hintStyle: TextStyle(color: AppTheme.textSecondary(context)),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.textSecondary(context),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor(context).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab('Upcoming', 0, Icons.event_available),
          _buildTab('Past Events', 1, Icons.history),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppTheme.accentBlue.withOpacity(0.3)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color:
                    isSelected
                        ? AppTheme.textPrimary(context)
                        : AppTheme.textSecondary(context),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color:
                      isSelected
                          ? AppTheme.textPrimary(context)
                          : AppTheme.textSecondary(context),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
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
}
