import 'package:flutter/material.dart';
import 'widgets/header.dart';
import 'widgets/footer.dart';

class GroupDetailPage extends StatelessWidget {
  final String groupName; // Tên nhóm được truyền từ trang groups_page.dart

  const GroupDetailPage({super.key, required this.groupName});

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
                    groupName, // Lấy tên nhóm từ tham số
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF010F07),
                    ),
                  ),
                  // Icon 3 chấm căn phải
                  const Icon(
                    Icons.more_horiz, // Biểu tượng 3 chấm
                    color: Color(0xFFC1B9B9),
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
                  _buildFeatureBox("Fridge"),
                  const SizedBox(height: 30), // Khoảng cách giữa các box
                  _buildFeatureBox("Shopping"),
                  const SizedBox(height: 30), // Khoảng cách giữa các box
                  _buildFeatureBox("Meals"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(currentIndex: -1), // Footer không active mục nào
    );
  }

  // Widget tạo box với nội dung truyền vào
  Widget _buildFeatureBox(String title) {
    return Container(
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
    );
  }
}
