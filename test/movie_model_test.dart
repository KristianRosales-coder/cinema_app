import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_ticketing/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
    test('Movie.fromJson creates Movie from valid JSON', () {
      final json = {
        'id': 550,
        'title': 'Fight Club',
        'overview': 'An insomniac office worker and a devil-may-care soapmaker',
        'poster_path': '/fCayJrkfRaCo5dh61q4IGsgMEKF.jpg',
        'backdrop_path': '/pWnxrp9JGU6qtPcGMPM5NKxCTLz.jpg',
        'vote_average': 8.8,
        'release_date': '1999-10-15',
      };

      final movie = Movie.fromJson(json);

      expect(movie.id, 550);
      expect(movie.title, 'Fight Club');
      expect(movie.overview,
          'An insomniac office worker and a devil-may-care soapmaker');
      expect(movie.posterPath, '/fCayJrkfRaCo5dh61q4IGsgMEKF.jpg');
      expect(movie.backdropPath, '/pWnxrp9JGU6qtPcGMPM5NKxCTLz.jpg');
      expect(movie.voteAverage, 8.8);
      expect(movie.releaseDate, '1999-10-15');
    });

    test('Movie.fromJson handles missing poster_path', () {
      final json = {
        'id': 550,
        'title': 'Fight Club',
        'overview': 'An insomniac office worker',
        'poster_path': null,
        'backdrop_path': null,
        'vote_average': 8.8,
        'release_date': '1999-10-15',
      };

      final movie = Movie.fromJson(json);

      expect(movie.posterPath, '');
      expect(movie.backdropPath, '');
    });

    test('Movie constructor creates Movie correctly', () {
      final movie = Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test overview',
        posterPath: '/test.jpg',
        backdropPath: '/backdrop.jpg',
        voteAverage: 7.5,
        releaseDate: '2024-01-01',
      );

      expect(movie.id, 1);
      expect(movie.title, 'Test Movie');
      expect(movie.voteAverage, 7.5);
    });
  });
}
