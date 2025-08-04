import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pet_service.dart';
import '../../models/pet.dart';
import '../../widgets/pet_card.dart';
import 'pet_detail_screen.dart';

class LostPetsScreen extends StatefulWidget {
  const LostPetsScreen({super.key});

  @override
  State<LostPetsScreen> createState() => _LostPetsScreenState();
}

class _LostPetsScreenState extends State<LostPetsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedType = 'All';
  String _selectedBreed = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petService = Provider.of<PetService>(context, listen: false);
      petService.searchPets(status: 'lost');
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
      status: 'lost',
      type: _selectedType == 'All' ? null : _selectedType,
      breed: _selectedBreed == 'All' ? null : _selectedBreed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Pets'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search lost pets...',
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
                          'No lost pets found',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search criteria',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    petService.searchPets(status: 'lost');
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Pets'),
              leading: Radio<String>(
                value: 'All',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Dogs Only'),
              leading: Radio<String>(
                value: 'dog',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Cats Only'),
              leading: Radio<String>(
                value: 'cat',
                groupValue: _selectedType,
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _performSearch();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
} 