class Fish {
  final String id;
  final String species;
  final String imageUrl;
  final double weight;
  final double length;
  final String location;
  final String fishingMethod;
  final DateTime captureDate;
  final String fishermanId;

  Fish({
    required this.id,
    required this.species,
    required this.imageUrl,
    required this.weight,
    required this.length,
    required this.location,
    required this.fishingMethod,
    required this.captureDate,
    required this.fishermanId,
  });

  // Convertir un objet Fish en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'species': species,
      'imageUrl': imageUrl,
      'weight': weight,
      'length': length,
      'location': location,
      'fishingMethod': fishingMethod,
      'captureDate': captureDate.toIso8601String(),
      'fishermanId': fishermanId,
    };
  }

  // Créer un objet Fish à partir d'un Map
  factory Fish.fromMap(Map<String, dynamic> map) {
    return Fish(
      id: map['id'],
      species: map['species'],
      imageUrl: map['imageUrl'],
      weight: map['weight'],
      length: map['length'],
      location: map['location'],
      fishingMethod: map['fishingMethod'],
      captureDate: DateTime.parse(map['captureDate']),
      fishermanId: map['fishermanId'],
    );
  }
}
