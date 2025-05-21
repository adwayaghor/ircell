import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventActions extends StatelessWidget {
  final String eventId;

  const EventActions({super.key, required this.eventId});

  Future<List<Map<String, dynamic>>> fetchStudentDetailsFromUids(
    String eventId,
  ) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('events')
              .doc(eventId)
              .get();

      final data = doc.data() as Map<String, dynamic>;

      List<String> uids = List<String>.from(data['attendanceList'] ?? []);
      print('Event ID: $eventId');
      print('UIDs from attendanceList: $uids');

      // Fetch user info from 'pccoe_students' collection using each UID
      List<Map<String, dynamic>> studentDetails = [];

      for (String uid in uids) {
        final trimmedUid = uid.trim(); // Remove leading/trailing spaces
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('pccoe_students')
                .doc(trimmedUid)
                .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          studentDetails.add({
            'uid': trimmedUid,
            'firstName': userData['first_name'] ?? '',
            'lastName': userData['last_name'] ?? '',
            'email': userData['email'] ?? '',
          });
        } else {
          studentDetails.add({
            'uid': trimmedUid,
            'firstName': '[Not Found]',
            'lastName': '',
            'email': '',
          });
        }
      }

      return studentDetails;
    } catch (e) {
      print('Error fetching student details: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchStudentDetailsFromUids(eventId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading attendance'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Attendance not yet marked'));
          } else {
            final students = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Attendance',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return ListTile(
                        title: Text(
                          '${student['firstName']} ${student['lastName']}',
                        ),
                        subtitle: Text(student['email']),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
