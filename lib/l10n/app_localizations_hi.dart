// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'हेलो ट्रक ड्राइवर';

  @override
  String get languageSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageTamil => 'தமிழ்';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get currentLanguage => 'हिन्दी';

  @override
  String get loginTitle => 'अपना फ़ोन नंबर दर्ज करें';

  @override
  String get loginSubtitle => 'हम आपको एक सत्यापन कोड भेजेंगे';

  @override
  String get phoneNumberHint => 'फ़ोन नंबर';

  @override
  String get sendOtp => 'OTP भेजें';

  @override
  String get phoneEmptyError => 'कृपया अपना फ़ोन नंबर दर्ज करें';

  @override
  String get phoneInvalidError => 'कृपया एक मान्य 10-अंकीय फ़ोन नंबर दर्ज करें';

  @override
  String errorSendingOtp(String error) {
    return 'OTP भेजने में त्रुटि: $error';
  }

  @override
  String get otpVerification => 'OTP सत्यापन';

  @override
  String get otpSentTo => 'हमने एक सत्यापन कोड भेजा है';

  @override
  String get otpSentSuccess => 'OTP सफलतापूर्वक भेजा गया!';

  @override
  String get checkTextMessages => 'अपने OTP के लिए टेक्स्ट संदेश देखें';

  @override
  String get didntGetOtp => 'OTP नहीं मिला?';

  @override
  String get resendSms => 'SMS पुनः भेजें';

  @override
  String resendSmsIn(int seconds) {
    return '${seconds}s में SMS पुनः भेजें';
  }

  @override
  String get changePhoneNumber => 'फ़ोन नंबर बदलें';

  @override
  String errorVerifyingOtp(String error) {
    return 'OTP सत्यापन में त्रुटि: $error';
  }

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get failedToLoadProfile => 'प्रोफाइल लोड करने में विफल';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get walletBalance => 'वॉलेट बैलेंस';

  @override
  String get documents => 'दस्तावेज़';

  @override
  String get documentsSubtitle => 'लाइसेंस, RC, बीमा और अधिक';

  @override
  String get vehicle => 'वाहन';

  @override
  String get vehicleSubtitle => 'वाहन विवरण और मालिक की जानकारी';

  @override
  String get address => 'पता';

  @override
  String get addressSubtitle => 'आपका पंजीकृत पता';

  @override
  String get languageSubtitle => 'ऐप भाषा बदलें';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get firstName => 'पहला नाम';

  @override
  String get lastName => 'अंतिम नाम';

  @override
  String get alternatePhone => 'वैकल्पिक फोन';

  @override
  String get notSet => 'सेट नहीं';

  @override
  String get account => 'खाता';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get email => 'ईमेल';

  @override
  String get notLinked => 'लिंक नहीं';

  @override
  String get link => 'लिंक';

  @override
  String get memberSince => 'सदस्य बने';

  @override
  String get referralCode => 'रेफरल कोड';

  @override
  String get edit => 'संपादित करें';

  @override
  String get add => 'जोड़ें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirmTitle => 'लॉगआउट';

  @override
  String get logoutConfirmMessage =>
      'क्या आप सुनिश्चित हैं कि आप लॉगआउट करना चाहते हैं?';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get pendingVerification => 'सत्यापन लंबित';

  @override
  String get verified => 'सत्यापित';

  @override
  String get verificationRejected => 'सत्यापन अस्वीकृत';

  @override
  String get profilePictureUpdated =>
      'प्रोफाइल फोटो सफलतापूर्वक अपडेट किया गया';

  @override
  String get emailLinkedSuccess => 'ईमेल सफलतापूर्वक लिंक हो गया';

  @override
  String get firstNameUpdated => 'पहला नाम सफलतापूर्वक अपडेट किया गया';

  @override
  String get lastNameUpdated => 'अंतिम नाम सफलतापूर्वक अपडेट किया गया';

  @override
  String get alternatePhoneUpdated =>
      'वैकल्पिक फ़ोन सफलतापूर्वक अपडेट किया गया';

  @override
  String failedToUpdate(String field, String error) {
    return '$field अपडेट करने में विफल: $error';
  }

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get home => 'होम';

  @override
  String get rides => 'राइड्स';

  @override
  String get earnings => 'कमाई';

  @override
  String helloDriver(String name) {
    return 'नमस्ते, $name 👋';
  }

  @override
  String get stayReadyEarnMore => 'तैयार रहें। ज्यादा कमाएं।';

  @override
  String get todaysSummary => 'आज का सारांश';

  @override
  String get ridesLabel => 'राइड्स';

  @override
  String get earned => 'कमाया';

  @override
  String get status => 'स्थिति';

  @override
  String get score => 'स्कोर';

  @override
  String get todaysRides => 'आज की राइड्स';

  @override
  String get noRidesCompletedYet => 'अभी तक कोई राइड पूरी नहीं हुई';

  @override
  String get completeFirstRide => 'आज अपनी पहली राइड पूरी करें!';

  @override
  String bookingNumber(String number) {
    return 'बुकिंग #$number';
  }

  @override
  String get completed => 'पूर्ण';

  @override
  String get dismiss => 'खारिज करें';

  @override
  String get documentExpired => 'दस्तावेज़ समाप्त!';

  @override
  String get documentExpiringSoon => 'दस्तावेज़ जल्द समाप्त हो रहा है';

  @override
  String get cannotTakeBookings =>
      'दस्तावेज़ अपडेट होने तक आप बुकिंग नहीं ले सकते।';

  @override
  String get turnOnLocationServices => 'लोकेशन सेवाएं चालू करें';

  @override
  String get locationServicesOffMessage =>
      'लोकेशन सेवाएं बंद हैं। लोकेशन के बिना, आप राइड नहीं ले पाएंगे।';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get skipForNow => 'अभी के लिए छोड़ें';

  @override
  String get enableLocationPermission => 'लोकेशन परमिशन सक्षम करें';

  @override
  String get locationPermissionMessage =>
      'हमें राइड असाइन करने के लिए आपकी लोकेशन चाहिए। अन्यथा आप राइड नहीं ले पाएंगे।';

  @override
  String get enable => 'सक्षम करें';

  @override
  String get locationPermissionRequired => 'स्थान अनुमति आवश्यक है';

  @override
  String get locationPermissionDeniedMessage =>
      'परमिशन स्थायी रूप से अस्वीकृत है। लोकेशन की अनुमति देने के लिए ऐप सेटिंग्स खोलें।\nइसके बिना, आप राइड नहीं ले पाएंगे।';

  @override
  String get youAreOffline =>
      'आप ऑफलाइन हैं। कृपया अपना इंटरनेट कनेक्शन चेक करें।';

  @override
  String get youAreBackOnline => 'आप वापस ऑनलाइन हैं';

  @override
  String get bookingCancelled => 'बुकिंग रद्द';

  @override
  String get bookingCancelledMessage =>
      'क्षमा करें, आपकी बुकिंग ग्राहक द्वारा रद्द कर दी गई है। आपको अपने समय के लिए कुछ मुआवजा मिलेगा।';

  @override
  String failedToRejectBooking(String error) {
    return 'बुकिंग अस्वीकार करने में विफल: $error';
  }

  @override
  String failedToProcessBooking(String error) {
    return 'बुकिंग प्रोसेस करने में विफल: $error';
  }

  @override
  String error(String message) {
    return 'त्रुटि: $message';
  }

  @override
  String get driverStatusAvailable => 'उपलब्ध';

  @override
  String get driverStatusUnavailable => 'अनुपलब्ध';

  @override
  String get driverStatusOnRide => 'राइड पर';

  @override
  String get driverStatusRideOffered => 'राइड ऑफर की गई';

  @override
  String get bookingStatusPending => 'लंबित';

  @override
  String get bookingStatusDriverAssigned => 'ड्राइवर असाइन';

  @override
  String get bookingStatusConfirmed => 'पुष्टि';

  @override
  String get bookingStatusPickupArrived => 'पिकअप पहुंचे';

  @override
  String get bookingStatusPickupVerified => 'पिकअप सत्यापित';

  @override
  String get bookingStatusInTransit => 'रास्ते में';

  @override
  String get bookingStatusDropArrived => 'ड्रॉप पहुंचे';

  @override
  String get bookingStatusDropVerified => 'ड्रॉप सत्यापित';

  @override
  String get bookingStatusCompleted => 'पूर्ण';

  @override
  String get bookingStatusCancelled => 'रद्द';

  @override
  String get bookingStatusExpired => 'समाप्त';

  @override
  String get assignmentStatusOffered => 'ऑफर किया गया';

  @override
  String get assignmentStatusAccepted => 'स्वीकार किया गया';

  @override
  String get assignmentStatusRejected => 'अस्वीकृत';

  @override
  String get assignmentStatusAutoRejected => 'ऑटो अस्वीकृत';

  @override
  String get transactionTypeCredit => 'क्रेडिट';

  @override
  String get transactionTypeDebit => 'डेबिट';

  @override
  String get transactionCategoryBookingPayment => 'बुकिंग भुगतान';

  @override
  String get transactionCategoryBookingRefund => 'बुकिंग रिफंड';

  @override
  String get transactionCategoryDriverPayout => 'पेआउट';

  @override
  String get transactionCategoryWalletCredit => 'वॉलेट क्रेडिट';

  @override
  String get transactionCategoryOther => 'अन्य';

  @override
  String get paymentMethodCash => 'नकद';

  @override
  String get paymentMethodOnline => 'ऑनलाइन';

  @override
  String get paymentMethodWallet => 'वॉलेट';

  @override
  String get payoutStatusPending => 'लंबित';

  @override
  String get payoutStatusProcessing => 'प्रोसेसिंग';

  @override
  String get payoutStatusCompleted => 'पूर्ण';

  @override
  String get payoutStatusFailed => 'विफल';

  @override
  String get payoutStatusCancelled => 'रद्द';

  @override
  String get productTypePersonal => 'व्यक्तिगत';

  @override
  String get productTypeAgricultural => 'कृषि';

  @override
  String get productTypeNonAgricultural => 'गैर-कृषि';

  @override
  String get weightUnitKg => 'kg';

  @override
  String get weightUnitQuintal => 'क्विंटल';

  @override
  String get vehicleTypeThreeWheeler => 'तीन पहिया';

  @override
  String get vehicleTypeFourWheeler => 'चार पहिया';

  @override
  String get vehicleBodyTypeOpen => 'खुला';

  @override
  String get vehicleBodyTypeClosed => 'बंद';

  @override
  String get fuelTypeDiesel => 'डीजल';

  @override
  String get fuelTypePetrol => 'पेट्रोल';

  @override
  String get fuelTypeEv => 'इलेक्ट्रिक';

  @override
  String get fuelTypeCng => 'CNG';

  @override
  String get payoutMethodBankAccount => 'बैंक खाता';

  @override
  String get payoutMethodVpa => 'UPI';

  @override
  String get pickup => 'पिकअप';

  @override
  String get drop => 'ड्रॉप';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get reject => 'अस्वीकार करें';

  @override
  String get startNavigation => 'नेविगेशन शुरू करें';

  @override
  String get arrived => 'पहुंच गए';

  @override
  String get verifyOtp => 'OTP सत्यापित करें';

  @override
  String get startRide => 'राइड शुरू करें';

  @override
  String get completeRide => 'राइड पूरी करें';

  @override
  String get collectPayment => 'भुगतान लें';

  @override
  String get customer => 'ग्राहक';

  @override
  String get package => 'पैकेज';

  @override
  String get distance => 'दूरी';

  @override
  String get estimatedTime => 'अनुमानित समय';

  @override
  String get fare => 'किराया';

  @override
  String get commission => 'कमीशन';

  @override
  String get netEarnings => 'शुद्ध कमाई';

  @override
  String get cashToCollect => 'नकद प्राप्त करें';

  @override
  String get onlinePayment => 'ऑनलाइन भुगतान';

  @override
  String get paymentReceived => 'भुगतान प्राप्त';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get close => 'बंद करें';

  @override
  String get save => 'सहेजें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get noDataFound => 'कोई डेटा नहीं मिला';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get success => 'सफलता';

  @override
  String get warning => 'चेतावनी';

  @override
  String get info => 'जानकारी';

  @override
  String get tabActive => 'सक्रिय';

  @override
  String get tabHistory => 'इतिहास';

  @override
  String get failedToLoadActiveRide => 'सक्रिय राइड लोड करने में विफल';

  @override
  String get noActiveRides => 'कोई सक्रिय राइड नहीं';

  @override
  String get noActiveRidesSubtitle => 'आपकी सक्रिय राइड यहाँ दिखाई देंगी';

  @override
  String get failedToLoadRideHistory => 'राइड इतिहास लोड करने में विफल';

  @override
  String get noRideHistory => 'कोई राइड इतिहास नहीं';

  @override
  String get noRideHistorySubtitle => 'आपकी पूर्ण राइड यहाँ दिखाई देंगी';

  @override
  String get cannotAcceptRides => 'राइड स्वीकार नहीं कर सकते';

  @override
  String get youAreAvailable => 'आप उपलब्ध हैं';

  @override
  String get youAreUnavailable => 'आप अनुपलब्ध हैं';

  @override
  String get readyToAcceptRequests => 'नई राइड स्वीकार करने के लिए तैयार';

  @override
  String get turnOnToReceiveRides =>
      'राइड प्राप्त करना शुरू करने के लिए चालू करें';

  @override
  String get verificationRejectedMessage =>
      'आपका सत्यापन अस्वीकार कर दिया गया। कृपया समस्या हल करने के लिए सहायता से संपर्क करें।';

  @override
  String get verificationPendingMessage =>
      'आपका खाता सत्यापन लंबित है। दस्तावेज़ सत्यापित होने तक आप राइड स्वीकार नहीं कर सकते।';

  @override
  String documentsExpiredMessage(String docs) {
    return 'आपके $docs समाप्त हो गए हैं। कृपया राइड स्वीकार करने के लिए उन्हें अपडेट करें।';
  }

  @override
  String get youAreNowAvailable => 'अब आप उपलब्ध हैं';

  @override
  String get youAreNowUnavailable => 'अब आप अनुपलब्ध हैं';

  @override
  String get failedToUpdateStatus => 'स्थिति अपडेट करने में विफल';

  @override
  String get agriculturalProduct => 'कृषि उत्पाद';

  @override
  String get packageDelivery => 'पैकेज डिलीवरी';

  @override
  String get navigateToPickup => 'पिकअप पर नेविगेट करें';

  @override
  String get navigateToDrop => 'ड्रॉप पर नेविगेट करें';

  @override
  String get walletActivity => 'वॉलेट गतिविधि';

  @override
  String get payouts => 'भुगतान';

  @override
  String get failedToLoadWalletBalance => 'वॉलेट बैलेंस लोड करने में विफल';

  @override
  String get totalBalance => 'कुल बैलेंस';

  @override
  String get failedToLoadWalletActivity => 'वॉलेट गतिविधि लोड करने में विफल';

  @override
  String get noWalletActivity => 'अभी तक कोई वॉलेट गतिविधि नहीं';

  @override
  String get walletActivitySubtitle => 'आपके वॉलेट लेनदेन यहाँ दिखाई देंगे';

  @override
  String get failedToLoadPayouts => 'भुगतान लोड करने में विफल';

  @override
  String get noPayouts => 'अभी तक कोई भुगतान नहीं';

  @override
  String get payoutsSubtitle => 'दैनिक भुगतान यहाँ दिखाई देंगे';

  @override
  String get license => 'लाइसेंस';

  @override
  String get fc => 'फिटनेस प्रमाण पत्र';

  @override
  String get insurance => 'बीमा';

  @override
  String get pickupLocation => 'पिकअप स्थान';

  @override
  String get dropLocation => 'ड्रॉप स्थान';

  @override
  String get navigation => 'नेविगेशन';

  @override
  String get location => 'स्थान';

  @override
  String get navigate => 'नेविगेट करें';

  @override
  String get termsAndConditionsTitle => 'हैलो ट्रक नेविगेशन';

  @override
  String get termsAndConditionsCompanyName => 'हैलो ट्रक';

  @override
  String get failedToStartNavigation => 'नेविगेशन सत्र शुरू करने में विफल';

  @override
  String routeError(String status) {
    return 'रूट त्रुटि: $status';
  }

  @override
  String get exitNavigationTitle => 'नेविगेशन बंद करें?';

  @override
  String get exitNavigationMessage => 'यह नेविगेशन और लोकेशन अपडेट रोक देगा';

  @override
  String get consequences => 'परिणाम:';

  @override
  String get warningNavigationStop => 'नेविगेशन अपडेट रुक जाएंगे';

  @override
  String get warningLocationInvisible => 'ग्राहक आपकी लोकेशन नहीं देख पाएगा';

  @override
  String get warningRating => 'आपकी रेटिंग प्रभावित हो सकती है';

  @override
  String get exitAnyway => 'फिर भी बाहर निकलें';

  @override
  String get navigatingToPickup => 'पिकअप के लिए नेविगेट कर रहे हैं';

  @override
  String get navigatingToDrop => 'ड्रॉप के लिए नेविगेट कर रहे हैं';

  @override
  String get enterValidEmail => 'कृपया एक मान्य ईमेल पता दर्ज करें';

  @override
  String get completeDocumentUploads => 'कृपया सभी दस्तावेज़ अपलोड पूरे करें';

  @override
  String get completeAddressDetails => 'कृपया पता विवरण पूरा करें';

  @override
  String get completeVehicleDetails => 'कृपया वाहन विवरण पूरा करें';

  @override
  String get completePayoutDetails => 'कृपया भुगतान विवरण पूरा करें';

  @override
  String failedToCompleteOnboarding(String error) {
    return 'ऑनबोर्डिंग पूरा करने में विफल: $error';
  }

  @override
  String get rideCompleteTitle => 'यात्रा पूर्ण!';

  @override
  String get packageDeliveredSuccess => 'पैकेज सफलतापूर्वक वितरित हो गया!';

  @override
  String get rideCompleteMessage =>
      'पिकअप और ड्रॉप दोनों सत्यापित हो चुके हैं। अब आप इस यात्रा को समाप्त कर सकते हैं।';

  @override
  String get tripSummary => 'यात्रा सारांश';

  @override
  String get finishRide => 'राइड समाप्त करें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get rideCompletedSuccessToast => 'यात्रा सफलतापूर्वक पूरी हो गई!';

  @override
  String failedToFinishRide(String error) {
    return 'यात्रा समाप्त करने में विफल: $error';
  }

  @override
  String get nameStepTitle => 'आपका नाम क्या है?';

  @override
  String get nameStepDescription =>
      'यह आपके ड्राइवर प्रोफाइल पर प्रदर्शित होगा और ग्राहकों को सवारी के दौरान आपकी पहचान करने में मदद करेगा।';

  @override
  String get enterFirstName => 'कृपया अपना पहला नाम दर्ज करें';

  @override
  String get enterLastNameOptional => 'अपना अंतिम नाम दर्ज करें (वैकल्पिक)';

  @override
  String get photoStepTitle => 'अपनी फोटो जोड़ें';

  @override
  String get photoStepDescription =>
      'ग्राहकों को आपको पहचानने में मदद करने के लिए एक स्पष्ट, पेशेवर फोटो अपलोड करें।';

  @override
  String get tapToAddPhoto => 'फोटो जोड़ने के लिए टैप करें';

  @override
  String get uploadingPhoto => 'आपकी फोटो अपलोड की जा रही है...';

  @override
  String get photoSelected => 'फोटो चुनी गई';

  @override
  String get emailStepTitle => 'अपना ईमेल सत्यापित करें';

  @override
  String get emailStepDescription =>
      'अपने ईमेल पते को सत्यापित करने और अपनी सवारी और कमाई के बारे में महत्वपूर्ण अपडेट प्राप्त करने के लिए Google से कनेक्ट करें।';

  @override
  String get emailVerifiedSuccess => 'ईमेल सफलतापूर्वक सत्यापित किया गया';

  @override
  String get connectWithGoogle => 'Google के साथ जुड़ें';

  @override
  String get emailStepOptional =>
      'यह चरण वैकल्पिक है। आप इसे छोड़ सकते हैं और बाद में अपना ईमेल सत्यापित कर सकते हैं।';

  @override
  String get addressStepTitle => 'अपना पता दर्ज करें';

  @override
  String get addressStepDescription =>
      'अपना पता खोजने के लिए खोज आइकन टैप करें और अपने सटीक स्थान का चयन करने के लिए मानचित्र पर टैप करें या मार्कर को खींचें।';

  @override
  String get searchAddress => 'पता खोजें';

  @override
  String get gettingLocation => 'स्थान प्राप्त किया जा रहा है...';

  @override
  String get addressNote =>
      'कृपया अपना पता दर्ज करें जैसा कि आपके बिजली बिल पर दिखाई देता है।';

  @override
  String get addressLine1 => 'पता पंक्ति 1';

  @override
  String get addressLine1Hint => 'घर/भवन, सड़क';

  @override
  String get landmark => 'लैंडमार्क (वैकल्पिक)';

  @override
  String get landmarkHint => 'लैंडमार्क या क्षेत्र के पास';

  @override
  String get pincode => 'पिनकोड';

  @override
  String get enterPincode => 'कृपया पिनकोड दर्ज करें';

  @override
  String get city => 'शहर';

  @override
  String get cityName => 'शहर का नाम';

  @override
  String get district => 'जिला';

  @override
  String get districtName => 'जिले का नाम';

  @override
  String get state => 'राज्य';

  @override
  String get stateName => 'राज्य का नाम';

  @override
  String get vehicleStepTitle => 'वाहन विवरण';

  @override
  String get vehicleStepDescription =>
      'पंजीकरण के लिए अपना वाहन विवरण और मालिक का विवरण दर्ज करें।';

  @override
  String get vehicleNumber => 'वाहन संख्या';

  @override
  String get enterVehicleNumber => 'कृपया वाहन संख्या दर्ज करें';

  @override
  String get vehicleType => 'वाहन प्रकार';

  @override
  String get vehicleModel => 'वाहन मॉडल';

  @override
  String get vehicleBodyLength => 'वाहन बॉडी की लंबाई (फीट)';

  @override
  String get enterBodyLength => 'बॉडी की लंबाई दर्ज करें';

  @override
  String get vehicleImage => 'वाहन की छवि';

  @override
  String get uploadVehicleImage => 'कृपया वाहन छवि अपलोड करें';

  @override
  String get vehicleBodyType => 'वाहन बॉडी प्रकार';

  @override
  String get fuelType => 'ईंधन प्रकार';

  @override
  String get vehicleOwnerDetails => 'वाहन मालिक का विवरण';

  @override
  String get sameAsDriver => 'ड्राइवर के समान';

  @override
  String get sameAsDriverSubtitle => 'वाहन मालिक का विवरण ड्राइवर के समान है';

  @override
  String get ownerName => 'मालिक का नाम';

  @override
  String get enterOwnerName => 'कृपया मालिक का नाम दर्ज करें';

  @override
  String get contactNumber => 'संपर्क संख्या';

  @override
  String get enterContactNumber => 'संपर्क संख्या दर्ज करें';

  @override
  String get ownerAadharCard => 'मालिक का आधार कार्ड';

  @override
  String get uploadOwnerAadhar => 'कृपया मालिक का आधार कार्ड अपलोड करें';

  @override
  String get noVehicleModels => 'कोई वाहन मॉडल उपलब्ध नहीं है';

  @override
  String get documentsStepTitle => 'दस्तावेज़ अपडेट करें';

  @override
  String get documentsStepDescription =>
      'कृपया अपने ड्राइवर प्रोफ़ाइल सत्यापन को पूरा करने के लिए सभी आवश्यक दस्तावेज़ अपलोड करें।';

  @override
  String get panNumber => 'पैन नंबर';

  @override
  String get enterPanNumber => 'अपना पैन नंबर दर्ज करें';

  @override
  String get drivingLicense => 'ड्राइविंग लाइसेंस';

  @override
  String get uploadLicense => 'अपना वैध ड्राइविंग लाइसेंस अपलोड करें';

  @override
  String get rcBook => 'आरसी बुक';

  @override
  String get uploadRcBook => 'अपने वाहन का पंजीकरण प्रमाण पत्र अपलोड करें';

  @override
  String get fcCertificate => 'एफसी प्रमाण पत्र';

  @override
  String get uploadFc => 'अपना फिटनेस प्रमाण पत्र अपलोड करें';

  @override
  String get insuranceCertificate => 'बीमा प्रमाण पत्र';

  @override
  String get uploadInsurance => 'कृपया अपना बीमा प्रमाण पत्र अपलोड करें';

  @override
  String get aadharCard => 'आधार कार्ड';

  @override
  String get uploadAadhar => 'कृपया अपना आधार कार्ड अपलोड करें';

  @override
  String get electricityBill => 'बिजली बिल';

  @override
  String get uploadEbBill => 'अपना पता प्रमाण अपलोड करें (बिजली बिल)';

  @override
  String get payoutDetails => 'भुगतान विवरण';

  @override
  String get payoutDescription =>
      'चुनें कि आप अपना भुगतान कैसे प्राप्त करना चाहते हैं। आप बैंक खाते या यूपीआई आईडी (वीपीए) का उपयोग कर सकते हैं।';

  @override
  String get bankAccount => 'बैंक खाता';

  @override
  String get upiVpa => 'यूपीआई (वीपीए)';

  @override
  String get accountHolderName => 'खाता धारक का नाम';

  @override
  String get enterAccountHolderName => 'कृपया खाता धारक का नाम दर्ज करें';

  @override
  String get accountNumber => 'खाता संख्या';

  @override
  String get enterAccountNumber => 'कृपया खाता संख्या दर्ज करें';

  @override
  String get ifscCode => 'आईएफएससी कोड';

  @override
  String get upiId => 'यूपीआई आईडी (वीपीए)';

  @override
  String get upiHint => 'उदाहरण: username@okicici';

  @override
  String get bankDetailsNote =>
      'आपके बैंक विवरण का उपयोग केवल सुरक्षित भुगतान खाता बनाने के लिए किया जाता है। हम आपकी पूरी बैंक जानकारी संग्रहीत नहीं करते हैं।';

  @override
  String get almostDone => 'लगभग हो गया!';

  @override
  String get phoneStepDescription =>
      'ग्राहकों के साथ बेहतर संचार के लिए एक वैकल्पिक फोन नंबर जोड़ें। यह सुचारू पिकअप और डिलीवरी सुनिश्चित करने में मदद करता है।';

  @override
  String get youAreAllSet => 'आप पूरी तरह तैयार हैं!';

  @override
  String get completeProfileDescription =>
      'हैलो ट्रक के साथ सवारी स्वीकार करने और पैसे कमाने के लिए अपनी प्रोफ़ाइल पूरी करें।';

  @override
  String get view => 'देखें';

  @override
  String get reupload => 'पुनः अपलोड करें';

  @override
  String get titleAddress => 'पता';

  @override
  String get titleVehicle => 'वाहन';

  @override
  String get titleDocuments => 'दस्तावेज़';

  @override
  String get addAddress => 'पता जोड़ें';

  @override
  String get failedToLoadAddress => 'पता लोड करने में विफल';

  @override
  String get noAddressFound => 'कोई पता नहीं मिला';

  @override
  String get addressFoundSubtitle => 'जारी रखने के लिए अपना पता जोड़ें';

  @override
  String get tapMapToSelect =>
      'स्थान चुनने के लिए मानचित्र पर टैप करें या मार्कर खींचें';

  @override
  String get fillAllRequired => 'कृपया सभी आवश्यक फ़ील्ड भरें';

  @override
  String get addressUpdatedSuccess => 'पता सफलतापूर्वक अपडेट किया गया';

  @override
  String failedToSaveAddress(Object error) {
    return 'पता सहेजने में विफल: $error';
  }

  @override
  String get failedToLoadVehicle => 'वाहन लोड करने में विफल';

  @override
  String get noVehicleFound => 'कोई वाहन नहीं मिला';

  @override
  String get completeOnboardingToAddVehicle =>
      'वाहन विवरण जोड़ने के लिए अपना ऑनबोर्डिंग पूरा करें';

  @override
  String get vehicleNumberLabel => 'वाहन संख्या';

  @override
  String get selfOwned => 'स्व-स्वामित्व';

  @override
  String get selfOwnedDescription => 'आप इस वाहन के मालिक हैं';

  @override
  String get failedToLoadDocuments => 'दस्तावेज़ लोड करने में विफल';

  @override
  String get noDocumentsFound => 'कोई दस्तावेज़ नहीं मिला';

  @override
  String get completeOnboardingToUploadDocuments =>
      'दस्तावेज़ अपलोड करने के लिए अपना ऑनबोर्डिंग पूरा करें';

  @override
  String expiredOn(Object date) {
    return '$date को समाप्त हो गया';
  }

  @override
  String validUntil(Object date) {
    return '$date तक मान्य';
  }

  @override
  String reuploadedSuccess(Object title) {
    return '$title सफलतापूर्वक पुनः अपलोड किया गया';
  }

  @override
  String get selectPaymentMethod => 'भुगतान विधि चुनें';

  @override
  String get searchForAddress => 'पता खोजें';

  @override
  String get searchLocationHint => 'स्थान खोजें...';

  @override
  String get startTypingToSearch => 'स्थान खोजने के लिए टाइप करना शुरू करें';

  @override
  String get newRideRequest => 'नया राइड अनुरोध';

  @override
  String get bookingNumberPrefix => 'बुकिंग #';

  @override
  String get pickupPrefix => 'पिकअप: ';

  @override
  String get acceptRide => 'राइड स्वीकार करें';

  @override
  String get paymentReceivedSuccess => 'भुगतान सफलतापूर्वक प्राप्त हुआ! 💰';

  @override
  String get paymentSettledSuccess => 'भुगतान सफलतापूर्वक निपटारा हुआ! 💰';

  @override
  String get paymentSettlementTitle => 'भुगतान निपटान';

  @override
  String get checkPaymentStatusTooltip => 'भुगतान स्थिति जांचें';

  @override
  String get paymentPendingTitle => 'भुगतान लंबित';

  @override
  String get paymentPendingMessage =>
      'ग्राहक ने अभी तक भुगतान नहीं किया है। भुगतान प्राप्त करने का तरीका चुनें।';

  @override
  String get serviceCost => 'सेवा शुल्क';

  @override
  String get customerWalletUsed => 'ग्राहक वॉलेट का उपयोग';

  @override
  String get customerDebtRecovery => 'ग्राहक ऋण वसूली';

  @override
  String platformFeePercentage(String percentage) {
    return 'प्लेटफ़ॉर्म शुल्क ($percentage%)';
  }

  @override
  String get yourEarnings => 'आपकी कमाई';

  @override
  String walletCreditAmount(String amount) {
    return 'वॉलेट क्रेडिट: +$amount';
  }

  @override
  String walletDebitAmount(String amount) {
    return 'वॉलेट डेबिट: $amount';
  }

  @override
  String get receivedCashTitle => 'नकद प्राप्त हुआ';

  @override
  String get receivedCashSubtitle => 'मैंने ग्राहक से नकद जमा किया';

  @override
  String get onlinePaymentTitle => 'ग्राहक ऐप के माध्यम से भुगतान करता है';

  @override
  String get onlinePaymentSubtitle =>
      'ग्राहक से उनके ऐप में भुगतान लिंक के माध्यम से भुगतान करने को कहें';

  @override
  String get importantInformation => 'महत्वपूर्ण जानकारी';

  @override
  String platformFeeDisclaimer(String percentage) {
    return 'प्लेटफ़ॉर्म शुल्क ($percentage%) की गणना पूर्ण सेवा लागत पर की जाती है, नकद एकत्रित राशि पर नहीं।';
  }

  @override
  String get walletAdjustmentDisclaimer =>
      'यदि ग्राहक ने वॉलेट क्रेडिट का उपयोग किया है, तो आपको वॉलेट क्रेडिट प्राप्त होगा। यदि ग्राहक पर ऋण था, तो अतिरिक्त एकत्रित राशि डेबिट की जाएगी।';

  @override
  String get exactCashCollectionWarning =>
      'सुनिश्चित करें कि आपने ऊपर दिखाए गए सटीक \"नकद प्राप्त करें\" राशि एकत्र की है।';

  @override
  String get confirmCashPaymentTitle => 'नकद भुगतान की पुष्टि करें';

  @override
  String get confirmCashPaymentMessage =>
      'पुष्टि करके, आप घोषित करते हैं कि आपने ग्राहक से पूरा नकद भुगतान प्राप्त कर लिया है।';

  @override
  String platformFeeDeductionMessage(String amount) {
    return '$amount प्लेटफ़ॉर्म शुल्क आपके वॉलेट से काटा जाएगा';
  }

  @override
  String get platformFeeDeductionSuffix =>
      ' प्लेटफ़ॉर्म शुल्क आपके वॉलेट से काटा जाएगा';

  @override
  String reUploadTitle(String title) {
    return '$title पुनः अपलोड करें';
  }

  @override
  String get fileSizeLimit10MB => 'फ़ाइल का आकार 10MB से कम होना चाहिए';

  @override
  String get fileSizeLimit5MB => 'छवि का आकार 5MB से कम होना चाहिए';

  @override
  String get documentSelected => 'दस्तावेज़ चयनित';

  @override
  String get tapToSelectDocument => 'दस्तावेज़ चुनने के लिए टैप करें';

  @override
  String get documentFormatHint => 'JPG, PNG, PDF (अधिकतम 10MB)';

  @override
  String get docVerificationInfo =>
      'दस्तावेज़ व्यवस्थापक द्वारा सत्यापित किया जाएगा। सत्यापन के दौरान समाप्ति तिथियां निर्धारित की जाएंगी।';

  @override
  String get linkEmailAddress => 'ईमेल पता लिंक करें';

  @override
  String get emailAlreadyLinkedMessage =>
      'आपका ईमेल पहले से ही Google के साथ लिंक है। यदि आवश्यक हो तो आप एक अलग Google खाते के साथ फिर से लिंक कर सकते हैं।';

  @override
  String get linkEmailMessage =>
      'अपनी राइड और कमाई के बारे में महत्वपूर्ण अपडेट प्राप्त करने के लिए अपने ईमेल को Google के साथ लिंक करें।';

  @override
  String get linking => 'लिंक हो रहा है...';

  @override
  String failedToLinkEmail(String error) {
    return 'Google के साथ ईमेल लिंक करने में विफल: $error';
  }

  @override
  String get fieldCannotBeEmpty => 'यह फ़ील्ड खाली नहीं हो सकता';

  @override
  String failedToSave(String error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String editTitle(String title) {
    return '$title संपादित करें';
  }

  @override
  String enterFieldHint(String field) {
    return 'अपना $field दर्ज करें';
  }

  @override
  String get updateProfilePicture => 'प्रोफ़ाइल चित्र अपडेट करें';

  @override
  String get currentPicture => 'वर्तमान चित्र';

  @override
  String get newPicture => 'नया चित्र';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get uploadPicture => 'चित्र अपलोड करें';

  @override
  String get chooseDifferentImage => 'एक अलग छवि चुनें';

  @override
  String get firstNameMinLength => 'पहला नाम कम से कम 3 अक्षर का होना चाहिए';

  @override
  String get enterValidPhone => 'कृपया एक मान्य 10-अंकीय फ़ोन नंबर दर्ज करें';

  @override
  String get enterAddressLine1 => 'कृपया पता पंक्ति 1 दर्ज करें';

  @override
  String get enterValidPincode => 'कृपया एक मान्य 6-अंकीय पिनकोड दर्ज करें';

  @override
  String get enterCity => 'कृपया शहर दर्ज करें';

  @override
  String get enterDistrict => 'कृपया जिला दर्ज करें';

  @override
  String get enterState => 'कृपया राज्य दर्ज करें';

  @override
  String get enterVehicleBodyLength => 'कृपया वाहन की लंबाई दर्ज करें';

  @override
  String get vehicleBodyLengthGreaterThanZero =>
      'वाहन की लंबाई 0 से अधिक होनी चाहिए';

  @override
  String get enterValidVehicleBodyLength =>
      'कृपया एक मान्य वाहन लंबाई दर्ज करें';

  @override
  String get selectVehicleType => 'कृपया वाहन प्रकार चुनें';

  @override
  String get selectVehicleModel => 'कृपया वाहन मॉडल चुनें';

  @override
  String get selectVehicleBodyType => 'कृपया वाहन बॉडी प्रकार चुनें';

  @override
  String get selectFuelType => 'कृपया ईंधन प्रकार चुनें';

  @override
  String get enterOwnerContact => 'कृपया मालिक का संपर्क नंबर दर्ज करें';

  @override
  String get enterValidOwnerContact =>
      'कृपया एक मान्य 10-अंकीय मालिक संपर्क नंबर दर्ज करें';

  @override
  String get enterOwnerAddress => 'कृपया मालिक का पता दर्ज करें';

  @override
  String get enterOwnerPincode => 'कृपया मालिक का पिनकोड दर्ज करें';

  @override
  String get enterValidOwnerPincode =>
      'कृपया एक मान्य 6-अंकीय मालिक पिनकोड दर्ज करें';

  @override
  String get enterOwnerCity => 'कृपया मालिक का शहर दर्ज करें';

  @override
  String get enterOwnerDistrict => 'कृपया मालिक का जिला दर्ज करें';

  @override
  String get enterOwnerState => 'कृपया मालिक का राज्य दर्ज करें';

  @override
  String get enterValidPAN => 'कृपया एक मान्य पैन नंबर दर्ज करें';

  @override
  String get uploadDrivingLicense => 'कृपया अपना ड्राइविंग लाइसेंस अपलोड करें';

  @override
  String get uploadRCBook => 'कृपया अपनी आरसी बुक अपलोड करें';

  @override
  String get uploadFCCertificate => 'कृपया अपना एफसी प्रमाण पत्र अपलोड करें';

  @override
  String get uploadElectricityBill => 'कृपया अपना बिजली बिल अपलोड करें';

  @override
  String get enterPAN => 'कृपया अपना पैन नंबर दर्ज करें';

  @override
  String get enterIFSCCode => 'कृपया IFSC कोड दर्ज करें';

  @override
  String get enterValidIFSC => 'कृपया एक मान्य IFSC कोड दर्ज करें';

  @override
  String get enterUPIID => 'कृपया UPI ID (VPA) दर्ज करें';

  @override
  String get enterValidUPI => 'कृपया एक मान्य UPI ID दर्ज करें';

  @override
  String get completeSetup => 'सेटअप पूरा करें';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get documentUploadedSuccess => 'दस्तावेज़ सफलतापूर्वक अपलोड किया गया!';

  @override
  String failedToPickDocument(String error) {
    return 'दस्तावेज़ चुनने में विफल: $error';
  }

  @override
  String failedToUploadDocument(String error) {
    return 'दस्तावेज़ अपलोड करने में विफल: $error';
  }

  @override
  String failedToPickImage(String error) {
    return 'छवि चुनने में विफल: $error';
  }

  @override
  String failedToUploadImage(String error) {
    return 'प्रोफ़ाइल चित्र अपलोड करने में विफल: $error';
  }

  @override
  String get documentsNotFound => 'दस्तावेज़ नहीं मिले';

  @override
  String get documentsNotUploadedYet =>
      'दस्तावेज़ अभी तक अपलोड नहीं किए गए हैं।';

  @override
  String get documentNotFound => 'दस्तावेज़ नहीं मिला';

  @override
  String get documentNotUploadedYet =>
      'यह दस्तावेज़ अभी तक अपलोड नहीं किया गया है।';

  @override
  String get loadingDocument => 'दस्तावेज़ लोड हो रहा है...';

  @override
  String get failedToLoadDocument => 'दस्तावेज़ लोड करने में विफल';

  @override
  String get checkInternetAndRetry =>
      'अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String failedToLoadPdf(String description) {
    return 'PDF लोड करने में विफल: $description';
  }

  @override
  String get loadingImage => 'छवि लोड हो रही है...';

  @override
  String get documentLoadError =>
      'दस्तावेज़ लोड नहीं हो सका। कृपया अपना इंटरनेट कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get checkingLocationPermissions =>
      'स्थान अनुमतियों की जांच हो रही है...';

  @override
  String get locationServicesDisabled => 'स्थान सेवाएं अक्षम हैं';

  @override
  String get locationPermissionDenied => 'स्थान अनुमति स्थायी रूप से अस्वीकृत';

  @override
  String get locationAccessRequired => 'स्थान पहुंच आवश्यक है';

  @override
  String get enableLocationServicesDesc =>
      'इस सुविधा का उपयोग करने के लिए कृपया अपनी डिवाइस सेटिंग्स में स्थान सेवाएं सक्षम करें।';

  @override
  String get needLocationAccessDesc =>
      'हमें आपकी वर्तमान स्थिति दिखाने और आपका पता सटीक रूप से चुनने में मदद के लिए स्थान पहुंच की आवश्यकता है।';

  @override
  String get locationDeniedForeverDesc =>
      'स्थान अनुमति स्थायी रूप से अस्वीकार कर दी गई है। जारी रखने के लिए कृपया इसे ऐप सेटिंग्स में सक्षम करें।';

  @override
  String get locationRequiredDesc =>
      'इस सुविधा के ठीक से काम करने के लिए स्थान पहुंच आवश्यक है।';

  @override
  String get enableLocationServices => 'स्थान सेवाएं सक्षम करें';

  @override
  String get grantPermission => 'अनुमति दें';

  @override
  String get requestPermission => 'अनुमति का अनुरोध करें';

  @override
  String get checkAgain => 'फिर से जांचें';

  @override
  String get actions => 'कार्य';

  @override
  String callContact(String name) {
    return '$name को कॉल करें';
  }

  @override
  String get couldNotMakeCall => 'कॉल नहीं कर सके';

  @override
  String get markArrivalAtPickup => 'पिकअप स्थान पर आगमन चिह्नित करें';

  @override
  String get verifyPickup => 'पिकअप सत्यापित करें';

  @override
  String get enterCustomerOtp => 'ग्राहक OTP दर्ज करें';

  @override
  String get markArrivalAtDrop => 'ड्रॉप स्थान पर आगमन चिह्नित करें';

  @override
  String get verifyDrop => 'ड्रॉप सत्यापित करें';

  @override
  String get rideComplete => 'राइड पूर्ण';

  @override
  String get readyToFinish => 'समाप्त करने के लिए तैयार';

  @override
  String get followTheRoute => 'रास्ते का पालन करें';

  @override
  String get markArrived => 'पहुंचा हुआ चिह्नित करें';

  @override
  String get markedAsArrivedAtPickup => 'पिकअप पर पहुंचा हुआ चिह्नित किया गया';

  @override
  String get pickupVerificationTitle => 'पिकअप सत्यापन';

  @override
  String get pickupVerified => 'पिकअप सत्यापित! 🎉';

  @override
  String get invalidOtpTryAgain => 'अमान्य OTP। कृपया पुनः प्रयास करें।';

  @override
  String get markedAsArrivedAtDrop => 'ड्रॉप पर पहुंचा हुआ चिह्नित किया गया';

  @override
  String get dropVerificationTitle => 'ड्रॉप सत्यापन';

  @override
  String get dropVerified => 'ड्रॉप सत्यापित! 🎉';

  @override
  String get rideCompleted => 'राइड पूर्ण! 🎉';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get nowAvailableForRides => 'अब आप राइड के लिए उपलब्ध हैं';

  @override
  String failedToMarkReady(String error) {
    return 'ड्राइवर को तैयार चिह्नित करने में विफल: $error';
  }

  @override
  String failedToMarkPromptSeen(String error) {
    return 'प्रॉम्प्ट को देखे गए के रूप में चिह्नित करने में विफल: $error';
  }

  @override
  String get readyToTakeRides => 'आज राइड लेने के लिए तैयार?';

  @override
  String get startEarningDesc =>
      'आपके पास के ग्राहकों से राइड अनुरोध स्वीकार करके कमाई शुरू करें';

  @override
  String get getInstantNotifications => 'तुरंत सूचनाएं प्राप्त करें';

  @override
  String get receiveRideRequestsImmediately => 'तुरंत राइड अनुरोध प्राप्त करें';

  @override
  String get findNearbyRides => 'आस-पास की राइड खोजें';

  @override
  String get connectWithCustomers => 'अपने क्षेत्र के ग्राहकों से जुड़ें';

  @override
  String get startEarningToday => 'आज कमाई शुरू करें';

  @override
  String get maximizeDailyIncome => 'अपनी दैनिक आय क्षमता को अधिकतम करें';

  @override
  String get maybeLater => 'शायद बाद में';

  @override
  String get imReady => 'मैं तैयार हूं!';

  @override
  String get changeFromRidesTab => 'आप इसे कभी भी राइड टैब से बदल सकते हैं';

  @override
  String get pleaseEnterFirstName => 'कृपया अपना पहला नाम दर्ज करें';

  @override
  String get pleaseEnterValidPhone =>
      'कृपया एक मान्य 10-अंकीय फ़ोन नंबर दर्ज करें';

  @override
  String get pleaseEnterAddressLine1 => 'कृपया पता पंक्ति 1 दर्ज करें';

  @override
  String get pleaseEnterPincode => 'कृपया पिनकोड दर्ज करें';

  @override
  String get pleaseEnterValidPincode =>
      'कृपया एक मान्य 6-अंकीय पिनकोड दर्ज करें';

  @override
  String get pleaseEnterCity => 'कृपया शहर दर्ज करें';

  @override
  String get pleaseEnterDistrict => 'कृपया जिला दर्ज करें';

  @override
  String get pleaseEnterState => 'कृपया राज्य दर्ज करें';

  @override
  String get pleaseEnterVehicleNumber => 'कृपया वाहन नंबर दर्ज करें';

  @override
  String get pleaseEnterVehicleBodyLength =>
      'कृपया वाहन बॉडी की लंबाई दर्ज करें';

  @override
  String get vehicleBodyLengthMustBePositive =>
      'वाहन बॉडी की लंबाई 0 से अधिक होनी चाहिए';

  @override
  String get pleaseEnterValidBodyLength =>
      'कृपया एक मान्य वाहन बॉडी लंबाई दर्ज करें';

  @override
  String get pleaseSelectVehicleType => 'कृपया वाहन प्रकार चुनें';

  @override
  String get pleaseSelectVehicleModel => 'कृपया वाहन मॉडल चुनें';

  @override
  String get pleaseSelectVehicleBodyType => 'कृपया वाहन बॉडी प्रकार चुनें';

  @override
  String get pleaseSelectFuelType => 'कृपया ईंधन प्रकार चुनें';

  @override
  String get pleaseUploadVehicleImage => 'कृपया वाहन की छवि अपलोड करें';

  @override
  String get pleaseEnterOwnerName => 'कृपया मालिक का नाम दर्ज करें';

  @override
  String get pleaseEnterOwnerContact => 'कृपया मालिक का संपर्क नंबर दर्ज करें';

  @override
  String get pleaseEnterValidOwnerContact =>
      'कृपया एक मान्य 10-अंकीय मालिक संपर्क नंबर दर्ज करें';

  @override
  String get pleaseEnterOwnerAddress => 'कृपया मालिक का पता दर्ज करें';

  @override
  String get pleaseEnterOwnerPincode => 'कृपया मालिक का पिनकोड दर्ज करें';

  @override
  String get pleaseEnterValidOwnerPincode =>
      'कृपया एक मान्य 6-अंकीय मालिक पिनकोड दर्ज करें';

  @override
  String get pleaseEnterOwnerCity => 'कृपया मालिक का शहर दर्ज करें';

  @override
  String get pleaseEnterOwnerDistrict => 'कृपया मालिक का जिला दर्ज करें';

  @override
  String get pleaseEnterOwnerState => 'कृपया मालिक का राज्य दर्ज करें';

  @override
  String get pleaseUploadOwnerAadhar => 'कृपया मालिक का आधार कार्ड अपलोड करें';

  @override
  String get pleaseEnterValidPan => 'कृपया एक मान्य PAN नंबर दर्ज करें';

  @override
  String get pleaseUploadDrivingLicense =>
      'कृपया अपना ड्राइविंग लाइसेंस अपलोड करें';

  @override
  String get pleaseUploadRcBook => 'कृपया अपनी RC बुक अपलोड करें';

  @override
  String get pleaseUploadFc => 'कृपया अपना FC प्रमाणपत्र अपलोड करें';

  @override
  String get pleaseUploadInsurance => 'कृपया अपना बीमा प्रमाणपत्र अपलोड करें';

  @override
  String get pleaseUploadAadhar => 'कृपया अपना आधार कार्ड अपलोड करें';

  @override
  String get pleaseUploadEbBill => 'कृपया अपना बिजली बिल अपलोड करें';

  @override
  String get pleaseEnterPanNumber => 'कृपया अपना PAN नंबर दर्ज करें';

  @override
  String get pleaseEnterAccountHolderName => 'कृपया खाता धारक का नाम दर्ज करें';

  @override
  String get pleaseEnterAccountNumber => 'कृपया खाता संख्या दर्ज करें';

  @override
  String get pleaseEnterIfscCode => 'कृपया IFSC कोड दर्ज करें';

  @override
  String get pleaseEnterValidIfsc => 'कृपया एक मान्य IFSC कोड दर्ज करें';

  @override
  String get pleaseEnterUpiId => 'कृपया UPI ID (VPA) दर्ज करें';

  @override
  String get pleaseEnterValidUpiId => 'कृपया एक मान्य UPI ID दर्ज करें';

  @override
  String get fileSizeMustBeLessThan10Mb =>
      'फ़ाइल का आकार 10MB से कम होना चाहिए';

  @override
  String get documentUploadedSuccessfully =>
      'दस्तावेज़ सफलतापूर्वक अपलोड किया गया!';

  @override
  String licenseExpiresInDays(int days) {
    return 'आपका ड्राइविंग लाइसेंस $days दिनों में समाप्त हो रहा है। कृपया इसे जल्द नवीनीकृत करें।';
  }

  @override
  String get licenseExpiresIn30Days =>
      'आपका ड्राइविंग लाइसेंस 30 दिनों में समाप्त हो रहा है। कृपया इसे नवीनीकृत करें।';

  @override
  String get licenseExpiresIn45Days =>
      'आपका ड्राइविंग लाइसेंस 45 दिनों में समाप्त हो रहा है। कृपया इसे नवीनीकृत करें।';

  @override
  String get licenseExpired =>
      'आपका ड्राइविंग लाइसेंस समाप्त हो गया है। कृपया इसे तुरंत नवीनीकृत करें।';

  @override
  String fcExpiresInDays(int days) {
    return 'आपका फिटनेस प्रमाणपत्र $days दिनों में समाप्त हो रहा है। कृपया इसे जल्द नवीनीकृत करें।';
  }

  @override
  String get fcExpiresIn30Days =>
      'आपका फिटनेस प्रमाणपत्र 30 दिनों में समाप्त हो रहा है। कृपया इसे नवीनीकृत करें।';

  @override
  String get fcExpiresIn45Days =>
      'आपका फिटनेस प्रमाणपत्र 45 दिनों में समाप्त हो रहा है। कृपया इसे नवीनीकृत करें।';

  @override
  String get fcExpired =>
      'आपका फिटनेस प्रमाणपत्र समाप्त हो गया है। कृपया इसे तुरंत नवीनीकृत करें।';

  @override
  String insuranceExpiresInDays(int days) {
    return 'आपका बीमा $days दिनों में समाप्त हो रहा है। कृपया इसे जल्द नवीनीकृत करें।';
  }

  @override
  String get insuranceExpiresIn30Days =>
      'आपका बीमा 30 दिनों में समाप्त हो रहा है। कृपया इसे नवीनीकृत करें।';

  @override
  String get insuranceExpiresIn45Days =>
      'आपका बीमा 45 दिनों में समाप्त हो रहा है। कृपया इसे नवीनीकृत करें।';

  @override
  String get insuranceExpired =>
      'आपका बीमा समाप्त हो गया है। कृपया इसे तुरंत नवीनीकृत करें।';
}
