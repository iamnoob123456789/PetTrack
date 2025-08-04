import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
    };
  }
}

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _error = '';
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      
      if (userJson != null) {
        // Parse user data from SharedPreferences
        // For now, we'll use mock data
        _currentUser = User(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1-555-0123',
        );
        _isAuthenticated = true;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to initialize auth: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock authentication
      if (email == 'demo@example.com' && password == 'password') {
        _currentUser = User(
          id: '1',
          name: 'John Doe',
          email: email,
          phone: '+1-555-0123',
        );
        _isAuthenticated = true;
        
        // Save to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', _currentUser!.toJson().toString());
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Invalid email or password';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Sign in failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String phone, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock registration
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        phone: phone,
      );
      _isAuthenticated = true;
      
      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _currentUser!.toJson().toString());
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Sign up failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      
      _currentUser = null;
      _isAuthenticated = false;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Sign out failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? profileImageUrl,
  }) async {
    if (_currentUser == null) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _currentUser = User(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
      );
      
      // Update SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _currentUser!.toJson().toString());
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Profile update failed: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 