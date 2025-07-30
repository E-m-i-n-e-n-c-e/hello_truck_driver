import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hello_truck_driver/models/documents.dart';
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
  final panNumberController = TextEditingController();

  // Focus Nodes
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final alternatePhoneFocus = FocusNode();
  final panNumberFocus = FocusNode();

  // State Variables
  int _currentStep = 0;
  final int totalSteps = 5; // Name, Photo, Email, Phone, Documents
  bool _isLoading = false;
  bool _isUploadingImage = false;
  bool _isPickingImage = false;
  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _googleIdToken;
  String? _userEmail;

  // Document-related state
  File? _selectedLicense;
  File? _selectedRcBook;
  File? _selectedFc;
  File? _selectedInsurance;
  File? _selectedAadhar;
  File? _selectedEbBill;
  String? _uploadedLicenseUrl;
  String? _uploadedRcBookUrl;
  String? _uploadedFcUrl;
  String? _uploadedInsuranceUrl;
  String? _uploadedAadharUrl;
  String? _uploadedEbBillUrl;
  DateTime? _licenseExpiry;
  DateTime? _fcExpiry;
  DateTime? _insuranceExpiry;
  final Set<String> _uploadingDocuments = <String>{};

  // State change notifiers
  VoidCallback? _onStateChanged;

  // Getters
  int get currentStep => _currentStep;
  bool get isLoading => _isLoading;
  bool get isUploadingImage => _isUploadingImage;
  bool get isPickingImage => _isPickingImage;
  bool get isUploadingDocument => _uploadingDocuments.isNotEmpty;
  bool isUploadingSpecificDocument(String documentType) => _uploadingDocuments.contains(documentType);
  File? get selectedImage => _selectedImage;
  String? get uploadedImageUrl => _uploadedImageUrl;
  String? get googleIdToken => _googleIdToken;
  String? get userEmail => _userEmail;

  // Document getters
  File? get selectedLicense => _selectedLicense;
  File? get selectedRcBook => _selectedRcBook;
  File? get selectedFc => _selectedFc;
  File? get selectedInsurance => _selectedInsurance;
  File? get selectedAadhar => _selectedAadhar;
  File? get selectedEbBill => _selectedEbBill;
  String? get uploadedLicenseUrl => _uploadedLicenseUrl;
  String? get uploadedRcBookUrl => _uploadedRcBookUrl;
  String? get uploadedFcUrl => _uploadedFcUrl;
  String? get uploadedInsuranceUrl => _uploadedInsuranceUrl;
  String? get uploadedAadharUrl => _uploadedAadharUrl;
  String? get uploadedEbBillUrl => _uploadedEbBillUrl;
  DateTime? get licenseExpiry => _licenseExpiry;
  DateTime? get fcExpiry => _fcExpiry;
  DateTime? get insuranceExpiry => _insuranceExpiry;

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
      duration: const Duration(milliseconds: 600), // Reduced from 1000ms
      vsync: vsync,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400), // Reduced from 800ms
      vsync: vsync,
    );

    _scaleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Reduced from 600ms
      vsync: vsync,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut), // Simpler curve
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2), // Reduced from 0.3
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOut, // Simpler curve
    ));

    scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate( // Reduced from 0.8
      CurvedAnimation(parent: _scaleAnimationController, curve: Curves.easeOut), // Simpler curve
    );

    startAnimations();
  }

  void startAnimations() {
    // Start animations sequentially with slight delays to reduce load
    _animationController.forward();

    // Start slide animation with a small delay
    Future.delayed(const Duration(milliseconds: 100), () {
      try {
        _slideAnimationController.forward();
      } catch (e) {
        // Controller might be disposed, ignore
      }
    });

    // Start scale animation with a larger delay
    Future.delayed(const Duration(milliseconds: 200), () {
      try {
        _scaleAnimationController.forward();
      } catch (e) {
        // Controller might be disposed, ignore
      }
    });
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

  // Navigation
  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      _notifyStateChange();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      _notifyStateChange();
    }
  }

  void setCurrentStep(int step) {
    _currentStep = step;
    _notifyStateChange();
  }

  // Loading state
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

  void setUploadingDocument(String documentType, bool uploading) {
    if (uploading) {
      _uploadingDocuments.add(documentType);
    } else {
      _uploadingDocuments.remove(documentType);
    }
    _notifyStateChange();
  }

  // Get total steps
  int getTotalSteps() {
    return totalSteps;
  }

  // Validation
  bool validatePersonalInfo() {
    return firstNameController.text.trim().isNotEmpty;
  }

  bool validateEmail() {
    // Email step is optional - user can proceed with or without Google verification
    return true;
  }

  String? validatePhoneDetails() {
    final phone = alternatePhoneController.text.trim();

    if (phone.isEmpty) return null; // Phone is optional

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return 'Please enter a valid 10-digit phone number';
    }

    return null;
  }

  String? validateDocuments() {

    // Validate PAN number format
    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(panNumberController.text.trim())) {
      return 'Please enter a valid PAN number';
      // example: ABCDE1234F
    }

    // Check if all required documents are uploaded
    if (_uploadedLicenseUrl == null) return 'Please upload your driving license';
    if (_licenseExpiry == null) return 'Please select license expiry date';
    if (_uploadedRcBookUrl == null) return 'Please upload your RC book';
    if (_uploadedFcUrl == null) return 'Please upload your FC certificate';
    if (_fcExpiry == null) return 'Please select FC expiry date';
    if (_uploadedInsuranceUrl == null) return 'Please upload your insurance certificate';
    if (_insuranceExpiry == null) return 'Please select insurance expiry date';
    if (_uploadedAadharUrl == null) return 'Please upload your Aadhar card';
    if (_uploadedEbBillUrl == null) return 'Please upload your electricity bill';
    if (panNumberController.text.trim().isEmpty) return 'Please enter your PAN number';



    return null;
  }

  String getButtonText() {
    if (_currentStep == totalSteps - 1) {
      return 'Complete Setup';
    }
    return 'Continue';
  }

  // Document methods
  void setLicenseExpiry(DateTime date) {
    _licenseExpiry = date;
    _notifyStateChange();
  }

  void setFcExpiry(DateTime date) {
    _fcExpiry = date;
    _notifyStateChange();
  }

  void setInsuranceExpiry(DateTime date) {
    _insuranceExpiry = date;
    _notifyStateChange();
  }

  Future<bool> pickDocument({
    required String documentType,
    required Function(String) onError,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Validate file size (limit to 10MB)
        final fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) {
          onError('File size must be less than 10MB');
          return false;
        }

        switch (documentType) {
          case 'license':
            _selectedLicense = file;
            _uploadedLicenseUrl = null;
            break;
          case 'rcBook':
            _selectedRcBook = file;
            _uploadedRcBookUrl = null;
            break;
          case 'fc':
            _selectedFc = file;
            _uploadedFcUrl = null;
            break;
          case 'insurance':
            _selectedInsurance = file;
            _uploadedInsuranceUrl = null;
            break;
          case 'aadhar':
            _selectedAadhar = file;
            _uploadedAadharUrl = null;
            break;
          case 'ebBill':
            _selectedEbBill = file;
            _uploadedEbBillUrl = null;
            break;
        }

        _notifyStateChange();
        return true; // Successfully picked document
      }
    } catch (e) {
      onError('Failed to pick document: $e');
    }
    return false; // Document picking failed
  }

  Future<void> uploadDocument({
    required String documentType,
    required Function(String) onError,
    required Function(String) onSuccess,
    required WidgetRef ref,
  }) async {
    File? selectedFile;

    switch (documentType) {
      case 'license':
        selectedFile = _selectedLicense;
        break;
      case 'rcBook':
        selectedFile = _selectedRcBook;
        break;
      case 'fc':
        selectedFile = _selectedFc;
        break;
      case 'insurance':
        selectedFile = _selectedInsurance;
        break;
      case 'aadhar':
        selectedFile = _selectedAadhar;
        break;
      case 'ebBill':
        selectedFile = _selectedEbBill;
        break;
    }

    if (selectedFile == null) return;

    setUploadingDocument(documentType, true);

    try {
      // Get file extension from the actual file
      final fileExtension = selectedFile.path.split('.').last.toLowerCase();
      final fileName = '${documentType}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'driver-documents/$fileName';
      final api = ref.read(apiProvider).value!;
      final downloadUrl = await api.uploadFile(selectedFile, filePath, fileExtension);

      switch (documentType) {
        case 'license':
          _uploadedLicenseUrl = downloadUrl;
          break;
        case 'rcBook':
          _uploadedRcBookUrl = downloadUrl;
          break;
        case 'fc':
          _uploadedFcUrl = downloadUrl;
          break;
        case 'insurance':
          _uploadedInsuranceUrl = downloadUrl;
          break;
        case 'aadhar':
          _uploadedAadharUrl = downloadUrl;
          break;
        case 'ebBill':
          _uploadedEbBillUrl = downloadUrl;
          break;
      }

      setUploadingDocument(documentType, false);
      onSuccess('Document uploaded successfully!');
    } catch (e) {
      setUploadingDocument(documentType, false);
      onError('Failed to upload document: $e');
    }
  }

  DriverDocuments? getDriverDocuments() {
    if (_uploadedLicenseUrl == null ||
        _uploadedRcBookUrl == null ||
        _uploadedFcUrl == null ||
        _uploadedInsuranceUrl == null ||
        _uploadedAadharUrl == null ||
        _uploadedEbBillUrl == null ||
        _licenseExpiry == null ||
        _fcExpiry == null ||
        _insuranceExpiry == null) {
      return null;
    }

    return DriverDocuments(
      licenseUrl: _uploadedLicenseUrl!,
      licenseExpiry: _licenseExpiry!,
      rcBookUrl: _uploadedRcBookUrl!,
      fcUrl: _uploadedFcUrl!,
      fcExpiry: _fcExpiry!,
      insuranceUrl: _uploadedInsuranceUrl!,
      insuranceExpiry: _insuranceExpiry!,
      aadharUrl: _uploadedAadharUrl!,
      panNumber: panNumberController.text.trim(),
      ebBillUrl: _uploadedEbBillUrl!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
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
    required WidgetRef ref,
  }) async {
    if (_selectedImage == null) return;

    setUploadingImage(true);

    try {
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = 'driver-profiles/$fileName';
      final api = ref.read(apiProvider).value!;
      final downloadUrl = await api.uploadFile(_selectedImage!, filePath, 'image/jpeg');

      _uploadedImageUrl = downloadUrl;
      setUploadingImage(false);
      onSuccess('Photo uploaded successfully!');
    } catch (e) {
      setUploadingImage(false);
      onError('Failed to upload photo: $e');
    }
  }

  // Google OAuth
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
    panNumberController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    alternatePhoneFocus.dispose();
    panNumberFocus.dispose();
  }
}