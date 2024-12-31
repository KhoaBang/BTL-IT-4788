import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/meal_service.dart';
import 'package:frontend/widgets/create_meal_dialog.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/notification_box.dart';

class MealPage extends ConsumerStatefulWidget {
  final String groupId;
  final bool isManager;

  const MealPage({
    Key? key,
    required this.groupId,
    required this.isManager,
  }) : super(key: key);

  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends ConsumerState<MealPage> {
  final MealService mealService = MealService();
  List<dynamic> meals = [];
  List<dynamic> filteredMeals = [];
  bool isLoading = true;
  bool hasError = false;
  final TextEditingController searchController = TextEditingController();

  // Static unit mapping to display units properly
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
    _fetchMeals();
  }

  Future<void> _fetchMeals() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });
    try {
      final data = await mealService.getAllMeals(widget.groupId);
      setState(() {
        meals = data;
        filteredMeals = meals;
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

  void _filterMeals(String query) {
    setState(() {
      filteredMeals = meals
          .where((meal) =>
              meal['meal_name'].toLowerCase().contains(query.toLowerCase()))
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
      _fetchMeals();
    } catch (e) {
      NotificationBox.show(
        context: context,
        status: 400,
        message: "Error: ${e.toString()}",
      );
    }
  }

  void _addMeal() async {
    await showDialog(
      context: context,
      builder: (context) => CreateMealDialog(
        groupId: widget.groupId,
        title: 'Add Meal',
        confirmText: 'Add',
        cancelText: 'Cancel',
        onConfirm: (groupId, mealName, consumeDate, ingredientList) async {
          await _performAction(
            () => mealService.createMeal(
              groupId,
              {
                'meal_name': mealName,
                'consume_date': consumeDate.toIso8601String(),
                'ingredient_list': ingredientList,
              },
            ),
            "Meal added successfully!",
          );
        },
      ),
    );
  }

  void _editMeal(dynamic meal) async {
    // Pre-fill the dialog with the existing meal data
    await showDialog(
      context: context,
      builder: (context) => CreateMealDialog(
        groupId: widget.groupId,
        title: 'Edit Meal',
        confirmText: 'Save',
        cancelText: 'Cancel',
        // Pre-fill the data
        initialMealName: meal['meal_name'],
        initialConsumeDate: DateTime.parse(meal['consume_date']),
        initialIngredients:
            List<Map<String, dynamic>>.from(meal['ingredient_list']),
        onConfirm: (groupId, mealName, consumeDate, ingredientList) async {
          // Update the meal
          await _performAction(
            () => mealService.updateMeal(
              groupId,
              meal['meal_id'],
              {
                'meal_name': mealName,
                'consume_date': consumeDate.toIso8601String(),
                'ingredient_list': ingredientList,
              },
            ),
            "Meal updated successfully!",
          );
        },
      ),
    );
  }

  void _deleteMeal(String mealId) async {
    await _performAction(
      () => mealService.deleteMeal(widget.groupId, mealId),
      "Deleted ingredient successfully!",
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
                onChanged: _filterMeals,
                decoration: const InputDecoration(
                  labelText: "Search Meals",
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
                  child: Text('Failed to load meals. Please try again later.'),
                )
              : filteredMeals.isEmpty
                  ? const Center(child: Text('No meals found.'))
                  : ListView.builder(
                      itemCount: filteredMeals.length,
                      itemBuilder: (context, index) {
                        final meal = filteredMeals[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ExpansionTile(
                            title: Text(meal['meal_name']),
                            subtitle: Text(
                              'Consume Date: ${meal['consume_date'] ?? 'N/A'}',
                            ),
                            children: [
                              ...(meal['ingredient_list'] as List<dynamic>)
                                  .map((ingredient) {
                                return ListTile(
                                  title: Text(ingredient['ingredient_name']),
                                  subtitle: Text(
                                    'Quantity: ${ingredient['quantity']} ${unitMapping[ingredient['unit_id']] ?? 'Unknown'}',
                                  ),
                                );
                              }).toList(),
                              if (widget.isManager)
                                OverflowBar(
                                  alignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () => _editMeal(meal),
                                      child: const Text("Edit"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          _deleteMeal(meal['meal_id']),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    ),
      floatingActionButton: widget.isManager
          ? FloatingActionButton(
              onPressed: _addMeal,
              child: const Icon(Icons.add, color: Color(0xFFEF9920)),
            )
          : null,
      bottomNavigationBar: const Footer(currentIndex: 1),
    );
  }
}
