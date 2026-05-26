import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../services/tmdb_service.dart';
import '../models/movie.dart';
import 'booking_screen.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  String _getMtrcbRating(String title) {
    if (title.contains('FOCKER') || title.contains('SCARY')) {
      return 'R-13';
    } else if (title.contains('MORTAL') || title.contains('SPEED')) {
      return 'R-16';
    } else if (title.contains('MARIO') || title.contains('TOY STORY')) {
      return 'G';
    } else {
      return 'PG';
    }
  }

  String _getDirector(String title) {
    final Map<String, String> directors = {
      'FOCKER IN-LAW': 'John Hamburg',
      'SCARY MOVIE': 'Keenen Ivory Wayans',
      'MORTAL KOMBAT II': 'Simon McQuoid',
      'SPEED DEMON': 'David Leitch',
      'THE MANDALORIAN AND GROGU': 'Jon Favreau',
      'THE SUPER MARIO GALAXY': 'Aaron Horvath, Michael Jelenic',
      'MICHAEL': 'Antoine Fuqua',
      'LOVE, NGO': 'Cathy Garcia-Molina',
      'TOY STORY 5': 'Andrew Stanton',
    };
    return directors[title] ?? 'To be announced';
  }

  String _getCast(String title) {
    final Map<String, String> cast = {
      'FOCKER IN-LAW':
          'Ben Stiller, Robert De Niro, Ariana Grande, Owen Wilson',
      'SCARY MOVIE': 'Anna Faris, Regina Hall, Shawn Wayans, Marlon Wayans',
      'MORTAL KOMBAT II':
          'Lewis Tan, Jessica McNamee, Josh Lawson, Hiroyuki Sanada',
      'SPEED DEMON': 'Tom Hardy, Charlize Theron, Anya Taylor-Joy',
      'THE MANDALORIAN AND GROGU': 'Pedro Pascal, Grogu, Katee Sackhoff',
      'THE SUPER MARIO GALAXY':
          'Chris Pratt, Anya Taylor-Joy, Charlie Day, Jack Black',
      'MICHAEL': 'Jaafar Jackson, Colman Domingo, Nia Long',
      'LOVE, NGO': 'Alden Richards, Kathryn Bernardo',
      'TOY STORY 5': 'Tom Hanks, Tim Allen, Joan Cusack, Greta Lee',
    };
    return cast[title] ?? 'To be announced';
  }

  @override
  Widget build(BuildContext context) {
    final mtrcbRating = _getMtrcbRating(movie.title);
    final director = _getDirector(movie.title);
    final cast = _getCast(movie.title);

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: Text(movie.title),
        backgroundColor: AppColors.primaryRed,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            GestureDetector(
              onTap: () {
                // Can be used for additional actions
              },
              child: Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                child: Image.network(
                  TMDbService.getImageUrl(movie.posterPath),
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryRed,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(Icons.movie,
                            size: 80, color: AppColors.primaryRed),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Movie Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 20, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          movie.releaseDate.substring(0, 4),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified,
                            size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          'MTRCB Rating: $mtrcbRating',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person_outline,
                            color: AppColors.primaryRed, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Director',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                director,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.people_outline,
                            color: AppColors.primaryRed, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Cast',
                                style: TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cast,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style:
                        const TextStyle(color: AppColors.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(movie: movie),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'BOOK NOW',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.description,
                    style:
                        const TextStyle(color: AppColors.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingScreen(movie: movie),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'BOOK NOW',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
