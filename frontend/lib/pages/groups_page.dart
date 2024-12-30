import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/group_provider.dart';
import 'package:frontend/widgets/header.dart';
import 'package:frontend/widgets/footer.dart';
import 'package:frontend/widgets/input_dialog.dart';
import 'package:frontend/models/group_state.dart';
import 'package:frontend/pages/groupDetail_page.dart';

// Define groupsFutureProvider at the global scope
final groupsFutureProvider = FutureProvider<void>((ref) async {
  final groupNotifier = ref.read(groupListProvider.notifier);
  await groupNotifier.getGroups();
});

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accessing the state of the groups
    final groupState =
        ref.watch(groupListProvider); // GroupListState from Riverpod
    final groupNotifier =
        ref.read(groupListProvider.notifier); // Accessing the notifier

    // Watch the groupsFutureProvider to trigger data fetching
    final groupsFetch = ref.watch(groupsFutureProvider);
    print(groupsFetch);
    Future<void> _createGroup(String groupName) async {
      try {
        // Using the GroupNotifier to create a group and refresh the list
        await groupNotifier.createGroup(groupName);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Group created successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create group: $e')),
        );
      }
    }

    Future<void> _joinGroup(String groupCode) async {
      try {
        // Using the GroupNotifier to join a group and refresh the list
        await groupNotifier.joinGroup(groupCode);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Joined group successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join group: $e')),
        );
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Header(), // Custom header widget
      ),
      body: groupsFetch.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (_) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Groups",
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
                  _buildGroupSection(
                    context: context,
                    title: "Manager of",
                    groups: groupState.managerOf,
                    onAdd: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return InputDialog(
                            title: 'Create new group',
                            hintText: 'Type group name here',
                            confirmText: 'Create',
                            cancelText: 'Cancel',
                            onConfirm: (input) => _createGroup(input),
                          );
                        },
                      );
                    },
                    role: 'manager',
                  ),
                  SizedBox(height: 32),
                  _buildGroupSection(
                    context: context,
                    title: "Member of",
                    groups: groupState.memberOf,
                    onAdd: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return InputDialog(
                            title: 'Join a group',
                            hintText: 'Type group code here',
                            confirmText: 'Join',
                            cancelText: 'Cancel',
                            onConfirm: (input) => _joinGroup(input),
                          );
                        },
                      );
                    },
                    role: 'member',
                  ),
                ],
              ),
            ),
            Footer(currentIndex: 1), // Footer widget
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection({
    required BuildContext context,
    required String title,
    required List<Group> groups,
    required VoidCallback onAdd,
    required String role,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Color(0xFFEF9920),
                    fontSize: 20,
                    fontFamily: 'Oxygen',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Expanded(
                child: Divider(
                  color: Color(0xFFEF9920),
                  thickness: 1,
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                onTap: onAdd,
                child: Icon(
                  Icons.add,
                  color: Color(0xFFEF9920),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              children: groups.map((group) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDetailPage(
                            gid: group.gid,
                            groupName: group.groupName,
                            role: role),
                      ),
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      group.groupName,
                      style: TextStyle(
                        color: Color(0xFF010F07),
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
