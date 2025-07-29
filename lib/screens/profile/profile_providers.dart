import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/api/driver_api.dart' as driver_api;

final driverProvider = FutureProvider.autoDispose<Driver>((ref) async {
  final api = await ref.watch(apiProvider.future);
  return driver_api.getDriverProfile(api, includeDocuments: true);
});