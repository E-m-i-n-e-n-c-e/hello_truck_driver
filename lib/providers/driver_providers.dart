import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/driver_address.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/models/vehicle.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/api/vehicle_api.dart' as vehicle_api;
import 'package:hello_truck_driver/api/documents_api.dart' as documents_api;
import 'package:hello_truck_driver/api/address_api.dart' as address_api;
import 'package:shared_preferences/shared_preferences.dart';

/// Driver profile provider - no longer includes documents
final driverProvider = FutureProvider.autoDispose<Driver>((ref) async {
  final api = await ref.watch(apiProvider.future);
  final driver = await driver_api.getDriverProfile(api, includeDocuments: false);
  return driver;
});

/// Driver documents provider - fetched separately
final documentsProvider = FutureProvider.autoDispose<DriverDocuments?>((ref) async {
  final api = await ref.watch(apiProvider.future);
  try {
    return await documents_api.getDriverDocuments(api);
  } catch (e) {
    // Return null if documents not found (new driver)
    return null;
  }
});

/// Driver vehicle provider - fetched separately
final vehicleProvider = FutureProvider.autoDispose<Vehicle?>((ref) async {
  final api = await ref.watch(apiProvider.future);
  try {
    return await vehicle_api.getVehicle(api);
  } catch (e) {
    // Return null if vehicle not found
    return null;
  }
});

/// Driver address provider - fetched separately
final addressProvider = FutureProvider.autoDispose<DriverAddress?>((ref) async {
  final api = await ref.watch(apiProvider.future);
  try {
    return await address_api.getAddress(api);
  } catch (e) {
    // Return null if address not found
    return null;
  }
});

/// Vehicle models provider
final vehicleModelsProvider = FutureProvider<List<VehicleModel>>((ref) async {
  final api = await ref.watch(apiProvider.future);
  return vehicle_api.getVehicleModels(api);
});

final showReadyPromptProvider = FutureProvider<bool>((ref) async {
  final driver = await ref.read(driverProvider.future);
  final driverStatus = driver.driverStatus;
  final verificationStatus = driver.verificationStatus;
  // If driver status is not yet resolved or not unavailable or driver is not verified, return false
  if (driverStatus != DriverStatus.unavailable || verificationStatus != VerificationStatus.verified) return false;
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final k = 'last_ready_prompt_date';
  final today = '${now.year}-${now.month}-${now.day}';
  if (prefs.getString(k) == today) return false;
  return true;
});

Future<void> markAsReadyPromptSeen(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final now = DateTime.now();
  final k = 'last_ready_prompt_date';
  final today = '${now.year}-${now.month}-${now.day}';
  await prefs.setString(k, today);
  ref.invalidate(showReadyPromptProvider);
}