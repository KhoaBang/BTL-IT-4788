import 'package:flutter/material.dart';

class ListSection extends StatelessWidget {
  final String title;
  final List<Map<String, String>> lists;
  final VoidCallback onAdd;
  final void Function(String id, String name) onItemTap;

  const ListSection({
    Key? key,
    required this.title,
    required this.lists,
    required this.onAdd,
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
              children: lists.map((list) {
                return GestureDetector(
                  onTap: () => onItemTap(list['id']!, list['name']!),
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