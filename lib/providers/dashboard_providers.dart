import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/utils/mock_data.dart';
import 'package:hello_truck_driver/utils/document_expiry_utils.dart';

// TODO: Remove mock data and uncomment API calls when backend is ready

/// Ride summary for today
final rideSummaryProvider = FutureProvider.autoDispose<RideSummary>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  return MockData.getMockRideSummary();

  // TODO: Uncomment when backend is ready
  // final api = await ref.watch(apiProvider.future);
  // return driver_api.getRideSummary(api);
});

/// Document expiry alerts
final expiryAlertsProvider = FutureProvider.autoDispose<ExpiryAlerts>((ref) async {
  final documents = await ref.watch(documentsProvider.future);

  // If no documents found, return empty alerts
  if (documents == null) {
    return const ExpiryAlerts();
  }

  // Calculate expiry alerts
  return calculateExpiryAlerts(documents);
});
