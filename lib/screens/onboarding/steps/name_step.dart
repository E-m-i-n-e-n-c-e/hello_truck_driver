import 'package:flutter/material.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

class NameStep extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onNext;

  const NameStep({
    super.key,
    required this.controller,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OnboardingStepContainer(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),

          // Enhanced icon with gradient background
          OnboardingStepIcon(
            controller: controller,
            icon: Icons.person_outline_rounded,
          ),

          const SizedBox(height: 40),

          // Enhanced title with better typography
          OnboardingStepTitle(
            controller: controller,
            title: l10n.nameStepTitle,
          ),

          const SizedBox(height: 16),

          OnboardingStepDescription(
            controller: controller,
            description: l10n.nameStepDescription,
          ),

          const SizedBox(height: 56),

          // Enhanced text fields with better animations
          OnboardingTextField(
            controller: controller,
            textController: controller.firstNameController,
            focusNode: controller.firstNameFocus,
            label: l10n.firstName,
            hint: l10n.enterFirstName,
            icon: Icons.person_rounded,
            isRequired: true,
            onSubmitted: (_) => controller.lastNameFocus.requestFocus(),
          ),

          const SizedBox(height: 24),

          OnboardingTextField(
            controller: controller,
            textController: controller.lastNameController,
            focusNode: controller.lastNameFocus,
            label: l10n.lastName,
            hint: l10n.enterLastNameOptional,
            icon: Icons.person_outline_rounded,
            onSubmitted: (_) => onNext(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}