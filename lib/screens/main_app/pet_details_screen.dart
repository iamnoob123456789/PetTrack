import 'package:flutter/material.dart';
import '../widgets/ui/button.dart';
import '../widgets/ui/badge.dart';
import '../widgets/ui/input.dart';
import '../widgets/ui/label.dart';
import '../widgets/ui/textarea.dart';
import '../widgets/ui/avatar.dart';
import '../widgets/figma/image_with_fallback.dart';
import '../models/pet_model.dart';
import '../services/toast_service.dart';

class PetDetailsScreen extends StatefulWidget {
  final Pet pet;
  final VoidCallback onBack;

  const PetDetailsScreen({
    super.key,
    required this.pet,
    required this.onBack,
  });

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  bool _showReportDialog = false;

  void _handleShare() {
    ToastService.showSuccess('Share link copied to clipboard!');
  }

  void _handleReportSighting() {
    ToastService.showSuccess('Sighting report submitted!');
    setState(() => _showReportDialog = false);
  }

  void _showReportDialogFunc() {
    setState(() => _showReportDialog = true);
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header Image
              SliverAppBar(
                expandedHeight: 400,
                flexibleSpace: _buildHeaderImage(),
                pinned: true,
                backgroundColor: Colors.transparent,
              ),
              // Content
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildContent(),
                ]),
              ),
            ],
          ),
          // Back Button
          Positioned(
            top: 48,
            left: 16,
            child: _buildBackButton(),
          ),
          // Share Button
          Positioned(
            top: 48,
            right: 16,
            child: _buildShareButton(),
          ),
          // Status Badge
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: _buildStatusBadge(),
          ),
          // Report Dialog
          if (_showReportDialog) _buildReportDialog(),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        ImageWithFallback(
          src: widget.pet.imageUrl,
          alt: widget.pet.name ?? widget.pet.breed,
          width: double.infinity,
          height: 400,
          fit: BoxFit.cover,
        ),
        // Overlay gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Theme.of(context).colorScheme.background.withOpacity(0.7),
                Theme.of(context).colorScheme.background,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: IconButton(
        onPressed: widget.onBack,
        icon: Icon(
          Icons.arrow_back,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: IconButton(
        onPressed: _handleShare,
        icon: Icon(
          Icons.share,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Align(
      child: Badge(
        child: Text(
          widget.pet.status.name,
          style: const TextStyle(fontSize: 16),
        ),
        variant: _getBadgeVariant(widget.pet.status),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: -20),
      child: Column(
        children: [
          // Main Info Card
          _buildMainInfoCard(),
          const SizedBox(height: 16),
          // Owner Info Card
          _buildOwnerInfoCard(),
          const SizedBox(height: 16),
          // Action Buttons
          _buildActionButtons(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMainInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            widget.pet.name ?? 'Unknown Name',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.pet.breed,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),

          // Details Grid
          _buildDetailsGrid(),
          const SizedBox(height: 24),

          // Color
          _buildDetailSection('Color/Markings', widget.pet.color),
          const SizedBox(height: 24),

          // Description
          _buildDetailSection('Description', widget.pet.description),
          const SizedBox(height: 24),

          // Tags
          if (widget.pet.tags.isNotEmpty) _buildTagsSection(),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Column(
      children: [
        _buildDetailRow(
          icon: Icons.location_on,
          title: 'Last Seen Location',
          value: widget.pet.location.address,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        _buildDetailRow(
          icon: Icons.calendar_today,
          title: 'Date',
          value: _formatDate(widget.pet.lastSeen),
          color: Theme.of(context).colorScheme.secondary,
        ),
        if (widget.pet.hasCollar) ...[
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.local_offer,
            title: 'Collar',
            value: '${widget.pet.collarColor} collar',
            color: Theme.of(context).colorScheme.tertiary ?? Theme.of(context).colorScheme.secondary,
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final tag in widget.pet.tags)
              Badge(
                child: Text(tag),
                variant: BadgeVariant.secondary,
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildOwnerInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posted By',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          // Owner Avatar and Name
          Row(
            children: [
              Avatar(
                alt: widget.pet.userName,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pet.userName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Member since ${widget.pet.createdAt.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Contact Info
          if (widget.pet.userPhone != null) _buildContactItem(
            icon: Icons.phone,
            value: widget.pet.userPhone!,
            onTap: () => _makePhoneCall(widget.pet.userPhone!),
          ),
          if (widget.pet.userEmail != null) _buildContactItem(
            icon: Icons.email,
            value: widget.pet.userEmail!,
            onTap: () => _sendEmail(widget.pet.userEmail!),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CustomButton(
            onPressed: _showReportDialogFunc,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                Text('Report Sighting'),
              ],
            ),
            fullWidth: true,
            size: ButtonSize.large,
          ),
          const SizedBox(height: 12),
          CustomButton(
            onPressed: () {
              ToastService.showSuccess('Issue reported!');
            },
            variant: ButtonVariant.outline,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flag, size: 20),
                const SizedBox(width: 8),
                Text('Report Issue'),
              ],
            ),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildReportDialog() {
    return Stack(
      children: [
        // Backdrop
        GestureDetector(
          onTap: () => setState(() => _showReportDialog = false),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        // Dialog Content
        Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report a Sighting',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                // Location Input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(child: Text('Location')),
                    const SizedBox(height: 8),
                    Input(
                      controller: _locationController,
                      placeholder: 'Where did you see this pet?',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Details Textarea
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(child: Text('Additional Details')),
                    const SizedBox(height: 8),
                    Textarea(
                      controller: _detailsController,
                      placeholder: 'Any additional information...',
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: _handleReportSighting,
                  child: Text('Submit Report'),
                  fullWidth: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _makePhoneCall(String phoneNumber) {
    // This would use url_launcher package in real app
    ToastService.showSuccess('Calling $phoneNumber');
  }

  void _sendEmail(String email) {
    // This would use url_launcher package in real app
    ToastService.showSuccess('Emailing $email');
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