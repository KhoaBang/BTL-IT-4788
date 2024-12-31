import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final void Function(String input) onConfirm;

  const InputDialog({
    super.key,
    required this.title,
    required this.hintText,
    this.confirmText = 'OK',
    this.cancelText = 'Cancel',
    required this.onConfirm,
  });

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true, // Enables background color
          fillColor: Colors.grey[200], // Gray background
          border: OutlineInputBorder(), // Adds border
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEF9920),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            widget.onConfirm(_controller.text); // Pass the input value
            Navigator.of(context).pop(); // Close dialog
          },
          child: Text(widget.confirmText),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without action
          },
          child: Text(widget.cancelText),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
