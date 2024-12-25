import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../MemberTablePage.dart';
import 'confirmation_dialog.dart';
import '../../api/group_service.dart';
import '../../pages/widgets/notification_box.dart';

void showAddMenu(BuildContext context, GlobalKey iconKey, String GID) {
  final RenderBox renderBox =
      iconKey.currentContext!.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);

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
        value: 'Get Invite Code',
        child: Text('Get Invite Code'),
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
          // Logic for viewing members
          break;
        case 'Get Invite Code':
          _getInviteCode(context, GID); // Gọi _getInviteCode với GID
          break;
        case 'Delete':
          // Logic for deleting the group
          break;
        case 'Leave':
          // Logic for leaving the group
          break;
      }
    }
  });
}

void _getInviteCode(BuildContext context, String GID) async {
  final groupService = GroupService();

  // Gọi API để lấy mã mời
  final inviteCode = await groupService.getGroupInviteCode(GID);

  if (inviteCode.isNotEmpty) {
    // Sử dụng ConfirmDialog thay vì AlertDialog
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Invite Code',
        content: 'Your group invite code is: $inviteCode',
        confirmText: 'Copy to Clipboard',
        cancelText: 'Close',
        onConfirm: () {
          // Sao chép mã mời vào clipboard
          Clipboard.setData(ClipboardData(text: inviteCode));

          // Hiển thị thông báo cho người dùng thay vì SnackBar
          NotificationBox.show(
            context: context,
            status: 200, // Status 200 là thành công
            message: 'Invite code copied to clipboard',
          );
        },
      ),
    );
  } else {
    // Hiển thị thông báo lỗi nếu không lấy được mã mời
    NotificationBox.show(
      context: context,
      status: 400, // Status 400 là lỗi
      message: 'Failed to get invite code',
    );
  }
}
