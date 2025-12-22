import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';

/// Ride summary for today
final rideSummaryProvider = FutureProvider.autoDispose<RideSummary>((ref) async {
  final api = await ref.watch(apiProvider.future);
  return driver_api.getRideSummary(api);
});
