import 'package:flutter/material.dart';
import 'confirmation_dialog.dart';

void showAddMenu(BuildContext context, GlobalKey iconKey) {
  final RenderBox renderBox =
      iconKey.currentContext!.findRenderObject() as RenderBox;
  final position =
      renderBox.localToGlobal(Offset.zero); // Get the position of the icon

  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx, // X position of the IconButton
      position.dy + renderBox.size.height, // Y position right below the button
      position.dx, // Same X position for the right
      position.dy, // Same Y position
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
          style: TextStyle(color: Colors.red), // Red text color for Delete
        ),
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'Leave',
        child: Text(
          'Leave',
          style: TextStyle(color: Colors.red), // Red text color for Leave
        ),
      ),
    ],
  ).then((value) {
    if (value != null) {
      switch (value) {
        case 'View Members':
          print('View Members selected');
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
