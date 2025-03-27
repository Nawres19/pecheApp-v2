class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final String phoneNumber;
  final String userType; // 'client' ou 'fisherman'
  final String? profileImageUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.userType,
    this.profileImageUrl,
    required this.createdAt,
  });

  // Convertir un objet User en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password, // Dans une vraie app, ne jamais stocker le mot de passe en clair
      'name': name,
      'phoneNumber': phoneNumber,
      'userType': userType,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Créer un objet User à partir d'un Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      userType: map['userType'],
      profileImageUrl: map['profileImageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Créer une copie de l'objet avec des modifications
  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
    String? userType,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userType: userType ?? this.userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

