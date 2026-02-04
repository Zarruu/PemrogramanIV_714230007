import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet.dart';

class ApiService {
  static const String baseUrl = 'https://696f8a64a06046ce61870d91.mockapi.io/api/v1';
  
  // GET - Fetch all pets
  Future<List<Pet>> fetchPets() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pets'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Pet.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pets: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch pets: $e');
    }
  }

  // POST - Create a new pet
  Future<Pet> createPet(Pet pet) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pets'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pet.toJson()),
      );

      if (response.statusCode == 201) {
        return Pet.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create pet: $e');
    }
  }

  // PUT - Update an existing pet
  Future<Pet> updatePet(Pet pet) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/pets/${pet.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(pet.toJson()),
      );

      if (response.statusCode == 200) {
        return Pet.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  // DELETE - Remove a pet
  Future<bool> deletePet(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/pets/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }
}
