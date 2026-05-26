import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';

class MovieProvider extends ChangeNotifier {
  List<Movie> _nowPlayingMovies = [];
  List<Movie> _upcomingMovies = [];
  bool _isLoading = false;
  String _error = '';

  List<Movie> get nowPlayingMovies => _nowPlayingMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Fetch now playing movies
  Future<void> fetchNowPlayingMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _nowPlayingMovies = await TMDbService.getNowPlayingMovies();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _nowPlayingMovies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch upcoming movies
  Future<void> fetchUpcomingMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _upcomingMovies = await TMDbService.getUpcomingMovies();
      _error = '';
    } catch (e) {
      _error = e.toString();
      _upcomingMovies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch both at once
  Future<void> fetchAllMovies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final now = await TMDbService.getNowPlayingMovies();
      final upcoming = await TMDbService.getUpcomingMovies();

      _nowPlayingMovies = now;
      _upcomingMovies = upcoming;
      _error = '';
    } catch (e) {
      _error = e.toString();
      _nowPlayingMovies = [];
      _upcomingMovies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
