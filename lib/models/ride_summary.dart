import 'package:hello_truck_driver/models/booking_assignment.dart';

/// Driver's daily ride summary
class RideSummary {
  final int totalRides;
  final double netEarnings; // Driver's net earnings after commission deduction
  final double commissionRate; // Platform commission rate (e.g., 0.07 = 7%)
  final String date; // YYYY-MM-DD format
  final List<BookingAssignment> assignments; // Completed assignments with bookings for the day

  const RideSummary({
    required this.totalRides,
    required this.netEarnings,
    required this.commissionRate,
    required this.date,
    required this.assignments,
  });

  factory RideSummary.fromJson(Map<String, dynamic> json) {
    return RideSummary(
      totalRides: json['totalRides'] ?? 0,
      netEarnings: (json['netEarnings'] ?? 0).toDouble(),
      commissionRate: (json['commissionRate'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      assignments: (json['assignments'] as List<dynamic>?)
          ?.map((e) => BookingAssignment.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  /// Returns true if there are any rides
  bool get hasRides => totalRides > 0;

  /// Calculate total gross earnings (before commission)
  double get grossEarnings => netEarnings / (1 - commissionRate);

  /// Calculate total commission amount
  double get totalCommission => grossEarnings - netEarnings;
}
