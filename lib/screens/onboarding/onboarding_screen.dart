import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_header.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_bottom_section.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/name_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/photo_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/email_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/phone_step.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late OnboardingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingController(vsync: this);

    // Set up state change callback to trigger rebuilds
    _controller.setStateChangeCallback(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_controller.currentStep < _controller.totalSteps - 1) {
      if (await _validateCurrentStep()) {
        setState(() => _controller.nextStep());
        _controller.pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
        _controller.resetAnimations();
      }
    } else {
      if (await _validateCurrentStep()) {
        await _submitOnboarding();
      }
    }
  }

  Future<void> _previousStep() async {
    if (_controller.currentStep > 0) {
      setState(() => _controller.previousStep());
      _controller.pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
      _controller.resetAnimations();
    }
  }

  Future<bool> _validateCurrentStep() async {
    switch (_controller.currentStep) {
      case 0: // Name step
        if (_controller.firstNameController.text.trim().isEmpty) {
          _showError('Please enter your first name');
          _controller.shake();
          return false;
        }
        return true;
      case 1: // Photo step
        if (_controller.selectedImage == null && _controller.uploadedImageUrl == null) {
          return true; // Photo is optional
        }
        if (_controller.selectedImage != null && _controller.uploadedImageUrl == null) {
          await _controller.uploadImage(
            onError: _showError,
            onSuccess: _showSuccess,
          );
        }
        return _controller.uploadedImageUrl != null || _controller.selectedImage == null;
      case 2: // Email step (optional)
        return true;
      case 3: // Phone step (optional)
        if (_controller.alternatePhoneController.text.trim().isNotEmpty) {
          if (!RegExp(r'^[0-9]{10}$')
              .hasMatch(_controller.alternatePhoneController.text.trim())) {
            _showError('Please enter a valid 10-digit phone number');
            _controller.shake();
            return false;
          }
        }
        return true;
      default:
        return true;
    }
  }

  void _showError(String message) {
    SnackBars.error(context, message);
  }

  void _showSuccess(String message) {
    SnackBars.success(context, message);
  }

  Future<void> _submitOnboarding() async {
    _controller.setLoading(true);

    try {
      final api = await ref.read(apiProvider.future);

      await driver_api.updateDriverProfile(
        api,
        firstName: _controller.firstNameController.text.trim(),
        lastName: _controller.lastNameController.text.trim().isEmpty
            ? null
            : _controller.lastNameController.text.trim(),
        alternatePhone: _controller.alternatePhoneController.text.trim().isEmpty
            ? null
            : _controller.alternatePhoneController.text.trim(),
        photo: _controller.uploadedImageUrl,
        googleIdToken: _controller.googleIdToken,
      );

      ref.read(authClientProvider).refreshTokens();
    } catch (e) {
      if (mounted) {
        _showError('Failed to complete onboarding: $e');
        _controller.setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Enhanced Header with improved progress indicator
            OnboardingHeader(
              controller: _controller,
              onPreviousPressed: _previousStep,
            ),

            // Content with better animations
            Expanded(
              child: PageView(
                controller: _controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  NameStep(controller: _controller, onNext: _nextStep),
                  PhotoStep(
                    controller: _controller,
                    onNext: _nextStep,
                    onError: _showError,
                  ),
                  EmailStep(
                    controller: _controller,
                    onNext: _nextStep,
                    onError: _showError,
                    onSuccess: _showSuccess,
                  ),
                  PhoneStep(controller: _controller, onNext: _nextStep),
                ],
              ),
            ),

            // Enhanced Bottom Section with better visual hierarchy
            OnboardingBottomSection(
              controller: _controller,
              onNextPressed: _nextStep,
            ),
          ],
        ),
      ),
    );
  }
}