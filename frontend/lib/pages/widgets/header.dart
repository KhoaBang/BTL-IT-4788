import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final bool canGoBack;
  final VoidCallback? onBackPressed;
  final VoidCallback onChangeProfile;
  final VoidCallback onLogout;

  const Header({
    Key? key,
    required this.canGoBack,
    this.onBackPressed,
    required this.onChangeProfile,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: canGoBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFFC1B9B9), size: 24),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Image.asset(
        'images/logo.jpg',
        height: 40, // Resize ảnh
        fit: BoxFit.contain,
      ),
      actions: [
        _UserMenu(onChangeProfile: onChangeProfile, onLogout: onLogout),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0); // Chiều cao của AppBar
}

class _UserMenu extends StatelessWidget {
  final VoidCallback onChangeProfile;
  final VoidCallback onLogout;

  const _UserMenu({
    Key? key,
    required this.onChangeProfile,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.person, color: Colors.black, size: 24), // Biểu tượng người dùng
      color: Colors.white, // Nền trắng
      onSelected: (value) {
        if (value == 0) {
          onChangeProfile();
        } else if (value == 1) {
          onLogout();
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<int>(
          value: 0,
          child: Text(
            'Change profile',
            style: TextStyle(color: Colors.black),
          ),
        ),
        PopupMenuDivider(), // Line phân cách
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
