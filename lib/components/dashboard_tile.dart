import 'package:flutter/material.dart';
import 'package:kaar/components/colors.dart';

class DashboardTile extends StatelessWidget {
  final String imagePath;
  final String title;
  // final Color color;
  final VoidCallback? onTap;
  final bool isEnabled;

  const DashboardTile(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.onTap,
      // required this.color,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      //stack widget allows you to place widgets on top of each other
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: isEnabled ? 1.0 : 0.6,
            child: Container(
              padding: const EdgeInsets.all(12),
              width: 100,
              height: 120,
              decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Image.asset(imagePath, height: 32, width: 32),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.background,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isEnabled)
            Positioned(
                top: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Coming Soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
        ],
      ),
    );
  }
}
