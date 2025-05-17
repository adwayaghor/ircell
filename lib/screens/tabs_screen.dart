import 'package:flutter/material.dart';
import 'package:ircell/app_theme.dart';
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

    switch (_selectedPageIndex) {
      case 0:
        activePage = const Page1();
        break;
      case 1:
        activePage = const Page2();
        break;
      case 2:
        activePage = const Page3();
        break;
      case 3:
        activePage = Page4();
        break;
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: AppTheme.gradientBackground,
            child: activePage,
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
            selectedItemColor: AppTheme.primaryBlue,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none),
                label: 'Notifications',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
