class Pet {
  final String id;
  final String name;
  final String type; // 'dog' or 'cat'
  final String breed;
  final String color;
  final String collarColor;
  final String description;
  final List<String> photoUrls;
  final String ownerName;
  final String ownerPhone;
  final String ownerEmail;
  final DateTime lastSeenDate;
  final double latitude;
  final double longitude;
  final String address;
  final String status; // 'lost', 'found', 'reunited'
  final DateTime createdAt;
  final String? qrCode;
  final bool isMicrochipped;
  final String? microchipNumber;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.color,
    required this.collarColor,
    required this.description,
    required this.photoUrls,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerEmail,
    required this.lastSeenDate,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.status,
    required this.createdAt,
    this.qrCode,
    this.isMicrochipped = false,
    this.microchipNumber,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      breed: json['breed'] ?? '',
      color: json['color'] ?? '',
      collarColor: json['collarColor'] ?? '',
      description: json['description'] ?? '',
      photoUrls: List<String>.from(json['photoUrls'] ?? []),
      ownerName: json['ownerName'] ?? '',
      ownerPhone: json['ownerPhone'] ?? '',
      ownerEmail: json['ownerEmail'] ?? '',
      lastSeenDate: DateTime.parse(json['lastSeenDate'] ?? DateTime.now().toIso8601String()),
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      status: json['status'] ?? 'lost',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      qrCode: json['qrCode'],
      isMicrochipped: json['isMicrochipped'] ?? false,
      microchipNumber: json['microchipNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'color': color,
      'collarColor': collarColor,
      'description': description,
      'photoUrls': photoUrls,
      'ownerName': ownerName,
      'ownerPhone': ownerPhone,
      'ownerEmail': ownerEmail,
      'lastSeenDate': lastSeenDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'qrCode': qrCode,
      'isMicrochipped': isMicrochipped,
      'microchipNumber': microchipNumber,
    };
  }

  Pet copyWith({
    String? id,
    String? name,
    String? type,
    String? breed,
    String? color,
    String? collarColor,
    String? description,
    List<String>? photoUrls,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    DateTime? lastSeenDate,
    double? latitude,
    double? longitude,
    String? address,
    String? status,
    DateTime? createdAt,
    String? qrCode,
    bool? isMicrochipped,
    String? microchipNumber,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      color: color ?? this.color,
      collarColor: collarColor ?? this.collarColor,
      description: description ?? this.description,
      photoUrls: photoUrls ?? this.photoUrls,
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      lastSeenDate: lastSeenDate ?? this.lastSeenDate,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      qrCode: qrCode ?? this.qrCode,
      isMicrochipped: isMicrochipped ?? this.isMicrochipped,
      microchipNumber: microchipNumber ?? this.microchipNumber,
    );
  }
} 