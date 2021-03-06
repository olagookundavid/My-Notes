import 'package:flutter/material.dart';
import 'package:mynotes/services/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/note_list_view.dart';
import '../../enums/menu_action.dart';
import '../../utilities/logout_dialog.dart';
import '../login_view.dart';

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);
  static const id = 'Notes';
  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late final NoteService _noteService;
  String get userEmail => AuthService.firebase().currentUser!.email;
  @override
  void initState() {
    _noteService = NoteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, createUpdateNoteView.id);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogoutDialog(context);

                  if (shouldlogout) {
                    // await auth.logOut();

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
      body: FutureBuilder(
        future: _noteService.getOrcreateUser(
          email: userEmail,
        ),
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _noteService.allNotes,
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DataBaseNotes>;
                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await _noteService.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.pushNamed(
                              context,
                              createUpdateNoteView.id,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    default:
                      return const CircularProgressIndicator();
                  }
                }),
              );

            default:
              return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
