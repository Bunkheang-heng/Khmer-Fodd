import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '';
  bool _isLoading = true;

  String get userName => _userName;
  bool get isLoading => _isLoading;

  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        
        _userName = userData.data()?['name'] ?? '';
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
} 