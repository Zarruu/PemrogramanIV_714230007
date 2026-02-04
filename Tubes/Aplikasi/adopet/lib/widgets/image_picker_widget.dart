import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../utils/constants.dart';

class ImagePickerWidget extends StatefulWidget {
  final String? initialImageUrl;
  final Function(String) onImageSelected;
  final double height;
  final double? width;
  final bool showEditButton;

  const ImagePickerWidget({
    super.key,
    this.initialImageUrl,
    required this.onImageSelected,
    this.height = 200,
    this.width,
    this.showEditButton = true,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  String? _currentImagePath;

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.initialImageUrl;
  }

  @override
  void didUpdateWidget(ImagePickerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialImageUrl != widget.initialImageUrl) {
      _currentImagePath = widget.initialImageUrl;
    }
  }

  bool get _isLocalFile {
    if (_currentImagePath == null || _currentImagePath!.isEmpty) return false;
    return !_currentImagePath!.startsWith('http');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        // Copy to app directory for persistence
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory('${appDir.path}/pet_images');
        if (!await imagesDir.exists()) {
          await imagesDir.create(recursive: true);
        }

        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
        final savedImage = await File(pickedFile.path).copy('${imagesDir.path}/$fileName');

        setState(() {
          _currentImagePath = savedImage.path;
        });
        widget.onImageSelected(savedImage.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _showUrlDialog() {
    final controller = TextEditingController(text: _isLocalFile ? '' : _currentImagePath);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: Text('Enter Image URL', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg',
            prefixIcon: const Icon(Icons.link),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final url = controller.text.trim();
              if (url.isNotEmpty && url.startsWith('http')) {
                setState(() => _currentImagePath = url);
                widget.onImageSelected(url);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Image Source',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    color: AppColors.primary,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                  _buildOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    color: AppColors.secondary,
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildOption(
                    icon: Icons.link,
                    label: 'URL',
                    color: AppColors.success,
                    onTap: () {
                      Navigator.pop(context);
                      _showUrlDialog();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (_currentImagePath == null || _currentImagePath!.isEmpty) {
      return Container(
        height: widget.height,
        width: widget.width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryLight.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to add image',
              style: GoogleFonts.poppins(
                color: AppColors.primary.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      child: _isLocalFile
          ? Image.file(
              File(_currentImagePath!),
              height: widget.height,
              width: widget.width ?? double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
            )
          : Image.network(
              _currentImagePath!,
              height: widget.height,
              width: widget.width ?? double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: widget.height,
                  width: widget.width ?? double.infinity,
                  color: AppColors.primaryLight.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
            ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      height: widget.height,
      width: widget.width ?? double.infinity,
      color: AppColors.primaryLight.withOpacity(0.3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Text(
            'Image not found',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showPickerOptions,
      child: Stack(
        children: [
          _buildImage(),
          if (widget.showEditButton && (_currentImagePath?.isNotEmpty ?? false))
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Helper widget to display images that could be either local or network
class AdaptiveImage extends StatelessWidget {
  final String? imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AdaptiveImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  bool get _isLocalFile {
    if (imagePath == null || imagePath!.isEmpty) return false;
    return !imagePath!.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return placeholder ?? Container(
        width: width,
        height: height,
        color: AppColors.primaryLight,
        child: const Icon(Icons.pets, color: AppColors.primary),
      );
    }

    if (_isLocalFile) {
      return Image.file(
        File(imagePath!),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => 
            errorWidget ?? _buildErrorWidget(),
      );
    }

    return Image.network(
      imagePath!,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ?? Container(
          width: width,
          height: height,
          color: AppColors.primaryLight.withOpacity(0.3),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => 
          errorWidget ?? _buildErrorWidget(),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: AppColors.primaryLight,
      child: const Icon(Icons.pets, color: AppColors.primary),
    );
  }
}
