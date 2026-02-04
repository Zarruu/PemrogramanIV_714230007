import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';

class AuthProvider with ChangeNotifier {
  String _username = '';
  String _password = '';
  String _role = 'user';
  String _name = '';
  String _photoUrl = '';
  String _email = '';
  List<AppUser> _registeredUsers = [];

  String get username => _username;
  String get password => _password;
  String get role => _role;
  String get name => _name.isNotEmpty ? _name : _username;
  String get photoUrl => _photoUrl;
  String get email => _email;
  bool get isAdmin => _role == 'admin';
  bool get isLoggedIn => _username.isNotEmpty;

  AuthProvider() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('registered_users');
    if (usersJson != null && usersJson.isNotEmpty) {
      _registeredUsers = AppUser.decode(usersJson);
    }
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_users', AppUser.encode(_registeredUsers));
  }

  // Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String password,
    required String name,
    required String email,
  }) async {
    // Check if username exists
    if (_registeredUsers.any((u) => u.username.toLowerCase() == username.toLowerCase())) {
      return {'success': false, 'message': 'Username already exists'};
    }

    // Check if email exists
    if (_registeredUsers.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return {'success': false, 'message': 'Email already registered'};
    }

    final newUser = AppUser(
      username: username,
      password: password,
      name: name,
      email: email,
      role: 'user',
    );

    _registeredUsers.add(newUser);
    await _saveUsers();
    
    return {'success': true, 'message': 'Registration successful'};
  }

  // Login - check admin or registered user
  Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    // Check admin
    if (username == 'admin' && password == 'admin123') {
      _username = username;
      _password = password;
      _role = 'admin';
      _name = 'Administrator';
      _email = 'admin@adopet.com';
      _photoUrl = '';
      notifyListeners();
      return {'success': true, 'role': 'admin'};
    }

    // Check registered users
    final user = _registeredUsers.firstWhere(
      (u) => u.username.toLowerCase() == username.toLowerCase() && u.password == password,
      orElse: () => AppUser(username: '', password: '', name: '', email: ''),
    );

    if (user.username.isNotEmpty) {
      _username = user.username;
      _password = user.password;
      _role = user.role;
      _name = user.name;
      _email = user.email;
      _photoUrl = user.photoUrl;
      notifyListeners();
      return {'success': true, 'role': 'user'};
    }

    return {'success': false, 'message': 'Invalid username or password'};
  }

  void login({
    required String username,
    required String password,
    required String role,
  }) {
    _username = username;
    _password = password;
    _role = role;
    if (role == 'admin') {
      _name = 'Administrator';
    } else {
      _name = username;
    }
    notifyListeners();
  }

  void updateProfile({String? name, String? photoUrl, String? email}) {
    if (name != null) _name = name;
    if (photoUrl != null) _photoUrl = photoUrl;
    if (email != null) _email = email;
    
    // Update in registered users
    final index = _registeredUsers.indexWhere((u) => u.username == _username);
    if (index != -1) {
      _registeredUsers[index] = _registeredUsers[index].copyWith(
        name: name ?? _registeredUsers[index].name,
        photoUrl: photoUrl ?? _registeredUsers[index].photoUrl,
        email: email ?? _registeredUsers[index].email,
      );
      _saveUsers();
    }
    
    notifyListeners();
  }

  bool changePassword({required String currentPassword, required String newPassword}) {
    if (_password == currentPassword) {
      _password = newPassword;
      
      // Update in registered users
      final index = _registeredUsers.indexWhere((u) => u.username == _username);
      if (index != -1) {
        _registeredUsers[index] = _registeredUsers[index].copyWith(password: newPassword);
        _saveUsers();
      }
      
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _username = '';
    _password = '';
    _role = 'user';
    _name = '';
    _photoUrl = '';
    _email = '';
    notifyListeners();
  }
}
