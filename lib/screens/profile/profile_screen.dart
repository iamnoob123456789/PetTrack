import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          final user = authService.currentUser;
          
          if (user == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(0xFF2196F3),
                          child: user.profileImageUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    user.profileImageUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.phone,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Lost Pets',
                        '0',
                        Icons.search,
                        Colors.red,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Found Pets',
                        '0',
                        Icons.pets,
                        Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        'Reunited',
                        '0',
                        Icons.favorite,
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Menu Items
                Card(
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        icon: Icons.pets,
                        title: 'My Pets',
                        subtitle: 'View your lost and found pets',
                        onTap: () {
                          // Navigate to my pets
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.notifications,
                        title: 'Notifications',
                        subtitle: 'Manage your notifications',
                        onTap: () {
                          // Navigate to notifications
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.location_on,
                        title: 'Location Settings',
                        subtitle: 'Manage location permissions',
                        onTap: () {
                          // Navigate to location settings
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.security,
                        title: 'Privacy',
                        subtitle: 'Privacy and data settings',
                        onTap: () {
                          // Navigate to privacy settings
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.help,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        onTap: () {
                          // Navigate to help
                        },
                      ),
                      _buildMenuItem(
                        context,
                        icon: Icons.info,
                        title: 'About',
                        subtitle: 'App version and information',
                        onTap: () {
                          // Navigate to about
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sign Out Button
                CustomButton(
                  text: 'Sign Out',
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await authService.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2196F3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2196F3),
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
} 