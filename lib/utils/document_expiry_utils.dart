import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

/// Calculate expiry alerts from driver documents
ExpiryAlerts calculateExpiryAlerts(DriverDocuments documents, AppLocalizations l10n) {
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
      licenseAlert = l10n.licenseExpiresInDays(daysUntilLicenseExpiry);
    } else if (daysUntilLicenseExpiry == 30) {
      licenseAlert = l10n.licenseExpiresIn30Days;
    } else if (daysUntilLicenseExpiry == 45) {
      licenseAlert = l10n.licenseExpiresIn45Days;
    } else if (daysUntilLicenseExpiry <= 0) {
      licenseAlert = l10n.licenseExpired;
      isLicenseExpired = true;
    }
  }

  // Check FC expiry (only if expiry date is set)
  if (documents.fcExpiry != null) {
    final daysUntilFcExpiry = documents.fcExpiry!.difference(now).inDays;

    if (daysUntilFcExpiry <= 15 && daysUntilFcExpiry > 0) {
      fcAlert = l10n.fcExpiresInDays(daysUntilFcExpiry);
    } else if (daysUntilFcExpiry == 30) {
      fcAlert = l10n.fcExpiresIn30Days;
    } else if (daysUntilFcExpiry == 45) {
      fcAlert = l10n.fcExpiresIn45Days;
    } else if (daysUntilFcExpiry <= 0) {
      fcAlert = l10n.fcExpired;
      isFcExpired = true;
    }
  }

  // Check insurance expiry (only if expiry date is set)
  if (documents.insuranceExpiry != null) {
    final daysUntilInsuranceExpiry = documents.insuranceExpiry!.difference(now).inDays;

    if (daysUntilInsuranceExpiry <= 15 && daysUntilInsuranceExpiry > 0) {
      insuranceAlert = l10n.insuranceExpiresInDays(daysUntilInsuranceExpiry);
    } else if (daysUntilInsuranceExpiry == 30) {
      insuranceAlert = l10n.insuranceExpiresIn30Days;
    } else if (daysUntilInsuranceExpiry == 45) {
      insuranceAlert = l10n.insuranceExpiresIn45Days;
    } else if (daysUntilInsuranceExpiry <= 0) {
      insuranceAlert = l10n.insuranceExpired;
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
