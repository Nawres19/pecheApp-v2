class Review {
  final String id;
  final String fishId;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.fishId,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Convertir un objet Review en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fishId': fishId,
      'userId': userId,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Créer un objet Review à partir d'un Map
  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      fishId: map['fishId'],
      userId: map['userId'],
      userName: map['userName'],
      userImageUrl: map['userImageUrl'],
      rating: map['rating'],
      comment: map['comment'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

