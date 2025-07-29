import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/api/driver_api.dart' as driver_api;
import 'dart:typed_data';

final driverProvider = FutureProvider.autoDispose<Driver>((ref) async {
  final api = await ref.watch(apiProvider.future);
  return driver_api.getDriverProfile(api, includeDocuments: true);
});

final documentFilesProvider = FutureProvider.autoDispose<Map<String, Uint8List>>((ref) async {
  final api = await ref.watch(apiProvider.future);
  final driver = await ref.watch(driverProvider.future);
  if (driver.documents == null) return {};

  final documents = driver.documents!;
  final urls = {
    'license': documents.licenseUrl,
    'rcBook': documents.rcBookUrl,
    'fc': documents.fcUrl,
    'insurance': documents.insuranceUrl,
    'aadhar': documents.aadharUrl,
    'ebBill': documents.ebBillUrl,
  };

  final Map<String, Uint8List> documentBytes = {};

  for (final entry in urls.entries) {
    final url = entry.value;
    if (url.isEmpty) continue;

    try {
      final response = await api.getFile(url);
      if (response.statusCode == 200 && response.data != null) {
        final bytes = Uint8List.fromList(response.data);
        if (bytes.isNotEmpty) {
          documentBytes[entry.key] = bytes;
        }
      }
    } catch (_) {
      // Ignore failed fetches silently
    }
  }

  return documentBytes;
});