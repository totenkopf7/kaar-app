import 'package:flutter/material.dart';
import 'package:kaar/screens/navbar_home.dart';
import 'package:kaar/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kaar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // Typically a Scaffold
    );
  }
}
