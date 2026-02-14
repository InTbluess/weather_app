// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String appbarTitle;
  final IconButton iconButton;
  const CustomAppBar({
    super.key,
    required this.appbarTitle,
    required this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(appbarTitle),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 124, 77, 255),
      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      actions: [iconButton],
    );
  }
}

@override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);
