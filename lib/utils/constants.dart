import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryRed = Color(0xFFE50914);
  static const Color accentRed = Color(0xFFB20710);
  static const Color backgroundBlack = Color(0xFF0F0F0F);
  static const Color cardBlack = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFFB3B3B3);
}

class AppStrings {
  static const String appName = 'Cinema Ticketing';
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String bookNow = 'Book Now';
  static const String myTickets = 'My Tickets';
  static const String profile = 'Profile';
  static const String settings = 'Settings';
  static const String logout = 'Logout';
}

class ApiConstants {
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbApiKey = 'd99c288697272230f56258dff79ee368';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const int requestTimeout = 10; // seconds
}

class AppDefaults {
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const int moviesPerPage = 10;
}
