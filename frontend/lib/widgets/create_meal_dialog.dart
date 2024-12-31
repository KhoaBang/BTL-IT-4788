import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/ingredient_service.dart';

class CreateMealDialog extends ConsumerStatefulWidget {
  final String groupId;
  final String title;
  final String confirmText;
  final String cancelText;
  final Function(String groupId, String mealName, DateTime consumeDate,
      List<Map<String, dynamic>> ingredients) onConfirm;

  final String? initialMealName;
  final DateTime? initialConsumeDate;
  final List<Map<String, dynamic>> initialIngredients;

  const CreateMealDialog({
    Key? key,
    required this.groupId,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    this.initialMealName,
    this.initialConsumeDate,
    this.initialIngredients = const [],
  }) : super(key: key);

  @override
  _CreateMealDialogState createState() => _CreateMealDialogState();
}

class _CreateMealDialogState extends ConsumerState<CreateMealDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _mealNameController;
  DateTime? _selectedDate;
  final List<Map<String, dynamic>> _selectedIngredients = [];
  final Map<String, TextEditingController> _quantityControllers = {};

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
    _mealNameController =
        TextEditingController(text: widget.initialMealName ?? '');
    _selectedDate = widget.initialConsumeDate;
    _selectedIngredients.addAll(widget.initialIngredients);
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
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Failed to load ingredients. Please try again.'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _fetchIngredients,
                      child: const Text('Retry'),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _mealNameController,
                          decoration:
                              const InputDecoration(labelText: 'Meal Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a meal name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => _selectDate(context),
                          child: Text(_selectedDate == null
                              ? 'Select Date'
                              : 'Selected Date: ${_selectedDate!.toLocal()}'
                                  .split(' ')[0]),
                        ),
                        if (_selectedDate == null)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Text('Please choose date',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                        const SizedBox(height: 10),
                        const Text('Add Ingredients:'),
                        ..._ingredients.map((ingredient) {
                          final isSelected = _selectedIngredients.any(
                              (selected) =>
                                  selected['ingredient_name'] ==
                                  ingredient['name']);
                          return CheckboxListTile(
                            title: Text(ingredient['name']),
                            subtitle: isSelected
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Map the ingredient's unitId to the corresponding unit name
                                      Text(
                                          'Unit: ${unitMappings[ingredient['unitId']] ?? "Unknown"}'),
                                      TextFormField(
                                        controller: _quantityControllers[
                                                ingredient['name']] ??
                                            TextEditingController(text: '1.0'),
                                        decoration: const InputDecoration(
                                            labelText: 'Quantity'),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          final parsedValue =
                                              double.tryParse(value) ?? 1.0;
                                          setState(() {
                                            final ingredientIndex =
                                                _selectedIngredients.indexWhere(
                                                    (selected) =>
                                                        selected[
                                                            'ingredient_name'] ==
                                                        ingredient['name']);
                                            _selectedIngredients[
                                                    ingredientIndex]
                                                ['quantity'] = parsedValue;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Unit: ${unitMappings[ingredient['unitId']] ?? "Unknown"}'),
                            value: isSelected,
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedIngredients.add({
                                    'ingredient_name': ingredient['name'],
                                    'unit_id': int.parse(ingredient['unitId']),
                                    'quantity': 1.0,
                                  });
                                  _quantityControllers[ingredient['name']] =
                                      TextEditingController(text: '1.0');
                                } else {
                                  _selectedIngredients.removeWhere((selected) =>
                                      selected['ingredient_name'] ==
                                      ingredient['name']);
                                  _quantityControllers
                                      .remove(ingredient['name']);
                                }
                              });
                            },
                          );
                        }).toList(),
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
            if (!_formKey.currentState!.validate() ||
                _selectedDate == null ||
                _selectedIngredients.isEmpty ||
                _selectedIngredients
                    .any((ingredient) => ingredient['quantity'] <= 0)) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please complete all fields!')));
              return;
            }
            widget.onConfirm(
              widget.groupId,
              _mealNameController.text,
              _selectedDate!,
              _selectedIngredients,
            );
            Navigator.of(context).pop();
          },
          child: Text(widget.confirmText),
        ),
      ],
    );
  }
}
