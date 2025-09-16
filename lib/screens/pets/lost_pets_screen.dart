// lib/screens/pets/lost_pets_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../models/pet.dart';
import '../../widgets/pet_card.dart';

class LostPetsScreen extends StatefulWidget {
  const LostPetsScreen({super.key});

  @override
  State<LostPetsScreen> createState() => _LostPetsScreenState();
}

class _LostPetsScreenState extends State<LostPetsScreen> {
  late Future<List<Pet>> _futurePets;

  @override
  void initState() {
    super.initState();
    _futurePets = _fetchPets();
  }

  Future<List<Pet>> _fetchPets() async {
    final response = await http.get(Uri.parse('${Config.backendUrl}/api/pets'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((json) => Pet.fromJson(json))
          .where((pet) => pet.type == 'lost') // only show lost pets
          .toList();
    } else {
      throw Exception('Failed to load lost pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lost Pets"),
      ),
      body: FutureBuilder<List<Pet>>(
        future: _futurePets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No lost pets found"));
          }

          final pets = snapshot.data!;
          return ListView.builder(
            itemCount: pets.length,
            itemBuilder: (context, index) {
              return PetCard(pet: pets[index]);
            },
          );
        },
      ),
    );
  }
}
