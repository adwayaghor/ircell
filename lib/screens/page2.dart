import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ircell/activities/events.dart';
import 'package:ircell/activities/outbound.dart';
import 'package:ircell/activities/user.dart';

class Page2 extends StatefulWidget {
  @override
  State<Page2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Page2> {
  late final PageController _pageController;
  int _currentPage = 0;

  final List<String> imagePaths = [
    'assets/images/img1.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
    'assets/images/img4.jpg',
    'assets/images/img5.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = imagePaths.length * 1000; // Start far in for smooth infinite loop
    _pageController = PageController(initialPage: _currentPage);

    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      _currentPage++;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCategoryButton(int index, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Events()));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Outbound()));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const User()));
        }
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
        ],
      ),
    );
  }

  Widget buildCard(String title, String imagePath, double height) {
    return SizedBox(
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {},
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔄 Auto-scrolling image carousel
            SizedBox(
              height: 250,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: (context, index) {
                  final imageIndex = index % imagePaths.length;
                  return Image.asset(
                    imagePaths[imageIndex],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryButtons(),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: buildCard("Events", 'assets/images/events.png', 190)),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                buildCard("Student Mobility", 'assets/images/student_mobility.png', 90),
                                SizedBox(height: 10),
                                buildCard("International Alumni", 'assets/images/international_alumini.png', 90),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                buildCard("About Us", 'assets/images/about_us.png', 95),
                                SizedBox(height: 10),
                                buildCard("International Students", 'assets/images/international_students.png', 95),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(child: buildCard("Higher Studies", 'assets/images/higher_studies.png', 200)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
