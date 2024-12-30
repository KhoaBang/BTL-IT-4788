import 'package:flutter/material.dart';

class InputDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String confirmText;
  final String cancelText;
  final Function(String groupId, String ingredientName, String unitId,
      String assignedTo, double quantity) onConfirm;

  const InputDialog({
    Key? key,
    required this.title,
    required this.hintText,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final _groupIdController = TextEditingController();
  final _ingredientNameController = TextEditingController();
  final _unitIdController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _groupIdController,
              decoration: InputDecoration(labelText: 'Group ID'),
            ),
            TextField(
              controller: _ingredientNameController,
              decoration: InputDecoration(labelText: 'Ingredient Name'),
            ),
            TextField(
              controller: _unitIdController,
              decoration: InputDecoration(labelText: 'Unit ID'),
            ),
            TextField(
              controller: _assignedToController,
              decoration: InputDecoration(labelText: 'Assigned To'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        TextButton(
          onPressed: () {
            final groupId = _groupIdController.text;
            final ingredientName = _ingredientNameController.text;
            final unitId = _unitIdController.text;
            final assignedTo = _assignedToController.text;
            final quantity = double.tryParse(_quantityController.text) ?? 0.0;

            widget.onConfirm(
                groupId, ingredientName, unitId, assignedTo, quantity);
            Navigator.of(context).pop();
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
