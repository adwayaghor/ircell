

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ircell/providers/alumni_provider.dart';
// import 'package:ircell/screens/activities/alumni_details.dart';

// class AlumniBlogsPage extends StatefulWidget {
//   const AlumniBlogsPage({Key? key}) : super(key: key);

//   @override
//   State<AlumniBlogsPage> createState() => _AlumniBlogsPageState();
// }

// class _AlumniBlogsPageState extends State<AlumniBlogsPage> {
//   List<Alumni> _allAlumni = [];
//   List<Alumni> _filteredAlumni = [];
//   TextEditingController _searchController = TextEditingController();

//   Future<void> fetchAlumni() async {
//     QuerySnapshot snapshot =
//         await FirebaseFirestore.instance.collection('alumni').get();
//     final alumniList = snapshot.docs
//         .map((doc) => Alumni.fromMap(doc.data() as Map<String, dynamic>))
//         .toList();

//     setState(() {
//       _allAlumni = alumniList;
//       _filteredAlumni = alumniList;
//     });
//   }
//   void _filterAlumni(String query) {
//     final lowerQuery = query.toLowerCase();
//     final filtered = _allAlumni.where((alumni) {
//       return alumni.firstName.toLowerCase().contains(lowerQuery) ||
//           alumni.lastName.toLowerCase().contains(lowerQuery) ||
//           alumni.country.toLowerCase().contains(lowerQuery) ||
//           alumni.state.toLowerCase().contains(lowerQuery) ||
//           alumni.pgName.toLowerCase().contains(lowerQuery);
//     }).toList();

//     setState(() {
//       _filteredAlumni = filtered;
//     });
//   }
//   @override
//   void initState() {
//     super.initState();
//     fetchAlumni();
//     _searchController.addListener(() {
//       _filterAlumni(_searchController.text);
//     });
//   }
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Alumni Blogs'),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search Alumni',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: _filteredAlumni.length,
//         itemBuilder: (context, index) {
//           final alumni = _filteredAlumni[index];
//           return ListTile(
//             title: Text('${alumni.firstName} ${alumni.lastName}'),
//             subtitle: Text(alumni.pgName),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => AlumniDetailScreen(alumni: alumni),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// lib/models/alumni_blog.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ircell/screens/community/blog_details.dart';

class AlumniBlog {
  final String firstName;
  final String lastName;
  final String email;
  final DateTime timestamp;
  final String title;
  final String content;

  AlumniBlog({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.timestamp,
    required this.title,
    required this.content,
  });

  factory AlumniBlog.fromMap(Map<String, dynamic> data) {
    return AlumniBlog(
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      title: data['title'] ?? '',
      content: data['content'] ?? '',
    );
  }
}



class AlumniBlogListPage extends StatefulWidget {
  const AlumniBlogListPage({Key? key}) : super(key: key);

  @override
  State<AlumniBlogListPage> createState() => _AlumniBlogListPageState();
}

class _AlumniBlogListPageState extends State<AlumniBlogListPage> {
  List<AlumniBlog> _blogs = [];

  Future<void> fetchBlogs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('alumni_blogs')
        .orderBy('timestamp', descending: true)
        .get();

    final blogList = snapshot.docs
        .map((doc) => AlumniBlog.fromMap(doc.data()))
        .toList();

    setState(() {
      _blogs = blogList;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumni Blogs')),
      body: _blogs.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _blogs.length,
              itemBuilder: (context, index) {
                final blog = _blogs[index];
                return ListTile(
                  title: Text(blog.title),
                  subtitle: Text('By ${blog.firstName} ${blog.lastName}'),
                  trailing: Text(
                    "${blog.timestamp.day}/${blog.timestamp.month}/${blog.timestamp.year}",
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AlumniBlogDetailPage(blog: blog),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
