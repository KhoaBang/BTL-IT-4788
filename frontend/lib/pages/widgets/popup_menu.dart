import 'package:flutter/material.dart';
import '../MemberTablePage.dart';
import 'confirmation_dialog.dart';

void showAddMenu(BuildContext context, GlobalKey iconKey) {
  final RenderBox renderBox =
      iconKey.currentContext!.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);

  final List<Map<String, String>> members = [
    {'name': 'John', 'email': 'john@gmail.com'},
    {'name': 'Jane', 'email': 'jane.doe@example.com'},
    {'name': 'Alice', 'email': 'alice.wonderland@mail.com'},
  ];

  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + renderBox.size.height,
      position.dx,
      position.dy,
    ),
    items: [
      PopupMenuItem<String>(
        value: 'View Members',
        child: Text('View members detail'),
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'Get Code',
        child: Text('Get group code'),
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'Delete',
        child: Text(
          'Delete Group',
          style: TextStyle(color: Colors.red),
        ),
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'Leave',
        child: Text(
          'Leave',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ],
  ).then((value) {
    if (value != null) {
      switch (value) {
        case 'View Members':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberTablePage(members: members),
            ),
          );
          break;
        case 'Get Code':
          print('Get Code selected');
          break;
        case 'Delete':
          showDialog(
            context: context,
            builder: (context) {
              return ConfirmDialog(
                title: 'Delete',
                content: 'Are you sure you want to delete this group',
                confirmText: 'Delete',
                cancelText: 'Cancel',
                onConfirm: () => {print('Delete group')},
              );
            },
          );
          break;
        case 'Leave':
          showDialog(
            context: context,
            builder: (context) {
              return ConfirmDialog(
                title: 'Leave',
                content: 'Are you sure you want to leave this group',
                confirmText: 'Leave',
                cancelText: 'Cancel',
                onConfirm: () => {print('Leave group')},
              );
            },
          );
          break;
      }
    }
  });
}
