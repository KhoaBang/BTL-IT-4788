// import 'package:flutter/material.dart';
// import 'package:frontend/api/recipe_service.dart';
// import 'package:frontend/pages/widgets/header.dart';
// import 'package:frontend/pages/widgets/footer.dart';
// import 'package:frontend/pages/widgets/notification_box.dart';
// import 'dart:convert';

// class RecipePage extends StatefulWidget {
//   const RecipePage({Key? key}) : super(key: key);

//   @override
//   _RecipePageState createState() => _RecipePageState();
// }

// class _RecipePageState extends State<RecipePage> {
//   final RecipeService _recipeService = RecipeService();
//   List<Map<String, dynamic>> recipes = [];
//   List<Map<String, dynamic>> filteredRecipes = [];
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchRecipes();
//   }

//   Future<void> fetchRecipes() async {
//     try {
//       final data = await _recipeService.getAllRecipes();
//       setState(() {
//         recipes = (data as List)
//             .map((recipe) => {
//                   'name': recipe['name'] ?? '',
//                   'description': recipe['description'] ?? '',
//                   'prep_time_minutes': recipe['prep_time_minutes'] ?? 0,
//                   'cook_time_minutes': recipe['cook_time_minutes'] ?? 0,
//                   'servings': recipe['servings'] ?? 0,
//                   'ingredients': recipe['ingredients'] ?? [],
//                   'steps': recipe['steps'] ?? [],
//                   'notes': recipe['notes'] ?? '',
//                 })
//             .toList();
//         filteredRecipes = recipes;
//       });
//     } catch (error) {
//       NotificationBox.show(
//         context: context,
//         status: 500,
//         message: 'Failed to fetch recipes!',
//       );
//     }
//   }

//   void filterRecipes(String query) {
//     setState(() {
//       filteredRecipes = recipes
//           .where((recipe) =>
//               recipe['name'].toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   TextEditingController createController(String? initialValue) {
//     return TextEditingController(text: initialValue ?? '');
//   }

