import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kaar/firebase_options.dart';
import 'package:kaar/screens/splash_screen.dart'; // Import your login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kaar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(), // Set the login screen as the initial route
    );
  }
}
