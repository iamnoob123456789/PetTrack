import 'package:flutter/material.dart';
import '../widgets/ui/badge.dart';
import '../widgets/ui/button.dart';
import '../widgets/ui/input.dart';
import '../widgets/ui/card.dart'; // We'll create this
import '../services/toast_service.dart'; // We'll create this

class AdminScreen extends StatefulWidget {
  final VoidCallback onBack;

  const AdminScreen({super.key, required this.onBack});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _activeTab = 'overview';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 160,
            flexibleSpace: _buildHeader(),
            pinned: true,
            backgroundColor: Colors.transparent,
          ),
          // Main Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Tabs
                _buildTabs(),
                const SizedBox(height: 24),
                // Tab Content
                _buildTabContent(),
              ]),
            ),
          ),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: widget.onBack,
                  variant: ButtonVariant.ghost,
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 20),
                      const SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                Badge(
                  child: Text('Admin'),
                  variant: BadgeVariant.secondary,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Title
            Text(
              'Admin Dashboard',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage and monitor the PetTrack platform',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = [
      _TabItem(id: 'overview', label: 'Overview', icon: Icons.bar_chart),
      _TabItem(id: 'posts', label: 'Posts', icon: Icons.pets),
      _TabItem(id: 'users', label: 'Users', icon: Icons.people),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final tab in tabs)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CustomButton(
                onPressed: () => setState(() => _activeTab = tab.id),
                variant: _activeTab == tab.id 
                    ? ButtonVariant.primary 
                    : ButtonVariant.outline,
                child: Row(
                  children: [
                    Icon(tab.icon, size: 16),
                    const SizedBox(width: 8),
                    Text(tab.label),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 'overview':
        return _buildOverviewTab();
      case 'posts':
        return _buildPostsTab();
      case 'users':
        return _buildUsersTab();
      default:
        return _buildOverviewTab();
    }
  }

  Widget _buildOverviewTab() {
    return Column(
      children: [
        // Statistics Cards
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(
              title: 'Total Posts',
              value: '12',
              subtitle: '+3 this week',
              icon: Icons.trending_up,
              color: Theme.of(context).colorScheme.secondary,
            ),
            _buildStatCard(
              title: 'Lost Pets',
              value: '8',
              subtitle: 'Needs attention',
              icon: Icons.warning,
              color: Theme.of(context).colorScheme.error,
            ),
            _buildStatCard(
              title: 'Found Pets',
              value: '3',
              subtitle: 'Available',
              icon: Icons.check_circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
            _buildStatCard(
              title: 'Reunited',
              value: '1',
              subtitle: 'Success stories',
              icon: Icons.pets,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Recent Activity
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Latest posts and updates',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No recent activity',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return Column(
      children: [
        // Search
        Input(
          placeholder: 'Search posts...',
          prefixIcon: Icon(Icons.search, size: 20),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        const SizedBox(height: 16),
        // Posts List
        Card(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                'No posts to display',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsersTab() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'View and manage registered users',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Text(
                  'No users to display',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final String id;
  final String label;
  final IconData icon;

  const _TabItem({
    required this.id,
    required this.label,
    required this.icon,
  });
}