class Fisherman {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final bool isCertified;
  final double rating;
  final List<String> fishCaptureIds;

  Fisherman({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    this.isCertified = false,
    this.rating = 0.0,
    this.fishCaptureIds = const [],
  });

  // Convertir un objet Fisherman en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'isCertified': isCertified,
      'rating': rating,
      'fishCaptureIds': fishCaptureIds,
    };
  }

  // Créer un objet Fisherman à partir d'un Map
  factory Fisherman.fromMap(Map<String, dynamic> map) {
    return Fisherman(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      isCertified: map['isCertified'] ?? false,
      rating: map['rating'] ?? 0.0,
      fishCaptureIds: List<String>.from(map['fishCaptureIds'] ?? []),
    );
  }

  // Créer une copie de l'objet avec des modifications
  Fisherman copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    bool? isCertified,
    double? rating,
    List<String>? fishCaptureIds,
  }) {
    return Fisherman(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isCertified: isCertified ?? this.isCertified,
      rating: rating ?? this.rating,
      fishCaptureIds: fishCaptureIds ?? this.fishCaptureIds,
    );
  }
}

