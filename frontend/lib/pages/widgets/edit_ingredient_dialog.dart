import 'package:flutter/material.dart';

class EditIngredientDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final String currentName;
  final String currentUnit;
  final List<String> allIngredientNames;
  final int currentUnitId;
  final void Function(String input, int unitId) onConfirm;

  const EditIngredientDialog({
    Key? key,
    required this.title,
    required this.hintText,
    required this.currentName,
    required this.currentUnit,
    required this.allIngredientNames,
    required this.currentUnitId,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _EditIngredientDialogState createState() => _EditIngredientDialogState();
}

class _EditIngredientDialogState extends State<EditIngredientDialog> {
  late final TextEditingController _controller;
  int? _selectedUnitId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentName);
    _selectedUnitId = widget.currentUnitId;
  }

  void _save() {
    final inputName = _controller.text.trim();

    // Check for duplicate name
    if (inputName.isEmpty) {
      setState(() {
        _errorMessage = 'Name cannot be empty.';
      });
      return;
    }

    if (inputName != widget.currentName &&
        widget.allIngredientNames.contains(inputName)) {
      setState(() {
        _errorMessage = 'This ingredient name already exists.';
      });
      return;
    }

    // Handle nullable unit_id
    setState(() {
      _errorMessage = null;
    });
    widget.onConfirm(inputName, _selectedUnitId!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                child: DropdownButtonFormField<int>(
                  value: _selectedUnitId,
                  items: [
                    DropdownMenuItem(value: 1, child: Text('cái')),
                    DropdownMenuItem(value: 2, child: Text('g')),
                    DropdownMenuItem(value: 3, child: Text('kg')),
                    DropdownMenuItem(value: 4, child: Text('l')),
                    DropdownMenuItem(value: 5, child: Text('ml')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedUnitId = value;
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
          if (_errorMessage != null) // Show error text if it exists
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
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
          onPressed: _save, // Call _save function
          child: Text('Confirm'),
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
