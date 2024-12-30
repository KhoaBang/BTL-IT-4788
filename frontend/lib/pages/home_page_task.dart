import 'package:flutter/material.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/api/shopping_service.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/header.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late Future<List<dynamic>> _tasksFuture;
  final ShoppingService _shoppingService = ShoppingService();

  // Mapping unit_id to unit name
  final Map<int, String> unitMapping = {
    1: "cái",
    2: "g",
    3: "kg",
    4: "ml",
    5: "l",
  };

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch tasks
    _tasksFuture = UserService().getTasksWithShoppingLists();
  }

  String getUnitName(int unitId) {
    return unitMapping[unitId] ?? "Unknown unit";
  }

  // Fetch shopping list by ID
  Future<String> getShoppingListName(String groupId, String shoppingId) async {
    var shoppingList =
        await _shoppingService.getShoppingListById(groupId, shoppingId);
    if (shoppingList != null && shoppingList.containsKey('name')) {
      return shoppingList['name'];
    } else {
      return 'Unknown shopping list';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your pending tasks',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading spinner while waiting for data
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Show an error message if fetching fails
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  // Handle case when no data is available
                  return const Center(child: Text('No tasks available.'));
                } else {
                  // Render the list of tasks
                  final tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      final unitName = getUnitName(task['unit_id']);
                      final shoppingLists =
                          task['shopping_list'] as List<dynamic>;

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingredient: ${task['ingredient_name']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Status: ${task['status']}',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Quantity: ${task['quantity']} $unitName'),
                              const SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shopping Lists:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // Display only the first shopping list name on the right
                                  FutureBuilder<String>(
                                    future: getShoppingListName(
                                        shoppingLists[0]['GID'],
                                        shoppingLists[0]['shopping_id']),
                                    builder: (context, shoppingListSnapshot) {
                                      if (shoppingListSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (shoppingListSnapshot
                                          .hasError) {
                                        return Text(
                                            'Error: ${shoppingListSnapshot.error}');
                                      } else if (shoppingListSnapshot.hasData) {
                                        return Text(shoppingListSnapshot.data ??
                                            'Unknown shopping list');
                                      } else {
                                        return const Text(
                                            'Unknown shopping list');
                                      }
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: 0,
      ),
    );
  }
}
