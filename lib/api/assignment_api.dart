import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';

import '../utils/logger.dart';

/// Get current pending assignment for the driver
Future<BookingAssignment?> getCurrentAssignment(API api) async {
  try {
    final response = await api.get(
      '/bookings/driver/current-assignment',
      policy: CachePolicy.noCache,
    );
    AppLogger.log("getCurrentAssignment: ${response.data}");
    return BookingAssignment.fromJson(response.data);
  } catch (e) {
    AppLogger.log("error: $e");
    // Return null if no assignment found (404)
    return null;
  }
}

/// Get assignment history for the driver
Future<List<BookingAssignment>> getAssignmentHistory(API api) async {
  final response = await api.get('/bookings/driver/history');
  return (response.data as List)
      .map((json) => BookingAssignment.fromJson(json))
      .toList();
}

/// Accept a booking assignment
Future<void> acceptAssignment(API api, String assignmentId) async {
  await api.post('/bookings/driver/accept/$assignmentId');
}

/// Reject a booking assignment
Future<void> rejectAssignment(API api, String assignmentId) async {
  await api.post('/bookings/driver/reject/$assignmentId');
}

/// Mark Pickup as arrived
Future<void> pickupArrived(API api) async {
  final response = await api.post('/bookings/driver/pickup/arrived');
  AppLogger.log("pickupArrived: ${response.data}");
}

/// Mark Drop as arrived
Future<void> dropArrived(API api) async {
  await api.post('/bookings/driver/drop/arrived');
}

/// Verify pickup OTP (transitions booking to PICKUP_VERIFIED)
Future<void> verifyPickupOtp(API api, String otp) async {
  await api.post('/bookings/driver/pickup/verify', data: { 'otp': otp });
}

/// Verify drop OTP (transitions booking to DROP_VERIFIED)
Future<void> verifyDropOtp(API api, String otp) async {
  await api.post('/bookings/driver/drop/verify', data: { 'otp': otp });
}

/// Start ride (PICKUP_VERIFIED -> IN_TRANSIT)
Future<void> startRide(API api) async {
  await api.post('/bookings/driver/start');
}

/// Finish ride (DROP_VERIFIED -> COMPLETED)
Future<void> finishRide(API api) async {
  await api.post('/bookings/driver/finish');
}
