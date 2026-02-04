import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pet.dart';
import '../utils/constants.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAdopt;
  final VoidCallback? onTap;
  final bool isAdmin;

  const PetCard({
    super.key,
    required this.pet,
    this.onEdit,
    this.onDelete,
    this.onAdopt,
    this.onTap,
    this.isAdmin = false,
  });

  bool get _isLocalImage {
    return pet.imageUrl.isNotEmpty && !pet.imageUrl.startsWith('http');
  }

  Widget _buildImage() {
    if (_isLocalImage) {
      return Image.file(
        File(pet.imageUrl),
        fit: BoxFit.cover,
        height: 180,
        width: double.infinity,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.primaryLight,
          child: const Icon(Icons.pets, size: 64, color: AppColors.primary),
        ),
      );
    }
    
    return CachedNetworkImage(
      imageUrl: pet.imageUrl,
      fit: BoxFit.cover,
      height: 180,
      width: double.infinity,
      placeholder: (context, url) => Container(
        color: AppColors.primaryLight,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.primaryLight,
        child: const Icon(Icons.pets, size: 64, color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSizes.paddingMedium,
        vertical: AppSizes.paddingSmall,
      ),
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pet Image - supports both local and network
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizes.radiusLarge),
              ),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: _buildImage(),
              ),
            ),
            
            // Pet Info
            Padding(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pet.name,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${pet.age} years',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pet.breed,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pet.description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Action Buttons based on role
                  if (isAdmin) 
                    _buildAdminActions()
                  else
                    _buildUserActions(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserActions() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onAdopt,
        icon: const Icon(Icons.favorite, size: 18),
        label: Text(
          'Adopt Me!',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
        ),
      ),
    );
  }
}
