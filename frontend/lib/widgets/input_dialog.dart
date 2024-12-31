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
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.hintText,
              filled: true, // Enables background color
              fillColor: Colors.grey[200], // Gray background
              border: OutlineInputBorder(), // Adds border
              errorText: _errorMessage, // Display error message
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFEF9920),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final input = _controller.text.trim();
            if (input.isEmpty) {
              setState(() {
                _errorMessage = 'Input cannot be empty';
              });
              return;
            }
            widget.onConfirm(input); // Pass the input value
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
