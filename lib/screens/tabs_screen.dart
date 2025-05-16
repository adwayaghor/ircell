import 'package:flutter/material.dart';
import 'package:ircell/screens/page1.dart';
import 'package:ircell/screens/page2.dart';
import 'package:ircell/screens/page3.dart';
import 'package:ircell/screens/page4.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const Page1();
    if (_selectedPageIndex == 0) {
      activePage = const Page1();
    }
    if (_selectedPageIndex == 1) {
      activePage = const Page2();
    }
    if (_selectedPageIndex == 2) {
      activePage = const Page3();
    }
    if (_selectedPageIndex == 3) {
      activePage = const Page4();
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => const ChatBotScreen(),
          //       ),
          //     );
          //   },
          //   backgroundColor: Colors.blueAccent,
          //   child: const Icon(Icons.forum, color: Colors.white),
          // ),
          //drawer: const MainDrawer(),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 15, 90),
                  Color.fromARGB(255, 50, 100, 150),
                  Color.fromARGB(255, 120, 230, 190),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: activePage,
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
            fixedColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(192, 255, 255, 255),
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.local_activity_outlined),
                label: '1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.thumb_up_sharp),
                label: '2',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '3'),
              BottomNavigationBarItem(icon: Icon(Icons.ballot), label: '4'),
            ],
          ),
        ),
      ),
    );
  }
}
