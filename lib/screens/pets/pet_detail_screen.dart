import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/pet.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Images
            if (pet.photoUrls.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    pet.photoUrls.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        pet.type == 'dog' ? Icons.pets : Icons.pets,
                        size: 80,
                        color: Colors.grey[400],
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: pet.status == 'lost'
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: pet.status == 'lost' ? Colors.red : Colors.green,
                ),
              ),
              child: Text(
                pet.status.toUpperCase(),
                style: TextStyle(
                  color: pet.status == 'lost' ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Pet Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pet Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', pet.name),
                    _buildInfoRow('Type', pet.type.toUpperCase()),
                    _buildInfoRow('Breed', pet.breed),
                    _buildInfoRow('Color', pet.color),
                    if (pet.collarColor.isNotEmpty)
                      _buildInfoRow('Collar Color', pet.collarColor),
                    if (pet.description.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(pet.description),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Owner Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Owner Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', pet.ownerName),
                    _buildInfoRow('Phone', pet.ownerPhone),
                    _buildInfoRow('Email', pet.ownerEmail),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Location Information
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Address', pet.address),
                    _buildInfoRow('Last Seen', DateFormat('MMM dd, yyyy').format(pet.lastSeenDate)),
                    _buildInfoRow('Posted', DateFormat('MMM dd, yyyy').format(pet.createdAt)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Contact Actions
            if (pet.status == 'found')
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Call functionality
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call Owner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // Message functionality
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Send Message'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 