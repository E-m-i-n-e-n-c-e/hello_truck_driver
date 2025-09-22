import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';

/// Get current pending assignment for the driver
Future<BookingAssignment?> getDriverAssignment(API api) async {
  try {
    final response = await api.get('/bookings/driver/assignment');
    return BookingAssignment.fromJson(response.data);
  } catch (e) {
    // Return null if no assignment found (404)
    return null;
  }
}

/// Get current active assignment for the driver
Future<BookingAssignment?> getActiveAssignment(API api) async {
  try {
    final response = await api.get('/bookings/driver/active-assignment');
    return BookingAssignment.fromJson(response.data);
  } catch (e) {
    // Return null if no active assignment found (404)
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
