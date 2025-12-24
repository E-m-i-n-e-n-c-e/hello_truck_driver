// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ஹலோ டிரக் டிரைவர்';

  @override
  String get languageSystem => 'சிஸ்டம் இயல்புநிலை';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageTitle => 'மொழி';

  @override
  String get currentLanguage => 'தமிழ்';

  @override
  String get loginTitle => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get loginSubtitle =>
      'நாங்கள் உங்களுக்கு சரிபார்ப்பு குறியீட்டை அனுப்புவோம்';

  @override
  String get phoneNumberHint => 'தொலைபேசி எண்';

  @override
  String get sendOtp => 'OTP அனுப்பு';

  @override
  String get phoneEmptyError => 'உங்கள் தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get phoneInvalidError => 'சரியான 10 இலக்க தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String errorSendingOtp(String error) {
    return 'OTP அனுப்புவதில் பிழை: $error';
  }

  @override
  String get otpVerification => 'OTP சரிபார்ப்பு';

  @override
  String get otpSentTo => 'நாங்கள் சரிபார்ப்பு குறியீட்டை அனுப்பியுள்ளோம்';

  @override
  String get otpSentSuccess => 'OTP வெற்றிகரமாக அனுப்பப்பட்டது!';

  @override
  String get checkTextMessages =>
      'உங்கள் OTP க்கு குறுஞ்செய்திகளைப் பார்க்கவும்';

  @override
  String get didntGetOtp => 'OTP கிடைக்கவில்லையா?';

  @override
  String get resendSms => 'SMS மீண்டும் அனுப்பு';

  @override
  String resendSmsIn(int seconds) {
    return '${seconds}s இல் SMS மீண்டும் அனுப்பு';
  }

  @override
  String get changePhoneNumber => 'தொலைபேசி எண்ணை மாற்று';

  @override
  String errorVerifyingOtp(String error) {
    return 'OTP சரிபார்ப்பதில் பிழை: $error';
  }

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get failedToLoadProfile => 'சுயவிவரத்தை ஏற்றுவதில் தோல்வி';

  @override
  String get retry => 'மீண்டும் முயற்சி';

  @override
  String get walletBalance => 'வாலட் இருப்பு';

  @override
  String get documents => 'ஆவணங்கள்';

  @override
  String get documentsSubtitle => 'உரிமம், RC, காப்பீடு மற்றும் பல';

  @override
  String get vehicle => 'வாகனம்';

  @override
  String get vehicleSubtitle => 'வாகன விவரங்கள் மற்றும் உரிமையாளர் தகவல்';

  @override
  String get address => 'முகவரி';

  @override
  String get addressSubtitle => 'உங்கள் பதிவு செய்யப்பட்ட முகவரி';

  @override
  String get languageSubtitle => 'ஆப் மொழியை மாற்று';

  @override
  String get personalInformation => 'தனிப்பட்ட தகவல்';

  @override
  String get firstName => 'முதல் பெயர்';

  @override
  String get lastName => 'கடைசி பெயர்';

  @override
  String get alternatePhone => 'மாற்று தொலைபேசி';

  @override
  String get notSet => 'அமைக்கப்படவில்லை';

  @override
  String get account => 'கணக்கு';

  @override
  String get phoneNumber => 'தொலைபேசி எண்';

  @override
  String get email => 'மின்னஞ்சல்';

  @override
  String get notLinked => 'இணைக்கப்படவில்லை';

  @override
  String get link => 'இணை';

  @override
  String get memberSince => 'உறுப்பினர் ஆனது';

  @override
  String get referralCode => 'பரிந்துரை குறியீடு';

  @override
  String get edit => 'திருத்து';

  @override
  String get add => 'சேர்';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get logoutConfirmTitle => 'வெளியேறு';

  @override
  String get logoutConfirmMessage =>
      'நீங்கள் நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';

  @override
  String get cancel => 'ரத்து';

  @override
  String get ok => 'சரி';

  @override
  String get pendingVerification => 'சரிபார்ப்பு நிலுவையில்';

  @override
  String get verified => 'சரிபார்க்கப்பட்டது';

  @override
  String get verificationRejected => 'சரிபார்ப்பு நிராகரிக்கப்பட்டது';

  @override
  String get profilePictureUpdated =>
      'சுயவிவர படம் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get emailLinkedSuccess => 'மின்னஞ்சல் வெற்றிகரமாக இணைக்கப்பட்டது';

  @override
  String get firstNameUpdated => 'முதல் பெயர் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get lastNameUpdated => 'கடைசி பெயர் வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String get alternatePhoneUpdated =>
      'மாற்று தொலைபேசி வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String failedToUpdate(String field, String error) {
    return '$field புதுப்பிப்பதில் தோல்வி: $error';
  }

  @override
  String get dashboard => 'டாஷ்போர்டு';

  @override
  String get home => 'முகப்பு';

  @override
  String get rides => 'பயணங்கள்';

  @override
  String get earnings => 'வருமானம்';

  @override
  String helloDriver(String name) {
    return 'வணக்கம், $name 👋';
  }

  @override
  String get stayReadyEarnMore => 'தயாராக இருங்கள். அதிகம் சம்பாதியுங்கள்.';

  @override
  String get todaysSummary => 'இன்றைய சுருக்கம்';

  @override
  String get ridesLabel => 'பயணங்கள்';

  @override
  String get earned => 'சம்பாதித்தது';

  @override
  String get status => 'நிலை';

  @override
  String get score => 'மதிப்பெண்';

  @override
  String get todaysRides => 'இன்றைய பயணங்கள்';

  @override
  String get noRidesCompletedYet => 'இன்னும் பயணங்கள் முடிக்கப்படவில்லை';

  @override
  String get completeFirstRide => 'இன்று உங்கள் முதல் பயணத்தை முடியுங்கள்!';

  @override
  String bookingNumber(String number) {
    return 'புக்கிங் #$number';
  }

  @override
  String get completed => 'முடிந்தது';

  @override
  String get dismiss => 'நிராகரி';

  @override
  String get documentExpired => 'ஆவணம் காலாவதியானது!';

  @override
  String get documentExpiringSoon => 'ஆவணம் விரைவில் காலாவதியாகும்';

  @override
  String get cannotTakeBookings =>
      'ஆவணங்கள் புதுப்பிக்கப்படும் வரை புக்கிங்குகளை எடுக்க முடியாது.';

  @override
  String get turnOnLocationServices => 'இருப்பிட சேவைகளை இயக்கு';

  @override
  String get locationServicesOffMessage =>
      'இருப்பிட சேவைகள் முடக்கப்பட்டுள்ளன. இருப்பிடம் இல்லாமல், பயணங்களை எடுக்க முடியாது.';

  @override
  String get openSettings => 'அமைப்புகளைத் திற';

  @override
  String get skipForNow => 'இப்போதைக்கு தவிர்';

  @override
  String get enableLocationPermission => 'இருப்பிட அனுமதியை இயக்கு';

  @override
  String get locationPermissionMessage =>
      'பயணங்களை ஒதுக்க உங்கள் இருப்பிடம் தேவை. இல்லையெனில் பயணங்களை எடுக்க முடியாது.';

  @override
  String get enable => 'இயக்கு';

  @override
  String get locationPermissionRequired => 'இருப்பிட அனுமதி தேவை';

  @override
  String get locationPermissionDeniedMessage =>
      'அனுமதி நிரந்தரமாக மறுக்கப்பட்டது. இருப்பிடத்தை அனுமதிக்க ஆப் அமைப்புகளைத் திறக்கவும்.\nஇது இல்லாமல், பயணங்களை எடுக்க முடியாது.';

  @override
  String get youAreOffline =>
      'நீங்கள் ஆஃப்லைனில் உள்ளீர்கள். உங்கள் இணைய இணைப்பைச் சரிபார்க்கவும்.';

  @override
  String get youAreBackOnline => 'நீங்கள் மீண்டும் ஆன்லைனில் உள்ளீர்கள்';

  @override
  String get bookingCancelled => 'புக்கிங் ரத்து செய்யப்பட்டது';

  @override
  String get bookingCancelledMessage =>
      'மன்னிக்கவும், உங்கள் புக்கிங் வாடிக்கையாளரால் ரத்து செய்யப்பட்டது. உங்கள் நேரத்திற்கு சில இழப்பீடு கிடைக்கும்.';

  @override
  String failedToRejectBooking(String error) {
    return 'புக்கிங்கை நிராகரிப்பதில் தோல்வி: $error';
  }

  @override
  String failedToProcessBooking(String error) {
    return 'புக்கிங்கை செயலாக்குவதில் தோல்வி: $error';
  }

  @override
  String error(String message) {
    return 'பிழை: $message';
  }

  @override
  String get driverStatusAvailable => 'கிடைக்கிறது';

  @override
  String get driverStatusUnavailable => 'கிடைக்கவில்லை';

  @override
  String get driverStatusOnRide => 'பயணத்தில்';

  @override
  String get driverStatusRideOffered => 'பயணம் வழங்கப்பட்டது';

  @override
  String get bookingStatusPending => 'நிலுவையில்';

  @override
  String get bookingStatusDriverAssigned => 'டிரைவர் ஒதுக்கப்பட்டார்';

  @override
  String get bookingStatusConfirmed => 'உறுதிப்படுத்தப்பட்டது';

  @override
  String get bookingStatusPickupArrived => 'பிக்அப் வந்துவிட்டது';

  @override
  String get bookingStatusPickupVerified => 'பிக்அப் சரிபார்க்கப்பட்டது';

  @override
  String get bookingStatusInTransit => 'போக்குவரத்தில்';

  @override
  String get bookingStatusDropArrived => 'டிராப் வந்துவிட்டது';

  @override
  String get bookingStatusDropVerified => 'டிராப் சரிபார்க்கப்பட்டது';

  @override
  String get bookingStatusCompleted => 'முடிந்தது';

  @override
  String get bookingStatusCancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get bookingStatusExpired => 'காலாவதியானது';

  @override
  String get assignmentStatusOffered => 'வழங்கப்பட்டது';

  @override
  String get assignmentStatusAccepted => 'ஏற்றுக்கொள்ளப்பட்டது';

  @override
  String get assignmentStatusRejected => 'நிராகரிக்கப்பட்டது';

  @override
  String get assignmentStatusAutoRejected => 'தானாக நிராகரிக்கப்பட்டது';

  @override
  String get transactionTypeCredit => 'கிரெடிட்';

  @override
  String get transactionTypeDebit => 'டெபிட்';

  @override
  String get transactionCategoryBookingPayment => 'புக்கிங் பணம்';

  @override
  String get transactionCategoryBookingRefund => 'புக்கிங் திரும்பப்பெறுதல்';

  @override
  String get transactionCategoryDriverPayout => 'பேஅவுட்';

  @override
  String get transactionCategoryWalletCredit => 'வாலட் கிரெடிட்';

  @override
  String get transactionCategoryOther => 'மற்றவை';

  @override
  String get paymentMethodCash => 'பணம்';

  @override
  String get paymentMethodOnline => 'ஆன்லைன்';

  @override
  String get paymentMethodWallet => 'வாலட்';

  @override
  String get payoutStatusPending => 'நிலுவையில்';

  @override
  String get payoutStatusProcessing => 'செயலாக்கத்தில்';

  @override
  String get payoutStatusCompleted => 'முடிந்தது';

  @override
  String get payoutStatusFailed => 'தோல்வி';

  @override
  String get payoutStatusCancelled => 'ரத்து செய்யப்பட்டது';

  @override
  String get productTypePersonal => 'தனிப்பட்ட';

  @override
  String get productTypeAgricultural => 'விவசாய';

  @override
  String get productTypeNonAgricultural => 'விவசாயமற்ற';

  @override
  String get weightUnitKg => 'கிலோ';

  @override
  String get weightUnitQuintal => 'குவிண்டால்';

  @override
  String get vehicleTypeThreeWheeler => 'மூன்று சக்கர வாகனம்';

  @override
  String get vehicleTypeFourWheeler => 'நான்கு சக்கர வாகனம்';

  @override
  String get vehicleBodyTypeOpen => 'திறந்த';

  @override
  String get vehicleBodyTypeClosed => 'மூடிய';

  @override
  String get fuelTypeDiesel => 'டீசல்';

  @override
  String get fuelTypePetrol => 'பெட்ரோல்';

  @override
  String get fuelTypeEv => 'மின்சாரம்';

  @override
  String get fuelTypeCng => 'CNG';

  @override
  String get payoutMethodBankAccount => 'வங்கி கணக்கு';

  @override
  String get payoutMethodVpa => 'UPI';

  @override
  String get pickup => 'பிக்அப்';

  @override
  String get drop => 'டிராப்';

  @override
  String get accept => 'ஏற்றுக்கொள்';

  @override
  String get reject => 'நிராகரி';

  @override
  String get startNavigation => 'வழிசெலுத்தலைத் தொடங்கு';

  @override
  String get arrived => 'வந்துவிட்டது';

  @override
  String get verifyOtp => 'OTP சரிபார்';

  @override
  String get startRide => 'பயணத்தைத் தொடங்கு';

  @override
  String get completeRide => 'பயணத்தை முடி';

  @override
  String get collectPayment => 'பணம் வசூலி';

  @override
  String get customer => 'வாடிக்கையாளர்';

  @override
  String get package => 'பொட்டலம்';

  @override
  String get distance => 'தூரம்';

  @override
  String get estimatedTime => 'மதிப்பிடப்பட்ட நேரம்';

  @override
  String get fare => 'கட்டணம்';

  @override
  String get commission => 'கமிஷன்';

  @override
  String get netEarnings => 'நிகர வருமானம்';

  @override
  String get cashToCollect => 'வசூலிக்க வேண்டிய பணம்';

  @override
  String get onlinePayment => 'ஆன்லைன் பணம்';

  @override
  String get paymentReceived => 'பணம் பெறப்பட்டது';

  @override
  String get confirm => 'உறுதிப்படுத்து';

  @override
  String get close => 'மூடு';

  @override
  String get save => 'சேமி';

  @override
  String get update => 'புதுப்பி';

  @override
  String get delete => 'நீக்கு';

  @override
  String get loading => 'ஏற்றுகிறது...';

  @override
  String get noDataFound => 'தரவு இல்லை';

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்தது';

  @override
  String get tryAgain => 'மீண்டும் முயற்சி';

  @override
  String get success => 'வெற்றி';

  @override
  String get warning => 'எச்சரிக்கை';

  @override
  String get info => 'தகவல்';

  @override
  String get tabActive => 'செயலில்';

  @override
  String get tabHistory => 'வரலாறு';

  @override
  String get failedToLoadActiveRide => 'செயலில் உள்ள பயணத்தை ஏற்றுவதில் தோல்வி';

  @override
  String get noActiveRides => 'செயலில் பயணங்கள் இல்லை';

  @override
  String get noActiveRidesSubtitle => 'உங்கள் செயலில் பயணங்கள் இங்கே தோன்றும்';

  @override
  String get failedToLoadRideHistory => 'பயண வரலாற்றை ஏற்றுவதில் தோல்வி';

  @override
  String get noRideHistory => 'பயண வரலாறு இல்லை';

  @override
  String get noRideHistorySubtitle => 'உங்கள் முடிந்த பயணங்கள் இங்கே தோன்றும்';

  @override
  String get cannotAcceptRides => 'பயணங்களை ஏற்க முடியாது';

  @override
  String get youAreAvailable => 'நீங்கள் கிடைக்கிறீர்கள்';

  @override
  String get youAreUnavailable => 'நீங்கள் கிடைக்கவில்லை';

  @override
  String get readyToAcceptRequests => 'புதிய பயண கோரிக்கைகளை ஏற்க தயார்';

  @override
  String get turnOnToReceiveRides => 'பயணங்களைப் பெற இயக்கு';

  @override
  String get verificationRejectedMessage =>
      'உங்கள் சரிபார்ப்பு நிராகரிக்கப்பட்டது. சிக்கலைத் தீர்க்க ஆதரவைத் தொடர்பு கொள்ளவும்.';

  @override
  String get verificationPendingMessage =>
      'உங்கள் கணக்கு சரிபார்ப்பு நிலுவையில் உள்ளது. ஆவணங்கள் சரிபார்க்கப்படும் வரை பயணங்களை ஏற்க முடியாது.';

  @override
  String documentsExpiredMessage(String docs) {
    return 'உங்கள் $docs காலாவதியாகிவிட்டது. பயணங்களை ஏற்க அவற்றைப் புதுப்பிக்கவும்.';
  }

  @override
  String get youAreNowAvailable => 'இப்போது நீங்கள் கிடைக்கிறீர்கள்';

  @override
  String get youAreNowUnavailable => 'இப்போது நீங்கள் கிடைக்கவில்லை';

  @override
  String get failedToUpdateStatus => 'நிலையைப் புதுப்பிப்பதில் தோல்வி';

  @override
  String get agriculturalProduct => 'விவசாய பொருள்';

  @override
  String get packageDelivery => 'பொட்டல விநியோகம்';

  @override
  String get navigateToPickup => 'பிக்அப்புக்கு வழிசெலுத்து';

  @override
  String get navigateToDrop => 'டிராப்புக்கு வழிசெலுத்து';

  @override
  String get walletActivity => 'வாலட் செயல்பாடு';

  @override
  String get payouts => 'பேஅவுட்கள்';

  @override
  String get failedToLoadWalletBalance => 'வாலட் இருப்பை ஏற்றுவதில் தோல்வி';

  @override
  String get totalBalance => 'மொத்த இருப்பு';

  @override
  String get failedToLoadWalletActivity =>
      'வாலட் செயல்பாட்டை ஏற்றுவதில் தோல்வி';

  @override
  String get noWalletActivity => 'இன்னும் வாலட் செயல்பாடு இல்லை';

  @override
  String get walletActivitySubtitle =>
      'உங்கள் வாலட் பரிவர்த்தனைகள் இங்கே தோன்றும்';

  @override
  String get failedToLoadPayouts => 'பேஅவுட்களை ஏற்றுவதில் தோல்வி';

  @override
  String get noPayouts => 'இன்னும் பேஅவுட்கள் இல்லை';

  @override
  String get payoutsSubtitle => 'தினசரி பேஅவுட்கள் இங்கே தோன்றும்';

  @override
  String get license => 'உரிமம்';

  @override
  String get fc => 'தகுதி சான்றிதழ்';

  @override
  String get insurance => 'காப்பீடு';

  @override
  String get pickupLocation => 'பிக்அப் இடம்';

  @override
  String get dropLocation => 'டிராப் இடம்';

  @override
  String get navigation => 'வழிசெலுத்தல்';

  @override
  String get location => 'இடம்';

  @override
  String get navigate => 'வழிசெலுத்து';

  @override
  String get termsAndConditionsTitle => 'ஹலோ டிரக் வழிசெலுத்தல்';

  @override
  String get termsAndConditionsCompanyName => 'ஹலோ டிரக்';

  @override
  String get failedToStartNavigation =>
      'வழிசெலுத்தல் அமர்வைத் தொடங்குவதில் தோல்வி';

  @override
  String routeError(String status) {
    return 'வழி பிழை: $status';
  }

  @override
  String get exitNavigationTitle => 'வழிசெலுத்தலை விட்டு வெளியேறவா?';

  @override
  String get exitNavigationMessage =>
      'இது வழிசெலுத்தல் மற்றும் இருப்பிட புதுப்பிப்புகளை நிறுத்தும்';

  @override
  String get consequences => 'விளைவுகள்:';

  @override
  String get warningNavigationStop =>
      'வழிசெலுத்தல் புதுப்பிப்புகள் நிறுத்தப்படும்';

  @override
  String get warningLocationInvisible =>
      'வாடிக்கையாளர் உங்கள் இருப்பிடத்தைப் பார்க்க முடியாது';

  @override
  String get warningRating => 'உங்கள் மதிப்பீட்டைப் பாதிக்கலாம்';

  @override
  String get exitAnyway => 'எப்படியும் வெளியேறு';

  @override
  String get navigatingToPickup => 'பிக்அப்புக்கு வழிசெலுத்துகிறது';

  @override
  String get navigatingToDrop => 'டிராப்புக்கு வழிசெலுத்துகிறது';

  @override
  String get enterValidEmail => 'சரியான மின்னஞ்சல் முகவரியை உள்ளிடவும்';

  @override
  String get completeDocumentUploads =>
      'அனைத்து ஆவண பதிவேற்றங்களையும் முடிக்கவும்';

  @override
  String get completeAddressDetails => 'முகவரி விவரங்களை முடிக்கவும்';

  @override
  String get completeVehicleDetails => 'வாகன விவரங்களை முடிக்கவும்';

  @override
  String get completePayoutDetails => 'பேஅவுட் விவரங்களை முடிக்கவும்';

  @override
  String failedToCompleteOnboarding(String error) {
    return 'ஆன்போர்டிங்கை முடிப்பதில் தோல்வி: $error';
  }

  @override
  String get rideCompleteTitle => 'பயணம் முடிந்தது!';

  @override
  String get packageDeliveredSuccess => 'பொட்டலம் வெற்றிகரமாக வழங்கப்பட்டது!';

  @override
  String get rideCompleteMessage =>
      'பிக்அப் மற்றும் டிராப் இரண்டும் சரிபார்க்கப்பட்டன. இப்போது இந்த பயணத்தை முடிக்கலாம்.';

  @override
  String get tripSummary => 'பயண சுருக்கம்';

  @override
  String get finishRide => 'பயணத்தை முடி';

  @override
  String get notNow => 'இப்போது வேண்டாம்';

  @override
  String get rideCompletedSuccessToast => 'பயணம் வெற்றிகரமாக முடிந்தது!';

  @override
  String failedToFinishRide(String error) {
    return 'பயணத்தை முடிப்பதில் தோல்வி: $error';
  }

  @override
  String get nameStepTitle => 'உங்கள் பெயர் என்ன?';

  @override
  String get nameStepDescription =>
      'இது உங்கள் டிரைவர் சுயவிவரத்தில் காட்டப்படும் மற்றும் பயணங்களின் போது வாடிக்கையாளர்கள் உங்களை அடையாளம் காண உதவும்.';

  @override
  String get enterFirstName => 'உங்கள் முதல் பெயரை உள்ளிடவும்';

  @override
  String get enterLastNameOptional =>
      'உங்கள் கடைசி பெயரை உள்ளிடவும் (விருப்பம்)';

  @override
  String get photoStepTitle => 'உங்கள் புகைப்படத்தைச் சேர்க்கவும்';

  @override
  String get photoStepDescription =>
      'வாடிக்கையாளர்கள் உங்களை அடையாளம் காண தெளிவான, தொழில்முறை புகைப்படத்தைப் பதிவேற்றவும்.';

  @override
  String get tapToAddPhoto => 'புகைப்படம் சேர்க்க தட்டவும்';

  @override
  String get uploadingPhoto => 'உங்கள் புகைப்படம் பதிவேற்றப்படுகிறது...';

  @override
  String get photoSelected => 'புகைப்படம் தேர்ந்தெடுக்கப்பட்டது';

  @override
  String get emailStepTitle => 'உங்கள் மின்னஞ்சலைச் சரிபார்க்கவும்';

  @override
  String get emailStepDescription =>
      'உங்கள் மின்னஞ்சல் முகவரியைச் சரிபார்க்கவும் உங்கள் பயணங்கள் மற்றும் வருமானம் பற்றிய முக்கிய புதுப்பிப்புகளைப் பெறவும் Google உடன் இணைக்கவும்.';

  @override
  String get emailVerifiedSuccess =>
      'மின்னஞ்சல் வெற்றிகரமாக சரிபார்க்கப்பட்டது';

  @override
  String get connectWithGoogle => 'Google உடன் இணை';

  @override
  String get emailStepOptional =>
      'இந்த படி விருப்பமானது. நீங்கள் இதைத் தவிர்த்து பின்னர் உங்கள் மின்னஞ்சலைச் சரிபார்க்கலாம்.';

  @override
  String get addressStepTitle => 'உங்கள் முகவரியை உள்ளிடவும்';

  @override
  String get addressStepDescription =>
      'உங்கள் முகவரியைத் தேட தேடல் ஐகானைத் தட்டவும் மற்றும் உங்கள் துல்லியமான இருப்பிடத்தைத் தேர்ந்தெடுக்க வரைபடத்தில் தட்டவும் அல்லது மார்க்கரை இழுக்கவும்.';

  @override
  String get searchAddress => 'முகவரியைத் தேடு';

  @override
  String get gettingLocation => 'உங்கள் இருப்பிடத்தைப் பெறுகிறது...';

  @override
  String get addressNote =>
      'உங்கள் மின்சார பில்லில் தோன்றும் முகவரியை உள்ளிடவும்.';

  @override
  String get addressLine1 => 'முகவரி வரி 1';

  @override
  String get addressLine1Hint => 'வீடு/கட்டிடம், தெரு';

  @override
  String get landmark => 'அடையாளம் (விருப்பம்)';

  @override
  String get landmarkHint => 'அடையாளம் அல்லது பகுதி அருகில்';

  @override
  String get pincode => 'பின்கோடு';

  @override
  String get enterPincode => 'பின்கோடு உள்ளிடவும்';

  @override
  String get city => 'நகரம்';

  @override
  String get cityName => 'நகர பெயர்';

  @override
  String get district => 'மாவட்டம்';

  @override
  String get districtName => 'மாவட்ட பெயர்';

  @override
  String get state => 'மாநிலம்';

  @override
  String get stateName => 'மாநில பெயர்';

  @override
  String get vehicleStepTitle => 'வாகன விவரங்கள்';

  @override
  String get vehicleStepDescription =>
      'பதிவுக்கு உங்கள் வாகன தகவல் மற்றும் உரிமையாளர் விவரங்களை உள்ளிடவும்.';

  @override
  String get vehicleNumber => 'வாகன எண்';

  @override
  String get enterVehicleNumber => 'வாகன எண்ணை உள்ளிடவும்';

  @override
  String get vehicleType => 'வாகன வகை';

  @override
  String get vehicleModel => 'வாகன மாடல்';

  @override
  String get vehicleBodyLength => 'வாகன உடல் நீளம் (அடி)';

  @override
  String get enterBodyLength => 'உடல் நீளத்தை உள்ளிடவும்';

  @override
  String get vehicleImage => 'வாகன படம்';

  @override
  String get uploadVehicleImage =>
      'உங்கள் வாகனத்தின் தெளிவான படத்தைப் பதிவேற்றவும்';

  @override
  String get vehicleBodyType => 'வாகன உடல் வகை';

  @override
  String get fuelType => 'எரிபொருள் வகை';

  @override
  String get vehicleOwnerDetails => 'வாகன உரிமையாளர் விவரங்கள்';

  @override
  String get sameAsDriver => 'டிரைவர் போன்றது';

  @override
  String get sameAsDriverSubtitle =>
      'வாகன உரிமையாளர் விவரங்கள் டிரைவர் போன்றது';

  @override
  String get ownerName => 'உரிமையாளர் பெயர்';

  @override
  String get enterOwnerName => 'உரிமையாளர் பெயரை உள்ளிடவும்';

  @override
  String get contactNumber => 'தொடர்பு எண்';

  @override
  String get enterContactNumber => 'தொடர்பு எண்ணை உள்ளிடவும்';

  @override
  String get ownerAadharCard => 'உரிமையாளர் ஆதார் அட்டை';

  @override
  String get uploadOwnerAadhar => 'உரிமையாளர் ஆதார் அட்டையைப் பதிவேற்றவும்';

  @override
  String get noVehicleModels => 'வாகன மாடல்கள் இல்லை';

  @override
  String get documentsStepTitle => 'ஆவணங்களைப் பதிவேற்றவும்';

  @override
  String get documentsStepDescription =>
      'உங்கள் டிரைவர் சுயவிவர சரிபார்ப்பை முடிக்க அனைத்து தேவையான ஆவணங்களையும் பதிவேற்றவும்.';

  @override
  String get panNumber => 'PAN எண்';

  @override
  String get enterPanNumber => 'உங்கள் PAN எண்ணை உள்ளிடவும்';

  @override
  String get drivingLicense => 'ஓட்டுநர் உரிமம்';

  @override
  String get uploadLicense =>
      'உங்கள் செல்லுபடியாகும் ஓட்டுநர் உரிமத்தைப் பதிவேற்றவும்';

  @override
  String get rcBook => 'RC புத்தகம்';

  @override
  String get uploadRcBook => 'உங்கள் வாகன பதிவு சான்றிதழைப் பதிவேற்றவும்';

  @override
  String get fcCertificate => 'FC சான்றிதழ்';

  @override
  String get uploadFc => 'உங்கள் தகுதி சான்றிதழைப் பதிவேற்றவும்';

  @override
  String get insuranceCertificate => 'காப்பீட்டு சான்றிதழ்';

  @override
  String get uploadInsurance =>
      'உங்கள் வாகன காப்பீட்டு சான்றிதழைப் பதிவேற்றவும்';

  @override
  String get aadharCard => 'ஆதார் அட்டை';

  @override
  String get uploadAadhar => 'உங்கள் ஆதார் அட்டையைப் பதிவேற்றவும்';

  @override
  String get electricityBill => 'மின்சார பில்';

  @override
  String get uploadEbBill =>
      'உங்கள் முகவரி ஆதாரத்தைப் பதிவேற்றவும் (மின்சார பில்)';

  @override
  String get payoutDetails => 'பேஅவுட் விவரங்கள்';

  @override
  String get payoutDescription =>
      'பேஅவுட்களை எவ்வாறு பெற விரும்புகிறீர்கள் என்பதைத் தேர்ந்தெடுக்கவும். வங்கி கணக்கு அல்லது UPI ID (VPA) பயன்படுத்தலாம்.';

  @override
  String get bankAccount => 'வங்கி கணக்கு';

  @override
  String get upiVpa => 'UPI (VPA)';

  @override
  String get accountHolderName => 'கணக்கு வைத்திருப்பவர் பெயர்';

  @override
  String get enterAccountHolderName => 'கணக்கு வைத்திருப்பவர் பெயரை உள்ளிடவும்';

  @override
  String get accountNumber => 'கணக்கு எண்';

  @override
  String get enterAccountNumber => 'கணக்கு எண்ணை உள்ளிடவும்';

  @override
  String get ifscCode => 'IFSC குறியீடு';

  @override
  String get upiId => 'UPI ID (VPA)';

  @override
  String get upiHint => 'எ.கா., username@okicici';

  @override
  String get bankDetailsNote =>
      'உங்கள் வங்கி விவரங்கள் பாதுகாப்பான பேஅவுட் கணக்கை உருவாக்க மட்டுமே பயன்படுத்தப்படுகின்றன. உங்கள் முழு வங்கி தகவலை நாங்கள் சேமிப்பதில்லை.';

  @override
  String get almostDone => 'கிட்டத்தட்ட முடிந்தது!';

  @override
  String get phoneStepDescription =>
      'வாடிக்கையாளர்களுடன் சிறந்த தொடர்புக்கு மாற்று தொலைபேசி எண்ணைச் சேர்க்கவும். இது சுமூகமான பிக்அப் மற்றும் டெலிவரிகளை உறுதி செய்ய உதவுகிறது.';

  @override
  String get youAreAllSet => 'நீங்கள் தயார்!';

  @override
  String get completeProfileDescription =>
      'ஹலோ டிரக்குடன் பயணங்களை ஏற்று பணம் சம்பாதிக்க உங்கள் சுயவிவரத்தை முடிக்கவும்.';

  @override
  String get view => 'பார்';

  @override
  String get reupload => 'மீண்டும் பதிவேற்று';

  @override
  String get titleAddress => 'முகவரி';

  @override
  String get titleVehicle => 'வாகனம்';

  @override
  String get titleDocuments => 'ஆவணங்கள்';

  @override
  String get addAddress => 'முகவரி சேர்';

  @override
  String get failedToLoadAddress => 'முகவரியை ஏற்றுவதில் தோல்வி';

  @override
  String get noAddressFound => 'முகவரி இல்லை';

  @override
  String get addressFoundSubtitle => 'தொடர உங்கள் முகவரியைச் சேர்க்கவும்';

  @override
  String get tapMapToSelect =>
      'இருப்பிடத்தைத் தேர்ந்தெடுக்க வரைபடத்தில் தட்டவும் அல்லது மார்க்கரை இழுக்கவும்';

  @override
  String get fillAllRequired => 'அனைத்து தேவையான புலங்களையும் நிரப்பவும்';

  @override
  String get addressUpdatedSuccess => 'முகவரி வெற்றிகரமாக புதுப்பிக்கப்பட்டது';

  @override
  String failedToSaveAddress(Object error) {
    return 'முகவரியைச் சேமிப்பதில் தோல்வி: $error';
  }

  @override
  String get failedToLoadVehicle => 'வாகனத்தை ஏற்றுவதில் தோல்வி';

  @override
  String get noVehicleFound => 'வாகனம் இல்லை';

  @override
  String get completeOnboardingToAddVehicle =>
      'வாகன விவரங்களைச் சேர்க்க உங்கள் ஆன்போர்டிங்கை முடிக்கவும்';

  @override
  String get vehicleNumberLabel => 'வாகன எண்';

  @override
  String get selfOwned => 'சுய உரிமை';

  @override
  String get selfOwnedDescription => 'நீங்கள் இந்த வாகனத்தின் உரிமையாளர்';

  @override
  String get failedToLoadDocuments => 'ஆவணங்களை ஏற்றுவதில் தோல்வி';

  @override
  String get noDocumentsFound => 'ஆவணங்கள் இல்லை';

  @override
  String get completeOnboardingToUploadDocuments =>
      'ஆவணங்களைப் பதிவேற்ற உங்கள் ஆன்போர்டிங்கை முடிக்கவும்';

  @override
  String expiredOn(Object date) {
    return '$date அன்று காலாவதியானது';
  }

  @override
  String validUntil(Object date) {
    return '$date வரை செல்லுபடியாகும்';
  }

  @override
  String reuploadedSuccess(Object title) {
    return '$title வெற்றிகரமாக மீண்டும் பதிவேற்றப்பட்டது';
  }

  @override
  String get selectPaymentMethod =>
      'பணம் செலுத்தும் முறையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get searchForAddress => 'முகவரியைத் தேடு';

  @override
  String get searchLocationHint => 'இருப்பிடத்தைத் தேடு...';

  @override
  String get startTypingToSearch =>
      'இருப்பிடங்களைத் தேட தட்டச்சு செய்யத் தொடங்கவும்';

  @override
  String get newRideRequest => 'புதிய பயண கோரிக்கை';

  @override
  String get bookingNumberPrefix => 'புக்கிங் #';

  @override
  String get pickupPrefix => 'பிக்அப்: ';

  @override
  String get acceptRide => 'பயணத்தை ஏற்றுக்கொள்';

  @override
  String get paymentReceivedSuccess => 'பணம் வெற்றிகரமாக பெறப்பட்டது! 💰';

  @override
  String get paymentSettledSuccess => 'பணம் வெற்றிகரமாக தீர்க்கப்பட்டது! 💰';

  @override
  String get paymentSettlementTitle => 'பணம் தீர்வு';

  @override
  String get checkPaymentStatusTooltip => 'பணம் நிலையைச் சரிபார்க்கவும்';

  @override
  String get paymentPendingTitle => 'பணம் நிலுவையில்';

  @override
  String get paymentPendingMessage =>
      'வாடிக்கையாளர் இன்னும் பணம் செலுத்தவில்லை. கீழே பணம் பெறும் முறையைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get serviceCost => 'சேவை செலவு';

  @override
  String get customerWalletUsed => 'வாடிக்கையாளர் வாலட் பயன்படுத்தப்பட்டது';

  @override
  String get customerDebtRecovery => 'வாடிக்கையாளர் கடன் மீட்பு';

  @override
  String platformFeePercentage(String percentage) {
    return 'தளம் கட்டணம் ($percentage%)';
  }

  @override
  String get yourEarnings => 'உங்கள் வருமானம்';

  @override
  String walletCreditAmount(String amount) {
    return 'வாலட் கிரெடிட்: +$amount';
  }

  @override
  String walletDebitAmount(String amount) {
    return 'வாலட் டெபிட்: $amount';
  }

  @override
  String get receivedCashTitle => 'பணம் பெறப்பட்டது';

  @override
  String get receivedCashSubtitle => 'வாடிக்கையாளரிடமிருந்து பணம் வசூலித்தேன்';

  @override
  String get onlinePaymentTitle =>
      'வாடிக்கையாளர் ஆப் வழியாக பணம் செலுத்துகிறார்';

  @override
  String get onlinePaymentSubtitle =>
      'வாடிக்கையாளரை அவர்களின் ஆப்பில் உள்ள பணம் செலுத்தும் இணைப்பு வழியாக பணம் செலுத்தச் சொல்லுங்கள்';

  @override
  String get importantInformation => 'முக்கிய தகவல்';

  @override
  String platformFeeDisclaimer(String percentage) {
    return 'தளம் கட்டணம் ($percentage%) முழு சேவை செலவில் கணக்கிடப்படுகிறது, வசூலிக்கப்பட்ட பணத்தில் அல்ல.';
  }

  @override
  String get walletAdjustmentDisclaimer =>
      'வாடிக்கையாளர் வாலட் கிரெடிட் பயன்படுத்தியிருந்தால், உங்களுக்கு வாலட் கிரெடிட் கிடைக்கும். வாடிக்கையாளருக்கு கடன் இருந்தால், கூடுதல் வசூலிக்கப்பட்ட தொகை டெபிட் செய்யப்படும்.';

  @override
  String get exactCashCollectionWarning =>
      'மேலே காட்டப்பட்ட சரியான \"வசூலிக்க வேண்டிய பணம்\" தொகையை வசூலித்துள்ளீர்கள் என்பதை உறுதிப்படுத்தவும்.';

  @override
  String get confirmCashPaymentTitle => 'பண பணம் செலுத்துதலை உறுதிப்படுத்தவும்';

  @override
  String get confirmCashPaymentMessage =>
      'உறுதிப்படுத்துவதன் மூலம், வாடிக்கையாளரிடமிருந்து முழு பண பணம் செலுத்துதலைப் பெற்றுள்ளீர்கள் என்று அறிவிக்கிறீர்கள்.';

  @override
  String platformFeeDeductionMessage(String amount) {
    return '$amount தளம் கட்டணம் உங்கள் வாலட்டிலிருந்து கழிக்கப்படும்';
  }

  @override
  String get platformFeeDeductionSuffix =>
      ' தளம் கட்டணம் உங்கள் வாலட்டிலிருந்து கழிக்கப்படும்';

  @override
  String reUploadTitle(String title) {
    return '$title மீண்டும் பதிவேற்று';
  }

  @override
  String get fileSizeLimit10MB =>
      'கோப்பு அளவு 10MB க்கும் குறைவாக இருக்க வேண்டும்';

  @override
  String get fileSizeLimit5MB => 'படம் அளவு 5MB க்கும் குறைவாக இருக்க வேண்டும்';

  @override
  String get documentSelected => 'ஆவணம் தேர்ந்தெடுக்கப்பட்டது';

  @override
  String get tapToSelectDocument => 'ஆவணத்தைத் தேர்ந்தெடுக்க தட்டவும்';

  @override
  String get documentFormatHint => 'JPG, PNG, PDF (அதிகபட்சம் 10MB)';

  @override
  String get docVerificationInfo =>
      'ஆவணம் நிர்வாகியால் சரிபார்க்கப்படும். சரிபார்ப்பின் போது காலாவதி தேதிகள் அமைக்கப்படும்.';

  @override
  String get linkEmailAddress => 'மின்னஞ்சல் முகவரியை இணை';

  @override
  String get emailAlreadyLinkedMessage =>
      'உங்கள் மின்னஞ்சல் ஏற்கனவே Google உடன் இணைக்கப்பட்டுள்ளது. தேவைப்பட்டால் வேறு Google கணக்குடன் மீண்டும் இணைக்கலாம்.';

  @override
  String get linkEmailMessage =>
      'உங்கள் பயணங்கள் மற்றும் வருமானம் பற்றிய முக்கிய புதுப்பிப்புகளைப் பெற உங்கள் மின்னஞ்சலை Google உடன் இணைக்கவும்.';

  @override
  String get linking => 'இணைக்கிறது...';

  @override
  String failedToLinkEmail(String error) {
    return 'Google உடன் மின்னஞ்சலை இணைப்பதில் தோல்வி: $error';
  }

  @override
  String get fieldCannotBeEmpty => 'இந்த புலம் காலியாக இருக்க முடியாது';

  @override
  String failedToSave(String error) {
    return 'சேமிப்பதில் தோல்வி: $error';
  }

  @override
  String editTitle(String title) {
    return '$title திருத்து';
  }

  @override
  String enterFieldHint(String field) {
    return 'உங்கள் $field உள்ளிடவும்';
  }

  @override
  String get updateProfilePicture => 'சுயவிவர படத்தைப் புதுப்பி';

  @override
  String get currentPicture => 'தற்போதைய படம்';

  @override
  String get newPicture => 'புதிய படம்';

  @override
  String get camera => 'கேமரா';

  @override
  String get gallery => 'கேலரி';

  @override
  String get uploadPicture => 'படத்தைப் பதிவேற்று';

  @override
  String get chooseDifferentImage => 'வேறு படத்தைத் தேர்ந்தெடு';

  @override
  String get firstNameMinLength =>
      'முதல் பெயர் குறைந்தது 3 எழுத்துக்கள் இருக்க வேண்டும்';

  @override
  String get enterValidPhone => 'சரியான 10 இலக்க தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get enterAddressLine1 => 'முகவரி வரி 1 உள்ளிடவும்';

  @override
  String get enterValidPincode => 'சரியான 6 இலக்க பின்கோடு உள்ளிடவும்';

  @override
  String get enterCity => 'நகரத்தை உள்ளிடவும்';

  @override
  String get enterDistrict => 'மாவட்டத்தை உள்ளிடவும்';

  @override
  String get enterState => 'மாநிலத்தை உள்ளிடவும்';

  @override
  String get enterVehicleBodyLength => 'வாகன உடல் நீளத்தை உள்ளிடவும்';

  @override
  String get vehicleBodyLengthGreaterThanZero =>
      'வாகன உடல் நீளம் 0 ஐ விட அதிகமாக இருக்க வேண்டும்';

  @override
  String get enterValidVehicleBodyLength =>
      'சரியான வாகன உடல் நீளத்தை உள்ளிடவும்';

  @override
  String get selectVehicleType => 'வாகன வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectVehicleModel => 'வாகன மாடலைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectVehicleBodyType => 'வாகன உடல் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectFuelType => 'எரிபொருள் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get enterOwnerContact => 'உரிமையாளர் தொடர்பு எண்ணை உள்ளிடவும்';

  @override
  String get enterValidOwnerContact =>
      'சரியான 10 இலக்க உரிமையாளர் தொடர்பு எண்ணை உள்ளிடவும்';

  @override
  String get enterOwnerAddress => 'உரிமையாளர் முகவரியை உள்ளிடவும்';

  @override
  String get enterOwnerPincode => 'உரிமையாளர் பின்கோடு உள்ளிடவும்';

  @override
  String get enterValidOwnerPincode =>
      'சரியான 6 இலக்க உரிமையாளர் பின்கோடு உள்ளிடவும்';

  @override
  String get enterOwnerCity => 'உரிமையாளர் நகரத்தை உள்ளிடவும்';

  @override
  String get enterOwnerDistrict => 'உரிமையாளர் மாவட்டத்தை உள்ளிடவும்';

  @override
  String get enterOwnerState => 'உரிமையாளர் மாநிலத்தை உள்ளிடவும்';

  @override
  String get enterValidPAN => 'சரியான PAN எண்ணை உள்ளிடவும்';

  @override
  String get uploadDrivingLicense => 'உங்கள் ஓட்டுநர் உரிமத்தைப் பதிவேற்றவும்';

  @override
  String get uploadRCBook => 'உங்கள் RC புத்தகத்தைப் பதிவேற்றவும்';

  @override
  String get uploadFCCertificate => 'உங்கள் FC சான்றிதழைப் பதிவேற்றவும்';

  @override
  String get uploadElectricityBill => 'உங்கள் மின்சார பில்லைப் பதிவேற்றவும்';

  @override
  String get enterPAN => 'உங்கள் PAN எண்ணை உள்ளிடவும்';

  @override
  String get enterIFSCCode => 'IFSC குறியீட்டை உள்ளிடவும்';

  @override
  String get enterValidIFSC => 'சரியான IFSC குறியீட்டை உள்ளிடவும்';

  @override
  String get enterUPIID => 'UPI ID (VPA) உள்ளிடவும்';

  @override
  String get enterValidUPI => 'சரியான UPI ID உள்ளிடவும்';

  @override
  String get completeSetup => 'அமைப்பை முடி';

  @override
  String get continueText => 'தொடர்';

  @override
  String get documentUploadedSuccess => 'ஆவணம் வெற்றிகரமாக பதிவேற்றப்பட்டது!';

  @override
  String failedToPickDocument(String error) {
    return 'ஆவணத்தைத் தேர்ந்தெடுப்பதில் தோல்வி: $error';
  }

  @override
  String failedToUploadDocument(String error) {
    return 'ஆவணத்தைப் பதிவேற்றுவதில் தோல்வி: $error';
  }

  @override
  String failedToPickImage(String error) {
    return 'படத்தைத் தேர்ந்தெடுப்பதில் தோல்வி: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'சுயவிவர படத்தைப் பதிவேற்றுவதில் தோல்வி: $error';
  }

  @override
  String get documentsNotFound => 'ஆவணங்கள் கிடைக்கவில்லை';

  @override
  String get documentsNotUploadedYet => 'ஆவணங்கள் இன்னும் பதிவேற்றப்படவில்லை.';

  @override
  String get documentNotFound => 'ஆவணம் கிடைக்கவில்லை';

  @override
  String get documentNotUploadedYet => 'இந்த ஆவணம் இன்னும் பதிவேற்றப்படவில்லை.';

  @override
  String get loadingDocument => 'ஆவணம் ஏற்றப்படுகிறது...';

  @override
  String get failedToLoadDocument => 'ஆவணத்தை ஏற்றுவதில் தோல்வி';

  @override
  String get checkInternetAndRetry =>
      'உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String failedToLoadPdf(String description) {
    return 'PDF ஏற்றுவதில் தோல்வி: $description';
  }

  @override
  String get loadingImage => 'படம் ஏற்றப்படுகிறது...';

  @override
  String get documentLoadError =>
      'ஆவணத்தை ஏற்ற முடியவில்லை. உங்கள் இணைய இணைப்பைச் சரிபார்த்து மீண்டும் முயற்சிக்கவும்.';

  @override
  String get checkingLocationPermissions =>
      'இருப்பிட அனுமதிகளைச் சரிபார்க்கிறது...';

  @override
  String get locationServicesDisabled => 'இருப்பிட சேவைகள் முடக்கப்பட்டுள்ளன';

  @override
  String get locationPermissionDenied =>
      'இருப்பிட அனுமதி நிரந்தரமாக மறுக்கப்பட்டது';

  @override
  String get locationAccessRequired => 'இருப்பிட அணுகல் தேவை';

  @override
  String get enableLocationServicesDesc =>
      'இந்த அம்சத்தைப் பயன்படுத்த உங்கள் சாதன அமைப்புகளில் இருப்பிட சேவைகளை இயக்கவும்.';

  @override
  String get needLocationAccessDesc =>
      'உங்கள் தற்போதைய நிலையைக் காட்டவும் உங்கள் முகவரியைத் துல்லியமாகத் தேர்ந்தெடுக்க உதவ இருப்பிட அணுகல் தேவை.';

  @override
  String get locationDeniedForeverDesc =>
      'இருப்பிட அனுமதி நிரந்தரமாக மறுக்கப்பட்டது. தொடர ஆப் அமைப்புகளில் இயக்கவும்.';

  @override
  String get locationRequiredDesc =>
      'இந்த அம்சம் சரியாக வேலை செய்ய இருப்பிட அணுகல் தேவை.';

  @override
  String get enableLocationServices => 'இருப்பிட சேவைகளை இயக்கு';

  @override
  String get grantPermission => 'அனுமதி வழங்கு';

  @override
  String get requestPermission => 'அனுமதி கோரு';

  @override
  String get checkAgain => 'மீண்டும் சரிபார்';

  @override
  String get actions => 'செயல்கள்';

  @override
  String callContact(String name) {
    return '$name ஐ அழை';
  }

  @override
  String get couldNotMakeCall => 'அழைப்பு செய்ய முடியவில்லை';

  @override
  String get markArrivalAtPickup => 'பிக்அப் இடத்தில் வருகையைக் குறி';

  @override
  String get verifyPickup => 'பிக்அப் சரிபார்';

  @override
  String get enterCustomerOtp => 'வாடிக்கையாளர் OTP உள்ளிடவும்';

  @override
  String get markArrivalAtDrop => 'டிராப் இடத்தில் வருகையைக் குறி';

  @override
  String get verifyDrop => 'டிராப் சரிபார்';

  @override
  String get rideComplete => 'பயணம் முடிந்தது';

  @override
  String get readyToFinish => 'முடிக்க தயார்';

  @override
  String get followTheRoute => 'வழியைப் பின்பற்று';

  @override
  String get markArrived => 'வந்துவிட்டதாகக் குறி';

  @override
  String get markedAsArrivedAtPickup =>
      'பிக்அப்பில் வந்துவிட்டதாகக் குறிக்கப்பட்டது';

  @override
  String get pickupVerificationTitle => 'பிக்அப் சரிபார்ப்பு';

  @override
  String get pickupVerified => 'பிக்அப் சரிபார்க்கப்பட்டது! 🎉';

  @override
  String get invalidOtpTryAgain => 'தவறான OTP. மீண்டும் முயற்சிக்கவும்.';

  @override
  String get markedAsArrivedAtDrop =>
      'டிராப்பில் வந்துவிட்டதாகக் குறிக்கப்பட்டது';

  @override
  String get dropVerificationTitle => 'டிராப் சரிபார்ப்பு';

  @override
  String get dropVerified => 'டிராப் சரிபார்க்கப்பட்டது! 🎉';

  @override
  String get rideCompleted => 'பயணம் முடிந்தது! 🎉';

  @override
  String get verify => 'சரிபார்';

  @override
  String get nowAvailableForRides =>
      'இப்போது நீங்கள் பயணங்களுக்கு கிடைக்கிறீர்கள்';

  @override
  String failedToMarkReady(String error) {
    return 'டிரைவரை தயார் என்று குறிப்பதில் தோல்வி: $error';
  }

  @override
  String failedToMarkPromptSeen(String error) {
    return 'ப்ராம்ப்ட்டை பார்த்ததாகக் குறிப்பதில் தோல்வி: $error';
  }

  @override
  String get readyToTakeRides => 'இன்று பயணங்களை எடுக்க தயாரா?';

  @override
  String get startEarningDesc =>
      'உங்கள் அருகிலுள்ள வாடிக்கையாளர்களிடமிருந்து பயண கோரிக்கைகளை ஏற்று சம்பாதிக்கத் தொடங்குங்கள்';

  @override
  String get getInstantNotifications => 'உடனடி அறிவிப்புகளைப் பெறுங்கள்';

  @override
  String get receiveRideRequestsImmediately =>
      'உடனடியாக பயண கோரிக்கைகளைப் பெறுங்கள்';

  @override
  String get findNearbyRides => 'அருகிலுள்ள பயணங்களைக் கண்டறியுங்கள்';

  @override
  String get connectWithCustomers =>
      'உங்கள் பகுதியில் உள்ள வாடிக்கையாளர்களுடன் இணையுங்கள்';

  @override
  String get startEarningToday => 'இன்று சம்பாதிக்கத் தொடங்குங்கள்';

  @override
  String get maximizeDailyIncome => 'உங்கள் தினசரி வருமான திறனை அதிகரிக்கவும்';

  @override
  String get maybeLater => 'பின்னர்';

  @override
  String get imReady => 'நான் தயார்!';

  @override
  String get changeFromRidesTab =>
      'பயணங்கள் தாவலில் இருந்து எப்போது வேண்டுமானாலும் மாற்றலாம்';

  @override
  String get pleaseEnterFirstName => 'உங்கள் முதல் பெயரை உள்ளிடவும்';

  @override
  String get pleaseEnterValidPhone =>
      'சரியான 10 இலக்க தொலைபேசி எண்ணை உள்ளிடவும்';

  @override
  String get pleaseEnterAddressLine1 => 'முகவரி வரி 1 உள்ளிடவும்';

  @override
  String get pleaseEnterPincode => 'பின்கோடு உள்ளிடவும்';

  @override
  String get pleaseEnterValidPincode => 'சரியான 6 இலக்க பின்கோடு உள்ளிடவும்';

  @override
  String get pleaseEnterCity => 'நகரத்தை உள்ளிடவும்';

  @override
  String get pleaseEnterDistrict => 'மாவட்டத்தை உள்ளிடவும்';

  @override
  String get pleaseEnterState => 'மாநிலத்தை உள்ளிடவும்';

  @override
  String get pleaseEnterVehicleNumber => 'வாகன எண்ணை உள்ளிடவும்';

  @override
  String get pleaseEnterVehicleBodyLength => 'வாகன உடல் நீளத்தை உள்ளிடவும்';

  @override
  String get vehicleBodyLengthMustBePositive =>
      'வாகன உடல் நீளம் 0 ஐ விட அதிகமாக இருக்க வேண்டும்';

  @override
  String get pleaseEnterValidBodyLength =>
      'சரியான வாகன உடல் நீளத்தை உள்ளிடவும்';

  @override
  String get pleaseSelectVehicleType => 'வாகன வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectVehicleModel => 'வாகன மாடலைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectVehicleBodyType =>
      'வாகன உடல் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseSelectFuelType => 'எரிபொருள் வகையைத் தேர்ந்தெடுக்கவும்';

  @override
  String get pleaseUploadVehicleImage => 'வாகன படத்தைப் பதிவேற்றவும்';

  @override
  String get pleaseEnterOwnerName => 'உரிமையாளர் பெயரை உள்ளிடவும்';

  @override
  String get pleaseEnterOwnerContact => 'உரிமையாளர் தொடர்பு எண்ணை உள்ளிடவும்';

  @override
  String get pleaseEnterValidOwnerContact =>
      'சரியான 10 இலக்க உரிமையாளர் தொடர்பு எண்ணை உள்ளிடவும்';

  @override
  String get pleaseEnterOwnerAddress => 'உரிமையாளர் முகவரியை உள்ளிடவும்';

  @override
  String get pleaseEnterOwnerPincode => 'உரிமையாளர் பின்கோடு உள்ளிடவும்';

  @override
  String get pleaseEnterValidOwnerPincode =>
      'சரியான 6 இலக்க உரிமையாளர் பின்கோடு உள்ளிடவும்';

  @override
  String get pleaseEnterOwnerCity => 'உரிமையாளர் நகரத்தை உள்ளிடவும்';

  @override
  String get pleaseEnterOwnerDistrict => 'உரிமையாளர் மாவட்டத்தை உள்ளிடவும்';

  @override
  String get pleaseEnterOwnerState => 'உரிமையாளர் மாநிலத்தை உள்ளிடவும்';

  @override
  String get pleaseUploadOwnerAadhar =>
      'உரிமையாளர் ஆதார் அட்டையைப் பதிவேற்றவும்';

  @override
  String get pleaseEnterValidPan => 'சரியான PAN எண்ணை உள்ளிடவும்';

  @override
  String get pleaseUploadDrivingLicense =>
      'உங்கள் ஓட்டுநர் உரிமத்தைப் பதிவேற்றவும்';

  @override
  String get pleaseUploadRcBook => 'உங்கள் RC புத்தகத்தைப் பதிவேற்றவும்';

  @override
  String get pleaseUploadFc => 'உங்கள் FC சான்றிதழைப் பதிவேற்றவும்';

  @override
  String get pleaseUploadInsurance =>
      'உங்கள் காப்பீட்டு சான்றிதழைப் பதிவேற்றவும்';

  @override
  String get pleaseUploadAadhar => 'உங்கள் ஆதார் அட்டையைப் பதிவேற்றவும்';

  @override
  String get pleaseUploadEbBill => 'உங்கள் மின்சார பில்லைப் பதிவேற்றவும்';

  @override
  String get pleaseEnterPanNumber => 'உங்கள் PAN எண்ணை உள்ளிடவும்';

  @override
  String get pleaseEnterAccountHolderName =>
      'கணக்கு வைத்திருப்பவர் பெயரை உள்ளிடவும்';

  @override
  String get pleaseEnterAccountNumber => 'கணக்கு எண்ணை உள்ளிடவும்';

  @override
  String get pleaseEnterIfscCode => 'IFSC குறியீட்டை உள்ளிடவும்';

  @override
  String get pleaseEnterValidIfsc => 'சரியான IFSC குறியீட்டை உள்ளிடவும்';

  @override
  String get pleaseEnterUpiId => 'UPI ID (VPA) உள்ளிடவும்';

  @override
  String get pleaseEnterValidUpiId => 'சரியான UPI ID உள்ளிடவும்';

  @override
  String get fileSizeMustBeLessThan10Mb =>
      'கோப்பு அளவு 10MB க்கும் குறைவாக இருக்க வேண்டும்';

  @override
  String get documentUploadedSuccessfully =>
      'ஆவணம் வெற்றிகரமாக பதிவேற்றப்பட்டது!';

  @override
  String licenseExpiresInDays(int days) {
    return 'உங்கள் ஓட்டுநர் உரிமம் $days நாட்களில் காலாவதியாகும். விரைவில் புதுப்பிக்கவும்.';
  }

  @override
  String get licenseExpiresIn30Days =>
      'உங்கள் ஓட்டுநர் உரிமம் 30 நாட்களில் காலாவதியாகும். புதுப்பிக்கவும்.';

  @override
  String get licenseExpiresIn45Days =>
      'உங்கள் ஓட்டுநர் உரிமம் 45 நாட்களில் காலாவதியாகும். புதுப்பிக்கவும்.';

  @override
  String get licenseExpired =>
      'உங்கள் ஓட்டுநர் உரிமம் காலாவதியாகிவிட்டது. உடனடியாக புதுப்பிக்கவும்.';

  @override
  String fcExpiresInDays(int days) {
    return 'உங்கள் தகுதி சான்றிதழ் $days நாட்களில் காலாவதியாகும். விரைவில் புதுப்பிக்கவும்.';
  }

  @override
  String get fcExpiresIn30Days =>
      'உங்கள் தகுதி சான்றிதழ் 30 நாட்களில் காலாவதியாகும். புதுப்பிக்கவும்.';

  @override
  String get fcExpiresIn45Days =>
      'உங்கள் தகுதி சான்றிதழ் 45 நாட்களில் காலாவதியாகும். புதுப்பிக்கவும்.';

  @override
  String get fcExpired =>
      'உங்கள் தகுதி சான்றிதழ் காலாவதியாகிவிட்டது. உடனடியாக புதுப்பிக்கவும்.';

  @override
  String insuranceExpiresInDays(int days) {
    return 'உங்கள் காப்பீடு $days நாட்களில் காலாவதியாகும். விரைவில் புதுப்பிக்கவும்.';
  }

  @override
  String get insuranceExpiresIn30Days =>
      'உங்கள் காப்பீடு 30 நாட்களில் காலாவதியாகும். புதுப்பிக்கவும்.';

  @override
  String get insuranceExpiresIn45Days =>
      'உங்கள் காப்பீடு 45 நாட்களில் காலாவதியாகும். புதுப்பிக்கவும்.';

  @override
  String get insuranceExpired =>
      'உங்கள் காப்பீடு காலாவதியாகிவிட்டது. உடனடியாக புதுப்பிக்கவும.';
}
