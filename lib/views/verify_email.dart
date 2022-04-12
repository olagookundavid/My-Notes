import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/register_view.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({Key? key}) : super(key: key);
  static const id = 'verifyemail';
  @override
  State<Verifyemail> createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(
        children: [
          const Text(
            'We have sent a verification link to your email! \n click on it to verify your email',
          ),
          const Text(
            'If you didn\'t receive the email, click the link below',
          ),
          TextButton(
            onPressed: () async {
              final user = _auth.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text(
              'Send Email verification',
            ),
          ),
          TextButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(RegisterPage.id, (route) => false);
              },
              child: const Text('Restart'))
        ],
      ),
    );
  }
}
