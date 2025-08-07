import 'package:hello_truck_driver/models/vehicle.dart';
import 'package:hello_truck_driver/models/vehicle_owner.dart';

/// Get vehicle information for the current driver
Future<Vehicle> getVehicle(dynamic api) async {
  final response = await api.get('/driver/vehicle');
  return Vehicle.fromJson(response.data);
}

/// Create a new vehicle for the current driver
Future<Vehicle> createVehicle(
  dynamic api, {
  required String vehicleNumber,
  required String vehicleType,
  required double vehicleBodyLength,
  required String vehicleBodyType,
  required String fuelType,
  required String vehicleImageUrl,
  VehicleOwner? owner,
}) async {
  final response = await api.post(
    '/driver/vehicle',
    data: {
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'vehicleBodyLength': vehicleBodyLength,
      'vehicleBodyType': vehicleBodyType,
      'fuelType': fuelType,
      'vehicleImageUrl': vehicleImageUrl,
      if (owner != null) 'owner': owner.toJson(),
    },
  );
  return Vehicle.fromJson(response.data);
}

/// Update vehicle information for the current driver
Future<Vehicle> updateVehicle(
  dynamic api, {
  String? vehicleNumber,
  String? vehicleType,
  double? vehicleBodyLength,
  String? vehicleBodyType,
  String? fuelType,
  String? vehicleImageUrl,
}) async {
  final response = await api.put(
    '/driver/vehicle',
    data: {
      if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
      if (vehicleType != null) 'vehicleType': vehicleType,
      if (vehicleBodyLength != null) 'vehicleBodyLength': vehicleBodyLength,
      if (vehicleBodyType != null) 'vehicleBodyType': vehicleBodyType,
      if (fuelType != null) 'fuelType': fuelType,
      if (vehicleImageUrl != null) 'vehicleImageUrl': vehicleImageUrl,
    },
  );
  return Vehicle.fromJson(response.data);
}

/// Delete vehicle for the current driver
Future<void> deleteVehicle(dynamic api) async {
  await api.delete('/driver/vehicle');
}