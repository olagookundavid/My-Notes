// ignore_for_file: file_names, unused_import
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth_service.dart';

import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email.dart';
import 'dart:developer' as devtools show log;
import '../main.dart';
import '../utilities/dialogs.dart';
import '../utilities/error_dialog.dart';
import 'notes/note_views.dart';

class LoginView extends StatefulWidget {
  static const id = 'Login';
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  final auth = AuthService.firebase();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: "Enter Your Email"),
          ),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: "Enter Your Password")),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await auth.logIn(
                  email: email,
                  password: password,
                );
                final user = auth.currentUser;
                if (user?.isEmailVerified ?? false) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(NoteView.id, (route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    Verifyemail.id,
                    (route) => false,
                  );
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } on WrongPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Wrong password',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text(
              "Login",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(RegisterPage.id, (route) => false);
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
