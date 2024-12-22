import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/auth/login.dart';
import '../screens/auth/register.dart';
import '../screens/auth/profile.dart';
import 'custom_button.dart';

class AuthSection extends StatelessWidget {
  const AuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomButton(
            text: 'ព័ត៌មានផ្ទាល់ខ្លួន',
            icon: Icons.person,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            ),
          );
        } else {
          return Column(
            children: [
              CustomButton(
                text: 'ចូលគណនី',
                icon: Icons.login,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'បង្កើតគណនី',
                icon: Icons.person_add,
                isOutlined: true,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
