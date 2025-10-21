import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_track/config.dart';
import 'package:pet_track/models/pet.dart';
import 'package:pet_track/widgets/pet_list_card.dart';
import 'package:pet_track/widgets/summary_card.dart';
import 'package:pet_track/models/mock_data.dart';

class LostPetsScreen extends StatefulWidget {
  const LostPetsScreen({super.key});

  @override
  State<LostPetsScreen> createState() => _LostPetsScreenState();
}

class _LostPetsScreenState extends State<LostPetsScreen> {
  late Future<List<Pet>> _futureLostPets;

  @override
  void initState() {
    super.initState();
    _futureLostPets = _fetchLostPets();
  }

  Future<List<Pet>> _fetchLostPets() async {
    // In a real app, you'd fetch this from your backend
    final response = await http.get(Uri.parse('${Config.backendUrl}/pets?type=lost'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      // Mock data for demonstration
      await Future.delayed(const Duration(seconds: 1));
      return mockPets.where((p) => p.type == 'lost').toList();
      // throw Exception('Failed to load lost pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Pets'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Pet>>(
          future: _futureLostPets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final lostPets = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SummaryCard(count: lostPets.length.toString(), label: 'Lost', color: Colors.redAccent),
                    const SummaryCard(count: '0', label: 'Found', color: Colors.green),
                    const SummaryCard(count: '0', label: 'Reunited', color: Colors.blueAccent),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Recent Reports',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: lostPets.isEmpty
                      ? const Center(child: Text('No lost pets reported yet.'))
                      : ListView.builder(
                          itemCount: lostPets.length,
                          itemBuilder: (context, index) {
                            return PetListCard(pet: lostPets[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

