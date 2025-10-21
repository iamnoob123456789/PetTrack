import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/pet.dart';
import '../../services/pet_service.dart';
import '../../services/location_service.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final MapController _mapController = MapController();
  final ImagePicker _imagePicker = ImagePicker();
  List<Marker> _markers = [];
  LatLng _currentPosition = const LatLng(17.3850, 78.4867); // Default: Hyderabad
  bool _isLoading = true;
  bool _locationLoaded = false;
  String _errorMessage = '';
  double _searchRadius = 10.0; // km
  String _filterType = 'all'; // all, lost, found

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final locationService = Provider.of<LocationService>(context, listen: false);
    final petService = Provider.of<PetService>(context, listen: false);

    try {
      // Get user location
      await locationService.getCurrentLocation();
      if (locationService.currentPosition != null) {
        if (!mounted) return;
        setState(() {
          _currentPosition = LatLng(
            locationService.currentPosition!.latitude,
            locationService.currentPosition!.longitude,
          );
          _locationLoaded = true;
          _mapController.move(_currentPosition, 13.0);
        });
      }

      // Fetch pets
      await petService.fetchPets(
        type: _filterType == 'all' ? null : _filterType,
      );

      if (!mounted) return;
      _updateMarkers(petService.pets);
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateMarkers(List<Pet> pets) {
    final filteredPets = _filterPetsByDistance(
      pets,
      _currentPosition.latitude,
      _currentPosition.longitude,
      _searchRadius,
    );

    setState(() {
      _markers = filteredPets.where((pet) => pet.location != null && pet.location!.coordinates.length >= 2).map((pet) {
        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(pet.location!.coordinates[1], pet.location!.coordinates[0]),
          child: GestureDetector(
            onTap: () => _showPetDetails(pet),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: pet.type == 'lost' ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.pets,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                Text(
                  pet.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList();

      // Add current location marker
      if (_locationLoaded) {
        _markers.add(
          Marker(
            width: 60,
            height: 60,
            point: _currentPosition,
            child: GestureDetector(
              onTap: () => _mapController.move(_currentPosition, 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        );
      }
    });
  }

  List<Pet> _filterPetsByDistance(
    List<Pet> pets,
    double latitude,
    double longitude,
    double radiusKm,
  ) {
    if (_filterType != 'all') {
      pets = pets.where((pet) => pet.type == _filterType).toList();
    }
    return pets.where((pet) {
      if (pet.location == null || pet.location!.coordinates.length < 2) return false;
      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        pet.location!.coordinates[1],
        pet.location!.coordinates[0],
      );
      return distance / 1000 <= radiusKm;
    }).toList();
  }

  void _showPetDetails(Pet pet) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pet.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (pet.photoUrls != null && pet.photoUrls!.isNotEmpty)
                Image.network(
                  pet.photoUrls!.first,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                ),
              const SizedBox(height: 8),
              Text('Type: ${pet.type}'),
              Text('Description: ${pet.description ?? 'No description'}'),
              Text('Address: ${pet.address ?? 'Unknown'}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _launchMaps(pet.location!.coordinates[1], pet.location!.coordinates[0]),
                child: const Text('Get Directions'),
              ),
              TextButton(
                onPressed: () => context.go('/pet-details/${pet.id}', extra: pet),
                child: const Text('View Full Details'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchMaps(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch maps')),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _isLoading = true;
        });
        final petService = Provider.of<PetService>(context, listen: false);
        // TODO: Implement actual image search when backend supports it
        // For now, just use regular pet fetching
        await petService.fetchPets(
          type: _filterType == 'all' ? null : _filterType,
        );
        final matchedPets = petService.pets;
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _filterType = 'all'; // Reset filter to show matches
          _updateMarkers(matchedPets.isNotEmpty ? matchedPets : petService.pets);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${matchedPets.length} matching pets found')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching pets: $e')),
      );
    }
  }

  Future<void> _refreshPets() async {
    setState(() {
      _isLoading = true;
    });
    await _loadData();
  }

  void _updateSearchRadius(double radius) {
    setState(() {
      _searchRadius = radius;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final petService = Provider.of<PetService>(context);
    final locationService = Provider.of<LocationService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pets Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPets,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.add_a_photo),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: _locationLoaded ? 13.0 : 11.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.pet_track.app',
              ),
              MarkerLayer(markers: _markers),
              if (_locationLoaded)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _currentPosition,
                      color: Colors.blue.withOpacity(0.2),
                      borderColor: Colors.blue.withOpacity(0.7),
                      borderStrokeWidth: 2,
                      radius: _searchRadius * 1000, // Convert km to meters
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _filterType = 'all');
                            _loadData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _filterType == 'all' ? Colors.blue.shade100 : null,
                          ),
                          child: const Text('All'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _filterType = 'lost');
                            _loadData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _filterType == 'lost' ? Colors.red.shade100 : null,
                          ),
                          child: const Text('Lost'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _filterType = 'found');
                            _loadData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _filterType == 'found' ? Colors.green.shade100 : null,
                          ),
                          child: const Text('Found'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Search Radius: ${_searchRadius.toStringAsFixed(1)} km',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Slider(
                          value: _searchRadius,
                          min: 1.0,
                          max: 50.0,
                          divisions: 49,
                          label: '${_searchRadius.toStringAsFixed(1)} km',
                          onChanged: _updateSearchRadius,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Showing ${_markers.length} pets',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                if (_locationLoaded) {
                  _mapController.move(_currentPosition, 13.0);
                }
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          if (_isLoading || petService.isLoading || locationService.isLoading)
            const Center(child: CircularProgressIndicator()),
          if (_errorMessage.isNotEmpty || petService.error.isNotEmpty || locationService.error.isNotEmpty)
            Center(
              child: Text(
                _errorMessage.isNotEmpty
                    ? _errorMessage
                    : '${petService.error} ${locationService.error}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}