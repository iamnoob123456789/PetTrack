import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_screen.dart';
import 'widgets/toaster_widget.dart';

class PetTrackApp extends StatefulWidget {
  const PetTrackApp({super.key});

  @override
  State<PetTrackApp> createState() => _PetTrackAppState();
}

class _PetTrackAppState extends State<PetTrackApp> {
  String _currentScreen = 'login';
  bool _isAdmin = false;

  void _changeScreen(String screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _setAdmin(bool isAdmin) {
    setState(() {
      _isAdmin = isAdmin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetTrack',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      home: Scaffold(
        body: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    // ... (same screen logic as before, but now uses the theme)
    switch (_currentScreen) {
      case 'login':
        return Stack(
          children: [
            LoginScreen(
              onLogin: () => _changeScreen('home'),
              onNavigateToSignup: () => _changeScreen('signup'),
              onNavigateToForgotPassword: () => _changeScreen('forgot'),
              onNavigateToAdminLogin: () => _changeScreen('admin-login'),
            ),
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );
      // ... other cases remain the same
    }
  }
}