//   void showRecipeDetails(Map<String, dynamic> recipe) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(recipe['name']),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Description: ${recipe['description']}'),
//                 Text('Prep Time: ${recipe['prep_time_minutes']} mins'),
//                 Text('Cook Time: ${recipe['cook_time_minutes']} mins'),
//                 Text('Servings: ${recipe['servings']}'),
//                 Text('Ingredients:'),
//                 for (var ingredient in recipe['ingredients'])
//                   Text(
//                       '- ${ingredient['ingredient_name']}, ${ingredient['quantity']} ${ingredient['unit_id']}'),
//                 Text('Steps:'),
//                 for (var step in recipe['steps']) Text('- $step'),
//                 Text('Notes: ${recipe['notes']}'),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void showAddOrUpdateDialog({Map<String, dynamic>? recipe}) {
//     final nameController = createController(recipe?['name'] ?? '');
//     final descriptionController =
//         createController(recipe?['description'] ?? '');
//     final prepTimeController =
//         createController((recipe?['prep_time_minutes'] ?? '').toString());
//     final cookTimeController =
//         createController((recipe?['cook_time_minutes'] ?? '').toString());
//     final servingsController =
//         createController((recipe?['servings'] ?? '').toString());
//     final ingredientsController = createController(
//         recipe != null && recipe['ingredients'] != null
//             ? jsonEncode(recipe['ingredients'])
//             : '');
//     final stepsController = createController(
//         recipe != null && recipe['steps'] != null
//             ? (recipe['steps'] as List).join(',')
//             : '');
//     final notesController = createController(recipe?['notes'] ?? '');

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(recipe == null ? 'Add Recipe' : 'Update Recipe'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(labelText: 'Name'),
//                 ),
//                 TextField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Description'),
//                 ),
//                 TextField(
//                   controller: prepTimeController,
//                   decoration: InputDecoration(labelText: 'Prep Time (mins)'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: cookTimeController,
//                   decoration: InputDecoration(labelText: 'Cook Time (mins)'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: servingsController,
//                   decoration: InputDecoration(labelText: 'Servings'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: ingredientsController,
//                   decoration: InputDecoration(labelText: 'Ingredients (JSON)'),
//                 ),
//                 TextField(
//                   controller: stepsController,
//                   decoration:
//                       InputDecoration(labelText: 'Steps (comma-separated)'),
//                 ),
//                 TextField(
//                   controller: notesController,
//                   decoration: InputDecoration(labelText: 'Notes'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () async {
//                 try {
//                   final ingredientsText = ingredientsController.text.isNotEmpty
//                       ? jsonDecode(ingredientsController.text)
//                       : [];

//                   final ingredients = ingredientsText is List
//                       ? List<Map<String, dynamic>>.from(ingredientsText)
//                       : [];

//                   final steps = stepsController.text.isNotEmpty
//                       ? stepsController.text.split(',')
//                       : [];

//                   final data = {
//                     'name': nameController.text,
//                     'description': descriptionController.text,
//                     'prep_time_minutes': int.parse(prepTimeController.text),
//                     'cook_time_minutes': int.parse(cookTimeController.text),
//                     'servings': int.parse(servingsController.text),
//                     'ingredients': ingredients,
//                     'steps': steps,
//                     'notes': notesController.text,
//                   };

//                   if (recipe == null) {
//                     await _recipeService.addRecipe(data);
//                   } else {
//                     await _recipeService.updateRecipe(recipe['name'], data);
//                   }

//                   Navigator.pop(context);
//                   fetchRecipes();
//                   NotificationBox.show(
//                     context: context,
//                     status: 200,
//                     message: recipe == null
//                         ? 'Recipe added successfully!'
//                         : 'Recipe updated successfully!',
//                   );
//                 } catch (error) {
//                   debugPrint('Error saving recipe: $error');
//                   NotificationBox.show(
//                     context: context,
//                     status: 500,
//                     message: 'Failed to save recipe!',
//                   );
//                 }
//               },
//               child: Text(recipe == null ? 'Add' : 'Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60),
//         child: Header(),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               onChanged: filterRecipes,
//               decoration: InputDecoration(
//                 labelText: 'Search Recipes',
//                 border: OutlineInputBorder(),
//                 suffixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredRecipes.length,
//               itemBuilder: (context, index) {
//                 final recipe = filteredRecipes[index];
//                 return Card(
//                   margin: EdgeInsets.all(8.0),
//                   child: ListTile(
//                     title: Text(recipe['name']),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: Icon(Icons.edit),
//                           onPressed: () =>
//                               showAddOrUpdateDialog(recipe: recipe),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () async {
//                             try {
//                               await _recipeService.deleteRecipe(recipe['name']);
//                               fetchRecipes();
//                               NotificationBox.show(
//                                 context: context,
//                                 status: 200,
//                                 message: 'Recipe deleted successfully!',
//                               );
//                             } catch (error) {
//                               NotificationBox.show(
//                                 context: context,
//                                 status: 500,
//                                 message: 'Failed to delete recipe!',
//                               );
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                     onTap: () => showRecipeDetails(recipe),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showAddOrUpdateDialog(),
//         child: Icon(Icons.add),
//       ),
//       bottomNavigationBar: const Footer(currentIndex: 3),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:frontend/api/recipe_service.dart';
import 'package:frontend/pages/widgets/header.dart';
import 'package:frontend/pages/widgets/footer.dart';
import 'package:frontend/pages/widgets/notification_box.dart';
import 'dart:convert';

class RecipePage extends StatefulWidget {
  const RecipePage({Key? key}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final RecipeService _recipeService = RecipeService();
  List<Map<String, dynamic>> recipes = [];
  List<Map<String, dynamic>> filteredRecipes = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  // Future<void> fetchRecipes() async {
  //   try {
  //     final data = await _recipeService.getAllRecipes();
  //     setState(() {
  //       recipes = (data as List)
  //           .map((recipe) => {
  //                 'name': recipe['name'] ?? '',
  //                 'description': recipe['description'] ?? '',
  //                 'prep_time_minutes': recipe['prep_time_minutes'] ?? 0,
  //                 'cook_time_minutes': recipe['cook_time_minutes'] ?? 0,
  //                 'servings': recipe['servings'] ?? 0,
  //                 'ingredients': recipe['ingredients'] ?? [],
  //                 'steps': recipe['steps'] ?? [],
  //                 'notes': recipe['notes'] ?? '',
  //               })
  //           .toList();
  //       filteredRecipes = recipes;
  //     });
  //   } catch (error) {
  //     NotificationBox.show(
  //       context: context,
  //       status: 500,
  //       message: 'Failed to fetch recipes!',
  //     );
  //   }
  // }

  Future<void> fetchRecipes() async {
    try {
      // Gọi API để lấy danh sách recipes (với đầy đủ thông tin).
      final response = await _recipeService.getAllRecipes();
      if (response != null) {
        // Nếu API trả về danh sách recipes với tên, thực hiện lấy thêm chi tiết từng recipe.
        final List<Map<String, dynamic>> fullRecipes = [];
        for (var recipe in response) {
          // Gọi API để lấy thông tin chi tiết của từng recipe bằng tên.
          final recipeDetails =
              await _recipeService.getRecipeDetails(recipe['recipe_name']);
          fullRecipes.add(recipeDetails);
        }

        setState(() {
          recipes = fullRecipes; // Cập nhật danh sách recipes đầy đủ.
          filteredRecipes = fullRecipes; // Cập nhật danh sách hiển thị.
        });
      }
    } catch (error) {
      debugPrint('Error fetching recipes: $error');
      NotificationBox.show(
        context: context,
        status: 500,
        message: 'Failed to fetch recipes!',
      );
    }
  }

  void filterRecipes(String query) {
    setState(() {
      filteredRecipes = recipes
          .where((recipe) =>
              recipe['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void showRecipeDetails(Map<String, dynamic> recipe) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(recipe['name']),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${recipe['description']}'),
                Text('Prep Time: ${recipe['prep_time_minutes']} mins'),
                Text('Cook Time: ${recipe['cook_time_minutes']} mins'),
                Text('Servings: ${recipe['servings']}'),
                Text('Ingredients:'),
                for (var ingredient in recipe['ingredients'])
                  Text(
                      '- ${ingredient['ingredient_name']}, ${ingredient['quantity']} ${ingredient['unit_id']}'),
                Text('Steps:'),
                for (var step in recipe['steps']) Text('- $step'),
                Text('Notes: ${recipe['notes']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void showAddOrUpdateDialog({Map<String, dynamic>? recipe}) {
    final nameController = TextEditingController(text: recipe?['name'] ?? '');
    final descriptionController =
        TextEditingController(text: recipe?['description'] ?? '');
    final prepTimeController = TextEditingController(
        text: (recipe?['prep_time_minutes'] ?? '').toString());
    final cookTimeController = TextEditingController(
        text: (recipe?['cook_time_minutes'] ?? '').toString());
    final servingsController =
        TextEditingController(text: (recipe?['servings'] ?? '').toString());
    final ingredientsController = TextEditingController(
        text: recipe != null && recipe['ingredients'] != null
            ? jsonEncode(recipe['ingredients'])
            : '');
    final stepsController = TextEditingController(
        text: recipe != null && recipe['steps'] != null
            ? (recipe['steps'] as List).join(',')
            : '');
    final notesController = TextEditingController(text: recipe?['notes'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(recipe == null ? 'Add Recipe' : 'Update Recipe'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: prepTimeController,
                  decoration:
                      const InputDecoration(labelText: 'Prep Time (mins)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: cookTimeController,
                  decoration:
                      const InputDecoration(labelText: 'Cook Time (mins)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: servingsController,
                  decoration: const InputDecoration(labelText: 'Servings'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: ingredientsController,
                  decoration:
                      const InputDecoration(labelText: 'Ingredients (JSON)'),
                ),
                TextField(
                  controller: stepsController,
                  decoration: const InputDecoration(
                      labelText: 'Steps (comma-separated)'),
                ),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final ingredients = jsonDecode(ingredientsController.text);
                  final steps = stepsController.text.split(',');

                  final data = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'prep_time_minutes':
                        int.tryParse(prepTimeController.text) ?? 0,
                    'cook_time_minutes':
                        int.tryParse(cookTimeController.text) ?? 0,
                    'servings': int.tryParse(servingsController.text) ?? 0,
                    'ingredients': ingredients,
                    'steps': steps,
                    'notes': notesController.text,
                  };

                  if (recipe == null) {
                    await _recipeService.addRecipe(data);
                  } else {
                    await _recipeService.updateRecipe(recipe['name'], data);
                  }

                  Navigator.pop(context);
                  fetchRecipes();
                  NotificationBox.show(
                    context: context,
                    status: 200,
                    message: recipe == null
                        ? 'Recipe added successfully!'
                        : 'Recipe updated successfully!',
                  );
                } catch (error) {
                  NotificationBox.show(
                    context: context,
                    status: 500,
                    message: 'Failed to save recipe!',
                  );
                }
              },
              child: Text(recipe == null ? 'Add' : 'Update'),
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
        preferredSize: const Size.fromHeight(60),
        child: const Header(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterRecipes,
              decoration: const InputDecoration(
                labelText: 'Search Recipes',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(recipe['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              showAddOrUpdateDialog(recipe: recipe),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            try {
                              await _recipeService.deleteRecipe(recipe['name']);
                              fetchRecipes();
                            } catch (error) {
                              NotificationBox.show(
                                context: context,
                                status: 500,
                                message: 'Failed to delete recipe!',
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    onTap: () => showRecipeDetails(recipe),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddOrUpdateDialog(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const Footer(currentIndex: 3),
    );
  }
}
