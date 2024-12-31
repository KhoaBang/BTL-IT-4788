import 'package:flutter/material.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/pages/signin_page.dart';
import 'package:frontend/widgets/notification_box.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/auth_provider.dart';

class Header extends ConsumerStatefulWidget {
  final bool canGoBack;
  final VoidCallback? onBack;

  const Header({super.key, this.canGoBack = false, this.onBack});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  final UserService _userService = UserService();

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

                // Handle password update
                final result =
                    await _userService.updatePassword(oldPassword, newPassword);

                Navigator.pop(context);

                if (result) {
                  NotificationBox.show(
                    context: context,
                    status: 200,
                    message: 'Password updated successfully.',
                  );
                } else {
                  NotificationBox.show(
                    context: context,
                    status: 400,
                    message: 'Incorrect old Password.',
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

                // Handle profile update
                final result =
                    await _userService.updateProfile(username, phone);

                Navigator.pop(context);

                if (result) {
                  NotificationBox.show(
                    context: context,
                    status: 200,
                    message: 'Profile updated successfully.',
                  );
                } else {
                  NotificationBox.show(
                    context: context,
                    status: 500,
                    message: 'Phone number has been used for another account.',
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

  void _logout() async {
    try {
      // Call the logout method from the AuthNotifier
      final authNotifier = ref.read(authProvider.notifier);
      final bool result = await authNotifier.logout();

      if (result) {
        // Show success notification
        NotificationBox.show(
          context: context,
          status: 200,
          message: 'Logout successful!',
        );

        // Navigate to SignInPage and remove all previous routes
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        // Show failure notification
        NotificationBox.show(
          context: context,
          status: 400,
          message: 'Logout failed. Please try again.',
        );
      }
    } catch (e) {
      print('Error logging out: $e');

      // Show unexpected error notification
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
                case 'Update Password':
                  _showUpdatePasswordDialog();
                case 'Update username and phone':
                  _showUpdateProfileDialog();
                case 'Logout':
                  _logout();
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
