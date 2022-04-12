import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/verify_email.dart';
import '../firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  static const id = 'homepage';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const Verifyemail();
              } else {
                
                return const NoteView();
              }
            } else {
              return const LoginView();
            }


          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
