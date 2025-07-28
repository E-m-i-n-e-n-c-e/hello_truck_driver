import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_header.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_bottom_section.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/name_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/photo_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/email_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/phone_step.dart';
import 'package:hello_truck_driver/screens/onboarding/steps/documents_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  late OnboardingController _controller;
  final _formKey = GlobalKey<FormState>();

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
    if (await _validateCurrentStep()) {
      if (_controller.currentStep < _controller.getTotalSteps() - 1) {
        if (mounted) {
          FocusScope.of(context).unfocus(); // Dismiss keyboard
        }
        _controller.nextStep();
        _controller.pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _controller.resetAnimations();
      }
    }
  }

  void _previousStep() {
    if (_controller.currentStep > 0) {
      if (mounted) {
        FocusScope.of(context).unfocus(); // Dismiss keyboard
      }
      _controller.previousStep();
      _controller.pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _controller.resetAnimations();
    }
  }

  Future<bool> _validateCurrentStep() async {
    switch (_controller.currentStep) {
      case 0: // Name step
        if (!_controller.validatePersonalInfo()) {
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

      case 2: // Email step
        if (!_controller.validateEmail()) {
          _showError('Please enter a valid email address');
          _controller.shake();
          return false;
        }
        return true;

      case 3: // Documents step
        final documentError = _controller.validateDocuments();
        if (documentError != null) {
          _showError(documentError);
          _controller.shake();
          return false;
        }
        return true;

      case 4: // Phone step
        final error = _controller.validatePhoneDetails();
        if (error != null) {
          _showError(error);
          _controller.shake();
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  Future<void> _submitForm() async {
    if (!await _validateCurrentStep()) return;

    _controller.setLoading(true);
    try {
      final api = await ref.read(apiProvider.future);
      final documents = _controller.getDriverDocuments();

      if (documents == null) {
        _showError('Please complete all document uploads');
        _controller.setLoading(false);
        return;
      }

      await driver_api.createDriverProfile(
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
        documents: documents,
      );

      if (mounted) {
        // Refresh tokens to update auth state
        ref.read(authClientProvider).refreshTokens();
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to complete onboarding: $e');
        _controller.setLoading(false);
      }
    }
  }

  void _showError(String message) {
    SnackBars.error(context, message);
  }

  void _showSuccess(String message) {
    SnackBars.success(context, message);
  }

  List<Widget> _getSteps() {
    final steps = <Widget>[
      // Step 0: Name
      NameStep(
        controller: _controller,
        onNext: _nextStep,
      ),

      // Step 1: Photo
      PhotoStep(
        controller: _controller,
        onNext: _nextStep,
        onError: _showError,
      ),

      // Step 2: Email
      EmailStep(
        controller: _controller,
        onNext: _nextStep,
        onError: _showError,
        onSuccess: _showSuccess,
      ),

      // Step 3: Documents
      DocumentsStep(
        controller: _controller,
        onNext: _nextStep,
        onError: _showError,
      ),

      // Step 4: Phone      // Step 3: Phone
      PhoneStep(
        controller: _controller,
        onNext: _nextStep,
      ),
    ];

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header with progress
              OnboardingHeader(controller: _controller),

              // Content
              Expanded(
                child: PageView(
                  controller: _controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _getSteps().map((step) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Step content
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height -
                                        MediaQuery.of(context).padding.top -
                                        MediaQuery.of(context).padding.bottom -
                                        180, // Adjust based on header and bottom section height
                            ),
                            child: step,
                          ),
                          // Bottom section with navigation
                          OnboardingBottomSection(
                            controller: _controller,
                            onNext: _nextStep,
                            onPrevious: _previousStep,
                            onSubmit: _submitForm,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}