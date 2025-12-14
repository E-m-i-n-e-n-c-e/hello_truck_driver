import 'vehicle_owner.dart';
import 'enums/vehicle_enums.dart';

class Vehicle {
  final String vehicleNumber;
  final VehicleType vehicleType;
  final double vehicleBodyLength;
  final VehicleBodyType vehicleBodyType;
  final FuelType fuelType;
  final String vehicleImageUrl;
  final String vehicleModelName;
  final VehicleModel? vehicleModelDetails;
  final VehicleOwner? owner;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.vehicleNumber,
    required this.vehicleType,
    required this.vehicleModelName,
    this.vehicleModelDetails,
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
      vehicleModelName: json['vehicleModelName'] ?? '',
      vehicleModelDetails: json['vehicleModel'] != null ? VehicleModel.fromJson(json['vehicleModel']) : null,
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
      'vehicleModelName': vehicleModelName,
      'vehicleBodyLength': vehicleBodyLength,
      'vehicleBodyType': vehicleBodyType.value,
      'fuelType': fuelType.value,
      'vehicleImageUrl': vehicleImageUrl,
      if (owner != null) 'owner': owner!.toJson(),
    };
  }
}

class VehicleModel {
  final String name;
  final double perKm;
  final int baseKm;
  final double baseFare;
  final double maxWeightTons;

  VehicleModel({
    required this.name,
    required this.perKm,
    required this.baseKm,
    required this.baseFare,
    required this.maxWeightTons,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
        name: json['name'],
        perKm: double.parse(json['perKm'].toString()),
        baseKm: json['baseKm'],
        baseFare: double.parse(json['baseFare'].toString()),
      maxWeightTons: double.parse(json['maxWeightTons'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'perKm': perKm,
      'baseKm': baseKm,
      'baseFare': baseFare,
      'maxWeightTons': maxWeightTons,
    };
  }
}
