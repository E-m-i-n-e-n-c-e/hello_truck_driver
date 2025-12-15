/// Driver wallet transaction log
class WalletLog {
  final String id;
  final double beforeBalance;
  final double afterBalance;
  final double amount;
  final String reason;
  final String? bookingId;
  final DateTime createdAt;

  const WalletLog({
    required this.id,
    required this.beforeBalance,
    required this.afterBalance,
    required this.amount,
    required this.reason,
    this.bookingId,
    required this.createdAt,
  });

  factory WalletLog.fromJson(Map<String, dynamic> json) {
    return WalletLog(
      id: json['id'] ?? '',
      beforeBalance: (json['beforeBalance'] ?? 0).toDouble(),
      afterBalance: (json['afterBalance'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      reason: json['reason'] ?? '',
      bookingId: json['bookingId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Returns true if this is a credit (positive amount)
  bool get isCredit => amount > 0;

  /// Returns the absolute amount value
  double get absoluteAmount => amount.abs();
}
