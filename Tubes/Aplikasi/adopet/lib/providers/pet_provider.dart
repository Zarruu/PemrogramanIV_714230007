import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../services/api_service.dart';

class PetProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Pet> _pets = [];
  List<Pet> _filteredPets = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Pet> get pets => _searchQuery.isEmpty ? _pets : _filteredPets;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Fetch all pets from API
  Future<void> fetchPets() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pets = await _apiService.fetchPets();
      _applySearch();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search functionality
  void searchPets(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredPets = _pets;
    } else {
      _filteredPets = _pets
          .where((pet) =>
              pet.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              pet.breed.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredPets = _pets;
    notifyListeners();
  }

  // Create a new pet
  Future<bool> createPet(Pet pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPet = await _apiService.createPet(pet);
      _pets.add(newPet);
      _applySearch();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update an existing pet
  Future<bool> updatePet(Pet pet) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedPet = await _apiService.updatePet(pet);
      final index = _pets.indexWhere((p) => p.id == pet.id);
      if (index != -1) {
        _pets[index] = updatedPet;
        _applySearch();
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete a pet
  Future<bool> deletePet(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deletePet(id);
      _pets.removeWhere((pet) => pet.id == id);
      _applySearch();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
