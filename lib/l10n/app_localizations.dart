import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello Truck Driver'**
  String get appTitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get languageHindi;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @currentLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get currentLanguage;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send you a verification code'**
  String get loginSubtitle;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberHint;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @phoneEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneEmptyError;

  /// No description provided for @phoneInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get phoneInvalidError;

  /// No description provided for @errorSendingOtp.
  ///
  /// In en, this message translates to:
  /// **'Error sending OTP: {error}'**
  String errorSendingOtp(String error);

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to'**
  String get otpSentTo;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully!'**
  String get otpSentSuccess;

  /// No description provided for @checkTextMessages.
  ///
  /// In en, this message translates to:
  /// **'Check text messages for your OTP'**
  String get checkTextMessages;

  /// No description provided for @didntGetOtp.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the OTP?'**
  String get didntGetOtp;

  /// No description provided for @resendSms.
  ///
  /// In en, this message translates to:
  /// **'Resend SMS'**
  String get resendSms;

  /// No description provided for @resendSmsIn.
  ///
  /// In en, this message translates to:
  /// **'Resend SMS in {seconds}s'**
  String resendSmsIn(int seconds);

  /// No description provided for @changePhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Change phone number'**
  String get changePhoneNumber;

  /// No description provided for @errorVerifyingOtp.
  ///
  /// In en, this message translates to:
  /// **'Error verifying OTP: {error}'**
  String errorVerifyingOtp(String error);

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @documentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'License, RC, Insurance & more'**
  String get documentsSubtitle;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @vehicleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle details & owner info'**
  String get vehicleSubtitle;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your registered address'**
  String get addressSubtitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get languageSubtitle;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @alternatePhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate Phone'**
  String get alternatePhone;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @notLinked.
  ///
  /// In en, this message translates to:
  /// **'Not linked'**
  String get notLinked;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @referralCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get referralCode;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @pendingVerification.
  ///
  /// In en, this message translates to:
  /// **'Pending Verification'**
  String get pendingVerification;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @verificationRejected.
  ///
  /// In en, this message translates to:
  /// **'Verification Rejected'**
  String get verificationRejected;

  /// No description provided for @profilePictureUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated successfully'**
  String get profilePictureUpdated;

  /// No description provided for @emailLinkedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email Linked Successfully'**
  String get emailLinkedSuccess;

  /// No description provided for @firstNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'First name updated successfully'**
  String get firstNameUpdated;

  /// No description provided for @lastNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last name updated successfully'**
  String get lastNameUpdated;

  /// No description provided for @alternatePhoneUpdated.
  ///
  /// In en, this message translates to:
  /// **'Alternate phone updated successfully'**
  String get alternatePhoneUpdated;

  /// No description provided for @failedToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Failed to update {field}: {error}'**
  String failedToUpdate(String field, String error);

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @rides.
  ///
  /// In en, this message translates to:
  /// **'Rides'**
  String get rides;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @helloDriver.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String helloDriver(String name);

  /// No description provided for @stayReadyEarnMore.
  ///
  /// In en, this message translates to:
  /// **'Stay ready. Earn more.'**
  String get stayReadyEarnMore;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// No description provided for @ridesLabel.
  ///
  /// In en, this message translates to:
  /// **'rides'**
  String get ridesLabel;

  /// No description provided for @earned.
  ///
  /// In en, this message translates to:
  /// **'earned'**
  String get earned;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @todaysRides.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Rides'**
  String get todaysRides;

  /// No description provided for @noRidesCompletedYet.
  ///
  /// In en, this message translates to:
  /// **'No rides completed yet'**
  String get noRidesCompletedYet;

  /// No description provided for @completeFirstRide.
  ///
  /// In en, this message translates to:
  /// **'Complete your first ride today!'**
  String get completeFirstRide;

  /// No description provided for @bookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking #{number}'**
  String bookingNumber(String number);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @documentExpired.
  ///
  /// In en, this message translates to:
  /// **'Document Expired!'**
  String get documentExpired;

  /// No description provided for @documentExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Document Expiring Soon'**
  String get documentExpiringSoon;

  /// No description provided for @cannotTakeBookings.
  ///
  /// In en, this message translates to:
  /// **'You cannot take bookings until documents are updated.'**
  String get cannotTakeBookings;

  /// No description provided for @turnOnLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Turn on Location Services'**
  String get turnOnLocationServices;

  /// No description provided for @locationServicesOffMessage.
  ///
  /// In en, this message translates to:
  /// **'Location services are off. Without location, you won\'t be able to take rides.'**
  String get locationServicesOffMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @enableLocationPermission.
  ///
  /// In en, this message translates to:
  /// **'Enable Location Permission'**
  String get enableLocationPermission;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'We need your location to assign rides. You won\'t be able to take rides otherwise.'**
  String get locationPermissionMessage;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Permission is permanently denied. Open app settings to allow location.\nWithout this, you won\'t be able to take rides.'**
  String get locationPermissionDeniedMessage;

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Please check your internet connection.'**
  String get youAreOffline;

  /// No description provided for @youAreBackOnline.
  ///
  /// In en, this message translates to:
  /// **'You are back online'**
  String get youAreBackOnline;

  /// No description provided for @bookingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking Cancelled'**
  String get bookingCancelled;

  /// No description provided for @bookingCancelledMessage.
  ///
  /// In en, this message translates to:
  /// **'Sorry, your booking has been cancelled by the customer. You will receive some compensation for your time.'**
  String get bookingCancelledMessage;

  /// No description provided for @failedToRejectBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject booking: {error}'**
  String failedToRejectBooking(String error);

  /// No description provided for @failedToProcessBooking.
  ///
  /// In en, this message translates to:
  /// **'Failed to process booking: {error}'**
  String failedToProcessBooking(String error);

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String error(String message);

  /// No description provided for @driverStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get driverStatusAvailable;

  /// No description provided for @driverStatusUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get driverStatusUnavailable;

  /// No description provided for @driverStatusOnRide.
  ///
  /// In en, this message translates to:
  /// **'On Ride'**
  String get driverStatusOnRide;

  /// No description provided for @driverStatusRideOffered.
  ///
  /// In en, this message translates to:
  /// **'Ride Offered'**
  String get driverStatusRideOffered;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusDriverAssigned.
  ///
  /// In en, this message translates to:
  /// **'Driver Assigned'**
  String get bookingStatusDriverAssigned;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusPickupArrived.
  ///
  /// In en, this message translates to:
  /// **'Pickup Arrived'**
  String get bookingStatusPickupArrived;

  /// No description provided for @bookingStatusPickupVerified.
  ///
  /// In en, this message translates to:
  /// **'Pickup Verified'**
  String get bookingStatusPickupVerified;

  /// No description provided for @bookingStatusInTransit.
  ///
  /// In en, this message translates to:
  /// **'In Transit'**
  String get bookingStatusInTransit;

  /// No description provided for @bookingStatusDropArrived.
  ///
  /// In en, this message translates to:
  /// **'Drop Arrived'**
  String get bookingStatusDropArrived;

  /// No description provided for @bookingStatusDropVerified.
  ///
  /// In en, this message translates to:
  /// **'Drop Verified'**
  String get bookingStatusDropVerified;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get bookingStatusExpired;

  /// No description provided for @assignmentStatusOffered.
  ///
  /// In en, this message translates to:
  /// **'Offered'**
  String get assignmentStatusOffered;

  /// No description provided for @assignmentStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get assignmentStatusAccepted;

  /// No description provided for @assignmentStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get assignmentStatusRejected;

  /// No description provided for @assignmentStatusAutoRejected.
  ///
  /// In en, this message translates to:
  /// **'Auto Rejected'**
  String get assignmentStatusAutoRejected;

  /// No description provided for @transactionTypeCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get transactionTypeCredit;

  /// No description provided for @transactionTypeDebit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get transactionTypeDebit;

  /// No description provided for @transactionCategoryBookingPayment.
  ///
  /// In en, this message translates to:
  /// **'Booking Payment'**
  String get transactionCategoryBookingPayment;

  /// No description provided for @transactionCategoryBookingRefund.
  ///
  /// In en, this message translates to:
  /// **'Booking Refund'**
  String get transactionCategoryBookingRefund;

  /// No description provided for @transactionCategoryDriverPayout.
  ///
  /// In en, this message translates to:
  /// **'Payout'**
  String get transactionCategoryDriverPayout;

  /// No description provided for @transactionCategoryWalletCredit.
  ///
  /// In en, this message translates to:
  /// **'Wallet Credit'**
  String get transactionCategoryWalletCredit;

  /// No description provided for @transactionCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get transactionCategoryOther;

  /// No description provided for @paymentMethodCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentMethodCash;

  /// No description provided for @paymentMethodOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get paymentMethodOnline;

  /// No description provided for @paymentMethodWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get paymentMethodWallet;

  /// No description provided for @payoutStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get payoutStatusPending;

  /// No description provided for @payoutStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get payoutStatusProcessing;

  /// No description provided for @payoutStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get payoutStatusCompleted;

  /// No description provided for @payoutStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get payoutStatusFailed;

  /// No description provided for @payoutStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get payoutStatusCancelled;

  /// No description provided for @productTypePersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get productTypePersonal;

  /// No description provided for @productTypeAgricultural.
  ///
  /// In en, this message translates to:
  /// **'Agricultural'**
  String get productTypeAgricultural;

  /// No description provided for @productTypeNonAgricultural.
  ///
  /// In en, this message translates to:
  /// **'Non-Agricultural'**
  String get productTypeNonAgricultural;

  /// No description provided for @weightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnitKg;

  /// No description provided for @weightUnitQuintal.
  ///
  /// In en, this message translates to:
  /// **'Quintal'**
  String get weightUnitQuintal;

  /// No description provided for @vehicleTypeThreeWheeler.
  ///
  /// In en, this message translates to:
  /// **'Three Wheeler'**
  String get vehicleTypeThreeWheeler;

  /// No description provided for @vehicleTypeFourWheeler.
  ///
  /// In en, this message translates to:
  /// **'Four Wheeler'**
  String get vehicleTypeFourWheeler;

  /// No description provided for @vehicleBodyTypeOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get vehicleBodyTypeOpen;

  /// No description provided for @vehicleBodyTypeClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get vehicleBodyTypeClosed;

  /// No description provided for @fuelTypeDiesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get fuelTypeDiesel;

  /// No description provided for @fuelTypePetrol.
  ///
  /// In en, this message translates to:
  /// **'Petrol'**
  String get fuelTypePetrol;

  /// No description provided for @fuelTypeEv.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get fuelTypeEv;

  /// No description provided for @fuelTypeCng.
  ///
  /// In en, this message translates to:
  /// **'CNG'**
  String get fuelTypeCng;

  /// No description provided for @payoutMethodBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get payoutMethodBankAccount;

  /// No description provided for @payoutMethodVpa.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get payoutMethodVpa;

  /// No description provided for @pickup.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get pickup;

  /// No description provided for @drop.
  ///
  /// In en, this message translates to:
  /// **'Drop'**
  String get drop;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @startNavigation.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get startNavigation;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @startRide.
  ///
  /// In en, this message translates to:
  /// **'Start Ride'**
  String get startRide;

  /// No description provided for @completeRide.
  ///
  /// In en, this message translates to:
  /// **'Complete Ride'**
  String get completeRide;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collectPayment;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @package.
  ///
  /// In en, this message translates to:
  /// **'Package'**
  String get package;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @estimatedTime.
  ///
  /// In en, this message translates to:
  /// **'Est. Time'**
  String get estimatedTime;

  /// No description provided for @fare.
  ///
  /// In en, this message translates to:
  /// **'Fare'**
  String get fare;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @netEarnings.
  ///
  /// In en, this message translates to:
  /// **'Net Earnings'**
  String get netEarnings;

  /// No description provided for @cashToCollect.
  ///
  /// In en, this message translates to:
  /// **'Cash to Collect'**
  String get cashToCollect;

  /// No description provided for @onlinePayment.
  ///
  /// In en, this message translates to:
  /// **'Online Payment'**
  String get onlinePayment;

  /// No description provided for @paymentReceived.
  ///
  /// In en, this message translates to:
  /// **'Payment Received'**
  String get paymentReceived;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @tabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// No description provided for @failedToLoadActiveRide.
  ///
  /// In en, this message translates to:
  /// **'Failed to load active ride'**
  String get failedToLoadActiveRide;

  /// No description provided for @noActiveRides.
  ///
  /// In en, this message translates to:
  /// **'No active rides'**
  String get noActiveRides;

  /// No description provided for @noActiveRidesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your active rides will appear here'**
  String get noActiveRidesSubtitle;

  /// No description provided for @failedToLoadRideHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ride history'**
  String get failedToLoadRideHistory;

  /// No description provided for @noRideHistory.
  ///
  /// In en, this message translates to:
  /// **'No ride history'**
  String get noRideHistory;

  /// No description provided for @noRideHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your completed rides will appear here'**
  String get noRideHistorySubtitle;

  /// No description provided for @cannotAcceptRides.
  ///
  /// In en, this message translates to:
  /// **'Cannot Accept Rides'**
  String get cannotAcceptRides;

  /// No description provided for @youAreAvailable.
  ///
  /// In en, this message translates to:
  /// **'You\'re available'**
  String get youAreAvailable;

  /// No description provided for @youAreUnavailable.
  ///
  /// In en, this message translates to:
  /// **'You\'re unavailable'**
  String get youAreUnavailable;

  /// No description provided for @readyToAcceptRequests.
  ///
  /// In en, this message translates to:
  /// **'Ready to accept new ride requests'**
  String get readyToAcceptRequests;

  /// No description provided for @turnOnToReceiveRides.
  ///
  /// In en, this message translates to:
  /// **'Turn on to start receiving rides'**
  String get turnOnToReceiveRides;

  /// No description provided for @verificationRejectedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your verification was rejected. Please contact support to resolve the issue.'**
  String get verificationRejectedMessage;

  /// No description provided for @verificationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is pending verification. You cannot accept rides until your documents are verified.'**
  String get verificationPendingMessage;

  /// No description provided for @documentsExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your {docs} have expired. Please update them to accept rides.'**
  String documentsExpiredMessage(String docs);

  /// No description provided for @youAreNowAvailable.
  ///
  /// In en, this message translates to:
  /// **'You are now available'**
  String get youAreNowAvailable;

  /// No description provided for @youAreNowUnavailable.
  ///
  /// In en, this message translates to:
  /// **'You are now unavailable'**
  String get youAreNowUnavailable;

  /// No description provided for @failedToUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status'**
  String get failedToUpdateStatus;

  /// No description provided for @agriculturalProduct.
  ///
  /// In en, this message translates to:
  /// **'Agricultural Product'**
  String get agriculturalProduct;

  /// No description provided for @packageDelivery.
  ///
  /// In en, this message translates to:
  /// **'Package Delivery'**
  String get packageDelivery;

  /// No description provided for @navigateToPickup.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Pickup'**
  String get navigateToPickup;

  /// No description provided for @navigateToDrop.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Drop'**
  String get navigateToDrop;

  /// No description provided for @walletActivity.
  ///
  /// In en, this message translates to:
  /// **'Wallet Activity'**
  String get walletActivity;

  /// No description provided for @payouts.
  ///
  /// In en, this message translates to:
  /// **'Payouts'**
  String get payouts;

  /// No description provided for @failedToLoadWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallet balance'**
  String get failedToLoadWalletBalance;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @failedToLoadWalletActivity.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wallet activity'**
  String get failedToLoadWalletActivity;

  /// No description provided for @noWalletActivity.
  ///
  /// In en, this message translates to:
  /// **'No wallet activity yet'**
  String get noWalletActivity;

  /// No description provided for @walletActivitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your wallet transactions will appear here'**
  String get walletActivitySubtitle;

  /// No description provided for @failedToLoadPayouts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load payouts'**
  String get failedToLoadPayouts;

  /// No description provided for @noPayouts.
  ///
  /// In en, this message translates to:
  /// **'No payouts yet'**
  String get noPayouts;

  /// No description provided for @payoutsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily payouts will appear here'**
  String get payoutsSubtitle;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @fc.
  ///
  /// In en, this message translates to:
  /// **'Fitness Certificate'**
  String get fc;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @pickupLocation.
  ///
  /// In en, this message translates to:
  /// **'Pickup Location'**
  String get pickupLocation;

  /// No description provided for @dropLocation.
  ///
  /// In en, this message translates to:
  /// **'Drop Location'**
  String get dropLocation;

  /// No description provided for @navigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @termsAndConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Hello Truck Navigation'**
  String get termsAndConditionsTitle;

  /// No description provided for @termsAndConditionsCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Hello Truck'**
  String get termsAndConditionsCompanyName;

  /// No description provided for @failedToStartNavigation.
  ///
  /// In en, this message translates to:
  /// **'Failed to start navigation session'**
  String get failedToStartNavigation;

  /// No description provided for @routeError.
  ///
  /// In en, this message translates to:
  /// **'Route error: {status}'**
  String routeError(String status);

  /// No description provided for @exitNavigationTitle.
  ///
  /// In en, this message translates to:
  /// **'Exit Navigation?'**
  String get exitNavigationTitle;

  /// No description provided for @exitNavigationMessage.
  ///
  /// In en, this message translates to:
  /// **'This will stop navigation and location updates'**
  String get exitNavigationMessage;

  /// No description provided for @consequences.
  ///
  /// In en, this message translates to:
  /// **'Consequences:'**
  String get consequences;

  /// No description provided for @warningNavigationStop.
  ///
  /// In en, this message translates to:
  /// **'Navigation updates will stop'**
  String get warningNavigationStop;

  /// No description provided for @warningLocationInvisible.
  ///
  /// In en, this message translates to:
  /// **'Customer won\'t see your location'**
  String get warningLocationInvisible;

  /// No description provided for @warningRating.
  ///
  /// In en, this message translates to:
  /// **'May affect your rating'**
  String get warningRating;

  /// No description provided for @exitAnyway.
  ///
  /// In en, this message translates to:
  /// **'Exit Anyway'**
  String get exitAnyway;

  /// No description provided for @navigatingToPickup.
  ///
  /// In en, this message translates to:
  /// **'Navigating to Pickup'**
  String get navigatingToPickup;

  /// No description provided for @navigatingToDrop.
  ///
  /// In en, this message translates to:
  /// **'Navigating to Drop'**
  String get navigatingToDrop;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get enterValidEmail;

  /// No description provided for @completeDocumentUploads.
  ///
  /// In en, this message translates to:
  /// **'Please complete all document uploads'**
  String get completeDocumentUploads;

  /// No description provided for @completeAddressDetails.
  ///
  /// In en, this message translates to:
  /// **'Please complete address details'**
  String get completeAddressDetails;

  /// No description provided for @completeVehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Please complete vehicle details'**
  String get completeVehicleDetails;

  /// No description provided for @completePayoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Please complete payout details'**
  String get completePayoutDetails;

  /// No description provided for @failedToCompleteOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete onboarding: {error}'**
  String failedToCompleteOnboarding(String error);

  /// No description provided for @rideCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Ride Complete!'**
  String get rideCompleteTitle;

  /// No description provided for @packageDeliveredSuccess.
  ///
  /// In en, this message translates to:
  /// **'Package delivered successfully!'**
  String get packageDeliveredSuccess;

  /// No description provided for @rideCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Both pickup and drop have been verified. You can now finish this ride.'**
  String get rideCompleteMessage;

  /// No description provided for @tripSummary.
  ///
  /// In en, this message translates to:
  /// **'Trip Summary'**
  String get tripSummary;

  /// No description provided for @finishRide.
  ///
  /// In en, this message translates to:
  /// **'Finish Ride'**
  String get finishRide;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @rideCompletedSuccessToast.
  ///
  /// In en, this message translates to:
  /// **'Ride completed successfully!'**
  String get rideCompletedSuccessToast;

  /// No description provided for @failedToFinishRide.
  ///
  /// In en, this message translates to:
  /// **'Failed to finish ride: {error}'**
  String failedToFinishRide(String error);

  /// No description provided for @nameStepTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get nameStepTitle;

  /// No description provided for @nameStepDescription.
  ///
  /// In en, this message translates to:
  /// **'This will be displayed on your driver profile and help customers identify you during their rides.'**
  String get nameStepDescription;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get enterFirstName;

  /// No description provided for @enterLastNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name (optional)'**
  String get enterLastNameOptional;

  /// No description provided for @photoStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your photo'**
  String get photoStepTitle;

  /// No description provided for @photoStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear, professional photo to help customers recognize you. This builds trust and makes pickups smoother.'**
  String get photoStepDescription;

  /// No description provided for @tapToAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to add photo'**
  String get tapToAddPhoto;

  /// No description provided for @uploadingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploading your photo...'**
  String get uploadingPhoto;

  /// No description provided for @photoSelected.
  ///
  /// In en, this message translates to:
  /// **'Photo selected'**
  String get photoSelected;

  /// No description provided for @emailStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get emailStepTitle;

  /// No description provided for @emailStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google to verify your email address and receive important updates about your rides and earnings.'**
  String get emailStepDescription;

  /// No description provided for @emailVerifiedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Email Verified Successfully'**
  String get emailVerifiedSuccess;

  /// No description provided for @connectWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Google'**
  String get connectWithGoogle;

  /// No description provided for @emailStepOptional.
  ///
  /// In en, this message translates to:
  /// **'This step is optional. You can skip it and verify your email later.'**
  String get emailStepOptional;

  /// No description provided for @addressStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Address'**
  String get addressStepTitle;

  /// No description provided for @addressStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap the search icon to search for your address and tap on the map or drag the marker to select your precise location.'**
  String get addressStepDescription;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for Address'**
  String get searchAddress;

  /// No description provided for @gettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Getting your location...'**
  String get gettingLocation;

  /// No description provided for @addressNote.
  ///
  /// In en, this message translates to:
  /// **'Please enter your address as it appears on your electricity bill.'**
  String get addressNote;

  /// No description provided for @addressLine1.
  ///
  /// In en, this message translates to:
  /// **'Address Line 1'**
  String get addressLine1;

  /// No description provided for @addressLine1Hint.
  ///
  /// In en, this message translates to:
  /// **'House/Building, Street'**
  String get addressLine1Hint;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark (Optional)'**
  String get landmark;

  /// No description provided for @landmarkHint.
  ///
  /// In en, this message translates to:
  /// **'Near landmark or area'**
  String get landmarkHint;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @enterPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter pincode'**
  String get enterPincode;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityName.
  ///
  /// In en, this message translates to:
  /// **'City name'**
  String get cityName;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @districtName.
  ///
  /// In en, this message translates to:
  /// **'District name'**
  String get districtName;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @stateName.
  ///
  /// In en, this message translates to:
  /// **'State name'**
  String get stateName;

  /// No description provided for @vehicleStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleStepTitle;

  /// No description provided for @vehicleStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your vehicle information and owner details for registration.'**
  String get vehicleStepDescription;

  /// No description provided for @vehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get vehicleNumber;

  /// No description provided for @enterVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle number'**
  String get enterVehicleNumber;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @vehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Model'**
  String get vehicleModel;

  /// No description provided for @vehicleBodyLength.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Body Length (ft)'**
  String get vehicleBodyLength;

  /// No description provided for @enterBodyLength.
  ///
  /// In en, this message translates to:
  /// **'Enter body length'**
  String get enterBodyLength;

  /// No description provided for @vehicleImage.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Image'**
  String get vehicleImage;

  /// No description provided for @uploadVehicleImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload vehicle image'**
  String get uploadVehicleImage;

  /// No description provided for @vehicleBodyType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Body Type'**
  String get vehicleBodyType;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @vehicleOwnerDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Owner Details'**
  String get vehicleOwnerDetails;

  /// No description provided for @sameAsDriver.
  ///
  /// In en, this message translates to:
  /// **'Same as Driver'**
  String get sameAsDriver;

  /// No description provided for @sameAsDriverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle owner details are same as driver'**
  String get sameAsDriverSubtitle;

  /// No description provided for @ownerName.
  ///
  /// In en, this message translates to:
  /// **'Owner Name'**
  String get ownerName;

  /// No description provided for @enterOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner name'**
  String get enterOwnerName;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @enterContactNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter contact number'**
  String get enterContactNumber;

  /// No description provided for @ownerAadharCard.
  ///
  /// In en, this message translates to:
  /// **'Owner Aadhar Card'**
  String get ownerAadharCard;

  /// No description provided for @uploadOwnerAadhar.
  ///
  /// In en, this message translates to:
  /// **'Please upload owner Aadhar card'**
  String get uploadOwnerAadhar;

  /// No description provided for @noVehicleModels.
  ///
  /// In en, this message translates to:
  /// **'No vehicle models available'**
  String get noVehicleModels;

  /// No description provided for @documentsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get documentsStepTitle;

  /// No description provided for @documentsStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Please upload all required documents to complete your driver profile verification.'**
  String get documentsStepDescription;

  /// No description provided for @panNumber.
  ///
  /// In en, this message translates to:
  /// **'PAN Number'**
  String get panNumber;

  /// No description provided for @enterPanNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your PAN number'**
  String get enterPanNumber;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicense;

  /// No description provided for @uploadLicense.
  ///
  /// In en, this message translates to:
  /// **'Upload your valid driving license'**
  String get uploadLicense;

  /// No description provided for @rcBook.
  ///
  /// In en, this message translates to:
  /// **'RC Book'**
  String get rcBook;

  /// No description provided for @uploadRcBook.
  ///
  /// In en, this message translates to:
  /// **'Upload your vehicle registration certificate'**
  String get uploadRcBook;

  /// No description provided for @fcCertificate.
  ///
  /// In en, this message translates to:
  /// **'FC Certificate'**
  String get fcCertificate;

  /// No description provided for @uploadFc.
  ///
  /// In en, this message translates to:
  /// **'Upload your fitness certificate'**
  String get uploadFc;

  /// No description provided for @insuranceCertificate.
  ///
  /// In en, this message translates to:
  /// **'Insurance Certificate'**
  String get insuranceCertificate;

  /// No description provided for @uploadInsurance.
  ///
  /// In en, this message translates to:
  /// **'Please upload your insurance certificate'**
  String get uploadInsurance;

  /// No description provided for @aadharCard.
  ///
  /// In en, this message translates to:
  /// **'Aadhar Card'**
  String get aadharCard;

  /// No description provided for @uploadAadhar.
  ///
  /// In en, this message translates to:
  /// **'Please upload your Aadhar card'**
  String get uploadAadhar;

  /// No description provided for @electricityBill.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill'**
  String get electricityBill;

  /// No description provided for @uploadEbBill.
  ///
  /// In en, this message translates to:
  /// **'Upload your address proof (electricity bill)'**
  String get uploadEbBill;

  /// No description provided for @payoutDetails.
  ///
  /// In en, this message translates to:
  /// **'Payout Details'**
  String get payoutDetails;

  /// No description provided for @payoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to receive payouts. You can use a bank account or a UPI ID (VPA).'**
  String get payoutDescription;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get bankAccount;

  /// No description provided for @upiVpa.
  ///
  /// In en, this message translates to:
  /// **'UPI (VPA)'**
  String get upiVpa;

  /// No description provided for @accountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderName;

  /// No description provided for @enterAccountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Please enter account holder name'**
  String get enterAccountHolderName;

  /// No description provided for @accountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumber;

  /// No description provided for @enterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter account number'**
  String get enterAccountNumber;

  /// No description provided for @ifscCode.
  ///
  /// In en, this message translates to:
  /// **'IFSC Code'**
  String get ifscCode;

  /// No description provided for @upiId.
  ///
  /// In en, this message translates to:
  /// **'UPI ID (VPA)'**
  String get upiId;

  /// No description provided for @upiHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., username@okicici'**
  String get upiHint;

  /// No description provided for @bankDetailsNote.
  ///
  /// In en, this message translates to:
  /// **'Your bank details are used only to create a secure payout account. We do not store your complete bank information.'**
  String get bankDetailsNote;

  /// No description provided for @almostDone.
  ///
  /// In en, this message translates to:
  /// **'Almost done!'**
  String get almostDone;

  /// No description provided for @phoneStepDescription.
  ///
  /// In en, this message translates to:
  /// **'Add an alternate phone number for better communication with customers. This helps ensure smooth pickups and deliveries.'**
  String get phoneStepDescription;

  /// No description provided for @youAreAllSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get youAreAllSet;

  /// No description provided for @completeProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile to start accepting rides and earning money with Hello Truck.'**
  String get completeProfileDescription;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @reupload.
  ///
  /// In en, this message translates to:
  /// **'Re-upload'**
  String get reupload;

  /// No description provided for @titleAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get titleAddress;

  /// No description provided for @titleVehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get titleVehicle;

  /// No description provided for @titleDocuments.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get titleDocuments;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @failedToLoadAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to load address'**
  String get failedToLoadAddress;

  /// No description provided for @noAddressFound.
  ///
  /// In en, this message translates to:
  /// **'No address found'**
  String get noAddressFound;

  /// No description provided for @addressFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your address to continue'**
  String get addressFoundSubtitle;

  /// No description provided for @tapMapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap on map or drag marker to select location'**
  String get tapMapToSelect;

  /// No description provided for @fillAllRequired.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get fillAllRequired;

  /// No description provided for @addressUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get addressUpdatedSuccess;

  /// No description provided for @failedToSaveAddress.
  ///
  /// In en, this message translates to:
  /// **'Failed to save address: {error}'**
  String failedToSaveAddress(Object error);

  /// No description provided for @failedToLoadVehicle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load vehicle'**
  String get failedToLoadVehicle;

  /// No description provided for @noVehicleFound.
  ///
  /// In en, this message translates to:
  /// **'No vehicle found'**
  String get noVehicleFound;

  /// No description provided for @completeOnboardingToAddVehicle.
  ///
  /// In en, this message translates to:
  /// **'Complete your onboarding to add vehicle details'**
  String get completeOnboardingToAddVehicle;

  /// No description provided for @vehicleNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get vehicleNumberLabel;

  /// No description provided for @selfOwned.
  ///
  /// In en, this message translates to:
  /// **'Self Owned'**
  String get selfOwned;

  /// No description provided for @selfOwnedDescription.
  ///
  /// In en, this message translates to:
  /// **'You are the owner of this vehicle'**
  String get selfOwnedDescription;

  /// No description provided for @failedToLoadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load documents'**
  String get failedToLoadDocuments;

  /// No description provided for @noDocumentsFound.
  ///
  /// In en, this message translates to:
  /// **'No documents found'**
  String get noDocumentsFound;

  /// No description provided for @completeOnboardingToUploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Complete your onboarding to upload documents'**
  String get completeOnboardingToUploadDocuments;

  /// No description provided for @expiredOn.
  ///
  /// In en, this message translates to:
  /// **'Expired on {date}'**
  String expiredOn(Object date);

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until {date}'**
  String validUntil(Object date);

  /// No description provided for @reuploadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{title} re-uploaded successfully'**
  String reuploadedSuccess(Object title);

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Method'**
  String get selectPaymentMethod;

  /// No description provided for @searchForAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for Address'**
  String get searchForAddress;

  /// No description provided for @searchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search for location...'**
  String get searchLocationHint;

  /// No description provided for @startTypingToSearch.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search for locations'**
  String get startTypingToSearch;

  /// No description provided for @newRideRequest.
  ///
  /// In en, this message translates to:
  /// **'New Ride Request'**
  String get newRideRequest;

  /// No description provided for @bookingNumberPrefix.
  ///
  /// In en, this message translates to:
  /// **'Booking #'**
  String get bookingNumberPrefix;

  /// No description provided for @pickupPrefix.
  ///
  /// In en, this message translates to:
  /// **'Pickup: '**
  String get pickupPrefix;

  /// No description provided for @acceptRide.
  ///
  /// In en, this message translates to:
  /// **'Accept Ride'**
  String get acceptRide;

  /// No description provided for @paymentReceivedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment received successfully! 💰'**
  String get paymentReceivedSuccess;

  /// No description provided for @paymentSettledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment settled successfully! 💰'**
  String get paymentSettledSuccess;

  /// No description provided for @paymentSettlementTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Settlement'**
  String get paymentSettlementTitle;

  /// No description provided for @checkPaymentStatusTooltip.
  ///
  /// In en, this message translates to:
  /// **'Check Payment Status'**
  String get checkPaymentStatusTooltip;

  /// No description provided for @paymentPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Pending'**
  String get paymentPendingTitle;

  /// No description provided for @paymentPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Customer hasn\'t paid yet. Choose how to receive payment below.'**
  String get paymentPendingMessage;

  /// No description provided for @serviceCost.
  ///
  /// In en, this message translates to:
  /// **'Service Cost'**
  String get serviceCost;

  /// No description provided for @customerWalletUsed.
  ///
  /// In en, this message translates to:
  /// **'Customer Wallet Used'**
  String get customerWalletUsed;

  /// No description provided for @customerDebtRecovery.
  ///
  /// In en, this message translates to:
  /// **'Customer Debt Recovery'**
  String get customerDebtRecovery;

  /// No description provided for @platformFeePercentage.
  ///
  /// In en, this message translates to:
  /// **'Platform Fee ({percentage}%)'**
  String platformFeePercentage(String percentage);

  /// No description provided for @yourEarnings.
  ///
  /// In en, this message translates to:
  /// **'Your Earnings'**
  String get yourEarnings;

  /// No description provided for @walletCreditAmount.
  ///
  /// In en, this message translates to:
  /// **'Wallet Credit: +{amount}'**
  String walletCreditAmount(String amount);

  /// No description provided for @walletDebitAmount.
  ///
  /// In en, this message translates to:
  /// **'Wallet Debit: {amount}'**
  String walletDebitAmount(String amount);

  /// No description provided for @receivedCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Received Cash'**
  String get receivedCashTitle;

  /// No description provided for @receivedCashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I collected cash from customer'**
  String get receivedCashSubtitle;

  /// No description provided for @onlinePaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Pays via App'**
  String get onlinePaymentTitle;

  /// No description provided for @onlinePaymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask customer to pay via payment link in their app'**
  String get onlinePaymentSubtitle;

  /// No description provided for @importantInformation.
  ///
  /// In en, this message translates to:
  /// **'Important Information'**
  String get importantInformation;

  /// No description provided for @platformFeeDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Platform fee ({percentage}%) is calculated on the full service cost, not the cash collected.'**
  String platformFeeDisclaimer(String percentage);

  /// No description provided for @walletAdjustmentDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'If customer used wallet credit, you\'ll receive a wallet credit. If customer had debt, extra amount collected will be debited.'**
  String get walletAdjustmentDisclaimer;

  /// No description provided for @exactCashCollectionWarning.
  ///
  /// In en, this message translates to:
  /// **'Make sure you have collected the exact \"Cash to Collect\" amount shown above.'**
  String get exactCashCollectionWarning;

  /// No description provided for @confirmCashPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cash Payment'**
  String get confirmCashPaymentTitle;

  /// No description provided for @confirmCashPaymentMessage.
  ///
  /// In en, this message translates to:
  /// **'By confirming, you declare that you have received the full cash payment from the customer.'**
  String get confirmCashPaymentMessage;

  /// No description provided for @platformFeeDeductionMessage.
  ///
  /// In en, this message translates to:
  /// **'{amount} platform fee will be deducted from your wallet'**
  String platformFeeDeductionMessage(String amount);

  /// No description provided for @platformFeeDeductionSuffix.
  ///
  /// In en, this message translates to:
  /// **' platform fee will be deducted from your wallet'**
  String get platformFeeDeductionSuffix;

  /// No description provided for @reUploadTitle.
  ///
  /// In en, this message translates to:
  /// **'Re-upload {title}'**
  String reUploadTitle(String title);

  /// No description provided for @fileSizeLimit10MB.
  ///
  /// In en, this message translates to:
  /// **'File size must be less than 10MB'**
  String get fileSizeLimit10MB;

  /// No description provided for @fileSizeLimit5MB.
  ///
  /// In en, this message translates to:
  /// **'Image size must be less than 5MB'**
  String get fileSizeLimit5MB;

  /// No description provided for @documentSelected.
  ///
  /// In en, this message translates to:
  /// **'Document Selected'**
  String get documentSelected;

  /// No description provided for @tapToSelectDocument.
  ///
  /// In en, this message translates to:
  /// **'Tap to select document'**
  String get tapToSelectDocument;

  /// No description provided for @documentFormatHint.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG, PDF (Max 10MB)'**
  String get documentFormatHint;

  /// No description provided for @docVerificationInfo.
  ///
  /// In en, this message translates to:
  /// **'Document will be verified by admin. Expiry dates will be set during verification.'**
  String get docVerificationInfo;

  /// No description provided for @linkEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Link Email Address'**
  String get linkEmailAddress;

  /// No description provided for @emailAlreadyLinkedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your email is already linked with Google. You can re-link with a different Google account if needed.'**
  String get emailAlreadyLinkedMessage;

  /// No description provided for @linkEmailMessage.
  ///
  /// In en, this message translates to:
  /// **'Link your email with Google to receive important updates about your rides and earnings.'**
  String get linkEmailMessage;

  /// No description provided for @linking.
  ///
  /// In en, this message translates to:
  /// **'Linking...'**
  String get linking;

  /// No description provided for @failedToLinkEmail.
  ///
  /// In en, this message translates to:
  /// **'Failed to link email with Google: {error}'**
  String failedToLinkEmail(String error);

  /// No description provided for @fieldCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get fieldCannotBeEmpty;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String failedToSave(String error);

  /// No description provided for @editTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit {title}'**
  String editTitle(String title);

  /// No description provided for @enterFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your {field}'**
  String enterFieldHint(String field);

  /// No description provided for @updateProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Update Profile Picture'**
  String get updateProfilePicture;

  /// No description provided for @currentPicture.
  ///
  /// In en, this message translates to:
  /// **'Current Picture'**
  String get currentPicture;

  /// No description provided for @newPicture.
  ///
  /// In en, this message translates to:
  /// **'New Picture'**
  String get newPicture;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @uploadPicture.
  ///
  /// In en, this message translates to:
  /// **'Upload Picture'**
  String get uploadPicture;

  /// No description provided for @chooseDifferentImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Different Image'**
  String get chooseDifferentImage;

  /// No description provided for @firstNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'First name must be at least 3 characters long'**
  String get firstNameMinLength;

  /// No description provided for @enterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get enterValidPhone;

  /// No description provided for @enterAddressLine1.
  ///
  /// In en, this message translates to:
  /// **'Please enter address line 1'**
  String get enterAddressLine1;

  /// No description provided for @enterValidPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit pincode'**
  String get enterValidPincode;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get enterCity;

  /// No description provided for @enterDistrict.
  ///
  /// In en, this message translates to:
  /// **'Please enter district'**
  String get enterDistrict;

  /// No description provided for @enterState.
  ///
  /// In en, this message translates to:
  /// **'Please enter state'**
  String get enterState;

  /// No description provided for @enterVehicleBodyLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle body length'**
  String get enterVehicleBodyLength;

  /// No description provided for @vehicleBodyLengthGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Vehicle body length must be greater than 0'**
  String get vehicleBodyLengthGreaterThanZero;

  /// No description provided for @enterValidVehicleBodyLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid vehicle body length'**
  String get enterValidVehicleBodyLength;

  /// No description provided for @selectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle type'**
  String get selectVehicleType;

  /// No description provided for @selectVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle model'**
  String get selectVehicleModel;

  /// No description provided for @selectVehicleBodyType.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle body type'**
  String get selectVehicleBodyType;

  /// No description provided for @selectFuelType.
  ///
  /// In en, this message translates to:
  /// **'Please select fuel type'**
  String get selectFuelType;

  /// No description provided for @enterOwnerContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner contact number'**
  String get enterOwnerContact;

  /// No description provided for @enterValidOwnerContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit owner contact number'**
  String get enterValidOwnerContact;

  /// No description provided for @enterOwnerAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner address'**
  String get enterOwnerAddress;

  /// No description provided for @enterOwnerPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner pincode'**
  String get enterOwnerPincode;

  /// No description provided for @enterValidOwnerPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit owner pincode'**
  String get enterValidOwnerPincode;

  /// No description provided for @enterOwnerCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner city'**
  String get enterOwnerCity;

  /// No description provided for @enterOwnerDistrict.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner district'**
  String get enterOwnerDistrict;

  /// No description provided for @enterOwnerState.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner state'**
  String get enterOwnerState;

  /// No description provided for @enterValidPAN.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid PAN number'**
  String get enterValidPAN;

  /// No description provided for @uploadDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Please upload your driving license'**
  String get uploadDrivingLicense;

  /// No description provided for @uploadRCBook.
  ///
  /// In en, this message translates to:
  /// **'Please upload your RC book'**
  String get uploadRCBook;

  /// No description provided for @uploadFCCertificate.
  ///
  /// In en, this message translates to:
  /// **'Please upload your FC certificate'**
  String get uploadFCCertificate;

  /// No description provided for @uploadElectricityBill.
  ///
  /// In en, this message translates to:
  /// **'Please upload your electricity bill'**
  String get uploadElectricityBill;

  /// No description provided for @enterPAN.
  ///
  /// In en, this message translates to:
  /// **'Please enter your PAN number'**
  String get enterPAN;

  /// No description provided for @enterIFSCCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter IFSC code'**
  String get enterIFSCCode;

  /// No description provided for @enterValidIFSC.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid IFSC code'**
  String get enterValidIFSC;

  /// No description provided for @enterUPIID.
  ///
  /// In en, this message translates to:
  /// **'Please enter UPI ID (VPA)'**
  String get enterUPIID;

  /// No description provided for @enterValidUPI.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid UPI ID'**
  String get enterValidUPI;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @documentUploadedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully!'**
  String get documentUploadedSuccess;

  /// No description provided for @failedToPickDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick document: {error}'**
  String failedToPickDocument(String error);

  /// No description provided for @failedToUploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload document: {error}'**
  String failedToUploadDocument(String error);

  /// No description provided for @failedToPickImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload profile picture: {error}'**
  String failedToUploadImage(String error);

  /// No description provided for @documentsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Documents not found'**
  String get documentsNotFound;

  /// No description provided for @documentsNotUploadedYet.
  ///
  /// In en, this message translates to:
  /// **'The documents may not be uploaded yet.'**
  String get documentsNotUploadedYet;

  /// No description provided for @documentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Document not found'**
  String get documentNotFound;

  /// No description provided for @documentNotUploadedYet.
  ///
  /// In en, this message translates to:
  /// **'This document has not been uploaded yet.'**
  String get documentNotUploadedYet;

  /// No description provided for @loadingDocument.
  ///
  /// In en, this message translates to:
  /// **'Loading document...'**
  String get loadingDocument;

  /// No description provided for @failedToLoadDocument.
  ///
  /// In en, this message translates to:
  /// **'Failed to load document'**
  String get failedToLoadDocument;

  /// No description provided for @checkInternetAndRetry.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get checkInternetAndRetry;

  /// No description provided for @failedToLoadPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to load PDF: {description}'**
  String failedToLoadPdf(String description);

  /// No description provided for @loadingImage.
  ///
  /// In en, this message translates to:
  /// **'Loading image...'**
  String get loadingImage;

  /// No description provided for @documentLoadError.
  ///
  /// In en, this message translates to:
  /// **'The document could not be loaded. Please check your internet connection and try again.'**
  String get documentLoadError;

  /// No description provided for @checkingLocationPermissions.
  ///
  /// In en, this message translates to:
  /// **'Checking location permissions...'**
  String get checkingLocationPermissions;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Services Disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Permanently Denied'**
  String get locationPermissionDenied;

  /// No description provided for @locationAccessRequired.
  ///
  /// In en, this message translates to:
  /// **'Location Access Required'**
  String get locationAccessRequired;

  /// No description provided for @enableLocationServicesDesc.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services in your device settings to use this feature.'**
  String get enableLocationServicesDesc;

  /// No description provided for @needLocationAccessDesc.
  ///
  /// In en, this message translates to:
  /// **'We need location access to show your current position and help you select your address accurately.'**
  String get needLocationAccessDesc;

  /// No description provided for @locationDeniedForeverDesc.
  ///
  /// In en, this message translates to:
  /// **'Location permission has been permanently denied. Please enable it in app settings to continue.'**
  String get locationDeniedForeverDesc;

  /// No description provided for @locationRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'Location access is required for this feature to work properly.'**
  String get locationRequiredDesc;

  /// No description provided for @enableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Enable Location Services'**
  String get enableLocationServices;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @requestPermission.
  ///
  /// In en, this message translates to:
  /// **'Request Permission'**
  String get requestPermission;

  /// No description provided for @checkAgain.
  ///
  /// In en, this message translates to:
  /// **'Check Again'**
  String get checkAgain;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @callContact.
  ///
  /// In en, this message translates to:
  /// **'Call {name}'**
  String callContact(String name);

  /// No description provided for @couldNotMakeCall.
  ///
  /// In en, this message translates to:
  /// **'Could not make call'**
  String get couldNotMakeCall;

  /// No description provided for @markArrivalAtPickup.
  ///
  /// In en, this message translates to:
  /// **'Mark arrival at pickup location'**
  String get markArrivalAtPickup;

  /// No description provided for @verifyPickup.
  ///
  /// In en, this message translates to:
  /// **'Verify Pickup'**
  String get verifyPickup;

  /// No description provided for @enterCustomerOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter customer OTP'**
  String get enterCustomerOtp;

  /// No description provided for @markArrivalAtDrop.
  ///
  /// In en, this message translates to:
  /// **'Mark arrival at drop location'**
  String get markArrivalAtDrop;

  /// No description provided for @verifyDrop.
  ///
  /// In en, this message translates to:
  /// **'Verify Drop'**
  String get verifyDrop;

  /// No description provided for @rideComplete.
  ///
  /// In en, this message translates to:
  /// **'Ride Complete'**
  String get rideComplete;

  /// No description provided for @readyToFinish.
  ///
  /// In en, this message translates to:
  /// **'Ready to finish'**
  String get readyToFinish;

  /// No description provided for @followTheRoute.
  ///
  /// In en, this message translates to:
  /// **'Follow the route'**
  String get followTheRoute;

  /// No description provided for @markArrived.
  ///
  /// In en, this message translates to:
  /// **'Mark Arrived'**
  String get markArrived;

  /// No description provided for @markedAsArrivedAtPickup.
  ///
  /// In en, this message translates to:
  /// **'Marked as arrived at pickup'**
  String get markedAsArrivedAtPickup;

  /// No description provided for @pickupVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Pickup Verification'**
  String get pickupVerificationTitle;

  /// No description provided for @pickupVerified.
  ///
  /// In en, this message translates to:
  /// **'Pickup verified! 🎉'**
  String get pickupVerified;

  /// No description provided for @invalidOtpTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP. Please try again.'**
  String get invalidOtpTryAgain;

  /// No description provided for @markedAsArrivedAtDrop.
  ///
  /// In en, this message translates to:
  /// **'Marked as arrived at drop'**
  String get markedAsArrivedAtDrop;

  /// No description provided for @dropVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Drop Verification'**
  String get dropVerificationTitle;

  /// No description provided for @dropVerified.
  ///
  /// In en, this message translates to:
  /// **'Drop verified! 🎉'**
  String get dropVerified;

  /// No description provided for @rideCompleted.
  ///
  /// In en, this message translates to:
  /// **'Ride completed! 🎉'**
  String get rideCompleted;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @nowAvailableForRides.
  ///
  /// In en, this message translates to:
  /// **'You are now available for rides'**
  String get nowAvailableForRides;

  /// No description provided for @failedToMarkReady.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark driver as ready: {error}'**
  String failedToMarkReady(String error);

  /// No description provided for @failedToMarkPromptSeen.
  ///
  /// In en, this message translates to:
  /// **'Failed to mark prompt as seen: {error}'**
  String failedToMarkPromptSeen(String error);

  /// No description provided for @readyToTakeRides.
  ///
  /// In en, this message translates to:
  /// **'Ready to take rides today?'**
  String get readyToTakeRides;

  /// No description provided for @startEarningDesc.
  ///
  /// In en, this message translates to:
  /// **'Start earning by accepting ride requests from customers near you'**
  String get startEarningDesc;

  /// No description provided for @getInstantNotifications.
  ///
  /// In en, this message translates to:
  /// **'Get instant notifications'**
  String get getInstantNotifications;

  /// No description provided for @receiveRideRequestsImmediately.
  ///
  /// In en, this message translates to:
  /// **'Receive ride requests immediately'**
  String get receiveRideRequestsImmediately;

  /// No description provided for @findNearbyRides.
  ///
  /// In en, this message translates to:
  /// **'Find nearby rides'**
  String get findNearbyRides;

  /// No description provided for @connectWithCustomers.
  ///
  /// In en, this message translates to:
  /// **'Connect with customers in your area'**
  String get connectWithCustomers;

  /// No description provided for @startEarningToday.
  ///
  /// In en, this message translates to:
  /// **'Start earning today'**
  String get startEarningToday;

  /// No description provided for @maximizeDailyIncome.
  ///
  /// In en, this message translates to:
  /// **'Maximize your daily income potential'**
  String get maximizeDailyIncome;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe later'**
  String get maybeLater;

  /// No description provided for @imReady.
  ///
  /// In en, this message translates to:
  /// **'I\'m ready!'**
  String get imReady;

  /// No description provided for @changeFromRidesTab.
  ///
  /// In en, this message translates to:
  /// **'You can change this anytime from the Rides tab'**
  String get changeFromRidesTab;

  /// No description provided for @pleaseEnterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterFirstName;

  /// No description provided for @pleaseEnterValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get pleaseEnterValidPhone;

  /// No description provided for @pleaseEnterAddressLine1.
  ///
  /// In en, this message translates to:
  /// **'Please enter address line 1'**
  String get pleaseEnterAddressLine1;

  /// No description provided for @pleaseEnterPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter pincode'**
  String get pleaseEnterPincode;

  /// No description provided for @pleaseEnterValidPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit pincode'**
  String get pleaseEnterValidPincode;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get pleaseEnterCity;

  /// No description provided for @pleaseEnterDistrict.
  ///
  /// In en, this message translates to:
  /// **'Please enter district'**
  String get pleaseEnterDistrict;

  /// No description provided for @pleaseEnterState.
  ///
  /// In en, this message translates to:
  /// **'Please enter state'**
  String get pleaseEnterState;

  /// No description provided for @pleaseEnterVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle number'**
  String get pleaseEnterVehicleNumber;

  /// No description provided for @pleaseEnterVehicleBodyLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter vehicle body length'**
  String get pleaseEnterVehicleBodyLength;

  /// No description provided for @vehicleBodyLengthMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Vehicle body length must be greater than 0'**
  String get vehicleBodyLengthMustBePositive;

  /// No description provided for @pleaseEnterValidBodyLength.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid vehicle body length'**
  String get pleaseEnterValidBodyLength;

  /// No description provided for @pleaseSelectVehicleType.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle type'**
  String get pleaseSelectVehicleType;

  /// No description provided for @pleaseSelectVehicleModel.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle model'**
  String get pleaseSelectVehicleModel;

  /// No description provided for @pleaseSelectVehicleBodyType.
  ///
  /// In en, this message translates to:
  /// **'Please select vehicle body type'**
  String get pleaseSelectVehicleBodyType;

  /// No description provided for @pleaseSelectFuelType.
  ///
  /// In en, this message translates to:
  /// **'Please select fuel type'**
  String get pleaseSelectFuelType;

  /// No description provided for @pleaseUploadVehicleImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload vehicle image'**
  String get pleaseUploadVehicleImage;

  /// No description provided for @pleaseEnterOwnerName.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner name'**
  String get pleaseEnterOwnerName;

  /// No description provided for @pleaseEnterOwnerContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner contact number'**
  String get pleaseEnterOwnerContact;

  /// No description provided for @pleaseEnterValidOwnerContact.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit owner contact number'**
  String get pleaseEnterValidOwnerContact;

  /// No description provided for @pleaseEnterOwnerAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner address'**
  String get pleaseEnterOwnerAddress;

  /// No description provided for @pleaseEnterOwnerPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner pincode'**
  String get pleaseEnterOwnerPincode;

  /// No description provided for @pleaseEnterValidOwnerPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit owner pincode'**
  String get pleaseEnterValidOwnerPincode;

  /// No description provided for @pleaseEnterOwnerCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner city'**
  String get pleaseEnterOwnerCity;

  /// No description provided for @pleaseEnterOwnerDistrict.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner district'**
  String get pleaseEnterOwnerDistrict;

  /// No description provided for @pleaseEnterOwnerState.
  ///
  /// In en, this message translates to:
  /// **'Please enter owner state'**
  String get pleaseEnterOwnerState;

  /// No description provided for @pleaseUploadOwnerAadhar.
  ///
  /// In en, this message translates to:
  /// **'Please upload owner Aadhar card'**
  String get pleaseUploadOwnerAadhar;

  /// No description provided for @pleaseEnterValidPan.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid PAN number'**
  String get pleaseEnterValidPan;

  /// No description provided for @pleaseUploadDrivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Please upload your driving license'**
  String get pleaseUploadDrivingLicense;

  /// No description provided for @pleaseUploadRcBook.
  ///
  /// In en, this message translates to:
  /// **'Please upload your RC book'**
  String get pleaseUploadRcBook;

  /// No description provided for @pleaseUploadFc.
  ///
  /// In en, this message translates to:
  /// **'Please upload your FC certificate'**
  String get pleaseUploadFc;

  /// No description provided for @pleaseUploadInsurance.
  ///
  /// In en, this message translates to:
  /// **'Please upload your insurance certificate'**
  String get pleaseUploadInsurance;

  /// No description provided for @pleaseUploadAadhar.
  ///
  /// In en, this message translates to:
  /// **'Please upload your Aadhar card'**
  String get pleaseUploadAadhar;

  /// No description provided for @pleaseUploadEbBill.
  ///
  /// In en, this message translates to:
  /// **'Please upload your electricity bill'**
  String get pleaseUploadEbBill;

  /// No description provided for @pleaseEnterPanNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your PAN number'**
  String get pleaseEnterPanNumber;

  /// No description provided for @pleaseEnterAccountHolderName.
  ///
  /// In en, this message translates to:
  /// **'Please enter account holder name'**
  String get pleaseEnterAccountHolderName;

  /// No description provided for @pleaseEnterAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter account number'**
  String get pleaseEnterAccountNumber;

  /// No description provided for @pleaseEnterIfscCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter IFSC code'**
  String get pleaseEnterIfscCode;

  /// No description provided for @pleaseEnterValidIfsc.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid IFSC code'**
  String get pleaseEnterValidIfsc;

  /// No description provided for @pleaseEnterUpiId.
  ///
  /// In en, this message translates to:
  /// **'Please enter UPI ID (VPA)'**
  String get pleaseEnterUpiId;

  /// No description provided for @pleaseEnterValidUpiId.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid UPI ID'**
  String get pleaseEnterValidUpiId;

  /// No description provided for @fileSizeMustBeLessThan10Mb.
  ///
  /// In en, this message translates to:
  /// **'File size must be less than 10MB'**
  String get fileSizeMustBeLessThan10Mb;

  /// No description provided for @documentUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully!'**
  String get documentUploadedSuccessfully;

  /// No description provided for @licenseExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Your driving license expires in {days} days. Please renew it soon.'**
  String licenseExpiresInDays(int days);

  /// No description provided for @licenseExpiresIn30Days.
  ///
  /// In en, this message translates to:
  /// **'Your driving license expires in 30 days. Please renew it.'**
  String get licenseExpiresIn30Days;

  /// No description provided for @licenseExpiresIn45Days.
  ///
  /// In en, this message translates to:
  /// **'Your driving license expires in 45 days. Please renew it.'**
  String get licenseExpiresIn45Days;

  /// No description provided for @licenseExpired.
  ///
  /// In en, this message translates to:
  /// **'Your driving license has expired. Please renew it immediately.'**
  String get licenseExpired;

  /// No description provided for @fcExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Your fitness certificate expires in {days} days. Please renew it soon.'**
  String fcExpiresInDays(int days);

  /// No description provided for @fcExpiresIn30Days.
  ///
  /// In en, this message translates to:
  /// **'Your fitness certificate expires in 30 days. Please renew it.'**
  String get fcExpiresIn30Days;

  /// No description provided for @fcExpiresIn45Days.
  ///
  /// In en, this message translates to:
  /// **'Your fitness certificate expires in 45 days. Please renew it.'**
  String get fcExpiresIn45Days;

  /// No description provided for @fcExpired.
  ///
  /// In en, this message translates to:
  /// **'Your fitness certificate has expired. Please renew it immediately.'**
  String get fcExpired;

  /// No description provided for @insuranceExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'Your insurance expires in {days} days. Please renew it soon.'**
  String insuranceExpiresInDays(int days);

  /// No description provided for @insuranceExpiresIn30Days.
  ///
  /// In en, this message translates to:
  /// **'Your insurance expires in 30 days. Please renew it.'**
  String get insuranceExpiresIn30Days;

  /// No description provided for @insuranceExpiresIn45Days.
  ///
  /// In en, this message translates to:
  /// **'Your insurance expires in 45 days. Please renew it.'**
  String get insuranceExpiresIn45Days;

  /// No description provided for @insuranceExpired.
  ///
  /// In en, this message translates to:
  /// **'Your insurance has expired. Please renew it immediately.'**
  String get insuranceExpired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
