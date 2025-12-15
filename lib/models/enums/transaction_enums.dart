/// Transaction type enum
enum TransactionType {
  credit('CREDIT'),
  debit('DEBIT');

  final String value;
  const TransactionType(this.value);

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionType.debit,
    );
  }
}

/// Transaction category enum
enum TransactionCategory {
  bookingPayment('BOOKING_PAYMENT'),
  bookingRefund('BOOKING_REFUND'),
  driverPayout('DRIVER_PAYOUT'),
  walletCredit('WALLET_CREDIT'),
  other('OTHER');

  final String value;
  const TransactionCategory(this.value);

  static TransactionCategory fromString(String value) {
    return TransactionCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionCategory.other,
    );
  }

  String get displayName {
    switch (this) {
      case TransactionCategory.bookingPayment:
        return 'Booking Payment';
      case TransactionCategory.bookingRefund:
        return 'Booking Refund';
      case TransactionCategory.driverPayout:
        return 'Payout';
      case TransactionCategory.walletCredit:
        return 'Wallet Credit';
      case TransactionCategory.other:
        return 'Other';
    }
  }
}

/// Payment method enum
enum PaymentMethod {
  cash('CASH'),
  online('ONLINE'),
  wallet('WALLET');

  final String value;
  const PaymentMethod(this.value);

  static PaymentMethod fromString(String value) {
    return PaymentMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PaymentMethod.cash,
    );
  }
}

/// Payout status enum
enum PayoutStatus {
  pending('PENDING'),
  processing('PROCESSING'),
  completed('COMPLETED'),
  failed('FAILED'),
  cancelled('CANCELLED');

  final String value;
  const PayoutStatus(this.value);

  static PayoutStatus fromString(String value) {
    return PayoutStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PayoutStatus.pending,
    );
  }
}