enum FcmEventType {
  driverAssignmentOffered('DRIVER_ASSIGNMENT_OFFERED'),
  driverAssignmentTimeout('DRIVER_ASSIGNMENT_TIMEOUT'),
  assignmentEscalated('ASSIGNMENT_ESCALATED'),
  noDriverAvailable('NO_DRIVER_AVAILABLE'),
  bookingStatusChange('BOOKING_STATUS_CHANGE'),
  paymentSuccess('PAYMENT_SUCCESS'),
  paymentFailed('PAYMENT_FAILED'),
  rideCancelled('RIDE_CANCELLED'),
  walletCredit('WALLET_CREDIT'),
  walletDebit('WALLET_DEBIT'),
  payoutProcessed('PAYOUT_PROCESSED'),
  driverVerificationUpdated('DRIVER_VERIFICATION_UPDATED');

  const FcmEventType(this.value);
  final String value;

  static FcmEventType fromString(String value) {
    return FcmEventType.values.firstWhere(
      (type) => type.value == value,
    );
  }

  static const localNotificationEnabledEvents = [
    walletCredit,
    walletDebit,
    payoutProcessed,
  ];

  static bool isLocalNotificationEnabled(FcmEventType eventType) {
    return localNotificationEnabledEvents.contains(eventType);
  }
}

