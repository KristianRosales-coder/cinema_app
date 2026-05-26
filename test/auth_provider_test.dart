import 'package:flutter_test/flutter_test.dart';
import 'package:cinema_ticketing/providers/auth_provider.dart';

void main() {
  group('AuthProvider Tests', () {
    test('AuthProvider initializes with isLoggedIn as false', () async {
      final provider = AuthProvider();
      // Give it time to load from SharedPreferences
      await Future.delayed(const Duration(milliseconds: 100));
      expect(provider.isLoggedIn, false);
    });

    test('Login sets isLoggedIn to true and stores email', () async {
      final provider = AuthProvider();
      final result = await provider.login('test@example.com', 'password123');

      expect(result, true);
      expect(provider.isLoggedIn, true);
      expect(provider.userEmail, 'test@example.com');
    });

    test('Login with empty email returns false', () async {
      final provider = AuthProvider();
      final result = await provider.login('', 'password123');

      expect(result, false);
    });

    test('Login with empty password returns false', () async {
      final provider = AuthProvider();
      final result = await provider.login('test@example.com', '');

      expect(result, false);
    });

    test('Register with matching passwords succeeds', () async {
      final provider = AuthProvider();
      final result = await provider.register(
        'newuser@example.com',
        'password123',
        'password123',
      );

      expect(result, true);
      expect(provider.isLoggedIn, true);
      expect(provider.userEmail, 'newuser@example.com');
    });

    test('Register with non-matching passwords fails', () async {
      final provider = AuthProvider();
      final result = await provider.register(
        'newuser@example.com',
        'password123',
        'password456',
      );

      expect(result, false);
      expect(provider.isLoggedIn, false);
    });

    test('Logout clears user data', () async {
      final provider = AuthProvider();
      await provider.login('test@example.com', 'password123');
      expect(provider.isLoggedIn, true);

      await provider.logout();
      expect(provider.isLoggedIn, false);
      expect(provider.userEmail, '');
    });
  });
}
