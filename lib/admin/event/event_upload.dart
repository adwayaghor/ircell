

import 'package:flutter/material.dart';
import 'package:ircell/admin/event/eventform.dart';
import 'package:ircell/admin/event/view_event.dart';

class EventUpload extends StatelessWidget {
  const EventUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (ctx) => EventForm()));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('Upload New Event'),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (ctx) => ViewEvents()));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: const Text('View All Events'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}