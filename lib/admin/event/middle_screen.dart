import 'package:flutter/material.dart';
import 'package:ircell/admin/event/scanner.dart';

class MiddleScreen extends StatelessWidget {
  const MiddleScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mark Attendance')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AttendanceScannerScreen(eventId: eventId),
              ),
            );
          },
          child: Text('Mark Attendance for $eventId', style: TextStyle(fontSize: 20),),
        ),
      ),
    );
  }
}
