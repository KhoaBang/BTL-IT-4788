import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'edit_ingredient_dialog.dart';
import '../api/api_user.dart';

class IngredientsTable extends StatefulWidget {
  @override
  _IngredientsTableState createState() => _IngredientsTableState();
}

class _IngredientsTableState extends State<IngredientsTable> {
  bool _isLoading = true;
  String? _errorMessage;
  List<Map<String, dynamic>> _ingredients =
      []; // Declare the _ingredients list here

  // Fetch ingredients from the API
  Future<void> _fetchIngredients() async {
    try {
      final api = ApiUser();
      final data = await api.getUserIngredients();
      setState(() {
        _ingredients = data; // Populate _ingredients with fetched data
        _isLoading = false;
      });
      print(_ingredients);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  // currentName: _ingredients[index]["Name"]!,
  // currentUnit: _ingredients[index]["Unit"]!,
  // Handle Modify button
  // Handle Update button
  void _modifyIngredient(int index) {
    final ingredient = _ingredients[index];
    final currentName = ingredient["Name"]!;
    final currentUnit = ingredient["Unit"]!;

    // Ensure that `currentUnitId` is an integer, if needed
    final currentUnitId = int.tryParse(ingredient["UnitId"]!) ?? 0;

    // Ensure tags is a List<Map<String, String>>
    // If the tags are stored as strings or another structure, map them to the required format.
    List<Map<String, String>> tags = [];
    if (ingredient["Tags"] != null) {
      tags = List<Map<String, String>>.from(ingredient["Tags"].map((tag) {
        return {"tag_name": tag}; // assuming tags are simple strings
      }));
    }

    showDialog(
      context: context,
      builder: (context) {
        return EditIngredientDialog(
          title: 'Update Ingredient',
          hintText: currentName,
          currentName: currentName,
          currentUnit: currentUnit,
          currentUnitId: currentUnitId, // Pass as int if needed
          allIngredientNames:
              _ingredients.map((e) => e["Name"] as String).toList(),
          onConfirm: (inputValue, selectedUnit) async {
            final api = ApiUser();
            try {
              // Call the updateIngredient API
              await api.updateIngredient(
                oldIngredientName: currentName,
                newIngredientName: inputValue,
                unitId: selectedUnit, // Make sure to pass the correct unitId
                tags: tags, // Pass the updated tags
              );
              // Reload the ingredient list after updating
              await _fetchIngredients();
            } catch (e) {
              setState(() {
                _errorMessage = e.toString();
              });
            }
          },
        );
      },
    );
  }

  // Handle Remove button
  void _removeIngredient(int index) async {
    final ingredientName = _ingredients[index]["Name"]!;
    try {
      final api = ApiUser();
      await api.deleteIngredient(
          ingredientName: ingredientName); // Call the delete API
      await _fetchIngredients(); // Reload the ingredient list after deletion
      print("Ingredient deleted: $ingredientName");
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  // Handle Add button and integrate createIngredient API
  Future<void> _addIngredient() async {
    showDialog(
      context: context,
      builder: (context) {
        return EditIngredientDialog(
          title: 'Add Ingredient',
          hintText: 'Enter ingredient name',
          currentName: '',
          currentUnit: 'kg',
          allIngredientNames:
              _ingredients.map((e) => e["Name"] as String).toList(),
          currentUnitId: 3, // Default to 'kg'
          onConfirm: (inputValue, selectedUnitId) async {
            try {
              final api = ApiUser();
              await api.createIngredient(
                ingredientName: inputValue,
                unitId: selectedUnitId,
              );

              // After successful addition, reload the ingredients
              await _fetchIngredients();
            } catch (e) {
              print("Error adding ingredient: $e");
              setState(() {
                _errorMessage = "Failed to add ingredient.";
              });
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text("Error: $_errorMessage"));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double parentWidth = constraints.maxWidth;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: Color.fromARGB(255, 255, 228, 188),
                  child: DataTable(
                    columnSpacing: 20,
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: parentWidth * 0.1,
                          child: Text(
                            "No.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: parentWidth * 0.4,
                          child: Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: parentWidth * 0.08,
                          child: Text(
                            "Unit",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: parentWidth * 0.42,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 20),
                              Text(
                                "Options",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    rows: List.generate(_ingredients.length, (index) {
                      final ingredient = _ingredients[index];
                      return DataRow(cells: [
                        DataCell(Text("${index + 1}")),
                        DataCell(Text(ingredient["Name"]!)),
                        DataCell(Text(ingredient["Unit"]!)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _modifyIngredient(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeIngredient(index),
                            ),
                          ],
                        )),
                      ]);
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addIngredient,
        backgroundColor: Color(0xFFEF9920),
        mini: true, // This makes the button smaller
        shape: CircleBorder(), // Ensures the button remains round
        child: Icon(Icons.add),
      ),
    );
  }
}
