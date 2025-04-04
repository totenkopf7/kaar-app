import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kaar/components/colors.dart';
import 'package:kaar/screens/login_screen.dart';
import 'package:kaar/screens/navbar_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate a loading process
    Future.delayed(const Duration(seconds: 4), () {
      // Navigate to the main screen after loading
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your app logo or image here
            Image.asset(
              'lib/assets/images/logo.png', // Replace with your logo path
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            // Circular progress indicator
            const SpinKitFadingCircle(
              color: AppColors.primary,
              size: 50, // Customize the color
            ),
          ],
        ),
      ),
    );
  }
}
