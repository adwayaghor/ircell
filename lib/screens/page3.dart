import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
import 'package:ircell/backend/shared_pref.dart';
import 'package:ircell/login/auth.dart';
import 'package:ircell/screens/events/generate_ticket.dart';
import 'package:ircell/screens/profile_page.dart';
import 'package:ircell/screens/chatbot/chatbot_icon.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  int _selectedTab = 0;

  List<String> eventTitles = [];

  final User? user = Auth().currentUser;

  Future<void> _loadEvents() async {
    try {
      if (user?.uid == null) return;

      final docRef = FirebaseFirestore.instance
          .collection('pccoe_students')
          .doc(user!.uid);

      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final attending = List<String>.from(data?['attending'] ?? []);

        attending.sort((a, b) => b.compareTo(a)); // sort by latest

        await EventCache.cacheEvents(user!.uid, attending);


        setState(() {
          eventTitles = attending;
        });
      } else {
        throw Exception('User document not found');
      }
    } catch (e) {
      print('Error loading events: $e');
      // If offline or error, load from cache
      final cached = await EventCache.getCachedEvents();
      setState(() {
        eventTitles = cached;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

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
                  child:
                      _selectedTab == 0
                          ? _buildCurrentlyBookedContent()
                          : _buildPastTicketsContent(),
                ),

                // Internships section at bottom
                _buildInternshipsSection(),
              ],
            ),
          ),

          // Chatbot icon positioned in the bottom right corner
          Positioned(bottom: 20, right: 20, child: ChatbotIcon()),
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
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // "Book a ticket for an event" text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Book a', style: Theme.of(context).textTheme.titleLarge),
              Text('ticket for', style: Theme.of(context).textTheme.titleLarge),
              Text('an event', style: Theme.of(context).textTheme.titleLarge),
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
                  color:
                      _selectedTab == 0
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Currently Booked',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        _selectedTab == 0
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                    fontWeight:
                        _selectedTab == 0 ? FontWeight.bold : FontWeight.normal,
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
                  color:
                      _selectedTab == 1
                          ? AppTheme.accentBlue.withOpacity(0.3)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Past Tickets',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        _selectedTab == 1
                            ? AppTheme.textPrimary
                            : AppTheme.textSecondary,
                    fontWeight:
                        _selectedTab == 1 ? FontWeight.bold : FontWeight.normal,
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
  return SizedBox(
    height: 180,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: eventTitles.length,
      itemBuilder: (context, index) {
        final event = eventTitles[index];

        return GestureDetector(
          onTap: () async {
            final uid = await EventCache.getCachedUid();
            if (uid != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GenerateTicket(eventTitle: event, uid: uid),
                ),
              );
            }
          },
          child: Container(
            width: 260,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accentBlue.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticket Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🎟 Ticket",
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accentBlue,
                      ),
                    ),
                    Icon(Icons.qr_code_2_rounded, color: AppTheme.textPrimary),
                  ],
                ),
                const SizedBox(height: 12),

                // Event Title
                Text(
                  event,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // Footer with placeholder date or status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.event_available_outlined, color: AppTheme.textSecondary),
                    Text(
                      'Valid Ticket',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
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
          Icon(Icons.history, color: AppTheme.textSecondary, size: 48),
          const SizedBox(height: 16),
          Text(
            'Past event tickets will appear here',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
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
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
