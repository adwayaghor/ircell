import 'package:flutter/material.dart';
import 'package:ircell/activities/events.dart';
import 'package:ircell/activities/outbound.dart';
import 'package:ircell/activities/user.dart';

class Page2 extends StatefulWidget {
  @override
  State<Page2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Page2> {
  Widget _buildCategoryButton(int index, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Events()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Outbound()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const User()),
            );
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategoryButton(0, 'Events', Icons.event),
              _buildCategoryButton(1, 'Internships', Icons.work),
              _buildCategoryButton(2, 'User', Icons.person),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width - 32, 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(
  String title,
  String subtitle, 
  double height,
) {
  return SizedBox(
    height: height,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(12),
          // 👇 Force child to take full height
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top text content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                  SizedBox(height: 8),
                  Text(subtitle),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo, // or your preferred background
      appBar: AppBar(
        title: Icon(Icons.star, color: Colors.amber),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Icon(Icons.help_outline, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryButtons(), // Injected custom top UI
            SizedBox(height: 20),
            Column(
              children: [
                // Row 1
                Row(
                  children: [
                    Expanded(
                      child: buildCard("Events", '', 190),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          buildCard("Student Mobility", '', 90),
                          SizedBox(height: 10),
                          buildCard("International Alumni", '', 90),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Row 2
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          buildCard("About Us", '', 95),
                          SizedBox(height: 10),
                          buildCard(
                            "International Students",
                            '',
                            95,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildCard("Higher Studies", '', 200),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
