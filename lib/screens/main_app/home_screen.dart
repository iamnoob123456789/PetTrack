import 'package:flutter/material.dart';
import '../components/pet_card.dart';
import '../lib/mock_data.dart';
import '../lib/types.dart';
import './ui/badge.dart';
import './ui/select.dart';

class HomeScreen extends StatefulWidget {
  final Function(Pet) onPetClick;

  const HomeScreen({super.key, required this.onPetClick});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filterStatus = 'all';

  List<Pet> get _filteredPets {
    return _filterStatus == 'all'
        ? mockPets
        : mockPets.where((pet) => pet.status == _filterStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: _buildHeader(),
            pinned: true,
            backgroundColor: Colors.transparent,
          ),
          // Filter Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _FilterBarDelegate(
              filterStatus: _filterStatus,
              onFilterChanged: (value) {
                setState(() {
                  _filterStatus = value;
                });
              },
            ),
          ),
          // Pet Feed
          _buildPetFeed(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 32),
        child: Column(
          children: [
            // App Bar
            _buildAppBar(),
            const SizedBox(height: 24),
            // Stats
            _buildStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PetTrack',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Text(
              'Helping reunite families with their pets',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
        // Notification bell
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Icon(
                Icons.notifications,
                size: 24,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    final lostCount = mockPets.where((pet) => pet.status == 'lost').length;
    final foundCount = mockPets.where((pet) => pet.status == 'found').length;
    final reunitedCount = mockPets.where((pet) => pet.status == 'reunited').length;

    return Row(
      children: [
        _buildStatCard(lostCount, 'Lost'),
        const SizedBox(width: 12),
        _buildStatCard(foundCount, 'Found'),
        const SizedBox(width: 12),
        _buildStatCard(reunitedCount, 'Reunited'),
      ],
    );
  }

  Widget _buildStatCard(int count, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetFeed() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Header with count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Reports',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Badge(
                child: Text('${_filteredPets.length} pets'),
                variant: BadgeVariant.secondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Pet grid
          if (_filteredPets.isEmpty)
            _buildEmptyState()
          else
            _buildPetGrid(),
        ]),
      ),
    );
  }

  Widget _buildPetGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredPets.length,
      itemBuilder: (context, index) {
        final pet = _filteredPets[index];
        return PetCard(
          pet: pet,
          onTap: () => widget.onPetClick(pet),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Text(
        'No pets found with the selected filter.',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FilterBarDelegate extends SliverPersistentHeaderDelegate {
  final String filterStatus;
  final Function(String) onFilterChanged;

  _FilterBarDelegate({
    required this.filterStatus,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.background.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.filter_list,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Select(
                value: filterStatus,
                onChanged: onFilterChanged,
                items: const [
                  SelectItem(value: 'all', label: 'All Pets'),
                  SelectItem(value: 'lost', label: 'Lost Only'),
                  SelectItem(value: 'found', label: 'Found Only'),
                  SelectItem(value: 'reunited', label: 'Reunited'),
                ],
                placeholder: 'Filter by status',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}