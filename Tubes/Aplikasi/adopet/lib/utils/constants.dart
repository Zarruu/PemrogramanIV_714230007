import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Orange palette for friendly pet vibe
  static const Color primary = Color(0xFFFF9800);
  static const Color primaryDark = Color(0xFFF57C00);
  static const Color primaryLight = Color(0xFFFFE0B2);
  
  // Secondary Colors - Deep Orange accent
  static const Color secondary = Color(0xFFFF5722);
  static const Color secondaryLight = Color(0xFFFFCCBC);
  
  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}

class AppStrings {
  static const String appName = 'Adopet';
  static const String appTagline = 'Find Your Furry Friend';
  
  // Login Screen
  static const String login = 'Login';
  static const String username = 'Username';
  static const String password = 'Password';
  static const String usernameHint = 'Enter your username';
  static const String passwordHint = 'Enter your password';
  static const String usernameRequired = 'Username is required';
  static const String usernameMinLength = 'Username must be at least 3 characters';
  static const String passwordRequired = 'Password is required';
  static const String passwordMinLength = 'Password must be at least 6 characters';
  static const String loginSuccess = 'Login successful!';
  static const String loginFailed = 'Invalid username or password';
  
  // Home Screen
  static const String home = 'Home';
  static const String searchHint = 'Search pets by name or breed...';
  static const String noPetsFound = 'No pets found';
  static const String pullToRefresh = 'Pull to refresh';
  
  // Pet Form
  static const String addPet = 'Add Pet';
  static const String editPet = 'Edit Pet';
  static const String petName = 'Pet Name';
  static const String petAge = 'Age';
  static const String petBreed = 'Breed';
  static const String petDescription = 'Description';
  static const String petImageUrl = 'Image URL';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String fieldRequired = 'This field is required';
  
  // Profile Screen
  static const String profile = 'Profile';
  static const String studentName = 'Student Name';
  static const String studentId = 'NPM';
  
  // About Screen
  static const String about = 'About';
  static const String appDescription = 'Adopet is a pet adoption platform that connects loving homes with pets in need. Browse through our listings of adorable pets waiting for their forever families.';
  static const String version = 'Version 1.0.0';
  
  // Actions
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String confirmDelete = 'Are you sure you want to delete this pet?';
  static const String yes = 'Yes';
  static const String no = 'No';
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  
  static const double iconSmall = 20.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  
  static const double avatarSmall = 40.0;
  static const double avatarMedium = 60.0;
  static const double avatarLarge = 100.0;
}
