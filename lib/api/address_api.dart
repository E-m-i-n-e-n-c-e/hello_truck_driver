import 'package:hello_truck_driver/models/address.dart';

/// Get address for the current driver
Future<Address> getAddress(dynamic api) async {
  final response = await api.get('/driver/address');
  return Address.fromJson(response.data);
}

/// Create address for the current driver
Future<Address> createAddress(
  dynamic api, {
  required String addressLine1,
  String? landmark,
  required String pincode,
  required String city,
  required String district,
  required String state,
  double? latitude,
  double? longitude,
}) async {
  final response = await api.post(
    '/driver/address',
    data: {
      'addressLine1': addressLine1,
      if (landmark?.isNotEmpty ?? false) 'landmark': landmark,
      'pincode': pincode,
      'city': city,
      'district': district,
      'state': state,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    },
  );
  return Address.fromJson(response.data);
}

/// Update address for the current driver
Future<Address> updateAddress(
  dynamic api, {
  String? addressLine1,
  String? landmark,
  String? pincode,
  String? city,
  String? district,
  String? state,
  double? latitude,
  double? longitude,
}) async {
  final response = await api.put(
    '/driver/address',
    data: {
      if (addressLine1?.isNotEmpty ?? false) 'addressLine1': addressLine1,
      if (landmark?.isNotEmpty ?? false) 'landmark': landmark,
      if (pincode?.isNotEmpty ?? false) 'pincode': pincode,
      if (city?.isNotEmpty ?? false) 'city': city,
      if (district?.isNotEmpty ?? false) 'district': district,
      if (state?.isNotEmpty ?? false) 'state': state,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    },
  );
  return Address.fromJson(response.data);
}

/// Delete address for the current driver
Future<void> deleteAddress(dynamic api) async {
  await api.delete('/driver/address');
}
