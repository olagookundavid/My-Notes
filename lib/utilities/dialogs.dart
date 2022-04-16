import 'package:flutter/material.dart';

typedef DialgueOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialogue<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialgueOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(optionTitle),
          );
        }).toList(),
      );
    },
  );
}

/*

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

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('An error has occurred'),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('ok'),
          )
        ],
      );
    },
  );
}


*/