// lib/components/CustomAppBar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;   // 左侧按钮
  final List<Widget>? actions; // 右侧按钮组
  final Color backgroundColor;

  const CustomAppBar({
    super.key,
    this.title ='',
    this.leading,
    this.actions,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: leading ?? IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(title, style: TextStyle(color: Colors.black)),
      centerTitle: true,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
