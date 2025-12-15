import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePictureDialog extends ConsumerStatefulWidget {
  final String? currentPhotoUrl;
  final VoidCallback onSuccess;

  const ProfilePictureDialog({
    super.key,
    this.currentPhotoUrl,
    required this.onSuccess,
  });

  @override
  ConsumerState<ProfilePictureDialog> createState() => _ProfilePictureDialogState();
}

class _ProfilePictureDialogState extends ConsumerState<ProfilePictureDialog> {
  File? _selectedImage;
  bool _isUploading = false;
  bool _isPickingImage = false;

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isPickingImage = true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();

        // Validate file size (limit to 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          if (mounted) {
            SnackBars.error(context, 'Image size must be less than 5MB');
          }
          return;
        }

        setState(() => _selectedImage = file);
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to pick image: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  Future<void> _uploadAndSave() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final api = ref.read(apiProvider).value!;

      // Upload to Firebase Storage
      final fileExtension = _selectedImage!.path.split('.').last.toLowerCase();
      final fileName = 'profile_picture_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'driver-profiles/$fileName';
      final downloadUrl = await api.uploadFile(_selectedImage!, filePath, fileExtension);

      // Update driver profile
      await driver_api.updateDriverProfile(
        api,
        photo: downloadUrl,
      );

      if (mounted) {
        widget.onSuccess();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to upload profile picture: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  color: colorScheme.secondary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Update Profile Picture',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Current Profile Picture
            if (widget.currentPhotoUrl != null && widget.currentPhotoUrl!.isNotEmpty) ...[
              Text(
                'Current Picture',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.currentPhotoUrl!),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // New Image Preview
            if (_selectedImage != null) ...[
              Text(
                'New Picture',
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(_selectedImage!),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Image Source Buttons
            if (_selectedImage == null) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isPickingImage ? null : () => _pickImage(ImageSource.camera),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.camera_alt_rounded),
                      label: const Text('Camera'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isPickingImage ? null : () => _pickImage(ImageSource.gallery),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.photo_library_rounded),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
              if (_isPickingImage) ...[
                const SizedBox(height: 16),
                const Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ] else ...[
              // Upload Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _uploadAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isUploading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSecondary),
                          ),
                        )
                      : const Text('Upload Picture'),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Cancel Button
            if (_selectedImage != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isUploading ? null : () => setState(() => _selectedImage = null),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Choose Different Image'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}