import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';

class OnboardingController {
  // Page and Animation Controllers
  final PageController pageController = PageController();
  late AnimationController _animationController;
  late AnimationController _slideAnimationController;
  late AnimationController _scaleAnimationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;

  // Text Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final alternatePhoneController = TextEditingController();

  // Focus Nodes
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final alternatePhoneFocus = FocusNode();

  // State Variables
  int _currentStep = 0;
  final int totalSteps = 4;
  bool _isLoading = false;
  bool _isUploadingImage = false;
  bool _isPickingImage = false;
  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _googleIdToken;
  String? _userEmail;

  // State change notifiers
  VoidCallback? _onStateChanged;

  // Getters
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  bool get isUploadingImage => _isUploadingImage;
  bool get isPickingImage => _isPickingImage;
  File? get selectedImage => _selectedImage;
  String? get uploadedImageUrl => _uploadedImageUrl;
  String? get googleIdToken => _googleIdToken;
  String? get userEmail => _userEmail;

  OnboardingController({required TickerProvider vsync}) {
    _initializeAnimations(vsync);
  }

  void setStateChangeCallback(VoidCallback callback) {
    _onStateChanged = callback;
  }

  void _notifyStateChange() {
    _onStateChanged?.call();
  }

  void _initializeAnimations(TickerProvider vsync) {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: vsync,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOutQuart),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.elasticOut),
    );

    startAnimations();
  }

  void startAnimations() {
    _animationController.forward();
    _slideAnimationController.forward();
    _scaleAnimationController.forward();
  }

  void resetAnimations() {
    _animationController.reset();
    _slideAnimationController.reset();
    _scaleAnimationController.reset();
    startAnimations();
  }

  void shake() {
    _scaleAnimationController.reset();
    _scaleAnimationController.forward();
  }

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
    }
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    _notifyStateChange();
  }

  void setUploadingImage(bool uploading) {
    _isUploadingImage = uploading;
    _notifyStateChange();
  }

  void setPickingImage(bool picking) {
    _isPickingImage = picking;
    _notifyStateChange();
  }

  String getButtonText() {
    switch (_currentStep) {
      case 0:
        return 'Continue with Name';
      case 1:
        return 'Continue to Email';
      case 2:
        return 'Continue to Phone';
      case 3:
        return 'Complete Setup';
      default:
        return 'Continue';
    }
  }

  Future<void> pickImage({
    required Function(String) onError,
  }) async {
    setPickingImage(true);

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        _selectedImage = File(pickedFile.path);
        _uploadedImageUrl = null;
        _scaleAnimationController.reset();
        _scaleAnimationController.forward();
        _notifyStateChange();
      }
    } catch (e) {
      onError('Failed to pick image: $e');
    } finally {
      setPickingImage(false);
    }
  }

  Future<void> uploadImage({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    if (_selectedImage == null) return;

    setUploadingImage(true);

    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('driver-profiles/$fileName');

      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      _uploadedImageUrl = downloadUrl;
      setUploadingImage(false);
      onSuccess('Photo uploaded successfully!');
    } catch (e) {
      setUploadingImage(false);
      onError('Failed to upload photo: $e');
    }
  }

  Future<void> linkEmailWithGoogle({
    required Function(String) onError,
    required Function(String) onSuccess,
  }) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '691159300275-37gn4bpd7jrkld0cmot36vl181s3tsf3.apps.googleusercontent.com',
      );

      await googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      _googleIdToken = googleAuth.idToken;
      _userEmail = googleUser.email;

      onSuccess('Email verified with Google!');
      _scaleAnimationController.reset();
      _scaleAnimationController.forward();
      _notifyStateChange();
    } catch (e) {
      onError('Failed to sign in with Google: $e');
    }
  }

  void dispose() {
    pageController.dispose();
    _animationController.dispose();
    _slideAnimationController.dispose();
    _scaleAnimationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    alternatePhoneController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    alternatePhoneFocus.dispose();
  }
}