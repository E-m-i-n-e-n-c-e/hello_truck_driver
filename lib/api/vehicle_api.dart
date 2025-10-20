import 'package:hello_truck_driver/models/enums/vehicle_enums.dart';
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
  required VehicleType vehicleType,
  required double vehicleBodyLength,
  required VehicleBodyType vehicleBodyType,
  required FuelType fuelType,
  required String vehicleImageUrl,
  VehicleOwner? owner,
}) async {
  final response = await api.post(
    '/driver/vehicle',
    data: {
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType.value,
      'vehicleBodyLength': vehicleBodyLength,
      'vehicleBodyType': vehicleBodyType.value,
      'fuelType': fuelType.value,
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
  VehicleType? vehicleType,
  double? vehicleBodyLength,
  VehicleBodyType? vehicleBodyType,
  FuelType? fuelType,
  String? vehicleImageUrl,
}) async {
  final response = await api.put(
    '/driver/vehicle',
    data: {
      if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
      if (vehicleType != null) 'vehicleType': vehicleType.value,
      if (vehicleBodyLength != null) 'vehicleBodyLength': vehicleBodyLength,
      if (vehicleBodyType != null) 'vehicleBodyType': vehicleBodyType.value,
      if (fuelType != null) 'fuelType': fuelType.value,
      if (vehicleImageUrl != null) 'vehicleImageUrl': vehicleImageUrl,
    },
  );
  return Vehicle.fromJson(response.data);
}

/// Delete vehicle for the current driver
Future<void> deleteVehicle(dynamic api) async {
  await api.delete('/driver/vehicle');
}

/// Create vehicle owner for the current driver's vehicle
Future<VehicleOwner> createVehicleOwner(
  dynamic api, {
  required VehicleOwner owner,
}) async {
  final response = await api.post(
    '/driver/vehicle/owner',
    data: owner.toJson(),
  );
  return VehicleOwner.fromJson(response.data);
}

/// Update vehicle owner for the current driver's vehicle
Future<VehicleOwner> updateVehicleOwner(
  dynamic api, {
  required VehicleOwner owner,
}) async {
  final response = await api.put(
    '/driver/vehicle/owner',
    data: owner.toJson(),
  );
  return VehicleOwner.fromJson(response.data);
}