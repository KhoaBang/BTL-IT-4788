import 'package:flutter/material.dart';
import 'widgets/members_table.dart'; // Import the UserTable widget

class Test extends StatelessWidget {
  // Sample data for the table
  final List<Map<String, String>> tableData = [
    {'Name': 'John Doe', 'Email': 'john@example.com'},
    {'Name': 'Jane Smith', 'Email': 'jane@example.com'},
    {'Name': 'Bob Johnson', 'Email': 'bob@example.com'},
  ];

  // Function to show the table in a dialog
  void _showTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('User Table'),
          content: SingleChildScrollView(
            child: UserTable(tableData: tableData), // Use the UserTable widget
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Table Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showTableDialog(context);
          },
          child: Text('Show Table'),
        ),
      ),
    );
  }
}
