import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'views/hompage.dart';
import 'views/Login_view.dart';
import 'views/register_view.dart';
import 'dart:developer' as devtools show log;


void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        HomePage.id: (context) => const HomePage()
      },
    ),
  );
}

enum MenuAction { logout }
class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

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
                  if (shouldlogout){
                    await _auth.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(LoginView.id, (route) => false);
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

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to log out'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
