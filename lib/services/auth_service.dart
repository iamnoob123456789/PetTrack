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

  /// Load current user if already logged in
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fb.User? firebaseUser = _auth.currentUser;
      if (firebaseUser != null) {
        await _loadUserFromFirestore(firebaseUser.uid);
        _isAuthenticated = true;
      }
    } catch (e) {
      _error = 'Initialization failed: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Load user details from Firestore
  Future<void> _loadUserFromFirestore(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      _currentUser = User.fromJson(doc.data()!);
    }
  }

  /// Sign in user
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

      _isLoading = false;
      notifyListeners();
      return true;
    } on fb.FirebaseAuthException catch (e) {
      _error = e.message ?? 'Login failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign up new user
 Future<bool> signUp(String name, String email, String phone, String password) async {
  _isLoading = true;
  _error = '';
  notifyListeners();

  try {
    // Create account in Firebase Auth
    final creds = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = creds.user!.uid;
    _currentUser = User(
      id: uid,
      name: name,
      email: email,
      phone: phone,
    );

    // Save to Firestore
    await _firestore.collection('users').doc(uid).set(_currentUser!.toJson());

    _isAuthenticated = true;
    _isLoading = false;
    notifyListeners();
    return true;

  } on fb.FirebaseAuthException catch (e) {
    _error = e.message ?? 'Signup failed (Auth)';
  } on FirebaseException catch (e) {
    _error = e.message ?? 'Signup failed (Database)';
  } catch (e) {
    _error = e.toString();
  }

  _isLoading = false;
  notifyListeners();
  return false;
}


  /// Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Update profile info in Firestore
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

      await _firestore.collection('users').doc(_currentUser!.id).update(updatedUser.toJson());

      _currentUser = updatedUser;
    } catch (e) {
      _error = 'Profile update failed: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
}
