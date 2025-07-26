import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';

class OnboardingStepIcon extends StatelessWidget {
  final OnboardingController controller;
  final IconData icon;

  const OnboardingStepIcon({
    super.key,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: controller.scaleAnimation,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.secondary,
              colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.secondary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 44,
          color: colorScheme.onSecondary,
        ),
      ),
    );
  }
}

class OnboardingStepTitle extends StatelessWidget {
  final OnboardingController controller;
  final String title;

  const OnboardingStepTitle({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: Text(
        title,
        style: GoogleFonts.dmSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
          height: 1.2,
        ),
      ),
    );
  }
}

class OnboardingStepDescription extends StatelessWidget {
  final OnboardingController controller;
  final String description;

  const OnboardingStepDescription({
    super.key,
    required this.controller,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: Text(
        description,
        style: GoogleFonts.dmSans(
          fontSize: 16,
          color: colorScheme.onSurface.withValues(alpha: 0.7),
          height: 1.6,
        ),
      ),
    );
  }
}

class OnboardingTextField extends StatelessWidget {
  final OnboardingController controller;
  final TextEditingController textController;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final IconData icon;
  final bool isRequired;
  final TextInputType? keyboardType;
  final String? prefixText;
  final Function(String)? onSubmitted;

  const OnboardingTextField({
    super.key,
    required this.controller,
    required this.textController,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.icon,
    this.isRequired = false,
    this.keyboardType,
    this.prefixText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: controller.scaleAnimation,
      child: TextFormField(
        controller: textController,
        focusNode: focusNode,
        keyboardType: keyboardType,
        onFieldSubmitted: onSubmitted,
        style: GoogleFonts.dmSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          prefixText: prefixText,
          prefixIcon: Container(
            margin: const EdgeInsets.all(14),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.secondary.withValues(alpha: 0.15),
                  colorScheme.secondaryContainer.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: colorScheme.secondary,
            ),
          ),
          labelStyle: GoogleFonts.dmSans(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: GoogleFonts.dmSans(
            color: colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: colorScheme.secondary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
        ),
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class OnboardingStepContainer extends StatelessWidget {
  final OnboardingController controller;
  final Widget child;

  const OnboardingStepContainer({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller.fadeAnimation,
      child: SlideTransition(
        position: controller.slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: child,
        ),
      ),
    );
  }
}