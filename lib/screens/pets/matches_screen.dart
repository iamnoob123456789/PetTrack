import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late Future<List<dynamic>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = ApiService().fetchMatches();
  }

  /// Builds a pet info column
  Widget _buildPetInfo(Map<String, dynamic> pet, String label) {
    if (pet.isEmpty) return const SizedBox.shrink();

    final imageUrl = (pet['photoUrls'] != null && pet['photoUrls'].isNotEmpty)
        ? pet['photoUrls'][0]
        : pet['image_url'] ?? '';
    final name = pet['name'] ?? 'Unknown';
    final breed = pet['breed'] ?? 'Unknown';
    final color = pet['color'] ?? 'Unknown';
    final description = pet['description'] ?? '';
    final ownerName = pet['ownerName'] ?? pet['reporterName'] ?? 'Unknown';
    final ownerPhone = pet['ownerPhone'] ?? pet['reporterPhone'] ?? 'Unknown';
    final date = pet['createdAt'] ?? 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: $name', style: const TextStyle(fontWeight: FontWeight.bold)),
        if (breed != 'Unknown') Text('Breed: $breed'),
        if (color != 'Unknown') Text('Color: $color'),
        if (description.isNotEmpty) Text('Description: $description'),
        Text('Owner: $ownerName'),
        Text('Phone: $ownerPhone'),
        Text('Date: $date'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Matches')),
      body: FutureBuilder<List<dynamic>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No matches yet'));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final m = matches[index];

              // Cast maps to avoid LinkedMap issues
              final lost = Map<String, dynamic>.from(m['lostPet'] ?? m['lost_pet'] ?? m['lost'] ?? {});
              final found = Map<String, dynamic>.from(m['foundPet'] ?? m['found_pet'] ?? m['found'] ?? {});
              final score = m['score'] ?? m['matchScore'] ?? '';

              final lostImage = (lost['photoUrls'] != null && lost['photoUrls'].isNotEmpty)
                  ? lost['photoUrls'][0]
                  : lost['image_url'] ?? '';
              final foundImage = (found['photoUrls'] != null && found['photoUrls'].isNotEmpty)
                  ? found['photoUrls'][0]
                  : found['image_url'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          lostImage.isNotEmpty
                              ? Image.network(lostImage, width: 80, height: 80, fit: BoxFit.cover)
                              : const Icon(Icons.pets, size: 80),
                          const SizedBox(height: 8),
                          foundImage.isNotEmpty
                              ? Image.network(foundImage, width: 80, height: 80, fit: BoxFit.cover)
                              : const Icon(Icons.pets, size: 80),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Score: $score', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            _buildPetInfo(lost, 'Lost Pet'),
                            const SizedBox(height: 8),
                            _buildPetInfo(found, 'Found Pet'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
