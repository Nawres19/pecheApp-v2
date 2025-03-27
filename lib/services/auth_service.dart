import 'dart:async';
import 'package:flutter/material.dart';
import 'package:peche_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final List<User> _users = []; // Simuler une base de données d'utilisateurs

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  // Constructeur qui initialise quelques utilisateurs de test
  AuthService() {
    _initializeTestUsers();
    _loadUserFromPrefs();
  }

  void _initializeTestUsers() {
    // Ajouter quelques utilisateurs de test
    _users.add(
      User(
        id: '1',
        email: 'pecheur@example.com',
        password: 'password123',
        name: 'Pierre Dupont',
        phoneNumber: '0612345678',
        userType: 'fisherman',
        profileImageUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    );
    
    _users.add(
      User(
        id: '2',
        email: 'client@example.com',
        password: 'password123',
        name: 'Jean Martin',
        phoneNumber: '0687654321',
        userType: 'client',
        profileImageUrl: 'https://images.unsplash.com/photo-1566492031773-4f4e44671857?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=80',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    );
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    
    if (userId != null) {
      // Simuler la récupération de l'utilisateur depuis une base de données
      final user = _users.firstWhere(
        (user) => user.id == userId,
        orElse: () => throw Exception('User not found'),
      );
      
      _currentUser = user;
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> _removeUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    // Simuler un délai de réseau
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Vérifier si l'utilisateur existe
      final user = _users.firstWhere(
        (user) => user.email == email && user.password == password,
        orElse: () => throw Exception('Invalid credentials'),
      );
      
      _currentUser = user;
      await _saveUserToPrefs(user.id);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String name, String phoneNumber, String userType) async {
    _isLoading = true;
    notifyListeners();
    
    // Simuler un délai de réseau
    await Future.delayed(const Duration(seconds: 1));
    
    try {
      // Vérifier si l'email est déjà utilisé
      final existingUser = _users.any((user) => user.email == email);
      if (existingUser) {
        throw Exception('Email already in use');
      }
      
      // Créer un nouvel utilisateur
      final newUser = User(
        id: const Uuid().v4(),
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
        userType: userType,
        createdAt: DateTime.now(),
      );
      
      _users.add(newUser);
      _currentUser = newUser;
      await _saveUserToPrefs(newUser.id);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _currentUser = null;
    await _removeUserFromPrefs();
    
    _isLoading = false;
    notifyListeners();
  }

  // Vérifier si l'utilisateur est un pêcheur
  bool get isFisherman => _currentUser?.userType == 'fisherman';
  
  // Vérifier si l'utilisateur est un client
  bool get isClient => _currentUser?.userType == 'client';
}

