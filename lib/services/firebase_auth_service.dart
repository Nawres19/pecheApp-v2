import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:peche_app/models/user.dart' as app_user;

class FirebaseAuthService with ChangeNotifier {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  app_user.User? _currentUser;
  bool _isLoading = false;

  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  FirebaseAuthService() {
    _initCurrentUser();
  }

  Future<void> _initCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await _fetchUserData(firebaseUser.uid);
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _currentUser = app_user.User(
          id: doc.id,
          email: data['email'],
          password: '', // Ne stockez jamais le mot de passe en clair
          name: data['name'],
          phoneNumber: data['phoneNumber'],
          userType: data['userType'],
          profileImageUrl: data['profileImageUrl'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
        notifyListeners();
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _fetchUserData(userCredential.user!.uid);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Erreur de connexion: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
    String email,
    String password,
    String name,
    String phoneNumber,
    String userType,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;
        final userData = {
          'email': email,
          'name': name,
          'phoneNumber': phoneNumber,
          'userType': userType,
          'profileImageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(uid).set(userData);
        await _fetchUserData(uid);

        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('Erreur d\'inscription: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _firebaseAuth.signOut();
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }

  // Vérifier si l'utilisateur est un pêcheur
  bool get isFisherman => _currentUser?.userType == 'fisherman';

  // Vérifier si l'utilisateur est un client
  bool get isClient => _currentUser?.userType == 'client';
}
