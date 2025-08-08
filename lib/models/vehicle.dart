import 'vehicle_owner.dart';
import 'enums/vehicle_enums.dart';

class Vehicle {
  final String vehicleNumber;
  final VehicleType vehicleType;
  final double vehicleBodyLength;
  final VehicleBodyType vehicleBodyType;
  final FuelType fuelType;
  final String vehicleImageUrl;
  final VehicleOwner? owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleBodyLength,
    required this.vehicleBodyType,
    required this.fuelType,
    required this.vehicleImageUrl,
    this.owner,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleNumber: json['vehicleNumber'],
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.value == json['vehicleType'],
      ),
      vehicleBodyLength: double.parse(json['vehicleBodyLength'].toString()),
      vehicleBodyType: VehicleBodyType.values.firstWhere(
        (e) => e.value == json['vehicleBodyType'],
      ),
      fuelType: FuelType.values.firstWhere(
        (e) => e.value == json['fuelType'],
      ),
      vehicleImageUrl: json['vehicleImageUrl'],
      owner: json['owner'] != null ? VehicleOwner.fromJson(json['owner']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType.value,
      'vehicleBodyLength': vehicleBodyLength,
      'vehicleBodyType': vehicleBodyType.value,
      'fuelType': fuelType.value,
      'vehicleImageUrl': vehicleImageUrl,
      if (owner != null) 'owner': owner!.toJson(),
    };
  }
}