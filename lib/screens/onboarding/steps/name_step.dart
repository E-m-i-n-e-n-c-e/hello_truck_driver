import 'package:flutter/material.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';

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
    return OnboardingStepContainer(
      controller: controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            title: 'What\'s your name?',
          ),

          const SizedBox(height: 16),

          OnboardingStepDescription(
            controller: controller,
            description: 'This will be displayed on your driver profile and help customers identify you during their rides.',
          ),

          const SizedBox(height: 56),

          // Enhanced text fields with better animations
          OnboardingTextField(
            controller: controller,
            textController: controller.firstNameController,
            focusNode: controller.firstNameFocus,
            label: 'First Name',
            hint: 'Enter your first name',
            icon: Icons.person_rounded,
            isRequired: true,
            onSubmitted: (_) => controller.lastNameFocus.requestFocus(),
          ),

          const SizedBox(height: 24),

          OnboardingTextField(
            controller: controller,
            textController: controller.lastNameController,
            focusNode: controller.lastNameFocus,
            label: 'Last Name',
            hint: 'Enter your last name (optional)',
            icon: Icons.person_outline_rounded,
            onSubmitted: (_) => onNext(),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}