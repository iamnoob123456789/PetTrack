import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:pet_track/config.dart';
import 'package:pet_track/models/pet.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late Future<List<Pet>> _futurePets;

  @override
  void initState() {
    super.initState();
    _futurePets = _fetchPets();
  }

  Future<List<Pet>> _fetchPets() async {
    final response = await http.get(Uri.parse('${Config.backendUrl}/pets'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Pet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load pets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets Map'),
      ),
      body: FutureBuilder<List<Pet>>(
        future: _futurePets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No pets to display on the map.'));
          }

          final pets = snapshot.data!;
          final markers = pets.where((pet) {
            // Filter out pets with invalid coordinates
            return pet.location != null &&
                   pet.location!.coordinates.length == 2 &&
                   pet.location!.coordinates[0] != 0 &&
                   pet.location!.coordinates[1] != 0;
          }).map((pet) {
            return Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(pet.location!.coordinates[1], pet.location!.coordinates[0]),
              child: Icon(
                Icons.pets,
                color: pet.type == 'lost' ? Colors.red : Colors.green,
                size: 40,
              ),
            );
          }).toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(17.3850, 78.4867), // Centered on Hyderabad
              initialZoom: 11.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
