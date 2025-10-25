import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:shared_preferences/shared_preferences.dart';

final driverProvider = FutureProvider<Driver>((ref) async {
  final api = await ref.watch(apiProvider.future);
  return driver_api.getDriverProfile(api, includeDocuments: true);
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