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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                event.imageURL,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow("📅 Date", event.date),
                    _buildDetailRow("⏰ Time", event.time),
                    _buildDetailRow("📍 Location", event.location),
                    _buildDetailRow("🎤 Speaker", event.speaker),
                    const SizedBox(height: 16),
                    Text(
                      "About the Event",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      event.description,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _handleRSVP(context, event),
                          icon: const Icon(Icons.event_available),
                          label: const Text("RSVP"),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Event Activities"),
                                content: Text(
                                  "Details of activities for '${event.title}' go here.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.local_activity),
                          label: const Text("Event Activities"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 78),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _handleRSVP(BuildContext context, Event event) async {
  final User? user = Auth().currentUser;
  final String uid = user?.uid ?? "";

  if (uid.isEmpty) return;

  final List<String> collections = [
    'pccoe_students',
    'external_college_students',
    'international_students',
    'alumni',
  ];

  final eventDocRef =
      FirebaseFirestore.instance.collection('events').doc(event.id);

  DocumentSnapshot? userSnapshot;
  DocumentReference? userDocRef;

  for (final collection in collections) {
    final docRef = FirebaseFirestore.instance.collection(collection).doc(uid);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      userSnapshot = snapshot;
      userDocRef = docRef;
      break;
    }
  }

  if (userSnapshot == null || userDocRef == null) {
    _showDialog(
      context,
      title: "User Not Found",
      content: "You are not registered in any user category.",
    );
    return;
  }

  final List<dynamic> attending = List.from(
    (userSnapshot.data() as Map<String, dynamic>?)?['attending'] ?? [],
  );

  if (attending.contains(event.title)) {
    _showDialog(
      context,
      title: "Already Registered",
      content: "You have already registered for this event.",
    );
    return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Do you wish to register for "${event.title}"?',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance.runTransaction(
                        (transaction) async {
                          final eventSnapshot =
                              await transaction.get(eventDocRef);

                          final currentAttendees =
                              eventSnapshot.data()?['attendees'] ?? 0;
                          final List<String> attendanceList = List<String>.from(
                            eventSnapshot.data()?['attendanceList'] ?? [],
                          );

                          if (!attendanceList.contains(uid)) {
                            attendanceList.add(uid);
                            transaction.update(eventDocRef, {
                              'attendees': currentAttendees + 1,
                              'attendanceList': attendanceList,
                            });
                          }

                          attending.add(event.title);
                          transaction.set(
                            userDocRef!,
                            {'attending': attending},
                            SetOptions(merge: true),
                          );
                        },
                      );

                      Navigator.of(context).pop(); // close confirm dialog
                      _showDialog(
                        context,
                        title: "Registered Successfully",
                        content:
                            "You have successfully registered for the event.\n\nNote: Ticket can be found in the Tickets section.",
                      );
                    } catch (e) {
                      Navigator.of(context).pop(); // close confirm dialog
                      _showDialog(
                        context,
                        title: "Registration Failed",
                        content: "Something went wrong: $e",
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
    ),
  );
}

  void _showDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
