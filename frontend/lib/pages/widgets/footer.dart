import 'package:flutter/material.dart';
import '../home_page.dart'; // Thay bằng đường dẫn chính xác tới HomePage
import '../groups_page.dart'; // Thay bằng đường dẫn chính xác tới GroupsPage
import '../ingredients_page.dart';
// import '../recipe_page.dart';

class Footer extends StatefulWidget {
  final int currentIndex; // Index của trang hiện tại
  const Footer({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  void _onItemTapped(int index) {
    if (index == widget.currentIndex)
      return; // Nếu đang ở trang này, không điều hướng nữa

    // Điều hướng tới các trang tương ứng
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroupsPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IngredientPage()),
        );
        break;
      // case 3:
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => RecipePage()),
      //   );
      //   break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _footerItems = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.group, 'label': 'Groups'},
      {'icon': Icons.food_bank, 'label': 'Ingredients'},
      {'icon': Icons.menu, 'label': 'Recipes'},
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: Color(0xFFC1B9B9), thickness: 1),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_footerItems.length, (index) {
              final item = _footerItems[index];
              final isSelected = widget.currentIndex == index;

              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item['icon'],
                      color: isSelected ? Color(0xFFEF9920) : Color(0xFFC1B9B9),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item['label'],
                      style: TextStyle(
                        color:
                            isSelected ? Color(0xFFEF9920) : Color(0xFFC1B9B9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
