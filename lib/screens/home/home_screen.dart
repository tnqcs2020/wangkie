import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _currentIndex = 0;

  // final List<Widget> _tabs = const [
  //   Center(child: Text('Dashboard')), // Placeholder for dashboard tab
  //   ProfileScreen(),
  //   SettingScreen(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Home"));
    // Scaffold(
    // body: _tabs[_currentIndex],
    // bottomNavigationBar: BottomNavigationBar(
    //   currentIndex: _currentIndex,
    //   onTap: (index) => setState(() => _currentIndex = index),
    //   items: const [
    //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    //     BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
    //   ],
    // ),
    // );
  }
}
