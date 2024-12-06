import 'package:flutter/material.dart';

class ResponsiveMemberTable extends StatelessWidget {
  final List<Map<String, String>> members;

  const ResponsiveMemberTable({Key? key, required this.members})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tableWidth = constraints.maxWidth;

        return Container(
          color: const Color.fromARGB(255, 255, 228, 188),
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: tableWidth,
              ),
              child: DataTable(
                columnSpacing: 20,
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Member',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Option',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: members.map((member) {
                  return DataRow(
                    cells: <DataCell>[
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member['name']!,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 4),
                          Text(
                            member['email']!,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      )),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Remove',
                          onPressed: () {
                            print('Remove ${member['name']}');
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
