import 'package:hello_truck_driver/models/documents.dart';

/// Calculate expiry alerts from driver documents
ExpiryAlerts calculateExpiryAlerts(DriverDocuments documents) {
  final now = DateTime.now();

  String? licenseAlert;
  String? fcAlert;
  String? insuranceAlert;
  bool isLicenseExpired = false;
  bool isFcExpired = false;
  bool isInsuranceExpired = false;

  // Check license expiry (only if expiry date is set)
  if (documents.licenseExpiry != null) {
    final daysUntilLicenseExpiry = documents.licenseExpiry!.difference(now).inDays;

    if (daysUntilLicenseExpiry <= 15 && daysUntilLicenseExpiry > 0) {
      licenseAlert = 'Your driving license expires in $daysUntilLicenseExpiry days. Please renew it soon.';
    } else if (daysUntilLicenseExpiry == 30) {
      licenseAlert = 'Your driving license expires in 30 days. Please renew it.';
    } else if (daysUntilLicenseExpiry == 45) {
      licenseAlert = 'Your driving license expires in 45 days. Please renew it.';
    } else if (daysUntilLicenseExpiry <= 0) {
      licenseAlert = 'Your driving license has expired. Please renew it immediately.';
      isLicenseExpired = true;
    }
  }

  // Check FC expiry (only if expiry date is set)
  if (documents.fcExpiry != null) {
    final daysUntilFcExpiry = documents.fcExpiry!.difference(now).inDays;

    if (daysUntilFcExpiry <= 15 && daysUntilFcExpiry > 0) {
      fcAlert = 'Your fitness certificate expires in $daysUntilFcExpiry days. Please renew it soon.';
    } else if (daysUntilFcExpiry == 30) {
      fcAlert = 'Your fitness certificate expires in 30 days. Please renew it.';
    } else if (daysUntilFcExpiry == 45) {
      fcAlert = 'Your fitness certificate expires in 45 days. Please renew it.';
    } else if (daysUntilFcExpiry <= 0) {
      fcAlert = 'Your fitness certificate has expired. Please renew it immediately.';
      isFcExpired = true;
    }
  }

  // Check insurance expiry (only if expiry date is set)
  if (documents.insuranceExpiry != null) {
    final daysUntilInsuranceExpiry = documents.insuranceExpiry!.difference(now).inDays;

    if (daysUntilInsuranceExpiry <= 15 && daysUntilInsuranceExpiry > 0) {
      insuranceAlert = 'Your insurance expires in $daysUntilInsuranceExpiry days. Please renew it soon.';
    } else if (daysUntilInsuranceExpiry == 30) {
      insuranceAlert = 'Your insurance expires in 30 days. Please renew it.';
    } else if (daysUntilInsuranceExpiry == 45) {
      insuranceAlert = 'Your insurance expires in 45 days. Please renew it.';
    } else if (daysUntilInsuranceExpiry <= 0) {
      insuranceAlert = 'Your insurance has expired. Please renew it immediately.';
      isInsuranceExpired = true;
    }
  }

  return ExpiryAlerts(
    licenseAlert: licenseAlert,
    fcAlert: fcAlert,
    insuranceAlert: insuranceAlert,
    isLicenseExpired: isLicenseExpired,
    isFcExpired: isFcExpired,
    isInsuranceExpired: isInsuranceExpired,
    licenseExpiry: documents.licenseExpiry,
    fcExpiry: documents.fcExpiry,
    insuranceExpiry: documents.insuranceExpiry,
  );
}
