import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/api/assignment_api.dart' as assignment_api;
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/mock_data.dart';

// TODO: Remove mock data and uncomment API calls when backend is ready

/// Current assignment for the driver (can be null)
final currentAssignmentProvider = FutureProvider<BookingAssignment?>((ref) async {
  // Simulate network delay
  // await Future.delayed(const Duration(milliseconds: 500));
  // return MockData.getMockCurrentAssignment();

  // TODO: Uncomment when backend is ready
  final API api = await ref.read(apiProvider.future);
  return assignment_api.getCurrentAssignment(api);
});

/// Assignment history for the driver
final assignmentHistoryProvider = FutureProvider<List<BookingAssignment>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 600));
  return MockData.getMockAssignmentHistory();

  // TODO: Uncomment when backend is ready
  // final API api = await ref.read(apiProvider.future);
  // return assignment_api.getAssignmentHistory(api);
});

final hasShownActionModalProvider = StateProvider((ref) => false);

