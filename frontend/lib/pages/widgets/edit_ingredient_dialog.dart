import 'package:flutter/material.dart';

class EditIngredientDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String currentName; // Pass the current name to show in placeholder
  final String currentUnit; // Pass the current unit
  final void Function(String input, String unit) onConfirm;

  const EditIngredientDialog({
    Key? key,
    required this.title,
    required this.hintText,
    required this.currentName,
    required this.currentUnit,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _EditIngredientDialogState createState() => _EditIngredientDialogState();
}

class _EditIngredientDialogState extends State<EditIngredientDialog> {
  late final TextEditingController _controller; // Initialize dynamically
  String _selectedUnit = 'kg';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.currentName); // Set the initial placeholder value
    _selectedUnit = widget.currentUnit; // Preselect the passed unit
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              value: _selectedUnit,
              items: [
                DropdownMenuItem(value: 'kg', child: Text('kg')),
                DropdownMenuItem(value: 'gr', child: Text('gr')),
                DropdownMenuItem(value: 'ml', child: Text('ml')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedUnit = value ?? 'kg';
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
              ),
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
            widget.onConfirm(_controller.text, _selectedUnit);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
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
