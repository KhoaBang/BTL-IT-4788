import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/api/group_provider.dart';
import 'package:frontend/api/api_service.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/input_dialog.dart';
import 'groupDetail_page.dart';
// import 'package:frontend/api/auth_provider.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupState = ref.watch(groupProvider);
    final groupNotifier = ref.read(groupProvider.notifier);
    final apiService = ApiService();
    // final authNotifier = ref.read(authProvider.notifier);

    Future<void> _createGroup(String groupName) async {
      try {
        final groupData = await apiService.createGroup(groupName);
        await groupNotifier.createGroup(groupData['group_name']);
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
        final groupDetail = await apiService.joinGroup(groupCode);
        await groupNotifier.joinGroup(groupDetail['name']);
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
        child: Header(
          //canGoBack: false,
        ),
      ),
      body: Column(
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
                  context: context, // Truyền context từ đây
                  title: "Manager of",
                  groups: groupState.managedGroups,
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
                ),
                SizedBox(height: 32),
                _buildGroupSection(
                  context: context, // Truyền context từ đây
                  title: "Member of",
                  groups: groupState.memberGroups,
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
                ),
              ],
            ),
          ),
          Footer(currentIndex: 1),
        ],
      ),
    );
  }

  Widget _buildGroupSection({
    required BuildContext context,
    required String title,
    required List<String> groups,
    required VoidCallback onAdd,
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
              // Spacer(),
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
            height: 200, // Chiều cao cố định cho từng phần danh sách nhóm
            child: ListView(
              children: groups.map((group) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDetailPage(groupName: group),
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
                      group,
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
//           ...groups.map((group) {
//             return GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context, // Sử dụng context đã được truyền vào
//                   MaterialPageRoute(
//                     builder: (buildContext) =>
//                         GroupDetailPage(groupName: group),
//                   ),
//                 );
//               },
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//                 margin: const EdgeInsets.only(bottom: 8),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFF1F1F1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(group),
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
