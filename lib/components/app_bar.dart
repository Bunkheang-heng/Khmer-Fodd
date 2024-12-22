import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    super.key,
    this.title = 'មុខម្ហូបខ្មែរ',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColorDark,
      elevation: 4, // Increased elevation for a more pronounced shadow
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Fasthand',
          color: Colors.white,
          fontSize: 30, // Slightly increased font size for emphasis
          letterSpacing: 1.5, // Increased letter spacing for elegance
          shadows: [
            Shadow(
              offset: Offset(2.0, 2.0), // More pronounced shadow
              blurRadius: 4.0, // Increased blur for a softer shadow
              color: Colors.black38,
            ),
          ],
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // More rounding for a modern look
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Add search functionality here
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Add notifications functionality here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
