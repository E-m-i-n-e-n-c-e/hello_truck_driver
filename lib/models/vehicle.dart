import 'vehicle_owner.dart';

class Vehicle {
  final String vehicleNumber;
  final String vehicleType;
  final double vehicleBodyLength;
  final String vehicleBodyType;
  final String fuelType;
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
      vehicleType: json['vehicleType'],
      vehicleBodyLength: double.parse(json['vehicleBodyLength'].toString()),
      vehicleBodyType: json['vehicleBodyType'],
      fuelType: json['fuelType'],
      vehicleImageUrl: json['vehicleImageUrl'],
      owner: json['owner'] != null ? VehicleOwner.fromJson(json['owner']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'vehicleBodyLength': vehicleBodyLength,
      'vehicleBodyType': vehicleBodyType,
      'fuelType': fuelType,
      'vehicleImageUrl': vehicleImageUrl,
      if (owner != null) 'owner': owner!.toJson(),
    };
  }
}