import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pet_service.dart';
import '../../models/pet.dart';
import '../../widgets/pet_card.dart';
import 'pet_detail_screen.dart';

class FoundPetsScreen extends StatefulWidget {
  const FoundPetsScreen({super.key});

  @override
  State<FoundPetsScreen> createState() => _FoundPetsScreenState();
}

class _FoundPetsScreenState extends State<FoundPetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petService = Provider.of<PetService>(context, listen: false);
      petService.searchPets(status: 'found');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final petService = Provider.of<PetService>(context, listen: false);
    petService.searchPets(
      query: _searchController.text,
      status: 'found',
      type: _selectedType == 'All' ? null : _selectedType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Pets'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search found pets...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                _performSearch();
              },
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', _selectedType == 'All', (value) {
                  setState(() {
                    _selectedType = value;
                  });
                  _performSearch();
                }),
                const SizedBox(width: 8),
                _buildFilterChip('Dogs', _selectedType == 'dog', (value) {
                  setState(() {
                    _selectedType = value;
                  });
                  _performSearch();
                }),
                const SizedBox(width: 8),
                _buildFilterChip('Cats', _selectedType == 'cat', (value) {
                  setState(() {
                    _selectedType = value;
                  });
                  _performSearch();
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Pets List
          Expanded(
            child: Consumer<PetService>(
              builder: (context, petService, child) {
                if (petService.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (petService.filteredPets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No found pets',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Found a pet? Add it to help reunite with owner',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    petService.searchPets(status: 'found');
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: petService.filteredPets.length,
                    itemBuilder: (context, index) {
                      final pet = petService.filteredPets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: PetCard(
                          pet: pet,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PetDetailScreen(pet: pet),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Function(String) onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onSelected(selected ? label.toLowerCase() : 'All');
      },
      selectedColor: const Color(0xFF2196F3).withOpacity(0.2),
      checkmarkColor: const Color(0xFF2196F3),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF2196F3) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
} 