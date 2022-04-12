import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/verify_email.dart';
import 'utilities/dialogs.dart';
import 'views/hompage.dart';
import 'views/Login_view.dart';
import 'views/register_view.dart';
import 'dart:developer' as devtools show log;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

enum MenuAction { logout }

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);
  static const id = 'Notes';
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogOutDialog(context);
                  devtools.log(shouldlogout.toString());
                  if (shouldlogout) {
                    await _auth.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginView.id, (route) => false);
                  }
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<MenuAction>(
                  child: Text('Log Out'),
                  value: MenuAction.logout,
                )
              ];
            },
          )
        ],
      ),
    );
  }
}
