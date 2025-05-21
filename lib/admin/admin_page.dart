import 'package:flutter/material.dart';
import 'package:ircell/admin/event/event_upload.dart';
import 'package:ircell/admin/event/view_event.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (ctx) => EventUpload()));
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Events'),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (ctx) => ViewEvents(function: 'publish',)));
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Attendance Scanner'),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.of(
                //   context,
                // ).push(MaterialPageRoute(builder: (ctx) => EventUpload()));
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Users'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
