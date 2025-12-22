import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

class PhotoStep extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onNext;
  final Function(String) onError;

  const PhotoStep({
    super.key,
    required this.controller,
    required this.onNext,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return OnboardingStepContainer(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          OnboardingStepIcon(
            controller: controller,
            icon: Icons.camera_alt_rounded,
          ),

          const SizedBox(height: 40),

          OnboardingStepTitle(controller: controller, title: l10n.photoStepTitle),

          const SizedBox(height: 16),

          OnboardingStepDescription(
            controller: controller,
            description: l10n.photoStepDescription,
          ),

          const SizedBox(height: 56),

          // Enhanced photo picker with better visual feedback
          Center(
            child: ScaleTransition(
              scale: controller.scaleAnimation,
              child: GestureDetector(
                onTap: controller.isPickingImage ? null : () => controller.pickImage(onError: onError),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: controller.selectedImage != null
                          ? colorScheme.secondary
                          : colorScheme.outline.withValues(alpha: 0.3),
                      width: controller.selectedImage != null ? 4 : 2,
                    ),
                    color: colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withValues(alpha: 0.15),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: controller.isPickingImage
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.secondary.withValues(alpha: 0.1),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(
                                  color: colorScheme.secondary,
                                  strokeWidth: 3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Loading...',
                                style: GoogleFonts.dmSans(
                                  color: colorScheme.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : controller.selectedImage != null
                          ? Stack(
                              children: [
                                ClipOval(
                                  child: Image.file(
                                    controller.selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 176,
                                    height: 176,
                                  ),
                                ),
                                // Add a subtle overlay with edit icon
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: colorScheme.secondary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: colorScheme.shadow.withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.edit_rounded,
                                      color: colorScheme.onSecondary,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: colorScheme.secondary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 28,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.tapToAddPhoto,
                                  style: GoogleFonts.dmSans(
                                    color: colorScheme.secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Optional',
                                  style: GoogleFonts.dmSans(
                                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ),
          ),

          // Photo selected success feedback
          if (controller.selectedImage != null && !controller.isUploadingImage) ...[
            const SizedBox(height: 24),
            Center(
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.green.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.photoSelected,
                        style: GoogleFonts.dmSans(
                          color: Colors.green.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          if (controller.isUploadingImage) ...[
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CircularProgressIndicator(
                      color: colorScheme.secondary,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.uploadingPhoto,
                    style: GoogleFonts.dmSans(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}