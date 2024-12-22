import 'package:flutter/material.dart';
import '../recipes/recipes.dart';
import '../components/ai_bar.dart';
import '../components/aboutUs.dart';
import '../components/welcome_header.dart';
import '../components/custom_button.dart';
import '../components/auth_section.dart';
import '../screens/notification.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'មុខម្ហូបខ្មែរ',
          style: TextStyle(
            fontFamily: 'Moul',
            fontSize: 30,
            color: Colors.white,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 6,
                color: Colors.black87,
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/homebackground.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.15),
                  BlendMode.srcOver,
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Add shimmer effect to welcome header
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Colors.white70],
                        stops: [0.5, 0.9],
                      ).createShader(bounds),
                      child: const WelcomeHeader(),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        CustomButton(
                          text: 'មើលមុខម្ហូប',
                          icon: Icons.restaurant_menu,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeListPage()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'សួរ AI',
                          icon: Icons.psychology,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatPage()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'អំពីយើង',
                          icon: Icons.info_outline,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AboutUsPage()),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: 'ការជូនដំណឹង',
                          icon: Icons.notifications_none,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NotificationPage()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const AuthSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated particles
class ParticlesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Add subtle floating particles
    for (var i = 0; i < 50; i++) {
      canvas.drawCircle(
        Offset(size.width * (i / 50), size.height * (i / 50)),
        1.5,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
