import 'package:flutter/material.dart';
import 'package:frontend/api/auth_service.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/signin_page.dart';
// import 'package:frontend/pages/widgets/notification_box.dart';

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
                try {
                  await _userService.updatePassword(
                    oldPasswordController.text,
                    newPasswordController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password updated successfully.')),
                  );
                } catch (e) {
                  print('Error updating password: $e');
                }
              }
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // void _showUpdatePasswordDialog() {
  //   final oldPasswordController = TextEditingController();
  //   final newPasswordController = TextEditingController();
  //   final formKey = GlobalKey<FormState>();

  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Update Password'),
  //       content: Form(
  //         key: formKey,
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextFormField(
  //               controller: oldPasswordController,
  //               decoration: InputDecoration(labelText: 'Old Password'),
  //               obscureText: true,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please enter Old Password';
  //                 }
  //                 return null;
  //               },
  //             ),
  //             TextFormField(
  //               controller: newPasswordController,
  //               decoration: InputDecoration(labelText: 'New Password'),
  //               obscureText: true,
  //               validator: (value) {
  //                 if (value == null || value.isEmpty) {
  //                   return 'Please enter New Password';
  //                 }
  //                 return null;
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             if (formKey.currentState?.validate() == true) {
  //               try {
  //                 await _userService.updatePassword(
  //                   oldPasswordController.text,
  //                   newPasswordController.text,
  //                 );
  //                 Navigator.pop(context);
  //                 showDialog(
  //                   context: context,
  //                   builder: (context) => NotificationBox(
  //                     message: 'Password updated successfully.',
  //                     isError: false,
  //                   ),
  //                 );
  //               } catch (e) {
  //                 if (e.toString().contains('Invalid old password')) {
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) => NotificationBox(
  //                       message: 'Invalid old password.',
  //                       isError: true,
  //                     ),
  //                   );
  //                 } else {
  //                   showDialog(
  //                     context: context,
  //                     builder: (context) => NotificationBox(
  //                       message:
  //                           'An unexpected error occurred. Please try again.',
  //                       isError: true,
  //                     ),
  //                   );
  //                 }
  //               }
  //             }
  //           },
  //           child: Text('Confirm'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Phone';
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
                try {
                  await _userService.updateProfile(
                    usernameController.text,
                    phoneController.text,
                  );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Profile updated successfully.')),
                  );
                } catch (e) {
                  print('Error updating profile: $e');
                }
              }
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _logout() async {
    try {
      await _authService.logout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout successful!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SignInPage()), // Giả sử HomePage đã có
      );
    } catch (e) {
      print('Error logging out: $e');
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