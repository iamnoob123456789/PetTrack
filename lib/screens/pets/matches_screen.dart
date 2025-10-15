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
              final lost = m['lostPet'] ?? m['lost_pet'] ?? m['lost'] ?? {};
              final found = m['foundPet'] ?? m['found_pet'] ?? m['found'] ?? {};
              final score = m['score'] ?? m['matchScore'] ?? '';
              return ListTile(
                leading: lost['images'] != null && lost['images'].isNotEmpty
                    ? Image.network(lost['images'][0], width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.pets),
                title: Text(lost['name'] ?? found['name'] ?? 'Unknown'),
                subtitle: Text('Score: $score'),
                onTap: () {
                  // implement navigation to detail if needed
                },
              );
            },
          );
        },
      ),
    );
  }
}
