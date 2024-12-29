import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod for state management
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/popup_menu.dart'; // Import the helper file
import 'shopping_lists_page.dart';
import 'package:frontend/providers/group_provider.dart'; // Import the chosen group provider

class GroupDetailPage extends ConsumerStatefulWidget {
  final String gid; // Group ID passed from the previous page
  final String groupName;
  final String role;
  const GroupDetailPage(
      {super.key,
      required this.gid,
      required this.groupName,
      required this.role});

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends ConsumerState<GroupDetailPage> {
  final GlobalKey _moreIconKey = GlobalKey(); // Global key for the IconButton

  @override
  void initState() {
    super.initState();
    // Select the group when the page is initialized
    ref.read(chosenGroupProvider.notifier).selectGroup(widget.gid);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ChosenGroupState to get the current selected group
    final chosenGroupState = ref.watch(chosenGroupProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(canGoBack: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container containing group name and more icon
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFEF9920), // Orange border
                  width: 1, // Border width
                ),
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Display group name (or loading if the group isn't loaded yet)
                  Text(
                    widget.groupName,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF010F07),
                    ),
                  ),
                  // More options icon
                  IconButton(
                    key: _moreIconKey, // GlobalKey for the more icon
                    icon: const Icon(
                      Icons.more_horiz, // Three dots icon
                      color: Color(0xFFC1B9B9),
                    ),
                    onPressed: () {
                      showAddMenu(context, _moreIconKey, widget.gid,
                          widget.role, ref); // Call the helper function
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 32), // Space between containers and feature boxes
            // Feature boxes
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFeatureBox(
                      "Fridge", ShoppingListPage()), // Navigate to FridgePage
                  const SizedBox(height: 30),
                  _buildFeatureBox("Shopping",
                      ShoppingListPage()), // Navigate to ShoppingPage
                  const SizedBox(height: 30),
                  _buildFeatureBox(
                      "Meals", ShoppingListPage()), // Navigate to MealsPage
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Footer(currentIndex: -1), // Footer without active item
    );
  }

  // Widget to create feature box with title and destination page
  Widget _buildFeatureBox(String title, Widget destinationPage) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destinationPage),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        width: double.infinity, // Full width
        decoration: BoxDecoration(
          color: Color(0xFFEF9920), // Orange background
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // White text color
            ),
          ),
        ),
      ),
    );
  }
}
