import 'package:flutter/material.dart';
import 'package:ircell/admin/event/event_actions.dart';
import 'package:ircell/admin/event/scanner.dart';
import 'package:ircell/providers/event_provider.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({super.key, required this.function});

  final String function;

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  late Future<List<Event>> _eventsFuture;

  late String function;

  @override
  void initState() {
    super.initState();
    function = widget.function;
    _eventsFuture = fetchAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.title),
                  onTap: () {
                    if (function == 'publish') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttendanceScannerScreen(eventId: event.id),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventActions(eventId: event.id),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
