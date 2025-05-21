import 'package:flutter/material.dart';
import 'package:ircell/providers/internship_provider.dart';
import 'package:ircell/screens/internships/outbound_detail_page.dart';

class OutboundDetails extends StatefulWidget {
  const OutboundDetails({super.key});

  @override
  OutboundDetailsState createState() => OutboundDetailsState();
}

class OutboundDetailsState extends State<OutboundDetails> {
  List<OutboundInternship> internships = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInternships();
  }

  Future<void> loadInternships() async {
    final fetched = await fetchAllOutboundInternships();
    setState(() {
      internships = fetched;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Outbound Internships")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: internships.length,
        itemBuilder: (context, index) {
          final internship = internships[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => OutboundDetailPage(internship: internship),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      internship.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${internship.university}, ${internship.country}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          internship.duration,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.attach_money,
                          size: 16,
                          color: Colors.blueGrey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          internship.cost,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
