import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProviderLoginScreen extends StatefulWidget {
  @override
  _ProviderLoginScreenState createState() => _ProviderLoginScreenState();
}

class _ProviderLoginScreenState extends State<ProviderLoginScreen> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _loginAsProvider() async {
    try {
      String enteredCode = _codeController.text.trim();

      // Query Firestore for the provider with the entered code
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('providerCode', isEqualTo: enteredCode)
          .where('role', isEqualTo: 'provider')
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Provider found
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        // Navigate to the provider dashboard
        Navigator.pushReplacementNamed(context, '/provider_dashboard');
      } else {
        // Invalid code
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid provider code!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Provider Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration:
                  const InputDecoration(labelText: 'Enter Provider Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loginAsProvider,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
