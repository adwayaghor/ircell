

import 'package:flutter/material.dart';
import 'package:ircell/providers/event_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(event.imageURL, height: 250, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Date: ${event.date}", style: const TextStyle(fontSize: 16)),
                  Text("Time: ${event.time}", style: const TextStyle(fontSize: 16)),
                  Text("Location: ${event.location}", style: const TextStyle(fontSize: 16)),
                  Text("Speaker: ${event.speaker}", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Text(event.description, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
