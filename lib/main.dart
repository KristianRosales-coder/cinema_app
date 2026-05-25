import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/ticket_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const CinemaTicketingApp());
}

class CinemaTicketingApp extends StatelessWidget {
  const CinemaTicketingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
      ],
      child: MaterialApp(
        title: 'Cinema Ticketing',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryRed,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryRed,
            secondary: AppColors.accentRed,
            surface: AppColors
                .backgroundBlack, // FIXED: changed 'background' to 'surface'
          ),
          scaffoldBackgroundColor: AppColors.backgroundBlack,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryRed,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.cardBlack,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.primaryRed, width: 2),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
        },
      ),
    );
  }
}
