
// lib/models/pet.dart
class Pet {
  final String id;
  final String name;
  final String type; // 'lost' or 'found'
  final String? status; // e.g., 'reunited'
  final String? breed;
  final String? color;
  final String? collarColor;
  final String? description;
  final List<String> photoUrls;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final DateTime? lastSeenDate;
  final DateTime? createdAt;
  final String? address;
  final String? ownerId;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    this.status,
    this.breed,
    this.color,
    this.collarColor,
    this.description,
    required this.photoUrls,
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.lastSeenDate,
    this.createdAt,
    this.address,
    this.ownerId,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      status: json['status'],
      breed: json['breed'],
      color: json['color'],
      collarColor: json['collarColor'],
      description: json['description'],
      photoUrls: (json['photoUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      ownerName: json['ownerName'],
      ownerPhone: json['ownerPhone'],
      ownerEmail: json['ownerEmail'],
      lastSeenDate: json['lastSeenDate'] != null ? DateTime.tryParse(json['lastSeenDate']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      address: json['address'],
      ownerId: json['ownerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'status': status,
      'breed': breed,
      'color': color,
      'collarColor': collarColor,
      'description': description,
      'photoUrls': photoUrls,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'lastSeenDate': lastSeenDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'address': address,
      'ownerId': ownerId,
    };
  }
}

