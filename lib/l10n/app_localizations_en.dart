// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hello Truck Driver';

  @override
  String get languageSystem => 'System Default';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageTitle => 'Language';

  @override
  String get currentLanguage => 'English';

  @override
  String get loginTitle => 'Enter your phone number';

  @override
  String get loginSubtitle => 'We\'ll send you a verification code';

  @override
  String get phoneNumberHint => 'Phone Number';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get phoneEmptyError => 'Please enter your phone number';

  @override
  String get phoneInvalidError => 'Please enter a valid 10-digit phone number';

  @override
  String errorSendingOtp(String error) {
    return 'Error sending OTP: $error';
  }

  @override
  String get otpVerification => 'OTP Verification';

  @override
  String get otpSentTo => 'We have sent a verification code to';

  @override
  String get otpSentSuccess => 'OTP sent successfully!';

  @override
  String get checkTextMessages => 'Check text messages for your OTP';

  @override
  String get didntGetOtp => 'Didn\'t get the OTP?';

  @override
  String get resendSms => 'Resend SMS';

  @override
  String resendSmsIn(int seconds) {
    return 'Resend SMS in ${seconds}s';
  }

  @override
  String get changePhoneNumber => 'Change phone number';

  @override
  String errorVerifyingOtp(String error) {
    return 'Error verifying OTP: $error';
  }

  @override
  String get profile => 'Profile';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get retry => 'Retry';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get documents => 'Documents';

  @override
  String get documentsSubtitle => 'License, RC, Insurance & more';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get vehicleSubtitle => 'Vehicle details & owner info';

  @override
  String get address => 'Address';

  @override
  String get addressSubtitle => 'Your registered address';

  @override
  String get languageSubtitle => 'Change app language';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get alternatePhone => 'Alternate Phone';

  @override
  String get notSet => 'Not set';

  @override
  String get account => 'Account';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get notLinked => 'Not linked';

  @override
  String get link => 'Link';

  @override
  String get memberSince => 'Member Since';

  @override
  String get referralCode => 'Referral Code';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get pendingVerification => 'Pending Verification';

  @override
  String get verified => 'Verified';

  @override
  String get verificationRejected => 'Verification Rejected';

  @override
  String get profilePictureUpdated => 'Profile picture updated successfully';

  @override
  String get emailLinkedSuccess => 'Email Linked Successfully';

  @override
  String get firstNameUpdated => 'First name updated successfully';

  @override
  String get lastNameUpdated => 'Last name updated successfully';

  @override
  String get alternatePhoneUpdated => 'Alternate phone updated successfully';

  @override
  String failedToUpdate(String field, String error) {
    return 'Failed to update $field: $error';
  }

  @override
  String get dashboard => 'Dashboard';

  @override
  String get home => 'Home';

  @override
  String get rides => 'Rides';

  @override
  String get earnings => 'Earnings';

  @override
  String helloDriver(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get stayReadyEarnMore => 'Stay ready. Earn more.';

  @override
  String get todaysSummary => 'Today\'s Summary';

  @override
  String get ridesLabel => 'rides';

  @override
  String get earned => 'earned';

  @override
  String get status => 'Status';

  @override
  String get score => 'Score';

  @override
  String get todaysRides => 'Today\'s Rides';

  @override
  String get noRidesCompletedYet => 'No rides completed yet';

  @override
  String get completeFirstRide => 'Complete your first ride today!';

  @override
  String bookingNumber(String number) {
    return 'Booking #$number';
  }

  @override
  String get completed => 'Completed';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get documentExpired => 'Document Expired!';

  @override
  String get documentExpiringSoon => 'Document Expiring Soon';

  @override
  String get cannotTakeBookings =>
      'You cannot take bookings until documents are updated.';

  @override
  String get turnOnLocationServices => 'Turn on Location Services';

  @override
  String get locationServicesOffMessage =>
      'Location services are off. Without location, you won\'t be able to take rides.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get enableLocationPermission => 'Enable Location Permission';

  @override
  String get locationPermissionMessage =>
      'We need your location to assign rides. You won\'t be able to take rides otherwise.';

  @override
  String get enable => 'Enable';

  @override
  String get locationPermissionRequired => 'Location Permission Required';

  @override
  String get locationPermissionDeniedMessage =>
      'Permission is permanently denied. Open app settings to allow location.\nWithout this, you won\'t be able to take rides.';

  @override
  String get youAreOffline =>
      'You are offline. Please check your internet connection.';

  @override
  String get youAreBackOnline => 'You are back online';

  @override
  String get bookingCancelled => 'Booking Cancelled';

  @override
  String get bookingCancelledMessage =>
      'Sorry, your booking has been cancelled by the customer. You will receive some compensation for your time.';

  @override
  String failedToRejectBooking(String error) {
    return 'Failed to reject booking: $error';
  }

  @override
  String failedToProcessBooking(String error) {
    return 'Failed to process booking: $error';
  }

  @override
  String error(String message) {
    return 'Error: $message';
  }

  @override
  String get driverStatusAvailable => 'Available';

  @override
  String get driverStatusUnavailable => 'Unavailable';

  @override
  String get driverStatusOnRide => 'On Ride';

  @override
  String get driverStatusRideOffered => 'Ride Offered';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusDriverAssigned => 'Driver Assigned';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusPickupArrived => 'Pickup Arrived';

  @override
  String get bookingStatusPickupVerified => 'Pickup Verified';

  @override
  String get bookingStatusInTransit => 'In Transit';

  @override
  String get bookingStatusDropArrived => 'Drop Arrived';

  @override
  String get bookingStatusDropVerified => 'Drop Verified';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusExpired => 'Expired';

  @override
  String get assignmentStatusOffered => 'Offered';

  @override
  String get assignmentStatusAccepted => 'Accepted';

  @override
  String get assignmentStatusRejected => 'Rejected';

  @override
  String get assignmentStatusAutoRejected => 'Auto Rejected';

  @override
  String get transactionTypeCredit => 'Credit';

  @override
  String get transactionTypeDebit => 'Debit';

  @override
  String get transactionCategoryBookingPayment => 'Booking Payment';

  @override
  String get transactionCategoryBookingRefund => 'Booking Refund';

  @override
  String get transactionCategoryDriverPayout => 'Payout';

  @override
  String get transactionCategoryWalletCredit => 'Wallet Credit';

  @override
  String get transactionCategoryOther => 'Other';

  @override
  String get paymentMethodCash => 'Cash';

  @override
  String get paymentMethodOnline => 'Online';

  @override
  String get paymentMethodWallet => 'Wallet';

  @override
  String get payoutStatusPending => 'Pending';

  @override
  String get payoutStatusProcessing => 'Processing';

  @override
  String get payoutStatusCompleted => 'Completed';

  @override
  String get payoutStatusFailed => 'Failed';

  @override
  String get payoutStatusCancelled => 'Cancelled';

  @override
  String get productTypePersonal => 'Personal';

  @override
  String get productTypeAgricultural => 'Agricultural';

  @override
  String get productTypeNonAgricultural => 'Non-Agricultural';

  @override
  String get weightUnitKg => 'kg';

  @override
  String get weightUnitQuintal => 'Quintal';

  @override
  String get vehicleTypeThreeWheeler => 'Three Wheeler';

  @override
  String get vehicleTypeFourWheeler => 'Four Wheeler';

  @override
  String get vehicleBodyTypeOpen => 'Open';

  @override
  String get vehicleBodyTypeClosed => 'Closed';

  @override
  String get fuelTypeDiesel => 'Diesel';

  @override
  String get fuelTypePetrol => 'Petrol';

  @override
  String get fuelTypeEv => 'Electric';

  @override
  String get fuelTypeCng => 'CNG';

  @override
  String get payoutMethodBankAccount => 'Bank Account';

  @override
  String get payoutMethodVpa => 'UPI';

  @override
  String get pickup => 'Pickup';

  @override
  String get drop => 'Drop';

  @override
  String get accept => 'Accept';

  @override
  String get reject => 'Reject';

  @override
  String get startNavigation => 'Start Navigation';

  @override
  String get arrived => 'Arrived';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get startRide => 'Start Ride';

  @override
  String get completeRide => 'Complete Ride';

  @override
  String get collectPayment => 'Collect Payment';

  @override
  String get customer => 'Customer';

  @override
  String get package => 'Package';

  @override
  String get distance => 'Distance';

  @override
  String get estimatedTime => 'Est. Time';

  @override
  String get fare => 'Fare';

  @override
  String get commission => 'Commission';

  @override
  String get netEarnings => 'Net Earnings';

  @override
  String get cashToCollect => 'Cash to Collect';

  @override
  String get onlinePayment => 'Online Payment';

  @override
  String get paymentReceived => 'Payment Received';

  @override
  String get confirm => 'Confirm';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get update => 'Update';

  @override
  String get delete => 'Delete';

  @override
  String get loading => 'Loading...';

  @override
  String get noDataFound => 'No data found';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get tabActive => 'Active';

  @override
  String get tabHistory => 'History';

  @override
  String get failedToLoadActiveRide => 'Failed to load active ride';

  @override
  String get noActiveRides => 'No active rides';

  @override
  String get noActiveRidesSubtitle => 'Your active rides will appear here';

  @override
  String get failedToLoadRideHistory => 'Failed to load ride history';

  @override
  String get noRideHistory => 'No ride history';

  @override
  String get noRideHistorySubtitle => 'Your completed rides will appear here';

  @override
  String get cannotAcceptRides => 'Cannot Accept Rides';

  @override
  String get youAreAvailable => 'You\'re available';

  @override
  String get youAreUnavailable => 'You\'re unavailable';

  @override
  String get readyToAcceptRequests => 'Ready to accept new ride requests';

  @override
  String get turnOnToReceiveRides => 'Turn on to start receiving rides';

  @override
  String get verificationRejectedMessage =>
      'Your verification was rejected. Please contact support to resolve the issue.';

  @override
  String get verificationPendingMessage =>
      'Your account is pending verification. You cannot accept rides until your documents are verified.';

  @override
  String documentsExpiredMessage(String docs) {
    return 'Your $docs have expired. Please update them to accept rides.';
  }

  @override
  String get youAreNowAvailable => 'You are now available';

  @override
  String get youAreNowUnavailable => 'You are now unavailable';

  @override
  String get failedToUpdateStatus => 'Failed to update status';

  @override
  String get agriculturalProduct => 'Agricultural Product';

  @override
  String get packageDelivery => 'Package Delivery';

  @override
  String get navigateToPickup => 'Navigate to Pickup';

  @override
  String get navigateToDrop => 'Navigate to Drop';

  @override
  String get walletActivity => 'Wallet Activity';

  @override
  String get payouts => 'Payouts';

  @override
  String get failedToLoadWalletBalance => 'Failed to load wallet balance';

  @override
  String get totalBalance => 'Total Balance';

  @override
  String get failedToLoadWalletActivity => 'Failed to load wallet activity';

  @override
  String get noWalletActivity => 'No wallet activity yet';

  @override
  String get walletActivitySubtitle =>
      'Your wallet transactions will appear here';

  @override
  String get failedToLoadPayouts => 'Failed to load payouts';

  @override
  String get noPayouts => 'No payouts yet';

  @override
  String get payoutsSubtitle => 'Daily payouts will appear here';

  @override
  String get license => 'License';

  @override
  String get fc => 'Fitness Certificate';

  @override
  String get insurance => 'Insurance';

  @override
  String get pickupLocation => 'Pickup Location';

  @override
  String get dropLocation => 'Drop Location';

  @override
  String get navigation => 'Navigation';

  @override
  String get location => 'Location';

  @override
  String get navigate => 'Navigate';

  @override
  String get termsAndConditionsTitle => 'Hello Truck Navigation';

  @override
  String get termsAndConditionsCompanyName => 'Hello Truck';

  @override
  String get failedToStartNavigation => 'Failed to start navigation session';

  @override
  String routeError(String status) {
    return 'Route error: $status';
  }

  @override
  String get exitNavigationTitle => 'Exit Navigation?';

  @override
  String get exitNavigationMessage =>
      'This will stop navigation and location updates';

  @override
  String get consequences => 'Consequences:';

  @override
  String get warningNavigationStop => 'Navigation updates will stop';

  @override
  String get warningLocationInvisible => 'Customer won\'t see your location';

  @override
  String get warningRating => 'May affect your rating';

  @override
  String get exitAnyway => 'Exit Anyway';

  @override
  String get navigatingToPickup => 'Navigating to Pickup';

  @override
  String get navigatingToDrop => 'Navigating to Drop';

  @override
  String get enterValidEmail => 'Please enter a valid email address';

  @override
  String get completeDocumentUploads => 'Please complete all document uploads';

  @override
  String get completeAddressDetails => 'Please complete address details';

  @override
  String get completeVehicleDetails => 'Please complete vehicle details';

  @override
  String get completePayoutDetails => 'Please complete payout details';

  @override
  String failedToCompleteOnboarding(String error) {
    return 'Failed to complete onboarding: $error';
  }

  @override
  String get rideCompleteTitle => 'Ride Complete!';

  @override
  String get packageDeliveredSuccess => 'Package delivered successfully!';

  @override
  String get rideCompleteMessage =>
      'Both pickup and drop have been verified. You can now finish this ride.';

  @override
  String get tripSummary => 'Trip Summary';

  @override
  String get finishRide => 'Finish Ride';

  @override
  String get notNow => 'Not Now';

  @override
  String get rideCompletedSuccessToast => 'Ride completed successfully!';

  @override
  String failedToFinishRide(String error) {
    return 'Failed to finish ride: $error';
  }

  @override
  String get nameStepTitle => 'What\'s your name?';

  @override
  String get nameStepDescription =>
      'This will be displayed on your driver profile and help customers identify you during their rides.';

  @override
  String get enterFirstName => 'Please enter your first name';

  @override
  String get enterLastNameOptional => 'Enter your last name (optional)';

  @override
  String get photoStepTitle => 'Add your photo';

  @override
  String get photoStepDescription =>
      'Upload a clear, professional photo to help customers recognize you. This builds trust and makes pickups smoother.';

  @override
  String get tapToAddPhoto => 'Tap to add photo';

  @override
  String get uploadingPhoto => 'Uploading your photo...';

  @override
  String get photoSelected => 'Photo selected';

  @override
  String get emailStepTitle => 'Verify your email';

  @override
  String get emailStepDescription =>
      'Connect with Google to verify your email address and receive important updates about your rides and earnings.';

  @override
  String get emailVerifiedSuccess => 'Email Verified Successfully';

  @override
  String get connectWithGoogle => 'Connect with Google';

  @override
  String get emailStepOptional =>
      'This step is optional. You can skip it and verify your email later.';

  @override
  String get addressStepTitle => 'Enter Your Address';

  @override
  String get addressStepDescription =>
      'Tap the search icon to search for your address and tap on the map or drag the marker to select your precise location.';

  @override
  String get searchAddress => 'Search for Address';

  @override
  String get gettingLocation => 'Getting your location...';

  @override
  String get addressNote =>
      'Please enter your address as it appears on your electricity bill.';

  @override
  String get addressLine1 => 'Address Line 1';

  @override
  String get addressLine1Hint => 'House/Building, Street';

  @override
  String get landmark => 'Landmark (Optional)';

  @override
  String get landmarkHint => 'Near landmark or area';

  @override
  String get pincode => 'Pincode';

  @override
  String get enterPincode => 'Please enter pincode';

  @override
  String get city => 'City';

  @override
  String get cityName => 'City name';

  @override
  String get district => 'District';

  @override
  String get districtName => 'District name';

  @override
  String get state => 'State';

  @override
  String get stateName => 'State name';

  @override
  String get vehicleStepTitle => 'Vehicle Details';

  @override
  String get vehicleStepDescription =>
      'Enter your vehicle information and owner details for registration.';

  @override
  String get vehicleNumber => 'Vehicle Number';

  @override
  String get enterVehicleNumber => 'Please enter vehicle number';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get vehicleModel => 'Vehicle Model';

  @override
  String get vehicleBodyLength => 'Vehicle Body Length (ft)';

  @override
  String get enterBodyLength => 'Enter body length';

  @override
  String get vehicleImage => 'Vehicle Image';

  @override
  String get uploadVehicleImage => 'Please upload vehicle image';

  @override
  String get vehicleBodyType => 'Vehicle Body Type';

  @override
  String get fuelType => 'Fuel Type';

  @override
  String get vehicleOwnerDetails => 'Vehicle Owner Details';

  @override
  String get sameAsDriver => 'Same as Driver';

  @override
  String get sameAsDriverSubtitle => 'Vehicle owner details are same as driver';

  @override
  String get ownerName => 'Owner Name';

  @override
  String get enterOwnerName => 'Please enter owner name';

  @override
  String get contactNumber => 'Contact Number';

  @override
  String get enterContactNumber => 'Enter contact number';

  @override
  String get ownerAadharCard => 'Owner Aadhar Card';

  @override
  String get uploadOwnerAadhar => 'Please upload owner Aadhar card';

  @override
  String get noVehicleModels => 'No vehicle models available';

  @override
  String get documentsStepTitle => 'Upload Documents';

  @override
  String get documentsStepDescription =>
      'Please upload all required documents to complete your driver profile verification.';

  @override
  String get panNumber => 'PAN Number';

  @override
  String get enterPanNumber => 'Enter your PAN number';

  @override
  String get drivingLicense => 'Driving License';

  @override
  String get uploadLicense => 'Upload your valid driving license';

  @override
  String get rcBook => 'RC Book';

  @override
  String get uploadRcBook => 'Upload your vehicle registration certificate';

  @override
  String get fcCertificate => 'FC Certificate';

  @override
  String get uploadFc => 'Upload your fitness certificate';

  @override
  String get insuranceCertificate => 'Insurance Certificate';

  @override
  String get uploadInsurance => 'Please upload your insurance certificate';

  @override
  String get aadharCard => 'Aadhar Card';

  @override
  String get uploadAadhar => 'Please upload your Aadhar card';

  @override
  String get electricityBill => 'Electricity Bill';

  @override
  String get uploadEbBill => 'Upload your address proof (electricity bill)';

  @override
  String get payoutDetails => 'Payout Details';

  @override
  String get payoutDescription =>
      'Choose how you want to receive payouts. You can use a bank account or a UPI ID (VPA).';

  @override
  String get bankAccount => 'Bank Account';

  @override
  String get upiVpa => 'UPI (VPA)';

  @override
  String get accountHolderName => 'Account Holder Name';

  @override
  String get enterAccountHolderName => 'Please enter account holder name';

  @override
  String get accountNumber => 'Account Number';

  @override
  String get enterAccountNumber => 'Please enter account number';

  @override
  String get ifscCode => 'IFSC Code';

  @override
  String get upiId => 'UPI ID (VPA)';

  @override
  String get upiHint => 'e.g., username@okicici';

  @override
  String get bankDetailsNote =>
      'Your bank details are used only to create a secure payout account. We do not store your complete bank information.';

  @override
  String get almostDone => 'Almost done!';

  @override
  String get phoneStepDescription =>
      'Add an alternate phone number for better communication with customers. This helps ensure smooth pickups and deliveries.';

  @override
  String get youAreAllSet => 'You\'re all set!';

  @override
  String get completeProfileDescription =>
      'Complete your profile to start accepting rides and earning money with Hello Truck.';

  @override
  String get view => 'View';

  @override
  String get reupload => 'Re-upload';

  @override
  String get titleAddress => 'Address';

  @override
  String get titleVehicle => 'Vehicle';

  @override
  String get titleDocuments => 'Documents';

  @override
  String get addAddress => 'Add Address';

  @override
  String get failedToLoadAddress => 'Failed to load address';

  @override
  String get noAddressFound => 'No address found';

  @override
  String get addressFoundSubtitle => 'Add your address to continue';

  @override
  String get tapMapToSelect => 'Tap on map or drag marker to select location';

  @override
  String get fillAllRequired => 'Please fill all required fields';

  @override
  String get addressUpdatedSuccess => 'Address updated successfully';

  @override
  String failedToSaveAddress(Object error) {
    return 'Failed to save address: $error';
  }

  @override
  String get failedToLoadVehicle => 'Failed to load vehicle';

  @override
  String get noVehicleFound => 'No vehicle found';

  @override
  String get completeOnboardingToAddVehicle =>
      'Complete your onboarding to add vehicle details';

  @override
  String get vehicleNumberLabel => 'Vehicle Number';

  @override
  String get selfOwned => 'Self Owned';

  @override
  String get selfOwnedDescription => 'You are the owner of this vehicle';

  @override
  String get failedToLoadDocuments => 'Failed to load documents';

  @override
  String get noDocumentsFound => 'No documents found';

  @override
  String get completeOnboardingToUploadDocuments =>
      'Complete your onboarding to upload documents';

  @override
  String expiredOn(Object date) {
    return 'Expired on $date';
  }

  @override
  String validUntil(Object date) {
    return 'Valid until $date';
  }

  @override
  String reuploadedSuccess(Object title) {
    return '$title re-uploaded successfully';
  }

  @override
  String get selectPaymentMethod => 'Select Payment Method';

  @override
  String get searchForAddress => 'Search for Address';

  @override
  String get searchLocationHint => 'Search for location...';

  @override
  String get startTypingToSearch => 'Start typing to search for locations';

  @override
  String get newRideRequest => 'New Ride Request';

  @override
  String get bookingNumberPrefix => 'Booking #';

  @override
  String get pickupPrefix => 'Pickup: ';

  @override
  String get acceptRide => 'Accept Ride';

  @override
  String get paymentReceivedSuccess => 'Payment received successfully! 💰';

  @override
  String get paymentSettledSuccess => 'Payment settled successfully! 💰';

  @override
  String get paymentSettlementTitle => 'Payment Settlement';

  @override
  String get checkPaymentStatusTooltip => 'Check Payment Status';

  @override
  String get paymentPendingTitle => 'Payment Pending';

  @override
  String get paymentPendingMessage =>
      'Customer hasn\'t paid yet. Choose how to receive payment below.';

  @override
  String get serviceCost => 'Service Cost';

  @override
  String get customerWalletUsed => 'Customer Wallet Used';

  @override
  String get customerDebtRecovery => 'Customer Debt Recovery';

  @override
  String platformFeePercentage(String percentage) {
    return 'Platform Fee ($percentage%)';
  }

  @override
  String get yourEarnings => 'Your Earnings';

  @override
  String walletCreditAmount(String amount) {
    return 'Wallet Credit: +$amount';
  }

  @override
  String walletDebitAmount(String amount) {
    return 'Wallet Debit: $amount';
  }

  @override
  String get receivedCashTitle => 'Received Cash';

  @override
  String get receivedCashSubtitle => 'I collected cash from customer';

  @override
  String get onlinePaymentTitle => 'Customer Pays via App';

  @override
  String get onlinePaymentSubtitle =>
      'Ask customer to pay via payment link in their app';

  @override
  String get importantInformation => 'Important Information';

  @override
  String platformFeeDisclaimer(String percentage) {
    return 'Platform fee ($percentage%) is calculated on the full service cost, not the cash collected.';
  }

  @override
  String get walletAdjustmentDisclaimer =>
      'If customer used wallet credit, you\'ll receive a wallet credit. If customer had debt, extra amount collected will be debited.';

  @override
  String get exactCashCollectionWarning =>
      'Make sure you have collected the exact \"Cash to Collect\" amount shown above.';

  @override
  String get confirmCashPaymentTitle => 'Confirm Cash Payment';

  @override
  String get confirmCashPaymentMessage =>
      'By confirming, you declare that you have received the full cash payment from the customer.';

  @override
  String platformFeeDeductionMessage(String amount) {
    return '$amount platform fee will be deducted from your wallet';
  }

  @override
  String get platformFeeDeductionSuffix =>
      ' platform fee will be deducted from your wallet';

  @override
  String reUploadTitle(String title) {
    return 'Re-upload $title';
  }

  @override
  String get fileSizeLimit10MB => 'File size must be less than 10MB';

  @override
  String get fileSizeLimit5MB => 'Image size must be less than 5MB';

  @override
  String get documentSelected => 'Document Selected';

  @override
  String get tapToSelectDocument => 'Tap to select document';

  @override
  String get documentFormatHint => 'JPG, PNG, PDF (Max 10MB)';

  @override
  String get docVerificationInfo =>
      'Document will be verified by admin. Expiry dates will be set during verification.';

  @override
  String get linkEmailAddress => 'Link Email Address';

  @override
  String get emailAlreadyLinkedMessage =>
      'Your email is already linked with Google. You can re-link with a different Google account if needed.';

  @override
  String get linkEmailMessage =>
      'Link your email with Google to receive important updates about your rides and earnings.';

  @override
  String get linking => 'Linking...';

  @override
  String failedToLinkEmail(String error) {
    return 'Failed to link email with Google: $error';
  }

  @override
  String get fieldCannotBeEmpty => 'This field cannot be empty';

  @override
  String failedToSave(String error) {
    return 'Failed to save: $error';
  }

  @override
  String editTitle(String title) {
    return 'Edit $title';
  }

  @override
  String enterFieldHint(String field) {
    return 'Enter your $field';
  }

  @override
  String get updateProfilePicture => 'Update Profile Picture';

  @override
  String get currentPicture => 'Current Picture';

  @override
  String get newPicture => 'New Picture';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get uploadPicture => 'Upload Picture';

  @override
  String get chooseDifferentImage => 'Choose Different Image';

  @override
  String get firstNameMinLength =>
      'First name must be at least 3 characters long';

  @override
  String get enterValidPhone => 'Please enter a valid 10-digit phone number';

  @override
  String get enterAddressLine1 => 'Please enter address line 1';

  @override
  String get enterValidPincode => 'Please enter a valid 6-digit pincode';

  @override
  String get enterCity => 'Please enter city';

  @override
  String get enterDistrict => 'Please enter district';

  @override
  String get enterState => 'Please enter state';

  @override
  String get enterVehicleBodyLength => 'Please enter vehicle body length';

  @override
  String get vehicleBodyLengthGreaterThanZero =>
      'Vehicle body length must be greater than 0';

  @override
  String get enterValidVehicleBodyLength =>
      'Please enter a valid vehicle body length';

  @override
  String get selectVehicleType => 'Please select vehicle type';

  @override
  String get selectVehicleModel => 'Please select vehicle model';

  @override
  String get selectVehicleBodyType => 'Please select vehicle body type';

  @override
  String get selectFuelType => 'Please select fuel type';

  @override
  String get enterOwnerContact => 'Please enter owner contact number';

  @override
  String get enterValidOwnerContact =>
      'Please enter a valid 10-digit owner contact number';

  @override
  String get enterOwnerAddress => 'Please enter owner address';

  @override
  String get enterOwnerPincode => 'Please enter owner pincode';

  @override
  String get enterValidOwnerPincode =>
      'Please enter a valid 6-digit owner pincode';

  @override
  String get enterOwnerCity => 'Please enter owner city';

  @override
  String get enterOwnerDistrict => 'Please enter owner district';

  @override
  String get enterOwnerState => 'Please enter owner state';

  @override
  String get enterValidPAN => 'Please enter a valid PAN number';

  @override
  String get uploadDrivingLicense => 'Please upload your driving license';

  @override
  String get uploadRCBook => 'Please upload your RC book';

  @override
  String get uploadFCCertificate => 'Please upload your FC certificate';

  @override
  String get uploadElectricityBill => 'Please upload your electricity bill';

  @override
  String get enterPAN => 'Please enter your PAN number';

  @override
  String get enterIFSCCode => 'Please enter IFSC code';

  @override
  String get enterValidIFSC => 'Please enter a valid IFSC code';

  @override
  String get enterUPIID => 'Please enter UPI ID (VPA)';

  @override
  String get enterValidUPI => 'Please enter a valid UPI ID';

  @override
  String get completeSetup => 'Complete Setup';

  @override
  String get continueText => 'Continue';

  @override
  String get documentUploadedSuccess => 'Document uploaded successfully!';

  @override
  String failedToPickDocument(String error) {
    return 'Failed to pick document: $error';
  }

  @override
  String failedToUploadDocument(String error) {
    return 'Failed to upload document: $error';
  }

  @override
  String failedToPickImage(String error) {
    return 'Failed to pick image: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'Failed to upload profile picture: $error';
  }

  @override
  String get documentsNotFound => 'Documents not found';

  @override
  String get documentsNotUploadedYet =>
      'The documents may not be uploaded yet.';

  @override
  String get documentNotFound => 'Document not found';

  @override
  String get documentNotUploadedYet =>
      'This document has not been uploaded yet.';

  @override
  String get loadingDocument => 'Loading document...';

  @override
  String get failedToLoadDocument => 'Failed to load document';

  @override
  String get checkInternetAndRetry =>
      'Check your internet connection and try again.';

  @override
  String failedToLoadPdf(String description) {
    return 'Failed to load PDF: $description';
  }

  @override
  String get loadingImage => 'Loading image...';

  @override
  String get documentLoadError =>
      'The document could not be loaded. Please check your internet connection and try again.';

  @override
  String get checkingLocationPermissions => 'Checking location permissions...';

  @override
  String get locationServicesDisabled => 'Location Services Disabled';

  @override
  String get locationPermissionDenied =>
      'Location Permission Permanently Denied';

  @override
  String get locationAccessRequired => 'Location Access Required';

  @override
  String get enableLocationServicesDesc =>
      'Please enable location services in your device settings to use this feature.';

  @override
  String get needLocationAccessDesc =>
      'We need location access to show your current position and help you select your address accurately.';

  @override
  String get locationDeniedForeverDesc =>
      'Location permission has been permanently denied. Please enable it in app settings to continue.';

  @override
  String get locationRequiredDesc =>
      'Location access is required for this feature to work properly.';

  @override
  String get enableLocationServices => 'Enable Location Services';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get requestPermission => 'Request Permission';

  @override
  String get checkAgain => 'Check Again';

  @override
  String get actions => 'Actions';

  @override
  String callContact(String name) {
    return 'Call $name';
  }

  @override
  String get couldNotMakeCall => 'Could not make call';

  @override
  String get markArrivalAtPickup => 'Mark arrival at pickup location';

  @override
  String get verifyPickup => 'Verify Pickup';

  @override
  String get enterCustomerOtp => 'Enter customer OTP';

  @override
  String get markArrivalAtDrop => 'Mark arrival at drop location';

  @override
  String get verifyDrop => 'Verify Drop';

  @override
  String get rideComplete => 'Ride Complete';

  @override
  String get readyToFinish => 'Ready to finish';

  @override
  String get followTheRoute => 'Follow the route';

  @override
  String get markArrived => 'Mark Arrived';

  @override
  String get markedAsArrivedAtPickup => 'Marked as arrived at pickup';

  @override
  String get pickupVerificationTitle => 'Pickup Verification';

  @override
  String get pickupVerified => 'Pickup verified! 🎉';

  @override
  String get invalidOtpTryAgain => 'Invalid OTP. Please try again.';

  @override
  String get markedAsArrivedAtDrop => 'Marked as arrived at drop';

  @override
  String get dropVerificationTitle => 'Drop Verification';

  @override
  String get dropVerified => 'Drop verified! 🎉';

  @override
  String get rideCompleted => 'Ride completed! 🎉';

  @override
  String get verify => 'Verify';

  @override
  String get nowAvailableForRides => 'You are now available for rides';

  @override
  String failedToMarkReady(String error) {
    return 'Failed to mark driver as ready: $error';
  }

  @override
  String failedToMarkPromptSeen(String error) {
    return 'Failed to mark prompt as seen: $error';
  }

  @override
  String get readyToTakeRides => 'Ready to take rides today?';

  @override
  String get startEarningDesc =>
      'Start earning by accepting ride requests from customers near you';

  @override
  String get getInstantNotifications => 'Get instant notifications';

  @override
  String get receiveRideRequestsImmediately =>
      'Receive ride requests immediately';

  @override
  String get findNearbyRides => 'Find nearby rides';

  @override
  String get connectWithCustomers => 'Connect with customers in your area';

  @override
  String get startEarningToday => 'Start earning today';

  @override
  String get maximizeDailyIncome => 'Maximize your daily income potential';

  @override
  String get maybeLater => 'Maybe later';

  @override
  String get imReady => 'I\'m ready!';

  @override
  String get changeFromRidesTab =>
      'You can change this anytime from the Rides tab';

  @override
  String get pleaseEnterFirstName => 'Please enter your first name';

  @override
  String get pleaseEnterValidPhone =>
      'Please enter a valid 10-digit phone number';

  @override
  String get pleaseEnterAddressLine1 => 'Please enter address line 1';

  @override
  String get pleaseEnterPincode => 'Please enter pincode';

  @override
  String get pleaseEnterValidPincode => 'Please enter a valid 6-digit pincode';

  @override
  String get pleaseEnterCity => 'Please enter city';

  @override
  String get pleaseEnterDistrict => 'Please enter district';

  @override
  String get pleaseEnterState => 'Please enter state';

  @override
  String get pleaseEnterVehicleNumber => 'Please enter vehicle number';

  @override
  String get pleaseEnterVehicleBodyLength => 'Please enter vehicle body length';

  @override
  String get vehicleBodyLengthMustBePositive =>
      'Vehicle body length must be greater than 0';

  @override
  String get pleaseEnterValidBodyLength =>
      'Please enter a valid vehicle body length';

  @override
  String get pleaseSelectVehicleType => 'Please select vehicle type';

  @override
  String get pleaseSelectVehicleModel => 'Please select vehicle model';

  @override
  String get pleaseSelectVehicleBodyType => 'Please select vehicle body type';

  @override
  String get pleaseSelectFuelType => 'Please select fuel type';

  @override
  String get pleaseUploadVehicleImage => 'Please upload vehicle image';

  @override
  String get pleaseEnterOwnerName => 'Please enter owner name';

  @override
  String get pleaseEnterOwnerContact => 'Please enter owner contact number';

  @override
  String get pleaseEnterValidOwnerContact =>
      'Please enter a valid 10-digit owner contact number';

  @override
  String get pleaseEnterOwnerAddress => 'Please enter owner address';

  @override
  String get pleaseEnterOwnerPincode => 'Please enter owner pincode';

  @override
  String get pleaseEnterValidOwnerPincode =>
      'Please enter a valid 6-digit owner pincode';

  @override
  String get pleaseEnterOwnerCity => 'Please enter owner city';

  @override
  String get pleaseEnterOwnerDistrict => 'Please enter owner district';

  @override
  String get pleaseEnterOwnerState => 'Please enter owner state';

  @override
  String get pleaseUploadOwnerAadhar => 'Please upload owner Aadhar card';

  @override
  String get pleaseEnterValidPan => 'Please enter a valid PAN number';

  @override
  String get pleaseUploadDrivingLicense => 'Please upload your driving license';

  @override
  String get pleaseUploadRcBook => 'Please upload your RC book';

  @override
  String get pleaseUploadFc => 'Please upload your FC certificate';

  @override
  String get pleaseUploadInsurance =>
      'Please upload your insurance certificate';

  @override
  String get pleaseUploadAadhar => 'Please upload your Aadhar card';

  @override
  String get pleaseUploadEbBill => 'Please upload your electricity bill';

  @override
  String get pleaseEnterPanNumber => 'Please enter your PAN number';

  @override
  String get pleaseEnterAccountHolderName => 'Please enter account holder name';

  @override
  String get pleaseEnterAccountNumber => 'Please enter account number';

  @override
  String get pleaseEnterIfscCode => 'Please enter IFSC code';

  @override
  String get pleaseEnterValidIfsc => 'Please enter a valid IFSC code';

  @override
  String get pleaseEnterUpiId => 'Please enter UPI ID (VPA)';

  @override
  String get pleaseEnterValidUpiId => 'Please enter a valid UPI ID';

  @override
  String get fileSizeMustBeLessThan10Mb => 'File size must be less than 10MB';

  @override
  String get documentUploadedSuccessfully => 'Document uploaded successfully!';

  @override
  String licenseExpiresInDays(int days) {
    return 'Your driving license expires in $days days. Please renew it soon.';
  }

  @override
  String get licenseExpiresIn30Days =>
      'Your driving license expires in 30 days. Please renew it.';

  @override
  String get licenseExpiresIn45Days =>
      'Your driving license expires in 45 days. Please renew it.';

  @override
  String get licenseExpired =>
      'Your driving license has expired. Please renew it immediately.';

  @override
  String fcExpiresInDays(int days) {
    return 'Your fitness certificate expires in $days days. Please renew it soon.';
  }

  @override
  String get fcExpiresIn30Days =>
      'Your fitness certificate expires in 30 days. Please renew it.';

  @override
  String get fcExpiresIn45Days =>
      'Your fitness certificate expires in 45 days. Please renew it.';

  @override
  String get fcExpired =>
      'Your fitness certificate has expired. Please renew it immediately.';

  @override
  String insuranceExpiresInDays(int days) {
    return 'Your insurance expires in $days days. Please renew it soon.';
  }

  @override
  String get insuranceExpiresIn30Days =>
      'Your insurance expires in 30 days. Please renew it.';

  @override
  String get insuranceExpiresIn45Days =>
      'Your insurance expires in 45 days. Please renew it.';

  @override
  String get insuranceExpired =>
      'Your insurance has expired. Please renew it immediately.';
}
