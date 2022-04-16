import 'package:flutter/material.dart';
import 'dialogs.dart';

Future<bool> showDeleteDialog(
  BuildContext context,
) {
  return showGenericDialogue(
    context: context,
    title: "Delete",
    content: 'Are you sure you want to delete this item',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
