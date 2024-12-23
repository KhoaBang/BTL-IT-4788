import 'package:flutter/material.dart';

class NotificationBox extends StatelessWidget {
  final String message;
  final bool isError;

  const NotificationBox({
    Key? key,
    required this.message,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isError ? Colors.red[100] : Colors.green[100],
      title: Text(
        isError ? 'Error' : 'Success',
        style: TextStyle(
          color: isError ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: isError ? Colors.red : Colors.green,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    );
  }
}
