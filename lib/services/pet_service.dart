import 'dart:convert';
import 'package:pet_track/config.dart';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_track/models/pet.dart';
import 'package:cross_file/cross_file.dart'; // ✅ XFile base class

class PetService extends ChangeNotifier {
  static String baseUrl = Config.backendUrl;

  List<Pet> _pets = [];
  bool _isLoading = false;
  String _error = '';

  List<Pet> get pets => _pets;
  bool get isLoading => _isLoading;
  String get error => _error;

  void setBaseUrl(String url) {
    baseUrl = url;
  }

  // 🔹 Fetch all pets
  Future<void> fetchPets({String? type}) async {
    _isLoading = true;
    notifyListeners();
    try {
      var url = Uri.parse('$baseUrl/api/pets${type != null ? '?type=$type' : ''}');
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final List<dynamic> data = json.decode(resp.body);
        _pets = data.map((e) => Pet.fromJson(e)).toList();
      } else {
        _error = 'Failed to load pets: ${resp.statusCode}';
      }
    } catch (e) {
      _error = 'Failed to load pets: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔹 Add a pet
  Future<Map<String, dynamic>> addPet({
    required String name,
    required String type,
    String? breed,
    String? description,
    String? ownerPhone,
    DateTime? lastSeenDate,
    String? address,
    required List<XFile> images,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return {'success': false, 'message': 'Not authenticated'};
      }
      final token = await user.getIdToken();

      // Step 1: Upload images to Cloudinary
      List<String> imageUrls = [];
      for (var img in images) {
        print("📤 Uploading ${img.name} to Cloudinary...");

        final uploadUrl = Uri.parse(Config.cloudinaryUrl);
        var uploadReq = http.MultipartRequest("POST", uploadUrl);
        uploadReq.fields["upload_preset"] = Config.cloudinaryUploadPreset;

        var bytes = await img.readAsBytes();
        uploadReq.files.add(http.MultipartFile.fromBytes(
          "file",
          bytes,
          filename: img.name,
        ));

        final uploadResp = await uploadReq.send();
        final uploadBody = await uploadResp.stream.bytesToString();
        print("📥 Cloudinary response: ${uploadResp.statusCode} - $uploadBody");

        if (uploadResp.statusCode == 200) {
          final uploadData = json.decode(uploadBody);
          imageUrls.add(uploadData["secure_url"]);
        } else {
          return {'success': false, 'message': 'Cloudinary upload failed'};
        }
      }

      // Step 2: Send JSON to backend (with correct schema field: photoUrls)
      var uri = Uri.parse('$baseUrl/api/pets');
      final resp = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': name,
          'type': type,
          if (breed != null) 'breed': breed,
          if (description != null) 'description': description,
          if (ownerPhone != null) 'ownerPhone': ownerPhone,
          if (lastSeenDate != null) 'lastSeenDate': lastSeenDate.toIso8601String(),
          if (address != null) 'address': address,
          'ownerEmail': user.email ?? '',
          'ownerName': user.displayName ?? '',
          'ownerId': user.uid, // ✅ required by schema
          'photoUrls': imageUrls, // ✅ match schema
        }),
      );

      print("📥 Backend response: ${resp.statusCode} - ${resp.body}");

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        final body = json.decode(resp.body);
        return {'success': true, 'data': body};
      } else if (resp.statusCode == 401) {
        return {'success': false, 'message': 'Unauthorized'};
      } else {
        return {
          'success': false,
          'message': 'Server error: ${resp.statusCode} - ${resp.body}'
        };
      }
    } catch (e) {
      print("❌ Exception in addPet: $e");
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // 🔹 Find pet by ID
  Pet? getPetById(String id) {
    try {
      return _pets.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // 🔹 Clear errors
  void clearError() {
    _error = '';
    notifyListeners();
  }
}
