import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'movie_detail_screen.dart';
import 'ticket_screen.dart';
import 'profile_screen.dart';
import 'qr_scanner_screen.dart';

class MovieItem {
  final int id;
  final String title;
  final String genre;
  final String duration;
  final double rating;
  final String imageAsset;
  final String description;
  final bool isComingSoon;
  final String trailerUrl;

  MovieItem({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.imageAsset,
    required this.description,
    this.isComingSoon = false,
    required this.trailerUrl,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String userName = 'Movie Fan';
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    _updateDate();
  }

  void _updateDate() {
    final now = DateTime.now();
    currentDate = '${_getMonth(now.month)} ${now.day}, ${now.year}';
  }

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  final List<MovieItem> nowShowingMovies = [
    MovieItem(
      id: 1,
      title: 'FOCKER IN-LAW',
      genre: 'Comedy',
      duration: '2h 30m',
      rating: 4.8,
      imageAsset: 'assets/images/cinema1.jpg',
      description:
          'The circle of trust just got bigger. Greg Focker meets his new in-laws in this hilarious new chapter.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=vyISuWUWcFs',
    ),
    MovieItem(
      id: 2,
      title: 'SCARY MOVIE',
      genre: 'Comedy',
      duration: '1h 50m',
      rating: 4.7,
      imageAsset: 'assets/images/cinema2.jpg',
      description: 'A hilarious parody that spoofs the biggest horror films.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=0fZ58S-7QP0',
    ),
    MovieItem(
      id: 3,
      title: 'MORTAL KOMBAT II',
      genre: 'Action',
      duration: '2h 15m',
      rating: 4.6,
      imageAsset: 'assets/images/cinema3.jpg',
      description:
          'The epic fighting tournament continues with more intense battles.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=ZdC5mFHPldg',
    ),
    MovieItem(
      id: 4,
      title: 'SPEED DEMON',
      genre: 'Action',
      duration: '1h 45m',
      rating: 4.9,
      imageAsset: 'assets/images/cinema4.jpg',
      description: 'High-speed racing action that pushes the limits.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=DHWrb3uVi1g',
    ),
    MovieItem(
      id: 5,
      title: 'THE MANDALORIAN AND GROGU',
      genre: 'Sci-Fi',
      duration: '1h 55m',
      rating: 4.5,
      imageAsset: 'assets/images/cinema5.jpg',
      description:
          'The Mandalorian and Grogu continue their journey across the galaxy.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=uwild1rw7Aw',
    ),
    MovieItem(
      id: 6,
      title: 'THE SUPER MARIO GALAXY',
      genre: 'Animation',
      duration: '1h 50m',
      rating: 4.4,
      imageAsset: 'assets/images/cinema6.jpeg',
      description:
          'Mario ventures into space, exploring cosmic worlds and tackling galactic challenges.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=En5QZmL5R1s',
    ),
    MovieItem(
      id: 7,
      title: 'MICHAEL',
      genre: 'Music',
      duration: '1h 50m',
      rating: 4.4,
      imageAsset: 'assets/images/cinema7.jpg',
      description:
          'The story of the famous musician Michael Jackson, known as the King of Pop.',
      isComingSoon: false,
      trailerUrl: 'https://www.youtube.com/watch?v=3zOLzsbOleM',
    ),
  ];

  final List<MovieItem> comingSoonMovies = [
    MovieItem(
      id: 8,
      title: 'LOVE, NGO',
      genre: 'Romance',
      duration: '1h 50m',
      rating: 0.0,
      imageAsset: 'assets/images/cinema8.jpg',
      description:
          'When Ngongo meets Scarlet, he dares to dream of a life beyond his insecurities.',
      isComingSoon: true,
      trailerUrl: 'https://www.youtube.com/watch?v=No-QYC87Q0c',
    ),
    MovieItem(
      id: 9,
      title: 'TOY STORY 5',
      genre: 'Animation',
      duration: '1h 50m',
      rating: 0.0,
      imageAsset: 'assets/images/cinema9.jpg',
      description:
          'Times may change but friends are forever. The toys face new challenges with modern technology.',
      isComingSoon: true,
      trailerUrl: 'https://www.youtube.com/watch?v=c51ND9Hdbw0',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TicketScreen()),
      ).then((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      ).then((_) {
        if (mounted) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      });
    }
  }

  Widget _buildMovieGrid(String title, List<MovieItem> movies,
      {bool showRating = true}) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.65,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          movie.imageAsset,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[800],
                              child: const Icon(
                                Icons.movie,
                                size: 50,
                                color: AppColors.primaryRed,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (showRating && movie.rating > 0)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating.toString(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  if (movie.isComingSoon)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'COMING SOON',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'CLICK POSTER TO BUY TICKETS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text('CINEMA TICKETING'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QRScannerScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.cardBlack,
        child: Column(
          children: [
            // Drawer Header - Fixed Left Alignment
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 45,
                        color: AppColors.primaryRed,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'movie@fan.com',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Menu Items
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primaryRed),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_num,
                  color: AppColors.primaryRed),
              title: const Text('My Tickets',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TicketScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primaryRed),
              title:
                  const Text('Profile', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
            ),
            const Divider(color: AppColors.textGrey),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primaryRed),
              title:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMovieGrid('NOW SHOWING', nowShowingMovies, showRating: true),
            _buildMovieGrid('COMING SOON', comingSoonMovies, showRating: false),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: AppColors.cardBlack,
        selectedItemColor: AppColors.primaryRed,
        unselectedItemColor: AppColors.textGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
