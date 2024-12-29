import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/list_section.dart';
import 'widgets/input_dialog.dart';
import 'package:frontend/providers/shopping_provider.dart';

class ShoppingListDetailPage extends ConsumerWidget {
  final String listName;

  const ShoppingListDetailPage({Key? key, required this.listName})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
    // // Access the provider to fetch items for this specific list
    // final items = ref
    //     .watch(shoppingListProvider)
    //     .where((list) => list.name == listName)
    //     .first
    //     .items;

    // return Scaffold(
    //   appBar: PreferredSize(
    //     preferredSize: Size.fromHeight(60),
    //     child: Header(
    //       canGoBack: true,
    //     ),
    //   ),
    //   body: Column(
    //     children: [
    //       // Page Title
    //       Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: Align(
    //           alignment: Alignment.centerLeft,
    //           child: Text(
    //             "$listName Details",
    //             style: TextStyle(
    //               color: Colors.black,
    //               fontSize: 24,
    //               fontFamily: 'Oxygen',
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //         ),
    //       ),
    //       SizedBox(height: 8),
    //       Expanded(
    //         child: ListSection(
    //           title: "Items in $listName",
    //           lists: items
    //               .map((item) =>
    //                   {'name': item.name, 'date': item.date.toIso8601String()})
    //               .toList(),
    //           onAdd: () {
    //             // Add new items to the list
    //             showDialog(
    //               context: context,
    //               builder: (context) {
    //                 return InputDialog(
    //                   title: 'Add new item',
    //                   hintText: 'Type item name here',
    //                   confirmText: 'Add',
    //                   cancelText: 'Cancel',
    //                   onConfirm: (input) async {
    //                     final success = await ref
    //                         .read(shoppingListProvider.notifier)
    //                         .addItemToList(listName, input);
    //                     if (success) {
    //                       ScaffoldMessenger.of(context).showSnackBar(
    //                         SnackBar(content: Text('Item added!')),
    //                       );
    //                     }
    //                   },
    //                 );
    //               },
    //             );
    //           },
    //           onItemTap: (item) {
    //             print('Tapped on item: $item');
    //             // Handle item tap (e.g., show details or edit item)
    //           },
    //         ),
    //       ),
    //       Footer(currentIndex: 0), // Update index to match detail page
    //     ],
    //   ),
    // );
  }
}
