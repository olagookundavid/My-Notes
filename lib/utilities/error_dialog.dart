import 'package:flutter/cupertino.dart';
import 'package:mynotes/utilities/dialogs.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialogue(
    context: context,
    title: "An error occurred",
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
