import 'package:flutter/material.dart';
import '../components/ai_bar.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTagsMenuPressed;

  const CustomAppBar({
    Key? key,
    required this.onTagsMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'មុខម្ហូបខ្មែរ', 
        style: TextStyle(
          fontFamily: 'Chenla',
          fontSize: 28,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black26,
            ),
          ],
        ),
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      actions: [
        IconButton(
          icon: Icon(Icons.menu, size: 28),
          onPressed: onTagsMenuPressed,
        ),
        IconButton(
          icon: Icon(Icons.smart_toy, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatPage()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
} 