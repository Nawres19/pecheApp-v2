import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peche_app/models/fish.dart';
import 'package:peche_app/models/review.dart';

class FirebaseFishService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtenir tous les poissons
  Future<List<Fish>> getAllFishes() async {
    try {
      final snapshot = await _firestore.collection('fishes').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Fish(
          id: doc.id,
          species: data['species'],
          imageUrl: data['imageUrl'],
          weight: data['weight'],
          length: data['length'],
          location: data['location'],
          fishingMethod: data['fishingMethod'],
          captureDate: (data['captureDate'] as Timestamp).toDate(),
          fishermanId: data['fishermanId'],
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des poissons: $e');
      return [];
    }
  }

  // Obtenir un poisson par son ID
  Future<Fish?> getFishById(String id) async {
    try {
      final doc = await _firestore.collection('fishes').doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Fish(
          id: doc.id,
          species: data['species'],
          imageUrl: data['imageUrl'],
          weight: data['weight'],
          length: data['length'],
          location: data['location'],
          fishingMethod: data['fishingMethod'],
          captureDate: (data['captureDate'] as Timestamp).toDate(),
          fishermanId: data['fishermanId'],
        );
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du poisson: $e');
      return null;
    }
  }

  // Obtenir les poissons d'un pêcheur
  Future<List<Fish>> getFishesByFishermanId(String fishermanId) async {
    try {
      final snapshot =
          await _firestore
              .collection('fishes')
              .where('fishermanId', isEqualTo: fishermanId)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Fish(
          id: doc.id,
          species: data['species'],
          imageUrl: data['imageUrl'],
          weight: data['weight'],
          length: data['length'],
          location: data['location'],
          fishingMethod: data['fishingMethod'],
          captureDate: (data['captureDate'] as Timestamp).toDate(),
          fishermanId: data['fishermanId'],
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des poissons du pêcheur: $e');
      return [];
    }
  }

  // Ajouter un nouveau poisson
  Future<void> addFish(Fish fish) async {
    try {
      await _firestore.collection('fishes').add({
        'species': fish.species,
        'imageUrl': fish.imageUrl,
        'weight': fish.weight,
        'length': fish.length,
        'location': fish.location,
        'fishingMethod': fish.fishingMethod,
        'captureDate': Timestamp.fromDate(fish.captureDate),
        'fishermanId': fish.fishermanId,
        'isAvailable': true,
      });
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'ajout du poisson: $e');
    }
  }

  // Mettre à jour un poisson existant
  Future<void> updateFish(Fish updatedFish) async {
    try {
      await _firestore.collection('fishes').doc(updatedFish.id).update({
        'species': updatedFish.species,
        'imageUrl': updatedFish.imageUrl,
        'weight': updatedFish.weight,
        'length': updatedFish.length,
        'location': updatedFish.location,
        'fishingMethod': updatedFish.fishingMethod,
        'captureDate': Timestamp.fromDate(updatedFish.captureDate),
      });
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la mise à jour du poisson: $e');
    }
  }

  // Supprimer un poisson
  Future<void> deleteFish(String id) async {
    try {
      await _firestore.collection('fishes').doc(id).delete();
      notifyListeners();
    } catch (e) {
      print('Erreur lors de la suppression du poisson: $e');
    }
  }

  // Obtenir les avis pour un poisson
  Future<List<Review>> getReviewsForFish(String fishId) async {
    try {
      final snapshot =
          await _firestore
              .collection('reviews')
              .where('fishId', isEqualTo: fishId)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Review(
          id: doc.id,
          fishId: data['fishId'],
          userId: data['userId'],
          userName: data['userName'],
          userImageUrl: data['userImageUrl'],
          rating: data['rating'],
          comment: data['comment'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Erreur lors de la récupération des avis: $e');
      return [];
    }
  }

  // Ajouter un avis
  Future<void> addReview(Review review) async {
    try {
      await _firestore.collection('reviews').add({
        'fishId': review.fishId,
        'userId': review.userId,
        'userName': review.userName,
        'userImageUrl': review.userImageUrl,
        'rating': review.rating,
        'comment': review.comment,
        'createdAt': Timestamp.fromDate(review.createdAt),
      });
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'avis: $e');
    }
  }

  // Calculer la note moyenne d'un poisson
  Future<double> getAverageRating(String fishId) async {
    try {
      final reviews = await getReviewsForFish(fishId);
      if (reviews.isEmpty) {
        return 0.0;
      }

      final totalRating = reviews.fold(
        0.0,
        (sum, review) => sum + review.rating,
      );
      return totalRating / reviews.length;
    } catch (e) {
      print('Erreur lors du calcul de la note moyenne: $e');
      return 0.0;
    }
  }
}
