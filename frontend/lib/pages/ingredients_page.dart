import 'package:flutter/material.dart';
import 'package:frontend/api/ingredient_service.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/notification_box.dart';

class IngredientPage extends StatefulWidget {
  const IngredientPage({Key? key}) : super(key: key);

  @override
  _IngredientPageState createState() => _IngredientPageState();
}

class _IngredientPageState extends State<IngredientPage> {
  final IngredientService _ingredientService = IngredientService();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _ingredientNameController =
      TextEditingController();
  final TextEditingController _unitIdController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  List<dynamic> _ingredients = [];
  List<dynamic> _filteredIngredients = [];

  @override
  void initState() {
    super.initState();
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    try {
      final ingredients = await _ingredientService.getIngredients();
      setState(() {
        _ingredients = ingredients;
        _filteredIngredients = ingredients;
      });
    } catch (e) {
      NotificationBox.show(
          context: context,
          status: 500,
          message: "Failed to fetch ingredients.");
    }
  }

  void _filterIngredients(String query) {
    setState(() {
      _filteredIngredients = _ingredients.where((ingredient) {
        final tags = ingredient['tags'] as List<dynamic>;
        return tags.any((tag) =>
            tag['tag_name'].toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  Future<void> _handleAddIngredient() async {
    final name = _ingredientNameController.text;
    final unitId = int.tryParse(_unitIdController.text);
    final tags = _tagsController.text
        .split(',')
        .map((tag) => {"tag_name": tag.trim()})
        .toList();

    if (name.isEmpty || unitId == null || tags.isEmpty) {
      NotificationBox.show(
          context: context, status: 400, message: "Invalid input data.");
      return;
    }

    try {
      await _ingredientService.addIngredient({
        "ingredient_name": name,
        "unit_id": unitId,
        "tags": tags,
      });
      NotificationBox.show(
          context: context,
          status: 200,
          message: "Ingredient added successfully.");
      _fetchIngredients();
    } catch (e) {
      NotificationBox.show(
          context: context, status: 500, message: "Failed to add ingredient.");
    }
  }

  Future<void> _handleUpdateIngredient(String oldName) async {
    final name = _ingredientNameController.text;
    final unitId = int.tryParse(_unitIdController.text);
    final tags = _tagsController.text
        .split(',')
        .map((tag) => {"tag_name": tag.trim()})
        .toList();

    if (name.isEmpty || unitId == null || tags.isEmpty) {
      NotificationBox.show(
          context: context, status: 400, message: "Invalid input data.");
      return;
    }

    try {
      await _ingredientService.updateIngredient(oldName, {
        "ingredient_name": name,
        "unit_id": unitId,
        "tags": tags,
      });
      NotificationBox.show(
          context: context,
          status: 200,
          message: "Ingredient updated successfully.");
      _fetchIngredients();
    } catch (e) {
      NotificationBox.show(
          context: context,
          status: 500,
          message: "Failed to update ingredient.");
    }
  }

  Future<void> _handleDeleteIngredient(String name) async {
    try {
      await _ingredientService.deleteIngredient(name);
      NotificationBox.show(
          context: context,
          status: 200,
          message: "Ingredient deleted successfully.");
      _fetchIngredients();
    } catch (e) {
      NotificationBox.show(
          context: context,
          status: 500,
          message: "Failed to delete ingredient.");
    }
  }

  void _showInputDialog({String? oldName}) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(oldName == null ? "Add Ingredient" : "Update Ingredient"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _ingredientNameController,
                  decoration: InputDecoration(labelText: "Ingredient Name"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter ingredient name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _unitIdController,
                  decoration: InputDecoration(
                      labelText: "Unit ID (1: cái, 2: g, 3: kg, 4: ml, 5: l)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final number = int.tryParse(value ?? '');
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter unit ID';
                    }
                    if (number == null || number < 1 || number > 5) {
                      return 'Please enter number from 1 to 5';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _tagsController,
                  decoration:
                      InputDecoration(labelText: "Tags (comma separated)"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter tags';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  if (oldName == null) {
                    _handleAddIngredient();
                  } else {
                    _handleUpdateIngredient(oldName);
                  }
                }
              },
              child: Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterIngredients,
              decoration: InputDecoration(
                labelText: "Search by tag",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredIngredients.length,
              itemBuilder: (context, index) {
                final ingredient = _filteredIngredients[index];
                return ListTile(
                  title: Text(ingredient['ingredient_name']),
                  subtitle: Text("Unit: ${ingredient['unit']['unit_name']}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          _ingredientNameController.text =
                              ingredient['ingredient_name'];
                          _unitIdController.text =
                              ingredient['unit']['id'].toString();
                          _tagsController.text = ingredient['tags']
                              .map((tag) => tag['tag_name'])
                              .join(', ');
                          _showInputDialog(
                              oldName: ingredient['ingredient_name']);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _handleDeleteIngredient(
                              ingredient['ingredient_name']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ingredientNameController.clear();
          _unitIdController.clear();
          _tagsController.clear();
          _showInputDialog();
        },
        child: Icon(
          Icons.add,
          color: Color(0xFFEF9920),
        ),
      ),
      bottomNavigationBar: const Footer(currentIndex: 2),
    );
  }
}
