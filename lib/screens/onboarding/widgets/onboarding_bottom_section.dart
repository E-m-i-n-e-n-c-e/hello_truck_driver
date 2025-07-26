import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';

class OnboardingBottomSection extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onNextPressed;

  const OnboardingBottomSection({
    super.key,
    required this.controller,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 44),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Skip button for optional steps
          // if (controller.currentStep > 0 && controller.currentStep < controller.totalSteps - 1)
          //   FadeTransition(
          //     opacity: controller.fadeAnimation,
          //     child: TextButton(
          //       onPressed: onNextPressed,
          //       child: Text(
          //         'Skip this step',
          //         style: GoogleFonts.dmSans(
          //           color: colorScheme.onSurface.withValues(alpha: 0.6),
          //           fontSize: 14,
          //           fontWeight: FontWeight.w500,
          //         ),
          //       ),
          //     ),
          //   ),

          const SizedBox(height: 10),

          // Enhanced main button with better loading states
          ScaleTransition(
            scale: controller.scaleAnimation,
            child: SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                onPressed: controller.isLoading || controller.isUploadingImage ? null : onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(
                    colorScheme.onSecondary.withValues(alpha: 0.1),
                  ),
                ),
                child: controller.isLoading || controller.isUploadingImage
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation(
                                colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            controller.isUploadingImage ? 'Uploading Photo...' : 'Setting Up Profile...',
                            style: GoogleFonts.dmSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        controller.getButtonText(),
                        style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}