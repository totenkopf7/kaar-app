import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaar/components/colors.dart';
import 'package:kaar/screens/home_screen.dart';
import 'package:kaar/screens/navbar_home.dart'; // Import your home screen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _verificationId;
  bool _isCodeSent = false;

  Future<void> _verifyPhoneNumber() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    final String smsCode = _codeController.text;
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Login Page',
          style: TextStyle(color: AppColors.background),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _phoneController,
              cursorColor: AppColors.primary,
              style: const TextStyle(color: AppColors.primary),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(color: AppColors.primary),
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(8)),
                //   borderSide:
                //       BorderSide(color: AppColors.primary), // default border
                // ),
                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.all(Radius.circular(8)),
                //   borderSide: BorderSide(color: AppColors.primary),
                // ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            if (_isCodeSent)
              TextField(
                controller: _codeController,
                cursorColor: AppColors.primary,
                style: const TextStyle(color: AppColors.primary),
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  labelStyle: TextStyle(color: AppColors.primary),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
              ),
              onPressed:
                  _isCodeSent ? _signInWithPhoneNumber : _verifyPhoneNumber,
              child: Text(
                _isCodeSent ? 'Verify Code' : 'Send Code',
                style: const TextStyle(
                    fontSize: 16.0, color: AppColors.background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
