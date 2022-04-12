import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Verifyemail extends StatefulWidget {
  const Verifyemail({Key? key}) : super(key: key);

  @override
  State<Verifyemail> createState() => _VerifyemailState();
}

class _VerifyemailState extends State<Verifyemail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address'),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text('Send Email verification'),
          )
        ],
      ),
    );
  }
}
