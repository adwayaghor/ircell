import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final String date;
  final String time;
  final String location;
  final String speaker;
  final String description;
  final String imageURL;
  final List<String> attendanceList;

  Event({
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.speaker,
    required this.description,
    required this.imageURL,
    required this.attendanceList,
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      title: data['title'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      location: data['location'] ?? '',
      speaker: data['speaker'] ?? '',
      description: data['description'] ?? '',
      imageURL: data['imageURL'] ?? '',
      attendanceList: data['attendanceList'] ?? [ ],
    );
  }
}

Future<List<Event>> fetchAllEvents() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    return querySnapshot.docs
        .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    print('Error fetching events: $e');
    return [];
  }
}
