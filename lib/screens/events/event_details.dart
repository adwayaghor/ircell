import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ircell/login/auth.dart';
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
            Image.network(
              event.imageURL,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Date: ${event.date}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Time: ${event.time}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Location: ${event.location}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Speaker: ${event.speaker}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(event.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final User? user = Auth().currentUser;
                      final userDocRef = FirebaseFirestore.instance
                          .collection('pccoe_students')
                          .doc(user?.uid); // Use actual universalId

                      final eventDocRef = FirebaseFirestore.instance
                          .collection('events')
                          .doc(event.id);

                      try {
                        final userSnapshot = await userDocRef.get();
                        final List<dynamic> attending = List.from(
                          userSnapshot.data()?['attending'] ?? [],
                        );

                        // ✅ If already registered, show alert directly
                        if (attending.contains(event.title)) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Already Registered"),
                                  content: const Text(
                                    "You have already registered for this event.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                          );
                          return;
                        }

                        // ✅ Show confirmation dialog only if not already registered
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Do you wish to register for "${event.title}"?',
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(context).pop(),
                                          child: const Text('No'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .runTransaction((
                                                    transaction,
                                                  ) async {
                                                    final eventSnapshot =
                                                        await transaction.get(
                                                          eventDocRef,
                                                        );

                                                    final currentAttendees =
                                                        eventSnapshot
                                                            .data()?['attendees'] ??
                                                        0;
                                                    final List<String>
                                                    attendanceList = List<
                                                      String
                                                    >.from(
                                                      eventSnapshot
                                                              .data()?['attendanceList'] ??
                                                          [],
                                                    );

                                                    if (!attendanceList
                                                        .contains(user?.uid)) {
                                                      attendanceList.add(
                                                        user?.uid ?? '',
                                                      );

                                                      transaction.update(
                                                        eventDocRef,
                                                        {
                                                          'attendees':
                                                              currentAttendees +
                                                              1,
                                                          'attendanceList':
                                                              attendanceList,
                                                        },
                                                      );
                                                    }

                                                    attending.add(event.title);
                                                    transaction.set(
                                                      userDocRef,
                                                      {'attending': attending},
                                                      SetOptions(merge: true),
                                                    );
                                                  });

                                              Navigator.of(
                                                context,
                                              ).pop(); // Close dialog
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Successfully registered!',
                                                  ),
                                                ),
                                              );
                                            } catch (e) {
                                              Navigator.of(
                                                context,
                                              ).pop(); // Close dialog
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Failed to register: $e',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error checking registration: $e'),
                          ),
                        );
                      }
                    },

                    child: const Text('RSVP'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
