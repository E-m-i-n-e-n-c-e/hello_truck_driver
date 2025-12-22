import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

class PhoneStep extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onNext;

  const PhoneStep({
    super.key,
    required this.controller,
    required this.onNext,
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
            icon: Icons.phone_rounded,
          ),

          const SizedBox(height: 40),

          OnboardingStepTitle(
            controller: controller,
            title: l10n.almostDone,
          ),

          const SizedBox(height: 16),

          OnboardingStepDescription(
            controller: controller,
            description: l10n.phoneStepDescription,
          ),

          const SizedBox(height: 56),

          OnboardingTextField(
            controller: controller,
            textController: controller.alternatePhoneController,
            focusNode: controller.alternatePhoneFocus,
            label: l10n.alternatePhone,
            hint: l10n.phoneNumber,
            icon: Icons.phone_rounded,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            prefixText: '+91 ',
            onSubmitted: (_) => onNext(),
          ),

          const SizedBox(height: 40),

          // Enhanced completion card
          ScaleTransition(
            scale: controller.scaleAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondary.withValues(alpha: 0.1),
                    colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.secondary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.secondary,
                          colorScheme.secondaryContainer,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.secondary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.celebration_rounded,
                      color: colorScheme.onSecondary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.youAreAllSet,
                          style: GoogleFonts.dmSans(
                            color: colorScheme.secondary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.completeProfileDescription,
                          style: GoogleFonts.dmSans(
                            color: colorScheme.secondary.withValues(alpha: 0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}