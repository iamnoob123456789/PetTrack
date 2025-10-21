import 'package:pet_track/models/pet.dart';

final List<Pet> mockPets = [
  Pet(
    id: '1',
    name: 'Zoro',
    type: 'lost',
    breed: 'German Shepherd',
    photoUrls: ['https://via.placeholder.com/150'],
    lastSeenDate: DateTime(2025, 10, 15),
    address: 'Musurambagh metro station, near Malakpet police...',
  ),
  Pet(
    id: '2',
    name: 'James',
    type: 'lost',
    breed: 'Pug',
    photoUrls: ['https://via.placeholder.com/150'],
    lastSeenDate: DateTime(2025, 10, 15),
    address: 'Asian Shiva Ganga Theatre, Dilsukhnagar, Saidaba...',
  ),
  Pet(
    id: '3',
    name: 'Jacky',
    type: 'lost',
    breed: 'Rotweiler',
    photoUrls: ['https://via.placeholder.com/150'],
    lastSeenDate: DateTime(2025, 10, 14),
    address: 'Near Charminar, Hyderabad',
  ),
  Pet(
    id: '4',
    name: 'Unknown',
    type: 'found',
    breed: 'Chuhawa',
    photoUrls: [],
    lastSeenDate: DateTime(2025, 10, 16),
    address: 'PVR Musurambagh Mall, Musurambagh metro stat...',
  ),
  Pet(
    id: '5',
    name: 'Nezuko',
    type: 'found',
    breed: 'Chihauha Female',
    photoUrls: [],
    lastSeenDate: DateTime(2025, 10, 14),
    address: 'No address',
  ),
];
