import 'package:flutter/material.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/signin_page.dart';
import 'package:frontend/pages/widgets/notification_box.dart';

class Header extends StatefulWidget {
  final bool canGoBack;
  final VoidCallback? onBack;

  const Header({Key? key, this.canGoBack = false, this.onBack})
      : super(key: key);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  void _showProfileDialog() async {
    try {
      final profile = await _userService.getUserProfile();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Profile Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Username: ${profile['username']}'),
              Text('Email: ${profile['email']}'),
              Text('Phone: ${profile['phone']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  void _showUpdatePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: oldPasswordController,
                decoration: InputDecoration(labelText: 'Old Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Old Password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'New Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter New Password';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                final oldPassword = oldPasswordController.text;
                final newPassword = newPasswordController.text;

                // Xử lý cập nhật mật khẩu
                final result =
                    await _userService.updatePassword(oldPassword, newPassword);

                Navigator.pop(context);

                if (result) {
                  // Thành công
                  NotificationBox.show(
                    context: context,
                    status: 200,
                    message: 'Password updated successfully.',
                  );
                } else {
                  // Thất bại
                  NotificationBox.show(
                    context: context,
                    status: 400,
                    message:
                        'Incorrect old Password. Please enter correct password',
                  );
                }
              }
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showUpdateProfileDialog() {
    final usernameController = TextEditingController();
    final phoneController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Profile'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Phone number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState?.validate() == true) {
                final username = usernameController.text;
                final phone = phoneController.text;

                // Xử lý cập nhật mật khẩu
                final result =
                    await _userService.updateProfile(username, phone);

                Navigator.pop(context);

                if (result) {
                  // Thành công
                  NotificationBox.show(
                    context: context,
                    status: 200,
                    message: 'Profile updated successfully.',
                  );
                } else {
                  // Thất bại
                  NotificationBox.show(
                    context: context,
                    status: 500,
                    message:
                        'Phone number has been used for another account. Please enter another phone number',
                  );
                }
              }
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // void _logout() async {
  //   try {
  //     await _authService.logout();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Logout successful!')),
  //     );
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => SignInPage()), // Giả sử HomePage đã có
  //     );
  //   } catch (e) {
  //     print('Error logging out: $e');
  //   }
  // }

  void _logout() async {
    try {
      // Gọi hàm logout từ _authService
      final bool result = await _authService.logout();

      if (result) {
        // Hiển thị thông báo thành công
        NotificationBox.show(
          context: context,
          status: 200,
          message: 'Logout successful!',
        );

        // Chuyển đến trang SignInPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
        );
      } else {
        // Hiển thị thông báo thất bại
        NotificationBox.show(
          context: context,
          status: 400,
          message: 'Logout failed. Please try again.',
        );
      }
    } catch (e) {
      print('Error logging out: $e');

      // Hiển thị thông báo lỗi không mong muốn
      NotificationBox.show(
        context: context,
        status: 400,
        message: 'An unexpected error occurred during logout.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 60,
      child: Row(
        children: [
          if (widget.canGoBack)
            IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFC1B9B9), size: 24),
              onPressed: widget.onBack ?? () => Navigator.pop(context),
            ),
          Spacer(),
          Image.asset('images/logo.jpg', height: 40),
          Spacer(),
          PopupMenuButton<String>(
            icon: Icon(Icons.person, color: Colors.black, size: 24),
            onSelected: (value) {
              switch (value) {
                case 'View profile':
                  _showProfileDialog();
                  break;
                case 'Update Password':
                  _showUpdatePasswordDialog();
                  break;
                case 'Update username and phone':
                  _showUpdateProfileDialog();
                  break;
                case 'Logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'View profile', child: Text('View profile')),
              PopupMenuItem(
                  value: 'Update Password', child: Text('Update Password')),
              PopupMenuItem(
                  value: 'Update username and phone',
                  child: Text('Update username and phone')),
              PopupMenuItem(value: 'Logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
    );
  }
}
