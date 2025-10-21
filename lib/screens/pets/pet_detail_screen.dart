import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pet_track/models/pet.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

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
            onPressed: _sharePetDetails,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPetImage(),
            const SizedBox(height: 20),
            _buildStatusBadge(),
            const SizedBox(height: 20),
            _buildPetInfoCard(context),
            const SizedBox(height: 16),
            _buildOwnerInfoCard(context),
            const SizedBox(height: 16),
            _buildLocationCard(context),
            if (pet.type == 'found') _buildContactButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPetImage() {
    return Hero(
      tag: 'pet-image-${pet.id}',
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: pet.photoUrls.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pet.photoUrls.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPetPlaceholder();
                  },
                ),
              )
            : _buildPetPlaceholder(),
      ),
    );
  }

  Widget _buildPetPlaceholder() {
    return Center(
      child: Icon(
        Icons.pets, // Simplified placeholder
        size: 80,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildStatusBadge() {
    final isLost = pet.type == 'lost';
    final statusText = pet.status ?? pet.type; // Fallback to type if status is null

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLost ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isLost ? Colors.red : Colors.green,
        ),
      ),
      child: Text(
        statusText.toUpperCase(),
        style: TextStyle(
          color: isLost ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPetInfoCard(BuildContext context) {
    return Card(
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
            _buildInfoRow('Breed', pet.breed ?? 'N/A'),
            _buildInfoRow('Color', pet.color ?? 'N/A'),
            if (pet.collarColor != null && pet.collarColor!.isNotEmpty)
              _buildInfoRow('Collar Color', pet.collarColor!),
            if (pet.description != null && pet.description!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(pet.description!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerInfoCard(BuildContext context) {
    return Card(
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
            _buildInfoRow('Name', pet.ownerName ?? 'N/A'),
            _buildInfoRow('Phone', pet.ownerPhone ?? 'N/A'),
            _buildInfoRow('Email', pet.ownerEmail ?? 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Card(
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
            _buildInfoRow('Address', pet.address ?? 'N/A'),
            if (pet.lastSeenDate != null)
              _buildInfoRow('Last Seen', _dateFormat.format(pet.lastSeenDate!)),
            if (pet.createdAt != null)
              _buildInfoRow('Posted', _dateFormat.format(pet.createdAt!)),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: (pet.ownerPhone != null) ? _callOwner : null,
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
            onPressed: (pet.ownerPhone != null) ? _messageOwner : null,
            icon: const Icon(Icons.message),
            label: const Text('Send Message'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
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

  Future<void> _callOwner() async {
    if (pet.ownerPhone == null) return;
    final phoneUrl = Uri.parse('tel:${pet.ownerPhone}');
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    }
  }

  Future<void> _messageOwner() async {
    if (pet.ownerPhone == null) return;
    final smsUrl = Uri.parse('sms:${pet.ownerPhone}');
    if (await canLaunchUrl(smsUrl)) {
      await launchUrl(smsUrl);
    }
  }

  Future<void> _sharePetDetails() async {
    // Implement share functionality using share_plus package
    // Example: await Share.share('Check out this ${pet.type} pet: ${pet.name}');
  }
}