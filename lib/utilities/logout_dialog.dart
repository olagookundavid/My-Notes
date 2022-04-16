import 'package:flutter/material.dart';
import 'dialogs.dart';

Future<bool> showLogoutDialog(
  BuildContext context,
) {
  return showGenericDialogue(
    context: context,
    title: "Log out",
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Log out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
