import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userEmail => _userEmail;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userEmail = prefs.getString('userEmail') ?? '';
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = true;
      _userEmail = email;
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(
      String email, String password, String confirmPassword) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        password == confirmPassword) {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = true;
      _userEmail = email;
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = false;
    _userEmail = '';
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userEmail');
    notifyListeners();
  }
}
