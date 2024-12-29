import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/input_dialog.dart';
import 'widgets/list_section.dart';
import 'widgets/list_section_noicon.dart';
import 'shopping_list_details_page.dart';
import 'package:frontend/providers/shopping_provider.dart';

class ShoppingListPage extends ConsumerWidget {
  final String gid;
  const ShoppingListPage({super.key, required this.gid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the shopping list state
    final shoppingLists = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(
          canGoBack: true,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your Shopping Lists",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Oxygen',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                ListSection(
                  title: "Personal Lists",
                  lists: shoppingLists
                      .where((list) => list.status == 'personal')
                      .map((list) => {
                            'name': list.name,
                            'date': list.createdAt.toIso8601String(),
                          })
                      .toList(),
                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return InputDialog(
                          title: 'Create new shopping list',
                          hintText: 'Type list name here',
                          confirmText: 'Create',
                          cancelText: 'Cancel',
                          onConfirm: (input) async {
                            final success = await ref
                                .read(shoppingListProvider.notifier)
                                .addShoppingList(gid, input);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('List created!')),
                              );
                            }
                          },
                        );
                      },
                    );
                  },
                  onItemTap: (list) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ShoppingListDetailPage(
                    //       listName: list['name']!,
                    //     ),
                    //   ),
                    // );
                  },
                ),
                SizedBox(height: 32),
                ListSectionNoicon(
                  title: "Shared Lists",
                  lists: shoppingLists
                      .where((list) => list.status == 'shared')
                      .map((list) => {
                            'name': list.name,
                            'date': list.createdAt.toIso8601String(),
                          })
                      .toList(),
                  onItemTap: (list) {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ShoppingListDetailPage(
                    //       listName: list['name']!,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
          Footer(currentIndex: -1),
        ],
      ),
    );
  }
}
