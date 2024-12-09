import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'groupDetail_page.dart';
import 'widgets/input_dialog.dart';
import 'package:frontend/api/api_service.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  List<String> managedGroups = [];
  List<String> memberGroups = [];
  final ApiService apiService = ApiService();

  void _createGroup(String groupName) async {
    try {
      final groupData = await apiService.createGroup(groupName);
      setState(() {
        managedGroups.add(groupData['group_name']);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Group created successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create group: $e')),
      );
    }
  }

  void _joinGroup(String groupCode) async {
    try {
      final groupDetail = await apiService
          .joinGroup(groupCode); // Lấy thông tin nhóm sau khi tham gia

      setState(() {
        memberGroups
            .add(groupDetail['name']); // Thêm tên nhóm thực tế vào danh sách
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined group successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join group: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        canGoBack: false, // Có nút Back
        onChangeProfile: () {
          print('Change profile selected');
        },
        onLogout: () {
          print('Logout selected');
        },
      ),
      body: Column(
        children: [
          // Tiêu đề "Your Groups" căn trái
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
            // Thêm ListView để cho phép cuộn danh sách các nhóm
            child: ListView(
              children: [
                // Danh sách nhóm "Manager of"
                _buildGroupSection(
                  title: "Manager of",
                  groups: managedGroups,
                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (context) {
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
                // Danh sách nhóm "Member of"
                _buildGroupSection(
                  title: "Member of",
                  groups: memberGroups,
                  onAdd: () {
                    showDialog(
                      context: context,
                      builder: (context) {
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
          Footer(currentIndex: 1), // Đặt currentIndex là 1 (GroupsPage)
        ],
      ),
    );
  }

  Widget _buildGroupSection({
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
                  fontWeight: FontWeight.bold,
                ),
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
          // Cho phép cuộn danh sách nhóm trong mỗi phần
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
