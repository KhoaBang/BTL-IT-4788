import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'groupDetail_page.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/input_dialog.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // Dữ liệu ví dụ cho danh sách các nhóm
  final List<String> managedGroups = [
    "Group A",
    "Group B",
    "Flutter Devs",
    "My Team",
    "Dep trai"
  ];
  final List<String> memberGroups = List.generate(
    100,
    (index) => "Group ${index + 1}",
  ); // Tạo danh sách 100 nhóm để kiểm tra cuộn

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
                          onConfirm: (input) {
                            // Handle the input
                            print('User Input: $input');
                          },
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
                          onConfirm: (input) {
                            // Handle the input
                            print('User Input: $input');
                          },
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
