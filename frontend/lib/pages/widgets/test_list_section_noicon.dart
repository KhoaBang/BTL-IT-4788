import 'package:flutter/material.dart';

class ListSectionNoicon extends StatelessWidget {
  final String title;
  final List<Map<String, String>>
      lists; // Updated to a list of maps for name and date
  final void Function(String listName) onItemTap;

  const ListSectionNoicon({
    Key? key,
    required this.title,
    required this.lists,
    required this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
          SizedBox(height: 16),
          // Scrollable list for shopping lists
          SizedBox(
            height: 200,
            child: ListView(
              children: lists.map((list) {
                return GestureDetector(
                  onTap: () => onItemTap(list['name']!),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list['name']!,
                          style: TextStyle(
                            color: Color(0xFF010F07),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          list['date']!,
                          style: TextStyle(
                            color: Color(0xFF8D8D8D),
                            fontSize: 12,
                          ),
                        ),
                      ],
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
