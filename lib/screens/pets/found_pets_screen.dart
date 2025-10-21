import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_track/config.dart';
import 'package:pet_track/models/pet.dart';
import 'package:pet_track/models/mock_data.dart';
import 'package:pet_track/widgets/pet_list_card.dart';
import 'package:pet_track/widgets/summary_card.dart';

class FoundPetsScreen extends StatefulWidget {
  const FoundPetsScreen({super.key});

  @override
  State<FoundPetsScreen> createState() => _FoundPetsScreenState();
}

class _FoundPetsScreenState extends State<FoundPetsScreen> {
  late Future<List<Pet>> _futureFoundPets;

  @override
  void initState() {
    super.initState();
    _futureFoundPets = _fetchFoundPets();
  }

  Future<List<Pet>> _fetchFoundPets() async {
    final response = await http.get(Uri.parse('${Config.backendUrl}/pets?status=found'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      await Future.delayed(const Duration(seconds: 1));
      return mockPets.where((p) => p.type == 'found').toList();
      // throw Exception('Failed to load found pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Pets'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<Pet>>(
          future: _futureFoundPets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final foundPets = snapshot.data ?? [];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SummaryCard(count: '0', label: 'Lost', color: Colors.redAccent),
                    SummaryCard(count: foundPets.length.toString(), label: 'Found', color: Colors.green),
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
                  child: foundPets.isEmpty
                      ? const Center(child: Text('No found pets reported yet.'))
                      : ListView.builder(
                          itemCount: foundPets.length,
                          itemBuilder: (context, index) {
                            return PetListCard(pet: foundPets[index]);
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

