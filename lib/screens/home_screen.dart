import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/movie_provider.dart';
import '../models/movie.dart';
import '../services/tmdb_service.dart';
import 'movie_detail_screen.dart';
import 'ticket_screen.dart';
import 'profile_screen.dart';
import 'qr_scanner_screen.dart';
import 'settings_screen.dart';

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
    // Fetch movies from API when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MovieProvider>(context, listen: false).fetchAllMovies();
    });
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

  Widget _buildMovieGrid(String title, List<Movie> movies) {
    if (movies.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Text(
          'No $title movies available',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      );
    }

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
                        child: Image.network(
                          TMDbService.getImageUrl(movie.posterPath),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryRed,
                                  ),
                                ),
                              ),
                            );
                          },
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
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
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
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.primaryRed),
              title:
                  const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
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
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading movies...',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          if (movieProvider.error.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Error loading movies',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      movieProvider.error,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      movieProvider.fetchAllMovies();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildMovieGrid('NOW SHOWING', movieProvider.nowPlayingMovies),
                _buildMovieGrid('COMING SOON', movieProvider.upcomingMovies),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
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
