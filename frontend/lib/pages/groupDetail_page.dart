import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';
import 'widgets/popup_menu.dart'; // Import the helper file
import 'shopping_lists_page.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupName; // Tên nhóm được truyền từ trang groups_page.dart

  const GroupDetailPage({super.key, required this.groupName});

  @override
  _GroupDetailPageState createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final GlobalKey _moreIconKey = GlobalKey(); // Global key for the IconButton

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        canGoBack: true, // Back quay lại trang groups_page.dart
        onChangeProfile: () {
          print('Change profile selected');
        },
        onLogout: () {
          print('Logout selected');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container chứa tên nhóm và icon "more"
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFEF9920), // Viền màu cam
                  width: 1, // Độ dày viền
                ),
                borderRadius: BorderRadius.circular(20), // Bo góc
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tên nhóm căn trái
                  Text(
                    widget.groupName, // Lấy tên nhóm từ tham số
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF010F07),
                    ),
                  ),
                  // Icon 3 chấm căn phải
                  IconButton(
                    key: _moreIconKey, // Set the GlobalKey here
                    icon: const Icon(
                      Icons.more_horiz, // Biểu tượng 3 chấm
                      color: Color(0xFFC1B9B9),
                    ),
                    onPressed: () {
                      showAddMenu(
                          context, _moreIconKey); // Call the helper function
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32), // Khoảng cách giữa container và các box
            // 3 box căn giữa
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
            )
          ],
        ),
      ),
      bottomNavigationBar:
          Footer(currentIndex: -1), // Footer không active mục nào
    );
  }

  // Widget tạo box với nội dung truyền vào và hỗ trợ điều hướng
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
        width: double.infinity, // Độ rộng box chiếm toàn bộ màn hình
        decoration: BoxDecoration(
          color: Color(0xFFEF9920), // Nền màu cam
          borderRadius: BorderRadius.circular(20), // Bo góc
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Màu chữ trắng
            ),
          ),
        ),
      ),
    );
  }
}
