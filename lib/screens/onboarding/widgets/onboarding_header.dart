import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';

class OnboardingHeader extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onPreviousPressed;

  const OnboardingHeader({
    super.key,
    required this.controller,
    required this.onPreviousPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.surface.withValues(alpha: 0.95),
          ],
        ),
      ),
      child: Column(
        children: [
          // Enhanced top bar with better spacing
          Row(
            children: [
              if (controller.currentStep > 0)
                ScaleTransition(
                  scale: controller.scaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: onPreviousPressed,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: colorScheme.onSurface,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 52),
              Expanded(
                child: Center(
                  child: FadeTransition(
                    opacity: controller.fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Step ${controller.currentStep + 1} of ${controller.totalSteps}',
                        style: GoogleFonts.dmSans(
                          color: colorScheme.onSecondaryContainer,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 52),
            ],
          ),

          const SizedBox(height: 24),

          // Enhanced progress bar with animated segments
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: colorScheme.outline.withValues(alpha: 0.1),
            ),
            child: Stack(
              children: [
                Row(
                  children: List.generate(controller.totalSteps, (index) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < controller.totalSteps - 1 ? 2 : 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: index <= controller.currentStep
                              ? colorScheme.secondary
                              : Colors.transparent,
                        ),
                        child: AnimatedContainer(
                          duration: Duration(
                            milliseconds: 800 + (index * 100),
                          ),
                          curve: Curves.easeInOutCubic,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: index <= controller.currentStep
                                ? LinearGradient(
                                    colors: [
                                      colorScheme.secondary,
                                      colorScheme.secondaryContainer,
                                    ],
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}