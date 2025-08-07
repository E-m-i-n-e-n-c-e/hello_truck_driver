import 'package:hello_truck_driver/models/vehicle_owner.dart';

/// Create vehicle owner information
Future<VehicleOwner> createVehicleOwner(
  dynamic api, {
  required String name,
  required String aadharUrl,
  required String contactNumber,
  required String addressLine1,
  String? landmark,
  required String pincode,
  required String city,
  required String district,
  required String state,
}) async {
  final response = await api.post(
    '/driver/vehicle/owner',
    data: {
      'name': name,
      'aadharUrl': aadharUrl,
      'contactNumber': contactNumber,
      'addressLine1': addressLine1,
      if (landmark != null) 'landmark': landmark,
      'pincode': pincode,
      'city': city,
      'district': district,
      'state': state,
    },
  );
  return VehicleOwner.fromJson(response.data);
}

/// Update vehicle owner information
Future<VehicleOwner> updateVehicleOwner(
  dynamic api, {
  String? name,
  String? aadharUrl,
  String? contactNumber,
  String? addressLine1,
  String? landmark,
  String? pincode,
  String? city,
  String? district,
  String? state,
}) async {
  final response = await api.put(
    '/driver/vehicle/owner',
    data: {
      if (name != null) 'name': name,
      if (aadharUrl != null) 'aadharUrl': aadharUrl,
      if (contactNumber != null) 'contactNumber': contactNumber,
      if (addressLine1 != null) 'addressLine1': addressLine1,
      if (landmark != null) 'landmark': landmark,
      if (pincode != null) 'pincode': pincode,
      if (city != null) 'city': city,
      if (district != null) 'district': district,
      if (state != null) 'state': state,
    },
  );
  return VehicleOwner.fromJson(response.data);
}