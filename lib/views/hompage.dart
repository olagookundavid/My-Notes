import 'package:flutter/material.dart';
import 'package:mynotes/services/auth_service.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/verify_email.dart';
import 'notes/note_views.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  static const id = 'homepage';
  final auth = AuthService.firebase();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = auth.currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
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
