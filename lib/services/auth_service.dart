import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      // Check current auth state synchronously first
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _loadUserFromFirestore(currentUser.uid);
        _isAuthenticated = true;
      }

      // Set up auth state listener for future changes
      _auth.authStateChanges().listen((fb.User? user) async {
        _isLoading = true;
        notifyListeners();

        try {
          if (user != null) {
            await _loadUserFromFirestore(user.uid);
            _isAuthenticated = true;
          } else {
            _currentUser = null;
            _isAuthenticated = false;
          }
        } finally {
          _isLoading = false;
          notifyListeners();
        }
      });
    } catch (e) {
      _error = 'Initialization failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadUserFromFirestore(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        _currentUser = User.fromJson(doc.data()!);
      } else {
        _error = 'User document not found';
      }
    } catch (e) {
      _error = 'Failed to load user: $e';
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final creds = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _loadUserFromFirestore(creds.user!.uid);
      _isAuthenticated = true;
      return true;
    } on fb.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Login failed';
      return false;
    } catch (e) {
      _error = 'Unexpected error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String name, String email, String phone, String password) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // 1. Create Firebase auth user
      final creds = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Create user document in Firestore
      final uid = creds.user!.uid;
      await _firestore.collection('users').doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'profileImageUrl': null,
      });

      // 3. Update local state
      _currentUser = User(
        id: uid,
        name: name,
        email: email,
        phone: phone,
      );
      _isAuthenticated = true;
      
      return true;
    } on fb.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Signup failed';
      return false;
    } catch (e) {
      _error = 'Unexpected error occurred';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      _isAuthenticated = false;
    } catch (e) {
      _error = 'Sign out failed: $e';
    } finally {
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
    notifyListeners();

    try {
      final updatedUser = User(
        id: _currentUser!.id,
        name: name ?? _currentUser!.name,
        email: _currentUser!.email,
        phone: phone ?? _currentUser!.phone,
        profileImageUrl: profileImageUrl ?? _currentUser!.profileImageUrl,
      );

      await _firestore
          .collection('users')
          .doc(_currentUser!.id)
          .update(updatedUser.toJson());

      _currentUser = updatedUser;
    } catch (e) {
      _error = 'Profile update failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}