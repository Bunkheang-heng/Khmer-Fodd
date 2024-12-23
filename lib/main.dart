import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'components/getStart.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khmer Food Recipe',
      theme: ThemeData(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.green[50],
      ),
      home: const Scaffold(
        body: GetStartPage(),
      ),
    );
  }
}
