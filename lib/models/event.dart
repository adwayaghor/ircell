import 'package:intl/intl.dart';

class Event {
  Event({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.speaker,
    required this.location,
    required this.time,
    required this.date,
    required this.description,
    required this.isInterested,
  });
  String id;
  String title;
  String imageUrl;
  String speaker;
  String location;
  String date;
  String time;
  String description;
  bool isInterested;

  Event copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? speaker,
    String? location,
    String? date,
    String? time,
    String? description,
    bool? isInterested,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      speaker: speaker ?? this.speaker,
      location: location ?? this.location,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      isInterested: isInterested ?? this.isInterested,
    );
  }

  // Convert Event to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "imageUrl": imageUrl,
      "speaker": speaker,
      "location": location,
      "date": date,
      "time": time,
      "description": description,
      "isInterested": isInterested,
    };
  }

  // Convert JSON to Event
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json["id"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      speaker: json["speaker"],
      location: json["location"],
      date: json["date"],
      time: json["time"],
      description: json["description"],
      isInterested: json["isInterested"],
    );
  }

  bool isPast() {
    try {
      final eventDate = DateFormat('dd/MM/yyyy').parse(date);
      return eventDate.isBefore(DateTime.now());
    } catch (e) {
      return false;
    }
  }
}
