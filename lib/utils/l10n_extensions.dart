import 'package:flutter/material.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/models/enums/transaction_enums.dart';
import 'package:hello_truck_driver/models/enums/package_enums.dart';
import 'package:hello_truck_driver/models/enums/vehicle_enums.dart';
import 'package:hello_truck_driver/models/enums/payout_enums.dart';

/// Extension for DriverStatus to get localized display name
extension DriverStatusL10n on DriverStatus {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case DriverStatus.available:
        return l10n.driverStatusAvailable;
      case DriverStatus.unavailable:
        return l10n.driverStatusUnavailable;
      case DriverStatus.onRide:
        return l10n.driverStatusOnRide;
      case DriverStatus.rideOffered:
        return l10n.driverStatusRideOffered;
    }
  }
}

/// Extension for VerificationStatus to get localized display name
extension VerificationStatusL10n on VerificationStatus {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case VerificationStatus.pending:
        return l10n.pendingVerification;
      case VerificationStatus.verified:
        return l10n.verified;
      case VerificationStatus.rejected:
        return l10n.verificationRejected;
    }
  }
}

/// Extension for BookingStatus to get localized display name
extension BookingStatusL10n on BookingStatus {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case BookingStatus.pending:
        return l10n.bookingStatusPending;
      case BookingStatus.driverAssigned:
        return l10n.bookingStatusDriverAssigned;
      case BookingStatus.confirmed:
        return l10n.bookingStatusConfirmed;
      case BookingStatus.pickupArrived:
        return l10n.bookingStatusPickupArrived;
      case BookingStatus.pickupVerified:
        return l10n.bookingStatusPickupVerified;
      case BookingStatus.inTransit:
        return l10n.bookingStatusInTransit;
      case BookingStatus.dropArrived:
        return l10n.bookingStatusDropArrived;
      case BookingStatus.dropVerified:
        return l10n.bookingStatusDropVerified;
      case BookingStatus.completed:
        return l10n.bookingStatusCompleted;
      case BookingStatus.cancelled:
        return l10n.bookingStatusCancelled;
      case BookingStatus.expired:
        return l10n.bookingStatusExpired;
    }
  }
}

/// Extension for AssignmentStatus to get localized display name
extension AssignmentStatusL10n on AssignmentStatus {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case AssignmentStatus.offered:
        return l10n.assignmentStatusOffered;
      case AssignmentStatus.accepted:
        return l10n.assignmentStatusAccepted;
      case AssignmentStatus.rejected:
        return l10n.assignmentStatusRejected;
      case AssignmentStatus.autoRejected:
        return l10n.assignmentStatusAutoRejected;
    }
  }
}

/// Extension for TransactionType to get localized display name
extension TransactionTypeL10n on TransactionType {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case TransactionType.credit:
        return l10n.transactionTypeCredit;
      case TransactionType.debit:
        return l10n.transactionTypeDebit;
    }
  }
}

/// Extension for TransactionCategory to get localized display name
extension TransactionCategoryL10n on TransactionCategory {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case TransactionCategory.bookingPayment:
        return l10n.transactionCategoryBookingPayment;
      case TransactionCategory.bookingRefund:
        return l10n.transactionCategoryBookingRefund;
      case TransactionCategory.driverPayout:
        return l10n.transactionCategoryDriverPayout;
      case TransactionCategory.walletCredit:
        return l10n.transactionCategoryWalletCredit;
      case TransactionCategory.other:
        return l10n.transactionCategoryOther;
    }
  }
}

/// Extension for PaymentMethod to get localized display name
extension PaymentMethodL10n on PaymentMethod {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PaymentMethod.cash:
        return l10n.paymentMethodCash;
      case PaymentMethod.online:
        return l10n.paymentMethodOnline;
      case PaymentMethod.wallet:
        return l10n.paymentMethodWallet;
    }
  }
}

/// Extension for PayoutStatus to get localized display name
extension PayoutStatusL10n on PayoutStatus {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PayoutStatus.pending:
        return l10n.payoutStatusPending;
      case PayoutStatus.processing:
        return l10n.payoutStatusProcessing;
      case PayoutStatus.completed:
        return l10n.payoutStatusCompleted;
      case PayoutStatus.failed:
        return l10n.payoutStatusFailed;
      case PayoutStatus.cancelled:
        return l10n.payoutStatusCancelled;
    }
  }
}

/// Extension for ProductType to get localized display name
extension ProductTypeL10n on ProductType {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ProductType.personal:
        return l10n.productTypePersonal;
      case ProductType.agricultural:
        return l10n.productTypeAgricultural;
      case ProductType.nonAgricultural:
        return l10n.productTypeNonAgricultural;
    }
  }
}

/// Extension for WeightUnit to get localized display name
extension WeightUnitL10n on WeightUnit {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case WeightUnit.kg:
        return l10n.weightUnitKg;
      case WeightUnit.quintal:
        return l10n.weightUnitQuintal;
    }
  }
}

/// Extension for VehicleType to get localized display name
extension VehicleTypeL10n on VehicleType {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case VehicleType.threeWheeler:
        return l10n.vehicleTypeThreeWheeler;
      case VehicleType.fourWheeler:
        return l10n.vehicleTypeFourWheeler;
    }
  }
}

/// Extension for VehicleBodyType to get localized display name
extension VehicleBodyTypeL10n on VehicleBodyType {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case VehicleBodyType.open:
        return l10n.vehicleBodyTypeOpen;
      case VehicleBodyType.closed:
        return l10n.vehicleBodyTypeClosed;
    }
  }
}

/// Extension for FuelType to get localized display name
extension FuelTypeL10n on FuelType {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case FuelType.diesel:
        return l10n.fuelTypeDiesel;
      case FuelType.petrol:
        return l10n.fuelTypePetrol;
      case FuelType.ev:
        return l10n.fuelTypeEv;
      case FuelType.cng:
        return l10n.fuelTypeCng;
    }
  }
}

/// Extension for PayoutMethod to get localized display name
extension PayoutMethodL10n on PayoutMethod {
  String toLocalizedString(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PayoutMethod.bankAccount:
        return l10n.payoutMethodBankAccount;
      case PayoutMethod.vpa:
        return l10n.payoutMethodVpa;
    }
  }
}
