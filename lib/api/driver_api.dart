import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/driver_address.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/models/vehicle.dart';
import 'package:hello_truck_driver/models/payout_details.dart';

/// Create driver profile
Future<void> createDriverProfile(
  API api, {
  required String firstName,
  String? lastName,
  String? alternatePhone,
  String? photo,
  String? referalCode,
  String? googleIdToken,
  required DriverDocuments documents,
  required DriverAddress address,
  required Vehicle vehicle,
  required PayoutDetails payoutDetails,
}) async {
  await api.post('/driver/profile', data: {
    'firstName': firstName,
    if (lastName?.isNotEmpty ?? false) 'lastName': lastName,
    if (alternatePhone?.isNotEmpty ?? false) 'alternatePhone': alternatePhone,
    if (photo?.isNotEmpty ?? false) 'photo': photo,
    if (referalCode?.isNotEmpty ?? false) 'referalCode': referalCode,
    if (googleIdToken?.isNotEmpty ?? false) 'googleIdToken': googleIdToken,
    'documents': documents.toJson(),
    'address': address.toJson(),
    'vehicle': vehicle.toJson(),
    'payoutDetails': payoutDetails.toJson(),
  });
}

/// Get driver profile
Future<Driver> getDriverProfile(API api, {bool includeDocuments = false}) async {
  final response = await api.get('/driver/profile', queryParameters: {
    'includeDocuments': includeDocuments,
  });
  return Driver.fromJson(response.data);
}

/// Update driver profile
Future<void> updateDriverProfile(
  API api, {
  String? firstName,
  String? lastName,
  String? alternatePhone,
  String? photo,
  String? googleIdToken,
}) async {
  await api.put('/driver/profile', data: {
    if (firstName?.isNotEmpty ?? false) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (alternatePhone?.isNotEmpty ?? false) 'alternatePhone': alternatePhone,
    if (photo?.isNotEmpty ?? false) 'photo': photo,
    if (googleIdToken?.isNotEmpty ?? false) 'googleIdToken': googleIdToken,
  });
}

/// Update driver status
Future<void> updateDriverStatus(API api, {required bool isAvailable}) async {
  await api.put('/driver/profile/status', data: {
    'status': isAvailable ? DriverStatus.available.value : DriverStatus.unavailable.value,
  });
}

// Update payout details
Future<void> updateDriverPayoutDetails(API api, {required PayoutDetails payoutDetails}) async {
  await api.put('/driver/profile/payout-details', data: payoutDetails.toJson());
}