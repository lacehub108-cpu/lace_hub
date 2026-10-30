import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isAdminLoggedIn = StorageService.isAdminLoggedIn;

  bool get isAdminLoggedIn => _isAdminLoggedIn;

  // ફાયરબેઝ દ્વારા લોગિન
  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        _isAdminLoggedIn = true;
        await StorageService.setAdminLoggedIn(true);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Login Error: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isAdminLoggedIn = false;
    await StorageService.setAdminLoggedIn(false);
    notifyListeners();
  }
}