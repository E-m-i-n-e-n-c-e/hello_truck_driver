import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';

import '../utils/logger.dart';

/// Get current pending assignment for the driver
Future<BookingAssignment?> getCurrentAssignment(API api) async {
  try {
    final response = await api.get('/bookings/driver/current-assignment');
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
