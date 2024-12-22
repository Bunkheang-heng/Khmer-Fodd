import 'package:flutter/material.dart';
import '../screens/auth/profile.dart';
import '../screens/notification.dart';
import '../recipes/recipes.dart';
import '../components/ai_bar.dart';
import '../screens/favorites_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.home_outlined),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeListPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => const FavoritesPage()),
                  );
                },
              ),
              _buildCenterButton(context),
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ChatPage()),
        );
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFF45B097),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.smart_toy_outlined,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}