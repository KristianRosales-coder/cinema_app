import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../providers/movie_provider.dart';
import '../providers/auth_provider.dart'; // Added
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
  String currentDate = '';

  @override
  void initState() {
    super.initState();
    _updateDate();
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
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketScreen()))
          .then((_) => setState(() => _selectedIndex = 0));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()))
          .then((_) => setState(() => _selectedIndex = 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text('MR.R CINEMA'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QRScannerScreen())),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.cardBlack,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20),
              decoration: const BoxDecoration(color: AppColors.primaryRed),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 45, color: AppColors.primaryRed),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back!",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.userEmail, // SHOW REAL FIREBASE EMAIL
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.movie, color: AppColors.primaryRed),
              title: const Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_num, color: AppColors.primaryRed),
              title: const Text('My Tickets', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const TicketScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primaryRed),
              title: const Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () async {
                await authProvider.logout();
                if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) return const Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
          return SingleChildScrollView(
            child: Column(
              children: [
                _buildMovieGrid('NOW SHOWING', movieProvider.nowPlayingMovies),
                _buildMovieGrid('COMING SOON', movieProvider.upcomingMovies),
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
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(String title, List<Movie> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 20, childAspectRatio: 0.65,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(TMDbService.getImageUrl(movie.posterPath), fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
