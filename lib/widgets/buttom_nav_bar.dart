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
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavButton(
                context,
                icon: Icons.home_rounded,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeListPage()),
                  );
                },
              ),
              _buildNavButton(
                context,
                icon: Icons.bookmark_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritesPage()),
                  );
                },
              ),
              _buildCenterButton(context),
              _buildNavButton(
                context,
                icon: Icons.notifications_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationPage()),
                  );
                },
              ),
              _buildNavButton(
                context,
                icon: Icons.person_rounded,
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

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: onPressed,
        splashColor: Colors.green[100],
        highlightColor: Colors.green[50],
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
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              const Color(0xFF45B097),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(
          Icons.smart_toy_rounded,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}