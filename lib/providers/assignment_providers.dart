import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/api/assignment_api.dart' as assignment_api;
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/mock_data.dart';

// TODO: Remove mock data and uncomment API calls when backend is ready

/// Current assignment for the driver (can be null)
final currentAssignmentProvider = FutureProvider.autoDispose<BookingAssignment?>((ref) async {
  final API api = await ref.read(apiProvider.future);
  BookingAssignment? assignment = await assignment_api.getCurrentAssignment(api);
  return assignment ?? MockData.getMockCurrentAssignment();
});

/// Assignment history for the driver
final assignmentHistoryProvider = FutureProvider.autoDispose<List<BookingAssignment>>((ref) async {
  final API api = await ref.read(apiProvider.future);
  List<BookingAssignment> history = await assignment_api.getAssignmentHistory(api);
  return history.isNotEmpty ? history : MockData.getMockAssignmentHistory();
});

final hasShownActionModalProvider = StateProvider((ref) => false);

