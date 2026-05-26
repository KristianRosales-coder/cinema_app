import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text('SETTINGS'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // App Info Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'APP INFORMATION',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: AppColors.primaryRed),
            title: const Text('App Version',
                style: TextStyle(color: Colors.white)),
            trailing: const Text('1.0.0',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
          ),
          ListTile(
            leading: const Icon(Icons.description, color: AppColors.primaryRed),
            title: const Text('About Cinema Ticketing',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Cinema Ticketing',
                applicationVersion: '1.0.0',
                applicationLegalese:
                    '© 2026 Cinema Ticketing App. All rights reserved.',
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    'A comprehensive mobile application for booking cinema tickets using Flutter with TMDb API integration.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              );
            },
          ),
          const Divider(color: AppColors.cardBlack, height: 32),

          // Preferences Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'PREFERENCES',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Push Notifications',
                style: TextStyle(color: Colors.white)),
            subtitle: const Text('Receive booking reminders and offers',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            activeColor: AppColors.primaryRed,
          ),
          SwitchListTile(
            title:
                const Text('Dark Mode', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Currently enabled',
                style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            activeColor: AppColors.primaryRed,
          ),
          const Divider(color: AppColors.cardBlack, height: 32),

          // Support Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'SUPPORT',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.help, color: AppColors.primaryRed),
            title: const Text('FAQ', style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textGrey),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('FAQ section coming soon')),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.support_agent, color: AppColors.primaryRed),
            title: const Text('Contact Support',
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textGrey),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Contact support: support@cinematicketing.com')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppColors.primaryRed),
            title: const Text('Privacy Policy',
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textGrey),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy policy coming soon')),
              );
            },
          ),
          const Divider(color: AppColors.cardBlack, height: 32),

          // Account Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ACCOUNT',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.cardBlack,
                  title: const Text('Logout',
                      style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.white70)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        authProvider.logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
