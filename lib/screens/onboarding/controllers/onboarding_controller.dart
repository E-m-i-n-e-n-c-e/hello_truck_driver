import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/address.dart';
import 'package:hello_truck_driver/models/vehicle.dart';
import 'package:hello_truck_driver/models/vehicle_owner.dart';
import 'package:hello_truck_driver/models/enums/vehicle_enums.dart';
import 'package:hello_truck_driver/models/enums/payout_enums.dart';
import 'package:hello_truck_driver/models/payout_details.dart';
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

  // Address Controllers
  final addressLine1Controller = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeController = TextEditingController();
  final cityController = TextEditingController();
  final districtController = TextEditingController();
  final stateController = TextEditingController();

  // Vehicle Controllers
  final vehicleNumberController = TextEditingController();
  final vehicleBodyLengthController = TextEditingController();

  // Vehicle Owner Controllers
  final ownerNameController = TextEditingController();
  final ownerContactController = TextEditingController();
  final ownerAddressLine1Controller = TextEditingController();
  final ownerLandmarkController = TextEditingController();
  final ownerPincodeController = TextEditingController();
  final ownerCityController = TextEditingController();
  final ownerDistrictController = TextEditingController();
  final ownerStateController = TextEditingController();

  // Payout Controllers
  final accountHolderNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final vpaController = TextEditingController();

  // Vehicle Owner Document
  File? _selectedOwnerAadhar;
  String? _uploadedOwnerAadharUrl;

  // Vehicle Image
  File? _selectedVehicleImage;
  String? _uploadedVehicleImageUrl;

  // Focus Nodes - Basic Info
  final firstNameFocus = FocusNode();
  final lastNameFocus = FocusNode();
  final alternatePhoneFocus = FocusNode();
  final panNumberFocus = FocusNode();

  // Address Focus Nodes
  final addressLine1Focus = FocusNode();
  final landmarkFocus = FocusNode();
  final pincodeFocus = FocusNode();
  final cityFocus = FocusNode();
  final districtFocus = FocusNode();
  final stateFocus = FocusNode();

  // Vehicle Focus Nodes
  final vehicleNumberFocus = FocusNode();
  final vehicleBodyLengthFocus = FocusNode();

  // Vehicle Owner Focus Nodes
  final ownerNameFocus = FocusNode();
  final ownerContactFocus = FocusNode();
  final ownerAddressLine1Focus = FocusNode();
  final ownerLandmarkFocus = FocusNode();
  final ownerPincodeFocus = FocusNode();
  final ownerCityFocus = FocusNode();
  final ownerDistrictFocus = FocusNode();
  final ownerStateFocus = FocusNode();

  // Payout Focus Nodes
  final accountHolderNameFocus = FocusNode();
  final accountNumberFocus = FocusNode();
  final ifscCodeFocus = FocusNode();
  final vpaFocus = FocusNode();

  // State Variables
  int _currentStep = 0;
  final int totalSteps = 8; // Name, Photo, Email, Documents, Address, Vehicle, Payout, Phone
  bool _isLoading = false;
  bool _isUploadingImage = false;
  bool _isPickingImage = false;
  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _googleIdToken;
  String? _userEmail;

  // Address Location
  double? _selectedLatitude;
  double? _selectedLongitude;

  // Vehicle State
  VehicleType? _selectedVehicleType;
  VehicleBodyType? _selectedVehicleBodyType;
  FuelType? _selectedFuelType;
  bool _sameAsDriver = false; // For vehicle owner

  // Payout State
  PayoutMethod _selectedPayoutMethod = PayoutMethod.vpa;

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

  // Vehicle Owner Document getters
  File? get selectedOwnerAadhar => _selectedOwnerAadhar;
  String? get uploadedOwnerAadharUrl => _uploadedOwnerAadharUrl;

  // Vehicle Image getters
  File? get selectedVehicleImage => _selectedVehicleImage;
  String? get uploadedVehicleImageUrl => _uploadedVehicleImageUrl;

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
  String? validatePersonalInfo() {
    final firstName = firstNameController.text.trim();
    if (firstName.isEmpty) {
      return 'Please enter your first name';
    }
    if (firstName.length < 3) {
      return 'First name must be at least 3 characters long';
    }
    return null;
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

  String? validateAddress() {
    if (addressLine1Controller.text.trim().isEmpty) {
      return 'Please enter address line 1';
    }
    if (pincodeController.text.trim().isEmpty) {
      return 'Please enter pincode';
    }
    if (!RegExp(r'^[0-9]{6}$').hasMatch(pincodeController.text.trim())) {
      return 'Please enter a valid 6-digit pincode';
    }
    if (cityController.text.trim().isEmpty) {
      return 'Please enter city';
    }
    if (districtController.text.trim().isEmpty) {
      return 'Please enter district';
    }
    if (stateController.text.trim().isEmpty) {
      return 'Please enter state';
    }
    return null;
  }

  String? validateVehicle() {
    if (vehicleNumberController.text.trim().isEmpty) {
      return 'Please enter vehicle number';
    }
    if (vehicleBodyLengthController.text.trim().isEmpty) {
      return 'Please enter vehicle body length';
    }

    // Validate vehicle body length is a valid number
    try {
      final length = double.parse(vehicleBodyLengthController.text.trim());
      if (length <= 0) {
        return 'Vehicle body length must be greater than 0';
      }
    } catch (e) {
      return 'Please enter a valid vehicle body length';
    }

    // Validate vehicle type selection
    if (_selectedVehicleType == null) {
      return 'Please select vehicle type';
    }

    // Validate vehicle body type selection
    if (_selectedVehicleBodyType == null) {
      return 'Please select vehicle body type';
    }

    // Validate fuel type selection
    if (_selectedFuelType == null) {
      return 'Please select fuel type';
    }

    // Validate vehicle image
    if (_uploadedVehicleImageUrl == null) {
      return 'Please upload vehicle image';
    }

    // Validate owner details if not same as driver
    if (!_sameAsDriver) {
      if (ownerNameController.text.trim().isEmpty) {
        return 'Please enter owner name';
      }
      if (ownerContactController.text.trim().isEmpty) {
        return 'Please enter owner contact number';
      }
      if (!RegExp(r'^[0-9]{10}$').hasMatch(ownerContactController.text.trim())) {
        return 'Please enter a valid 10-digit owner contact number';
      }
      if (ownerAddressLine1Controller.text.trim().isEmpty) {
        return 'Please enter owner address';
      }
      if (ownerPincodeController.text.trim().isEmpty) {
        return 'Please enter owner pincode';
      }
      if (!RegExp(r'^[0-9]{6}$').hasMatch(ownerPincodeController.text.trim())) {
        return 'Please enter a valid 6-digit owner pincode';
      }
      if (ownerCityController.text.trim().isEmpty) {
        return 'Please enter owner city';
      }
      if (ownerDistrictController.text.trim().isEmpty) {
        return 'Please enter owner district';
      }
      if (ownerStateController.text.trim().isEmpty) {
        return 'Please enter owner state';
      }
      if (_uploadedOwnerAadharUrl == null) {
        return 'Please upload owner Aadhar card';
      }
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
    if (_uploadedRcBookUrl == null) return 'Please upload your RC book';
    if (_uploadedFcUrl == null) return 'Please upload your FC certificate';
    if (_uploadedInsuranceUrl == null) return 'Please upload your insurance certificate';
    if (_uploadedAadharUrl == null) return 'Please upload your Aadhar card';
    if (_uploadedEbBillUrl == null) return 'Please upload your electricity bill';
    if (panNumberController.text.trim().isEmpty) return 'Please enter your PAN number';

    return null;
  }

  String? validatePayout() {
    if (_selectedPayoutMethod == PayoutMethod.bankAccount) {
      if (accountHolderNameController.text.trim().isEmpty) return 'Please enter account holder name';
      if (accountNumberController.text.trim().isEmpty) return 'Please enter account number';
      if (ifscCodeController.text.trim().isEmpty) return 'Please enter IFSC code';
      if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(ifscCodeController.text.trim())) {
        return 'Please enter a valid IFSC code';
      }
      return null;
    } else {
      if (vpaController.text.trim().isEmpty) return 'Please enter UPI ID (VPA)';
      if (!RegExp(r'^[a-zA-Z0-9\.\-_]{2,256}@[a-zA-Z0-9\.\-_]{2,64}$').hasMatch(vpaController.text.trim())) {
        return 'Please enter a valid UPI ID';
      }
      return null;
    }
  }

  String getButtonText() {
    if (_currentStep == totalSteps - 1) {
      return 'Complete Setup';
    }
    return 'Continue';
  }

  // Document methods
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
          case 'ownerAadhar':
            _selectedOwnerAadhar = file;
            _uploadedOwnerAadharUrl = null;
            break;
          case 'vehicleImage':
            _selectedVehicleImage = file;
            _uploadedVehicleImageUrl = null;
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
      case 'ownerAadhar':
        selectedFile = _selectedOwnerAadhar;
        break;
      case 'vehicleImage':
        selectedFile = _selectedVehicleImage;
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
        case 'ownerAadhar':
          _uploadedOwnerAadharUrl = downloadUrl;
          break;
        case 'vehicleImage':
          _uploadedVehicleImageUrl = downloadUrl;
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
        _uploadedEbBillUrl == null) {
      return null;
    }

    return DriverDocuments(
      licenseUrl: _uploadedLicenseUrl!,
      rcBookUrl: _uploadedRcBookUrl!,
      fcUrl: _uploadedFcUrl!,
      insuranceUrl: _uploadedInsuranceUrl!,
      aadharUrl: _uploadedAadharUrl!,
      panNumber: panNumberController.text.trim(),
      ebBillUrl: _uploadedEbBillUrl!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Address? getAddress() {
    if (addressLine1Controller.text.trim().isEmpty ||
        pincodeController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty ||
        districtController.text.trim().isEmpty ||
        stateController.text.trim().isEmpty) {
      return null;
    }

    return Address(
      addressLine1: addressLine1Controller.text.trim(),
      landmark: landmarkController.text.trim().isEmpty
          ? null
          : landmarkController.text.trim(),
      pincode: pincodeController.text.trim(),
      city: cityController.text.trim(),
      district: districtController.text.trim(),
      state: stateController.text.trim(),
      latitude: _selectedLatitude,
      longitude: _selectedLongitude,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Vehicle? getVehicle() {
    if (vehicleNumberController.text.trim().isEmpty ||
        vehicleBodyLengthController.text.trim().isEmpty ||
        _selectedVehicleType == null ||
        _selectedVehicleBodyType == null ||
        _selectedFuelType == null ||
        _uploadedVehicleImageUrl == null) {
      return null;
    }

    // Validate owner details if not same as driver
    if (!_sameAsDriver) {
      if (ownerNameController.text.trim().isEmpty ||
          ownerContactController.text.trim().isEmpty ||
          ownerAddressLine1Controller.text.trim().isEmpty ||
          ownerPincodeController.text.trim().isEmpty ||
          ownerCityController.text.trim().isEmpty ||
          ownerDistrictController.text.trim().isEmpty ||
          ownerStateController.text.trim().isEmpty ||
          _uploadedOwnerAadharUrl == null) {
        return null;
      }
    }

    return Vehicle(
      vehicleNumber: vehicleNumberController.text.trim(),
      vehicleType: _selectedVehicleType!,
      vehicleBodyLength: double.parse(vehicleBodyLengthController.text.trim()),
      vehicleBodyType: _selectedVehicleBodyType!,
      fuelType: _selectedFuelType!,
      vehicleImageUrl: _uploadedVehicleImageUrl!,
      owner: _sameAsDriver
          ? null
          : VehicleOwner(
              name: ownerNameController.text.trim(),
              aadharUrl: _uploadedOwnerAadharUrl!,
              contactNumber: ownerContactController.text.trim(),
              addressLine1: ownerAddressLine1Controller.text.trim(),
              landmark: ownerLandmarkController.text.trim().isEmpty
                  ? null
                  : ownerLandmarkController.text.trim(),
              pincode: ownerPincodeController.text.trim(),
              city: ownerCityController.text.trim(),
              district: ownerDistrictController.text.trim(),
              state: ownerStateController.text.trim(),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  PayoutDetails? getPayoutDetails() {
    final error = validatePayout();
    if (error != null) return null;
    if (_selectedPayoutMethod == PayoutMethod.bankAccount) {
      return PayoutDetails(
        payoutMethod: PayoutMethod.bankAccount,
        bankDetails: BankDetails(
          accountHolderName: accountHolderNameController.text.trim(),
          accountNumber: accountNumberController.text.trim(),
          ifscCode: ifscCodeController.text.trim().toUpperCase(),
        ),
      );
    }
    return PayoutDetails(
      payoutMethod: PayoutMethod.vpa,
      vpaDetails: VpaDetails(vpa: vpaController.text.trim()),
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

  // Address Methods
  void updateSelectedLocation(double latitude, double longitude) {
    _selectedLatitude = latitude;
    _selectedLongitude = longitude;
    _notifyStateChange();
  }

  double? get selectedLatitude => _selectedLatitude;
  double? get selectedLongitude => _selectedLongitude;

  // Vehicle Methods
  VehicleType? get selectedVehicleType => _selectedVehicleType;
  VehicleBodyType? get selectedVehicleBodyType => _selectedVehicleBodyType;
  FuelType? get selectedFuelType => _selectedFuelType;
  bool get sameAsDriver => _sameAsDriver;

  void updateVehicleType(String type) {
    _selectedVehicleType = VehicleType.values.firstWhere(
      (e) => e.value == type
    );
    _notifyStateChange();
  }

  void updateVehicleBodyType(String type) {
    _selectedVehicleBodyType = VehicleBodyType.values.firstWhere(
      (e) => e.value == type
    );
    _notifyStateChange();
  }

  void updateFuelType(String type) {
    _selectedFuelType = FuelType.values.firstWhere(
      (e) => e.value == type
    );
    _notifyStateChange();
  }

  void updateSameAsDriver(bool value) {
    _sameAsDriver = value;
    _notifyStateChange();
  }

    // Payout Methods
  PayoutMethod get selectedPayoutMethod => _selectedPayoutMethod;

  void updatePayoutMethod(PayoutMethod method) {
    _selectedPayoutMethod = method;
    _notifyStateChange();
  }

  void dispose() {
    pageController.dispose();
    _animationController.dispose();
    _slideAnimationController.dispose();
    _scaleAnimationController.dispose();

    // Basic Info Controllers
    firstNameController.dispose();
    lastNameController.dispose();
    alternatePhoneController.dispose();
    panNumberController.dispose();

    // Address Controllers
    addressLine1Controller.dispose();
    landmarkController.dispose();
    pincodeController.dispose();
    cityController.dispose();
    districtController.dispose();
    stateController.dispose();

    // Vehicle Controllers
    vehicleNumberController.dispose();
    vehicleBodyLengthController.dispose();

    // Vehicle Owner Controllers
    ownerNameController.dispose();
    ownerContactController.dispose();
    ownerAddressLine1Controller.dispose();
    ownerLandmarkController.dispose();
    ownerPincodeController.dispose();
    ownerCityController.dispose();
    ownerDistrictController.dispose();
    ownerStateController.dispose();

    // Basic Info Focus Nodes
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    alternatePhoneFocus.dispose();
    panNumberFocus.dispose();

    // Address Focus Nodes
    addressLine1Focus.dispose();
    landmarkFocus.dispose();
    pincodeFocus.dispose();
    cityFocus.dispose();
    districtFocus.dispose();
    stateFocus.dispose();

    // Vehicle Focus Nodes
    vehicleNumberFocus.dispose();
    vehicleBodyLengthFocus.dispose();

    // Vehicle Owner Focus Nodes
    ownerNameFocus.dispose();
    ownerContactFocus.dispose();
    ownerAddressLine1Focus.dispose();
    ownerLandmarkFocus.dispose();
    ownerPincodeFocus.dispose();
    ownerCityFocus.dispose();
    ownerDistrictFocus.dispose();
    ownerStateFocus.dispose();

    // Payout controllers & focuses
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    vpaController.dispose();
    accountHolderNameFocus.dispose();
    accountNumberFocus.dispose();
    ifscCodeFocus.dispose();
    vpaFocus.dispose();
  }
}