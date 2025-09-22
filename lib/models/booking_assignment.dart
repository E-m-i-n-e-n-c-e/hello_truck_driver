import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';

class BookingAssignment {
  final String id;
  final String driverId;
  final String bookingId;
  final AssignmentStatus status;
  final DateTime offeredAt;
  final DateTime? respondedAt;
  final Booking booking;

  BookingAssignment({
    required this.id,
    required this.driverId,
    required this.bookingId,
    required this.status,
    required this.offeredAt,
    this.respondedAt,
    required this.booking,
  });

  factory BookingAssignment.fromJson(Map<String, dynamic> json) {
    return BookingAssignment(
      id: json['id'],
      driverId: json['driverId'],
      bookingId: json['bookingId'],
      status: AssignmentStatus.fromString(json['status']),
      offeredAt: DateTime.parse(json['offeredAt']),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'])
          : null,
      booking: Booking.fromJson(json['booking']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driverId': driverId,
      'bookingId': bookingId,
      'status': status.value,
      'offeredAt': offeredAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
      'booking': booking.toJson(),
    };
  }
}
