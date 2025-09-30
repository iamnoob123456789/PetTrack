import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';
import '../theme/app_theme.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for admin dashboard
    final List<Map<String, dynamic>> posts = [
      {
        'image': 'assets/images/dog1.jpg',
        'breed': 'Golden Retriever',
        'location': 'Central Park',
        'status': 'Lost',
        'owner': 'John Doe',
      },
      {
        'image': 'assets/images/cat1.jpg',
        'breed': 'Siamese',
        'location': 'Downtown',
        'status': 'Found',
        'owner': 'Jane Smith',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppTheme.pastelBlue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return PetCard(
            image: post['image'],
            breed: post['breed'],
            location: post['location'],
            status: post['status'],
            onTap: () {},
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    // Approve post logic
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    // Remove post logic
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.flag, color: Colors.orange),
                  onPressed: () {
                    // Flag post logic
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
