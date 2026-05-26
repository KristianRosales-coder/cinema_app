import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  User? _user;

  AuthProvider() {
    // Listen to real-time auth changes
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null;
  String get userEmail => _user?.email ?? '';
  String get userId => _user?.uid ?? '';

  Future<bool> login(String email, String password) async {
    try {
      final user = await _authService.signInWithEmail(email, password);
      return user != null;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) return false;
    try {
      final user = await _authService.signUpWithEmail(email, password);
      return user != null;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
