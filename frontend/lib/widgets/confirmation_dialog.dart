import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEF9920), // Orange background for OK
            foregroundColor: Colors.white, // White text
          ),
          onPressed: () {
            onConfirm(); // Execute the confirmation action
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text(confirmText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // White background for Cancel
            foregroundColor: Colors.black, // Black text
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without action
          },
          child: Text(cancelText),
        ),
      ],
    );
  }
}
