import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/ingredient_service.dart';
import 'package:frontend/providers/group_provider.dart';

class InputDialog extends ConsumerStatefulWidget {
  final String groupId;
  final String title;
  final String confirmText;
  final String cancelText;
  final Function(String groupId, String ingredientName, String unitId,
      String assignedTo, double quantity) onConfirm;

  const InputDialog({
    super.key,
    required this.groupId,
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
  });

  @override
  _InputDialogState createState() => _InputDialogState();
}

class _InputDialogState extends ConsumerState<InputDialog> {
  final _quantityController = TextEditingController();
  String? _selectedIngredientName;
  String? _selectedUnitId;
  String? _selectedAssignedTo;

  List<Map<String, dynamic>> _ingredients = [];
  bool _isLoading = true;

  // Map unit IDs to their names
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
    _loadGroupMembers();
  }

  Future<void> _fetchIngredients() async {
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
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch ingredients')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadGroupMembers() async {
    await ref.read(chosenGroupProvider.notifier).selectGroup(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    final groupState = ref.watch(chosenGroupProvider);

    return AlertDialog(
      title: Text(widget.title),
      content: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Group ID: ${widget.groupId}'),
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
                  DropdownButtonFormField<String>(
                    value: _selectedAssignedTo,
                    items: groupState.memberList.map((member) {
                      return DropdownMenuItem<String>(
                        value: member.uuid,
                        child: Text('${member.username} (${member.email})'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedAssignedTo = value;
                      });
                    },
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
            if (_selectedIngredientName == null ||
                _selectedUnitId == null ||
                _selectedAssignedTo == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please complete all fields')),
              );
              return;
            }

            final quantity = double.tryParse(_quantityController.text) ?? 0.0;

            widget.onConfirm(
              widget.groupId,
              _selectedIngredientName!,
              _selectedUnitId!,
              _selectedAssignedTo!,
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
