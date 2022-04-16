import 'package:flutter/material.dart';
import 'package:mynotes/views/Login_view.dart';
import 'package:mynotes/views/verify_email.dart';
import '../services/auth/auth_exceptions.dart';
import '../services/auth_service.dart';
import '../utilities/error_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const id = 'register';
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      appBar: AppBar(
        title: const Text('Register'),
      ),
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
            decoration: const InputDecoration(
              hintText: "Enter Your Password",
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await auth.createUser(
                  email: email,
                  password: password,
                );

                await auth.sendEmailVerification();
                Navigator.of(context).pushNamed(
                  Verifyemail.id,
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email Already in use ',
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Weak password',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Invalid Email address',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Authentication error',
                );
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(LoginView.id, (route) => false);
              },
              child: const Text('Already registered? Login here!'))
        ],
      ),
    );
  }
}
