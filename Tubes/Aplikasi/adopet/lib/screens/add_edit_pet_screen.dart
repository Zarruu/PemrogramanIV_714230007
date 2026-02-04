import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';
import '../utils/constants.dart';
import '../widgets/image_picker_widget.dart';

class AddEditPetScreen extends StatefulWidget {
  final Pet? pet;

  const AddEditPetScreen({super.key, this.pet});

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _breedController;
  late TextEditingController _descriptionController;
  String _imageUrl = '';
  bool _isLoading = false;

  bool get isEditing => widget.pet != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.pet?.name ?? '');
    _ageController = TextEditingController(text: widget.pet?.age ?? '');
    _breedController = TextEditingController(text: widget.pet?.breed ?? '');
    _descriptionController = TextEditingController(text: widget.pet?.description ?? '');
    _imageUrl = widget.pet?.imageUrl ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _breedController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _savePet() async {
    if (_formKey.currentState!.validate()) {
      if (_imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select an image'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      final pet = Pet(
        id: widget.pet?.id,
        name: _nameController.text.trim(),
        age: _ageController.text.trim(),
        breed: _breedController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: _imageUrl,
      );

      bool success;
      if (isEditing) {
        success = await context.read<PetProvider>().updatePet(pet);
      } else {
        success = await context.read<PetProvider>().createPet(pet);
      }

      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? (isEditing ? 'Pet updated successfully!' : 'Pet added successfully!')
                  : (isEditing ? 'Failed to update pet' : 'Failed to add pet'),
            ),
            backgroundColor: success ? AppColors.success : AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        if (success) {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          isEditing ? AppStrings.editPet : AppStrings.addPet,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Picker
              Text(
                'Pet Photo',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ImagePickerWidget(
                initialImageUrl: _imageUrl,
                height: 220,
                onImageSelected: (path) {
                  setState(() => _imageUrl = path);
                },
              ),
              const SizedBox(height: 24),

              // Form Fields Card
              Card(
                elevation: 4,
                shadowColor: AppColors.primary.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: Column(
                    children: [
                      // Pet Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: AppStrings.petName,
                          prefixIcon: const Icon(Icons.pets, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Age and Breed in a Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: AppStrings.petAge,
                                prefixIcon: const Icon(Icons.cake, color: AppColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.fieldRequired;
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _breedController,
                              decoration: InputDecoration(
                                labelText: AppStrings.petBreed,
                                prefixIcon: const Icon(Icons.category, color: AppColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return AppStrings.fieldRequired;
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: AppStrings.petDescription,
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 48),
                            child: Icon(Icons.description, color: AppColors.primary),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.fieldRequired;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(isEditing ? Icons.save : Icons.add),
                            const SizedBox(width: 8),
                            Text(
                              AppStrings.save,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
