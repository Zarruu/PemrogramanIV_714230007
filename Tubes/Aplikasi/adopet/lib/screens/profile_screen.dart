import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  bool _isLocalImage(String path) {
    return path.isNotEmpty && !path.startsWith('http');
  }

  Widget _buildProfileImage(String photoUrl) {
    if (photoUrl.isEmpty) {
      return const CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 80, color: AppColors.primary),
      );
    }

    if (_isLocalImage(photoUrl)) {
      return CircleAvatar(
        radius: 60,
        backgroundColor: Colors.white,
        backgroundImage: FileImage(File(photoUrl)),
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(photoUrl),
      onBackgroundImageError: (_, __) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.paddingMedium),
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Profile Card
              Card(
                elevation: 8,
                shadowColor: AppColors.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSizes.paddingLarge),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.radiusXLarge),
                    gradient: authProvider.isAdmin
                        ? const LinearGradient(
                            colors: [AppColors.secondary, Color(0xFFE64A19)],
                          )
                        : AppColors.primaryGradient,
                  ),
                  child: Column(
                    children: [
                      // Profile Photo - supports local and network images
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: ClipOval(
                          child: SizedBox(
                            width: 120,
                            height: 120,
                            child: _buildProfileImageContent(authProvider.photoUrl),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Name
                      Text(
                        authProvider.name.isNotEmpty ? authProvider.name : 'Guest',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              authProvider.isAdmin ? Icons.admin_panel_settings : Icons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              authProvider.isAdmin ? 'Administrator' : 'User',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Edit Profile Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // User Info Card - only username
              _buildInfoCard(Icons.person_outline, 'Username', '@${authProvider.username}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileImageContent(String photoUrl) {
    if (photoUrl.isEmpty) {
      return Container(
        color: Colors.white,
        child: const Icon(Icons.person, size: 80, color: AppColors.primary),
      );
    }

    if (_isLocalImage(photoUrl)) {
      return Image.file(
        File(photoUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.white,
          child: const Icon(Icons.person, size: 80, color: AppColors.primary),
        ),
      );
    }

    return Image.network(
      photoUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.white,
        child: const Icon(Icons.person, size: 80, color: AppColors.primary),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
