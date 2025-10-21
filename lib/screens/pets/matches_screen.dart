import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:pet_track/config.dart';
import 'package:pet_track/models/pet.dart';
import 'package:pet_track/widgets/pet_list_card.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  List<Pet> _allPets = [];
  List<Pet> _filteredPets = [];
  List<Pet> _matchedPets = [];
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _uploadedImage;
  bool _isLoadingMatches = false;

  @override
  void initState() {
    super.initState();
    _fetchAllPets();
    _searchController.addListener(_filterPets);
  }
  
  void _filterPets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPets = _allPets.where((pet) {
        return (pet.name?.toLowerCase()?.contains(query) ?? false) ||
               (pet.breed?.toLowerCase()?.contains(query) ?? false) ||
               (pet.description?.toLowerCase()?.contains(query) ?? false);
      }).toList();
    });
  }

  Future<void> _fetchAllPets() async {
    try {
      final response = await http.get(Uri.parse('${Config.backendUrl}/pets'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _allPets = data.map((json) => Pet.fromJson(json)).toList();
          _filteredPets = _allPets;
        });
      } else {
        // Fallback to mock data if API fails
        setState(() {
          _allPets = [];
          _filteredPets = _allPets;
        });
      }
    } catch (e) {
      print('Error fetching pets: $e');
      setState(() {
        _allPets = [];
        _filteredPets = _allPets;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImage = File(pickedFile.path);
      });
      await _findMatches();
    }
  }

  Future<void> _findMatches() async {
    if (_uploadedImage == null) return;

    setState(() {
      _isLoadingMatches = true;
    });

    try {
      // Upload image to Python backend for matching
      final bytes = await _uploadedImage!.readAsBytes();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.backendUrl}/pets/matches/upload'),
      );

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: 'image.jpg',
      ));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = json.decode(responseBody);
        final matches = data['matches'] as List<dynamic>;

        // Convert matches to Pet objects
        final matchedPets = matches.map((match) {
          final petData = match['pet'];
          return Pet.fromJson(petData);
        }).toList();

        setState(() {
          _matchedPets = matchedPets;
          _isLoadingMatches = false;
        });
      } else {
        throw Exception('Failed to find matches');
      }
    } catch (e) {
      print('Error finding matches: $e');
      setState(() {
        _isLoadingMatches = false;
        _matchedPets = [];
      });
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding matches: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Pets'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Photo Upload Area
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _uploadedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _uploadedImage!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[600]),
                    const SizedBox(height: 8),
                    Text(
                      _uploadedImage != null ? 'Tap to change image' : 'Upload a photo',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 16),
            // Pet List
            Expanded(
              child: _isLoadingMatches
                  ? const Center(child: CircularProgressIndicator())
                  : _uploadedImage != null
                      ? _matchedPets.isEmpty
                          ? const Center(child: Text('No matching pets found.'))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Matching Pets',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _matchedPets.length,
                                    itemBuilder: (context, index) {
                                      return PetListCard(pet: _matchedPets[index]);
                                    },
                                  ),
                                ),
                              ],
                            )
                      : _filteredPets.isEmpty
                          ? const Center(child: Text('No pets found.'))
                          : ListView.builder(
                              itemCount: _filteredPets.length,
                              itemBuilder: (context, index) {
                                return PetListCard(pet: _filteredPets[index]);
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

