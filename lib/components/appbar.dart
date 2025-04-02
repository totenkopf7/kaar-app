import 'package:flutter/material.dart';
import 'package:kaar/components/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // builder is needed for drawer to open
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: AppColors.secondary,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: AppColors.secondary),
      ),
      backgroundColor: AppColors.background,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: AppColors.secondary,
          onPressed: () {},
        ),
      ],
    );
  }

  // Required for PreferredSizeWidget
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
