import 'package:flutter/material.dart';

// A reusable widget that displays a table
class UserTable extends StatelessWidget {
  final List<Map<String, String>> tableData;

  UserTable({required this.tableData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Make the table horizontally scrollable
      scrollDirection: Axis.horizontal, // Scroll horizontally
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Options')),
        ],
        rows: tableData.map<DataRow>((data) {
          return DataRow(cells: [
            DataCell(Text(data['Name']!)),
            DataCell(Text(data['Email']!)),
            DataCell(
              IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  // Add action for options
                  print('Options clicked for ${data['Name']}');
                },
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }
}
