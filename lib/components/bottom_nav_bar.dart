import 'package:flutter/material.dart';
import 'package:kaar/components/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap, // Handle tab selection
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: AppColors.secondary,
            ),
            label: 'Home',
            backgroundColor: AppColors.background),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: AppColors.secondary,
          ),
          label: 'Search',
          backgroundColor: AppColors.background,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.book_online,
            color: AppColors.secondary,
          ),
          label: 'Bookings',
          backgroundColor: AppColors.background,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.favorite,
            color: AppColors.secondary,
          ),
          label: 'Favorites',
          backgroundColor: AppColors.background,
        ),
      ],
    );
  }
}
