import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/fridge_service.dart';
import 'package:frontend/widgets/create_fridge_dialog.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/notification_box.dart';
import 'package:frontend/widgets/confirmation_dialog.dart';

class FridgePage extends ConsumerStatefulWidget {
  final String groupId;
  final bool isManager;

  const FridgePage({
    Key? key,
    required this.groupId,
    required this.isManager,
  }) : super(key: key);

  @override
  _FridgePageState createState() => _FridgePageState();
}

class _FridgePageState extends ConsumerState<FridgePage> {
  final FridgeService fridgeService = FridgeService();
  List<dynamic> fridge = [];
  List<dynamic> filteredFridge = [];
  bool isLoading = true;
  bool hasError = false;
  final TextEditingController searchController = TextEditingController();

  static const unitMapping = {
    1: "cái",
    2: "g",
    3: "kg",
    4: "ml",
    5: "l",
  };

  @override
  void initState() {
    super.initState();
    _fetchFridge();
  }

  Future<void> _fetchFridge() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final data = await fridgeService.getFridge(widget.groupId);
      setState(() {
        fridge = data;
        filteredFridge = fridge;
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterFridge(String query) {
    setState(() {
      filteredFridge = fridge
          .where((ingredient) => ingredient['ingredient_name']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _performAction(
      Future<void> Function() action, String successMessage) async {
    try {
      await action();
      NotificationBox.show(
        context: context,
        status: 200,
        message: successMessage,
      );
      _fetchFridge();
    } catch (e) {
      NotificationBox.show(
        context: context,
        status: 400,
        message: "Failed!",
      );
    }
  }

  void _addIngredient() async {
    await showDialog(
      context: context,
      builder: (context) => InputDialog(
        groupId: widget.groupId,
        title: 'Add Ingredient',
        confirmText: 'Add',
        cancelText: 'Cancel',
        onConfirm:
            (groupId, ingredientName, unitId, createdAt, quantity) async {
          final parsedUnitId = int.tryParse(unitId.toString()) ?? unitId;
          final formattedDate =
              "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

          await _performAction(
            () => fridgeService.addIngredientToFridge(
              groupId,
              {
                'ingredient_name': ingredientName,
                'unit_id': parsedUnitId,
                'detail': [
                  {
                    'createdAt': formattedDate,
                    'quantity': quantity,
                  },
                ],
              },
            ),
            "Added ingredient successfully!",
          );
        },
      ),
    );
  }

  void _updateIngredient(String oldIngredientName) async {
    await showDialog(
      context: context,
      builder: (context) => InputDialog(
        groupId: widget.groupId,
        title: 'Update Ingredient',
        confirmText: 'Update',
        cancelText: 'Cancel',
        onConfirm:
            (groupId, ingredientName, unitId, createdAt, quantity) async {
          final parsedUnitId = int.tryParse(unitId.toString()) ?? unitId;
          final formattedDate =
              "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

          await _performAction(
            () => fridgeService.updateIngredient(
              groupId,
              oldIngredientName,
              {
                'ingredient_name': ingredientName,
                'unit_id': parsedUnitId,
                'detail': [
                  {
                    'createdAt': formattedDate,
                    'quantity': quantity,
                  },
                ],
              },
            ),
            "Updated ingredient successfully!",
          );
        },
      ),
    );
  }

  void _deleteIngredient(String ingredientName) async {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Delete Ingredient',
        content: 'Are you sure you want to delete "$ingredientName"?',
        confirmText: 'Delete',
        cancelText: 'Cancel',
        onConfirm: () async {
          await _performAction(
            () =>
                fridgeService.deleteIngredient(widget.groupId, ingredientName),
            "Deleted ingredient successfully!",
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Column(
          children: [
            const Header(canGoBack: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: searchController,
                onChanged: _filterFridge,
                decoration: const InputDecoration(
                  labelText: "Search Ingredients",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text('Failed to load fridge. Please try again later.'),
                )
              : filteredFridge.isEmpty
                  ? const Center(child: Text('No ingredients found.'))
                  : ListView.builder(
                      itemCount: filteredFridge.length,
                      itemBuilder: (context, index) {
                        final ingredient = filteredFridge[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(ingredient['ingredient_name']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Unit: ${unitMapping[ingredient['unit_id']] ?? 'Unknown'}'),
                                ...ingredient['detail'].map<Widget>((detail) {
                                  return Text(
                                      'Quantity: ${detail['quantity']}, Date: ${detail['createdAt']}');
                                }).toList(),
                              ],
                            ),
                            trailing: widget.isManager
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        onPressed: () => _updateIngredient(
                                            ingredient['ingredient_name']),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _deleteIngredient(
                                            ingredient['ingredient_name']),
                                      ),
                                    ],
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
      floatingActionButton: widget.isManager
          ? FloatingActionButton(
              onPressed: _addIngredient,
              child: const Icon(Icons.add, color: Color(0xFFEF9920)),
            )
          : null,
      bottomNavigationBar: const Footer(currentIndex: 1),
    );
  }
}
