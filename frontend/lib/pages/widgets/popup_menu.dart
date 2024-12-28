import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../MemberTablePage.dart';
import 'confirmation_dialog.dart';
import '../../api/group_service.dart';
import '../../pages/widgets/notification_box.dart';
import '../../providers/group_provider.dart';

void showAddMenu(BuildContext context, GlobalKey iconKey, String GID,
    String role, WidgetRef ref) {
  final RenderBox renderBox =
      iconKey.currentContext!.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);

  List<PopupMenuEntry<String>> menuItems = [
    PopupMenuItem<String>(
      value: 'View Members',
      child: Text('View members detail'),
    ),
  ];

  // Thêm các mục menu dựa trên vai trò
  if (role == 'manager') {
    menuItems.addAll([
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
    ]);
  } else if (role == 'member') {
    menuItems.addAll([
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'Leave',
        child: Text(
          'Leave',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ]);
  }

  // Hiển thị menu
  showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy + renderBox.size.height,
      position.dx,
      position.dy,
    ),
    items: menuItems,
  ).then((value) {
    if (value != null) {
      switch (value) {
        case 'View Members':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemberTablePage(groupId: GID),
            ),
          );
          break;
        case 'Get Invite Code':
          _getInviteCode(context, GID); // Gọi _getInviteCode với GID
          break;
        case 'Delete':
          _deleteGroup(context, ref, GID); // Gọi _deleteGroup với GID
          break;
        case 'Leave':
          _leaveGroup(context, ref, GID); // Gọi _leaveGroup với GID
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

//delete group
void _deleteGroup(BuildContext context, WidgetRef ref, String GID) async {
  final groupState = ref.watch(groupListProvider);
  final groupNotifier = ref.read(groupListProvider.notifier);

  showDialog(
    context: context,
    builder: (context) => ConfirmDialog(
      title: 'Delete Group',
      content: 'Are you sure you want to delete this group?',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          final success = await groupNotifier.deleteGroup(GID);
          NotificationBox.show(
            context: context,
            status: 200,
            message: 'Group deleted successfully',
          );
        } catch (e) {
          NotificationBox.show(
            context: context,
            status: 400,
            message: 'An error occurred: ${e.toString()}',
          );
        }
        Navigator.of(context).pop();
      },
    ),
  );
}

//leave group
void _leaveGroup(BuildContext context, WidgetRef ref, String GID) async {
  final groupState = ref.watch(groupListProvider);
  final groupNotifier = ref.read(groupListProvider.notifier);

  showDialog(
    context: context,
    builder: (context) => ConfirmDialog(
      title: 'Leave Group',
      content: 'Are you sure you want to leave this group?',
      confirmText: 'Leave',
      cancelText: 'Cancel',
      onConfirm: () async {
        try {
          final success = await groupNotifier.leaveGroup(GID);
          NotificationBox.show(
            context: context,
            status: 200,
            message: 'Leave Group successfully',
          );
        } catch (e) {
          NotificationBox.show(
            context: context,
            status: 400,
            message: 'An error occurred: ${e.toString()}',
          );
        }
        Navigator.of(context).pop();
      },
    ),
  );
}
