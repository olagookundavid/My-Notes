import 'package:flutter/material.dart';
import 'package:mynotes/views/verify_email.dart';
import 'views/hompage.dart';
import 'views/Login_view.dart';
import 'views/note_views.dart';
import 'views/register_view.dart ';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomePage.id,
      routes: {
        LoginView.id: (context) => const LoginView(),
        RegisterPage.id: (context) => const RegisterPage(),
        HomePage.id: (context) => HomePage(),
        NoteView.id: (context) => const NoteView(),
        Verifyemail.id: (context) => const Verifyemail(),
      },
    ),
  );
}
