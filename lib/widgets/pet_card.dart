import 'package:flutter/material.dart';
import './ui/badge.dart';
import './figma/image_with_fallback.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onTap;

  const PetCard({
    super.key,
    required this.pet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            _buildImageSection(context),
            // Content section
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final statusColor = _getStatusColor(context);
    
    return Stack(
      children: [
        // Pet image
        AspectRatio(
          aspectRatio: 4 / 3,
          child: ImageWithFallback(
            src: pet.imageUrl,
            alt: pet.name ?? pet.breed,
            fit: BoxFit.cover,
          ),
        ),
        // Status badge
        Positioned(
          top: 12,
          right: 12,
          child: Badge(
            child: Text(
              pet.status.name,
              style: const TextStyle(fontSize: 12),
            ),
            variant: _getBadgeVariant(pet.status),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          _buildTitleSection(),
          const SizedBox(height: 12),
          // Details section
          _buildDetailsSection(theme),
          // Tags section
          if (pet.tags.isNotEmpty) _buildTagsSection(),
          // Reporter section
          _buildReporterSection(theme),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pet.name ?? 'Unknown Name',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          pet.breed,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(ThemeData theme) {
    return Column(
      children: [
        _buildDetailRow(
          icon: Icons.location_on,
          text: pet.location.address,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        _buildDetailRow(
          icon: Icons.calendar_today,
          text: _formatDate(pet.lastSeen),
          color: theme.colorScheme.primary,
        ),
        if (pet.hasCollar) ...[
          const SizedBox(height: 4),
          _buildDetailRow(
            icon: Icons.local_offer,
            text: '${pet.collarColor} collar',
            color: theme.colorScheme.secondary,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          for (final tag in pet.tags.take(3))
            Badge(
              child: Text(
                tag,
                style: const TextStyle(fontSize: 11),
              ),
              variant: BadgeVariant.secondary,
            ),
        ],
      ),
    );
  }

  Widget _buildReporterSection(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withOpacity(0.2),
            ),
          ),
        ),
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Posted by ',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              TextSpan(
                text: pet.userName,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BadgeVariant _getBadgeVariant(PetStatus status) {
    switch (status) {
      case PetStatus.lost:
        return BadgeVariant.destructive;
      case PetStatus.found:
        return BadgeVariant.secondary;
      case PetStatus.reunited:
        return BadgeVariant.primary;
    }
  }

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (pet.status) {
      case PetStatus.lost:
        return theme.colorScheme.error;
      case PetStatus.found:
        return theme.colorScheme.secondary;
      case PetStatus.reunited:
        return theme.colorScheme.primary;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Pet model (you'll need to create this)
class Pet {
  final String? name;
  final String breed;
  final String imageUrl;
  final PetStatus status;
  final PetLocation location;
  final DateTime lastSeen;
  final bool hasCollar;
  final String collarColor;
  final List<String> tags;
  final String userName;

  const Pet({
    this.name,
    required this.breed,
    required this.imageUrl,
    required this.status,
    required this.location,
    required this.lastSeen,
    required this.hasCollar,
    required this.collarColor,
    required this.tags,
    required this.userName,
  });
}

class PetLocation {
  final String address;

  const PetLocation({required this.address});
}

enum PetStatus {
  lost,
  found,
  reunited,
  
  String get name {
    switch (this) {
      case PetStatus.lost:
        return 'lost';
      case PetStatus.found:
        return 'found';
      case PetStatus.reunited:
        return 'reunited';
    }
  }
}