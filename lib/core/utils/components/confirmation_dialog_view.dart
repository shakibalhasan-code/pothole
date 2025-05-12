// lib/core/widgets/confirmation_dialog.dart

import 'package:flutter/material.dart';
import 'package:jourapothole/core/utils/constants/app_colors.dart'; // Assuming you have this

// Enum to represent the dialog result
enum DialogAction { no, yes, dontKnow }

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String noButtonText;
  final String yesButtonText;
  final String dontKnowButtonText;

  const ConfirmationDialog({
    super.key,
    this.title = 'Confirm Action',
    required this.message,
    this.noButtonText = 'No',
    this.yesButtonText = 'Yes',
    this.dontKnowButtonText = "I don't know",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.redColor, // Or your desired color
          ),
          child: Text(noButtonText),
          onPressed: () {
            Navigator.of(context).pop(DialogAction.no); // Pop with a result
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green, // Or your desired color
          ),
          child: Text(yesButtonText),
          onPressed: () {
            Navigator.of(context).pop(DialogAction.yes); // Pop with a result
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue, // Or your desired color
          ),
          child: Text(dontKnowButtonText),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(DialogAction.dontKnow); // Pop with a result
          },
        ),
      ],
    );
  }
}
