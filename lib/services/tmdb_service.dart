import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';

class TMDbService {
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String _apiKey = 'd99c288697272230f56258dff79ee368';
  static const String _imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Get now playing movies
  static Future<List<Movie>> getNowPlayingMovies() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '$_baseUrl/movie/now_playing?api_key=$_apiKey&language=en-US&page=1'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results
            .map((json) => Movie.fromJson(json))
            .where((movie) => movie.posterPath.isNotEmpty)
            .take(10)
            .toList();
      } else {
        throw Exception(
            'Failed to load now playing movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching now playing movies: $e');
    }
  }

  // Get upcoming movies
  static Future<List<Movie>> getUpcomingMovies() async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '$_baseUrl/movie/upcoming?api_key=$_apiKey&language=en-US&page=1'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results
            .map((json) => Movie.fromJson(json))
            .where((movie) => movie.posterPath.isNotEmpty)
            .take(10)
            .toList();
      } else {
        throw Exception(
            'Failed to load upcoming movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching upcoming movies: $e');
    }
  }

  // Get movie details
  static Future<Movie> getMovieDetails(int movieId) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '$_baseUrl/movie/$movieId?api_key=$_apiKey&language=en-US'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw Exception('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  // Search movies
  static Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await http
          .get(
            Uri.parse(
                '$_baseUrl/search/movie?api_key=$_apiKey&language=en-US&query=$query&page=1'),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        return results
            .map((json) => Movie.fromJson(json))
            .where((movie) => movie.posterPath.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to search movies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching movies: $e');
    }
  }

  // Get full image URL
  static String getImageUrl(String posterPath) {
    if (posterPath.isEmpty) {
      return 'https://via.placeholder.com/500x750?text=No+Image';
    }
    return '$_imageBaseUrl$posterPath';
  }
}
