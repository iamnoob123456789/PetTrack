import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_track/screens/auth/login_screen.dart';
import 'package:pet_track/widgets/home_nav_button.dart';
import 'pets/lost_pets_screen.dart';
import 'pets/found_pets_screen.dart';
import 'pets/add_pet_screen.dart';
import 'pets/matches_screen.dart';
import 'maps/maps_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back, $displayName!'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like to do?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                HomeNavButton(
                  title: 'Report Lost Pet',
                  subtitle: 'Help find your missing companion',
                  icon: Icons.error_outline,
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LostPetsScreen()),
                    );
                  },
                ),
                HomeNavButton(
                  title: 'Report Found Pet',
                  subtitle: 'Help reunite someone pet',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FoundPetsScreen()),
                    );
                  },
                ),
                HomeNavButton(
                  title: 'Search Pets',
                  subtitle: 'Find pets in your area',
                  icon: Icons.search,
                  color: Colors.blueAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MatchesScreen()),
                    );
                  },
                ),
                HomeNavButton(
                  title: 'Maps',
                  subtitle: 'View pets on a map',
                  icon: Icons.map_outlined,
                  color: Colors.purpleAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapsScreen()),
                    );
                  },
                ),
                HomeNavButton(
                  title: 'Post Pet',
                  subtitle: 'Report a lost or found pet',
                  icon: Icons.add,
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPetScreen()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

