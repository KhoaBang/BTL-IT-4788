import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/ingredient_service.dart';

class InputDialog extends ConsumerStatefulWidget {
  final String groupId;
  final String title;
  final String confirmText;
  final String cancelText;
  final Function(String groupId, String ingredientName, String unitId,
      DateTime createdAt, double quantity) onConfirm;

  const InputDialog({
    Key? key,
    required this.groupId,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  }) : super(key: key);

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends ConsumerState<InputDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedIngredientName;
  String? _selectedUnitId;

  List<Map<String, dynamic>> _ingredients = [];
  bool _isLoading = true;
  bool _hasError = false;

  final Map<String, String> unitMappings = {
    "1": "cái",
    "2": "g",
    "3": "kg",
    "4": "ml",
    "5": "l",
  };

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final ingredientService = IngredientService();
      final ingredients = await ingredientService.getIngredients();
      setState(() {
        _ingredients = ingredients.map((ingredient) {
          return {
            'name': ingredient['ingredient_name'],
            'unitId': ingredient['unit']['id'].toString(),
          };
        }).toList();
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasError
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Failed to load ingredients. Please try again.'),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchIngredients,
                      child: Text('Retry'),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedIngredientName,
                          items: _ingredients.map((ingredient) {
                            return DropdownMenuItem<String>(
                              value: ingredient['name'],
                              child: Text(ingredient['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIngredientName = value;
                              _selectedUnitId = _ingredients.firstWhere(
                                  (ing) => ing['name'] == value)['unitId'];
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please choose ingredient name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Ingredient'),
                        ),
                        if (_selectedUnitId != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Unit: ${unitMappings[_selectedUnitId] ?? "Unknown"}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(labelText: 'Quantity'),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            final quantity = double.tryParse(value);
                            if (quantity == null || quantity <= 0) {
                              return 'Quantity must be more than 0';
                            }
                            return null;
                          },
                        ),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(_selectedDate == null
                              ? 'Select Date'
                              : 'Selected Date: ${_selectedDate!.toLocal()}'
                                  .split(' ')[0]),
                        ),
                        if (_selectedDate == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Please choose date',
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelText),
        ),
        TextButton(
          onPressed: () {
            if (!_formKey.currentState!.validate() || _selectedDate == null) {
              if (_selectedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter feilds correctly.')),
                );
              }
              return;
            }

            final quantity = double.parse(_quantityController.text);
            widget.onConfirm(
              widget.groupId,
              _selectedIngredientName!,
              _selectedUnitId!,
              _selectedDate!,
              quantity,
            );
            Navigator.of(context).pop();
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
