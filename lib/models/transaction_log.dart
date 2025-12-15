import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/enums/transaction_enums.dart';

/// Payout details
class Payout {
  final String id;
  final String driverId;
  final double amount;
  final String? razorpayPayoutId;
  final PayoutStatus status;
  final String? failureReason;
  final int retryCount;
  final DateTime createdAt;
  final DateTime? processedAt;

  const Payout({
    required this.id,
    required this.driverId,
    required this.amount,
    this.razorpayPayoutId,
    required this.status,
    this.failureReason,
    required this.retryCount,
    required this.createdAt,
    this.processedAt,
  });

  factory Payout.fromJson(Map<String, dynamic> json) {
    return Payout(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      razorpayPayoutId: json['razorpayPayoutId'],
      status: PayoutStatus.fromString(json['status'] ?? 'PENDING'),
      failureReason: json['failureReason'],
      retryCount: json['retryCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
    );
  }
}

/// Driver transaction log entry
class TransactionLog {
  final String id;
  final String? customerId;
  final String? driverId;
  final double amount;
  final TransactionType type;
  final TransactionCategory category;
  final String description;
  final String? bookingId;
  final Booking? booking;
  final String? payoutId;
  final Payout? payout;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;

  const TransactionLog({
    required this.id,
    this.customerId,
    this.driverId,
    required this.amount,
    required this.type,
    required this.category,
    required this.description,
    this.bookingId,
    this.booking,
    this.payoutId,
    this.payout,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory TransactionLog.fromJson(Map<String, dynamic> json) {
    return TransactionLog(
      id: json['id'] ?? '',
      customerId: json['customerId'],
      driverId: json['driverId'],
      amount: (json['amount'] ?? 0).toDouble(),
      type: TransactionType.fromString(json['type'] ?? 'DEBIT'),
      category: TransactionCategory.fromString(json['category'] ?? 'OTHER'),
      description: json['description'] ?? '',
      bookingId: json['bookingId'],
      booking: json['booking'] != null ? Booking.fromJson(json['booking']) : null,
      payoutId: json['payoutId'],
      payout: json['payout'] != null ? Payout.fromJson(json['payout']) : null,
      paymentMethod: PaymentMethod.fromString(json['paymentMethod'] ?? 'CASH'),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Returns true if this is a credit transaction
  bool get isCredit => type == TransactionType.credit;
}
