import 'package:flutter/material.dart';
import '../../models/match.dart';
import '../../services/api_service.dart';


class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  late Future<List<MatchModel>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = ApiService().fetchMatches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Matches")),
      body: FutureBuilder<List<MatchModel>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No matches found"));
          }

          final matches = snapshot.data!;
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final match = matches[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text("Found Pet: ${match.foundPet.name} (${match.foundPet.type})"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Lost Pet: ${match.lostPet.name} (${match.lostPet.type})"),
                      Text("Description: ${match.foundPet.description}"),
                      Text("Match Score: ${match.score}"),
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
