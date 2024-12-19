import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';
import 'edit_ingredient_dialog.dart';

class IngredientsTable extends StatefulWidget {
  @override
  _IngredientsTableState createState() => _IngredientsTableState();
}

class _IngredientsTableState extends State<IngredientsTable> {
  // Sample data for ingredients
  final List<Map<String, String>> _ingredients = [
    {"Name": "Flour", "Unit": "kg"},
    {"Name": "Sugar", "Unit": "gr"},
    {"Name": "Butter", "Unit": "gr"},
  ];

  // Handle Modify button
  void _modifyIngredient(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return EditIngredientDialog(
          title: 'Edit Ingredient',
          hintText: 'Enter ingredient name',
          currentName: _ingredients[index]["Name"]!,
          currentUnit: _ingredients[index]["Unit"]!,
          onConfirm: (inputValue, selectedUnit) {
            setState(() {
              _ingredients[index]["Name"] = inputValue;
              _ingredients[index]["Unit"] = selectedUnit;
            });
            print('Ingredient updated: ${_ingredients[index]}');
          },
        );
      },
    );
  }

  // Handle Remove button
  void _removeIngredient(int index) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: 'Delete Ingredient',
          content: 'Are you sure you want to delete this ingredient?',
          confirmText: 'Delete',
          cancelText: 'Cancel',
          onConfirm: () {
            setState(() {
              _ingredients.removeAt(index);
            });
            Navigator.of(context).pop();
            print("Removed ingredient at index: $index");
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ingredients List"),
      ),
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
    );
  }
}
