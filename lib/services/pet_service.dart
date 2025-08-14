import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet.dart';

class PetService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Pet> _pets = [];
  List<Pet> _filteredPets = [];
  bool _isLoading = false;
  String _error = '';

  List<Pet> get pets => _pets;
  List<Pet> get filteredPets => _filteredPets;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Initialize Firestore listener
  void initialize() {
    _firestore.collection('pets').snapshots().listen((snapshot) {
      _pets = snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList();
      _filteredPets = _pets;
      notifyListeners();
    });
  }

  Future<void> addPet(Pet pet) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final docRef = await _firestore.collection('pets').add({
        'name': pet.name,
        'type': pet.type,
        'breed': pet.breed,
        'color': pet.color,
        'collarColor': pet.collarColor,
        'description': pet.description,
        'photoUrls': pet.photoUrls,
        'ownerName': pet.ownerName,
        'ownerPhone': pet.ownerPhone,
        'ownerEmail': pet.ownerEmail,
        'lastSeenDate': pet.lastSeenDate,
        'latitude': pet.latitude,
        'longitude': pet.longitude,
        'address': pet.address,
        'status': pet.status,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _pets.add(pet.copyWith(id: docRef.id));
      _filteredPets = _pets;
    } catch (e) {
      _error = 'Failed to add pet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePet(Pet pet) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _firestore.collection('pets').doc(pet.id).update({
        'name': pet.name,
        'type': pet.type,
        'breed': pet.breed,
        'color': pet.color,
        'collarColor': pet.collarColor,
        'description': pet.description,
        'photoUrls': pet.photoUrls,
        'ownerName': pet.ownerName,
        'ownerPhone': pet.ownerPhone,
        'ownerEmail': pet.ownerEmail,
        'lastSeenDate': pet.lastSeenDate,
        'latitude': pet.latitude,
        'longitude': pet.longitude,
        'address': pet.address,
        'status': pet.status,
      });

      final index = _pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        _pets[index] = pet;
        _filteredPets = _pets;
      }
    } catch (e) {
      _error = 'Failed to update pet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePet(String petId) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      await _firestore.collection('pets').doc(petId).delete();
      _pets.removeWhere((pet) => pet.id == petId);
      _filteredPets = _pets;
    } catch (e) {
      _error = 'Failed to delete pet: $e';
    } finally {
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