import 'package:flutter/material.dart';
import 'package:peche_app/models/fish.dart';
import 'package:peche_app/models/review.dart';
import 'package:uuid/uuid.dart';

class FishService with ChangeNotifier {
  final List<Fish> _fishes = [];
  final List<Review> _reviews = [];
  
  List<Fish> get fishes => [..._fishes];
  
  // Constructeur qui initialise quelques poissons de test
  FishService() {
    _initializeTestData();
  }
  
  void _initializeTestData() {
    // Ajouter quelques poissons de test
    _fishes.add(
      Fish(
        id: '1',
        species: 'Bar commun',
        imageUrl: 'https://images.unsplash.com/photo-1545816250-e12bedba42ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        weight: 2.5,
        length: 45.0,
        location: 'Côte atlantique',
        fishingMethod: 'Canne à pêche',
        captureDate: DateTime.now().subtract(const Duration(days: 2)),
        fishermanId: '1',
      ),
    );
    
    _fishes.add(
      Fish(
        id: '2',
        species: 'Dorade royale',
        imageUrl: 'https://images.unsplash.com/photo-1579168765467-3b235f938439?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        weight: 1.8,
        length: 35.0,
        location: 'Méditerranée',
        fishingMethod: 'Filet',
        captureDate: DateTime.now().subtract(const Duration(days: 5)),
        fishermanId: '1',
      ),
    );
    
    _fishes.add(
      Fish(
        id: '3',
        species: 'Maquereau',
        imageUrl: 'https://images.unsplash.com/photo-1574781330855-d0db8cc6a79c?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        weight: 0.9,
        length: 28.0,
        location: 'Manche',
        fishingMethod: 'Ligne de traîne',
        captureDate: DateTime.now().subtract(const Duration(days: 10)),
        fishermanId: '1',
      ),
    );
    
    _fishes.add(
      Fish(
        id: '4',
        species: 'Sole',
        imageUrl: 'https://images.unsplash.com/photo-1559589290-0da9bc7d1df7?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        weight: 1.2,
        length: 32.0,
        location: 'Golfe de Gascogne',
        fishingMethod: 'Chalut',
        captureDate: DateTime.now().subtract(const Duration(days: 12)),
        fishermanId: '1',
      ),
    );
    
    // Ajouter quelques avis de test
    _reviews.add(
      Review(
        id: '1',
        fishId: '1',
        userId: '2',
        userName: 'Jean Martin',
        userImageUrl: 'https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        rating: 4.5,
        comment: 'Excellent poisson, très frais et savoureux !',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    );
    
    _reviews.add(
      Review(
        id: '2',
        fishId: '2',
        userId: '2',
        userName: 'Jean Martin',
        userImageUrl: 'https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        rating: 5.0,
        comment: 'La dorade était parfaite, je recommande vivement !',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    );
  }
  
  // Obtenir tous les poissons
  List<Fish> getAllFishes() {
    return [..._fishes];
  }
  
  // Obtenir un poisson par son ID
  Fish? getFishById(String id) {
    try {
      return _fishes.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Obtenir les poissons d'un pêcheur
  List<Fish> getFishesByFishermanId(String fishermanId) {
    return _fishes.where((fish) => fish.fishermanId == fishermanId).toList();
  }
  
  // Ajouter un nouveau poisson
  Future<void> addFish(Fish fish) async {
    _fishes.add(fish);
    notifyListeners();
  }
  
  // Mettre à jour un poisson existant
  Future<void> updateFish(Fish updatedFish) async {
    final index = _fishes.indexWhere((fish) => fish.id == updatedFish.id);
    if (index >= 0) {
      _fishes[index] = updatedFish;
      notifyListeners();
    }
  }
  
  // Supprimer un poisson
  Future<void> deleteFish(String id) async {
    _fishes.removeWhere((fish) => fish.id == id);
    notifyListeners();
  }
  
  // Obtenir les avis pour un poisson
  List<Review> getReviewsForFish(String fishId) {
    return _reviews.where((review) => review.fishId == fishId).toList();
  }
  
  // Ajouter un avis
  Future<void> addReview(Review review) async {
    _reviews.add(review);
    notifyListeners();
  }
  
  // Calculer la note moyenne d'un poisson
  double getAverageRating(String fishId) {
    final reviews = getReviewsForFish(fishId);
    if (reviews.isEmpty) {
      return 0.0;
    }
    
    final totalRating = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return totalRating / reviews.length;
  }
  
  // Rechercher des poissons
  List<Fish> searchFishes(String query) {
    if (query.isEmpty) {
      return [];
    }
    
    final lowercaseQuery = query.toLowerCase();
    return _fishes.where((fish) {
      return fish.species.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}

