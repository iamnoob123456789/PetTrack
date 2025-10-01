import 'package:flutter/material.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: _buildCurrentScreen(),
      ),
    );
  }

  Widget _buildCurrentScreen() {
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

      case 'admin-login':
        return Stack(
          children: [
            AdminLoginScreen(
              onAdminLogin: () {
                _setAdmin(true);
                _changeScreen('admin');
              },
              onBackToUserLogin: () => _changeScreen('login'),
            ),
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );

      case 'admin' when _isAdmin:
        return Stack(
          children: [
            AdminScreen(
              onBack: () {
                _setAdmin(false);
                _changeScreen('login');
              },
            ),
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );

      case 'signup':
        return Stack(
          children: [
            SignupPlaceholder(
              onBack: () => _changeScreen('login'),
            ),
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );

      case 'forgot':
        return Stack(
          children: [
            ForgotPlaceholder(
              onBack: () => _changeScreen('login'),
            ),
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );

      case 'home':
        return Stack(
          children: [
            HomePlaceholder(
              onLogout: () => _changeScreen('login'),
            ),
            const Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );

      default:
        return Stack(
          children: const [
            Center(child: Text('Loading...')),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: ToasterWidget(),
            ),
          ],
        );
    }
  }
}

// Placeholder Widgets (to be replaced with actual screens)
class SignupPlaceholder extends StatelessWidget {
  final VoidCallback onBack;

  const SignupPlaceholder({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Signup Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onBack,
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPlaceholder extends StatelessWidget {
  final VoidCallback onBack;

  const ForgotPlaceholder({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onBack,
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePlaceholder extends StatelessWidget {
  final VoidCallback onLogout;

  const HomePlaceholder({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Home Screen',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onLogout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}