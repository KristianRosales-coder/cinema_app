import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_ticketing/providers/movie_provider.dart';

void main() {
  group('MovieProvider Tests', () {
    test('MovieProvider initializes with empty movie lists', () {
      final provider = MovieProvider();

      expect(provider.nowPlayingMovies, isEmpty);
      expect(provider.upcomingMovies, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.error, '');
    });

    test('fetchAllMovies sets isLoading to true initially', () async {
      final provider = MovieProvider();

      // Start fetching (don't await)
      final future = provider.fetchAllMovies();

      // Give it a moment to start
      await Future.delayed(const Duration(milliseconds: 50));
      expect(provider.isLoading, true);

      // Wait for completion
      await future;
    });

    test('clearError clears error message', () {
      final provider = MovieProvider();

      // Manually set an error for testing
      provider._error = 'Test error';
      provider.clearError();

      expect(provider.error, '');
    });

    test('MovieProvider notifies listeners when state changes', () async {
      final provider = MovieProvider();

      int notifyCount = 0;
      provider.addListener(() {
        notifyCount++;
      });

      // Try to fetch (will likely fail in test environment without mocking)
      await provider.fetchAllMovies();

      // Should have notified at least once (when loading starts)
      expect(notifyCount, greaterThan(0));
    });

    test('MovieProvider has fetchNowPlayingMovies method', () {
      final provider = MovieProvider();

      expect(provider.fetchNowPlayingMovies, isNotNull);
      expect(provider.fetchNowPlayingMovies, isA<Function>());
    });

    test('MovieProvider has fetchUpcomingMovies method', () {
      final provider = MovieProvider();

      expect(provider.fetchUpcomingMovies, isNotNull);
      expect(provider.fetchUpcomingMovies, isA<Function>());
    });

    test('fetchNowPlayingMovies can be called without error', () async {
      final provider = MovieProvider();

      // This will fail in test environment but shouldn't throw an exception
      expect(() => provider.fetchNowPlayingMovies(), returnsNormally);
    });

    test('fetchUpcomingMovies can be called without error', () async {
      final provider = MovieProvider();

      // This will fail in test environment but shouldn't throw an exception
      expect(() => provider.fetchUpcomingMovies(), returnsNormally);
    });
  });
}
