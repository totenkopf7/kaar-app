import 'package:flutter/material.dart';
import 'package:kaar/components/bottom_nav_bar.dart';
import 'package:kaar/screens/home_screen.dart';

class NavbarHomeScreen extends StatefulWidget {
  const NavbarHomeScreen({super.key});

  @override
  State<NavbarHomeScreen> createState() => _NavbarHomeScreenState();
}

class _NavbarHomeScreenState extends State<NavbarHomeScreen> {
  int _selectedIndex = 0; // Index of the selected tab
  final List<Widget> _pages = [
    HomeScreen(),
    Center(child: Text('Search Page')),
    Center(child: Text('Booking Page')),
    Center(child: Text('Favorite Page')),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Pass the onTap function
      ),
    );
  }
}
