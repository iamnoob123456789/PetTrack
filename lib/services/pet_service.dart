import 'package:flutter/foundation.dart';
import '../models/pet.dart';

class PetService extends ChangeNotifier {
  List<Pet> _pets = [];
  List<Pet> _filteredPets = [];
  bool _isLoading = false;
  String _error = '';

  List<Pet> get pets => _pets;
  List<Pet> get filteredPets => _filteredPets;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Mock data for demonstration
  void loadMockData() {
    _pets = [
      Pet(
        id: '1',
        name: 'Buddy',
        type: 'dog',
        breed: 'Golden Retriever',
        color: 'Golden',
        collarColor: 'Blue',
        description: 'Friendly golden retriever with a blue collar. Last seen near Central Park.',
        photoUrls: ['https://example.com/buddy1.jpg'],
        ownerName: 'John Smith',
        ownerPhone: '+1-555-0123',
        ownerEmail: 'john@example.com',
        lastSeenDate: DateTime.now().subtract(const Duration(days: 2)),
        latitude: 40.7589,
        longitude: -73.9851,
        address: 'Central Park, New York',
        status: 'lost',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Pet(
        id: '2',
        name: 'Whiskers',
        type: 'cat',
        breed: 'Persian',
        color: 'White',
        collarColor: 'Red',
        description: 'White Persian cat with red collar. Found near Brooklyn Bridge.',
        photoUrls: ['https://example.com/whiskers1.jpg'],
        ownerName: 'Sarah Johnson',
        ownerPhone: '+1-555-0456',
        ownerEmail: 'sarah@example.com',
        lastSeenDate: DateTime.now().subtract(const Duration(days: 1)),
        latitude: 40.7061,
        longitude: -73.9969,
        address: 'Brooklyn Bridge, New York',
        status: 'found',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
    _filteredPets = _pets;
    notifyListeners();
  }

  Future<void> addPet(Pet pet) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final newPet = pet.copyWith(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: DateTime.now(),
      );
      
      _pets.add(newPet);
      _filteredPets = _pets;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add pet: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePet(Pet pet) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      final index = _pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        _pets[index] = pet;
        _filteredPets = _pets;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update pet: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePet(String petId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      _pets.removeWhere((pet) => pet.id == petId);
      _filteredPets = _pets;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete pet: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchPets({
    String? query,
    String? type,
    String? status,
    String? breed,
  }) {
    _filteredPets = _pets.where((pet) {
      bool matchesQuery = query == null || 
          query.isEmpty ||
          pet.name.toLowerCase().contains(query.toLowerCase()) ||
          pet.breed.toLowerCase().contains(query.toLowerCase()) ||
          pet.description.toLowerCase().contains(query.toLowerCase());
      
      bool matchesType = type == null || pet.type == type;
      bool matchesStatus = status == null || pet.status == status;
      bool matchesBreed = breed == null || pet.breed.toLowerCase().contains(breed.toLowerCase());
      
      return matchesQuery && matchesType && matchesStatus && matchesBreed;
    }).toList();
    
    notifyListeners();
  }

  List<Pet> getPetsByStatus(String status) {
    return _pets.where((pet) => pet.status == status).toList();
  }

  List<Pet> getPetsByType(String type) {
    return _pets.where((pet) => pet.type == type).toList();
  }

  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }
} 