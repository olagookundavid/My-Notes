import 'package:flutter/material.dart';
import 'package:mynotes/services/auth_service.dart';
import '../enums/menu_action.dart';
import '../utilities/dialogs.dart';
import 'login_view.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);
  static const id = 'Notes';
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final auth = AuthService.firebase();

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

                  if (shouldlogout) {
                    await auth.logOut();
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
