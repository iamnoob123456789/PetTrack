import 'package:flutter/material.dart';
import 'package:pet_track/models/mock_data.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Using mock data for now
    _allPets = mockPets;
    _filteredPets = _allPets;
    _searchController.addListener(_filterPets);
  }

  void _filterPets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPets = _allPets.where((pet) {
        return pet.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.camera_alt_outlined, size: 48, color: Colors.grey[600]),
                  const SizedBox(height: 8),
                  Text(
                    'Upload a photo',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
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
              child: _filteredPets.isEmpty
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

