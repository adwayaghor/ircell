import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OutboundDetails extends StatefulWidget {
  const OutboundDetails({super.key});

  @override
  OutboundDetailsState createState() => OutboundDetailsState();
}

class OutboundDetailsState extends State<OutboundDetails> {
  final Uri url = Uri.https("irproject2-460e3-default-rtdb.firebaseio.com", "outbound-internship.json");
  List<Map<String, String>> internships = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>?;
      if (data != null) {
        setState(() {
          internships = data.values.map((e) => Map<String, String>.from(e)).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Outbound Registration',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 15, 90), // Dark Blue (Top Left)
              Color.fromARGB(255, 50, 100, 150), // Mid Blue (Center)
              Color.fromARGB(255, 120, 230, 190), // Cyan Green (Bottom Right)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: internships.length,
          itemBuilder: (context, index) {
            final internship = internships[index];

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      internship["title"] ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildDetailRow("University", internship["university"] ?? ""),
                    _buildDetailRow("Country", internship["country"] ?? ""),
                    _buildDetailRow("Topic", internship["topic"] ?? ""),
                    _buildDetailRow("Duration", internship["duration"] ?? ""),
                    _buildDetailRow("Approx Cost", internship["cost"] ?? ""),
                    _buildDetailRow("Student Benefit", internship["benefit"] ?? ""),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Registration action
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFF9800), // Deep Orange (Left)
                                Color(0xFFFFC107), // Lighter Orange (Right)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Registration action
                            },
                            splashColor: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.black, // Black text
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
            softWrap: true,
          ),
        ],
      ),
    );
  }
}

    //   {
    //     "title": "NUS, Singapore",
    //     "university":
    //         "National University of Singapore (QS Ranking: 8) and Amazon ",
    //     "country": "Singapore",
    //     "topic": "“Big Data Analytics and Deep Learning”",
    //     "duration": "3 weeks",
    //     "cost": "₹ 1-3 lakh (Approx.)",
    //     "benefit":
    //         "Students will benefit from:\n• Expert teaching at NUS Singapore\n• Project allocation on first day\n• Transcript/Evaluation Sheet\n• Recommendation letter by NUS Professor\n• Industry visits, lab tours, and networking \n• A certificate of participation by NUS and Amazon",
    //   },
    //   {
    //     "title": "LSI R&D Lab, Japan",
    //     "university": "University of Tokyo",
    //     "country": "Japan",
    //     "topic": "LSI R&D",
    //     "duration": "1 Month",
    //     "cost": "₹ 1.70 Lakh (Approx.)",
    //     "benefit":
    //         "Students will benefit from:\n• Expert guidance at LSI R&D\n• Project allocation on first day\n• Completion Certificate\n•Pre-Placement offer as per performance/ vacancie\n",
    //   },
    // ];