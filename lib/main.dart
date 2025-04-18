import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kaar/firebase_options.dart';
import 'package:kaar/screens/home_screen.dart';
import 'package:kaar/screens/provider_login_screen.dart';
import 'package:kaar/screens/splash_screen.dart';
import 'package:kaar/screens/user_auth_screen.dart'; // Import your login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
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
      initialRoute: '/user_auth',
      routes: {
        '/user_auth': (context) => UserAuthScreen(),
        '/provider_login': (context) => ProviderLoginScreen(),
        '/home': (context) => HomeScreen(),
        '/provider_dashboard': (context) => Placeholder(), // Replace with actual provider dashboard
      },
    );
  }
}