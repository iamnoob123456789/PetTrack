import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/pet_service.dart';
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
    // Initialize with lost pets only
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PetService>(context, listen: false)
          .searchPets(status: 'lost');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    Provider.of<PetService>(context, listen: false).searchPets(
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
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Consumer<PetService>(
        builder: (context, petService, _) {
          return Column(
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
                  onChanged: (_) => _performSearch(),
                ),
              ),

              // Filter Chips
              _buildFilterChips(),

              // Pets List
              Expanded(
                child: _buildPetList(petService),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['All', 'dog', 'cat'].map((type) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(type == 'All' ? 'All' : type == 'dog' ? 'Dogs' : 'Cats'),
              selected: _selectedType == type,
              onSelected: (selected) {
                setState(() => _selectedType = selected ? type : 'All');
                _performSearch();
              },
              selectedColor: const Color(0xFF2196F3).withOpacity(0.2),
              checkmarkColor: const Color(0xFF2196F3),
              labelStyle: TextStyle(
                color: _selectedType == type 
                    ? const Color(0xFF2196F3) 
                    : Colors.grey[700],
                fontWeight: _selectedType == type 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPetList(PetService petService) {
    if (petService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (petService.filteredPets.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async => _performSearch(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: petService.filteredPets.length,
        itemBuilder: (context, index) {
          final pet = petService.filteredPets[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: PetCard(
              pet: pet,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PetDetailScreen(pet: pet),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...['All', 'dog', 'cat'].map((type) {
              return ListTile(
                title: Text(type == 'All' ? 'All Pets' : 
                          type == 'dog' ? 'Dogs Only' : 'Cats Only'),
                leading: Radio<String>(
                  value: type,
                  groupValue: _selectedType,
                  onChanged: (value) {
                    setState(() => _selectedType = value!);
                  },
                ),
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
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