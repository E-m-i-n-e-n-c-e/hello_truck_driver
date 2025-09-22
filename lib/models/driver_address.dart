class DriverAddress {
  final String addressLine1;
  final String? landmark;
  final String pincode;
  final String city;
  final String district;
  final String state;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverAddress({
    required this.addressLine1,
    this.landmark,
    required this.pincode,
    required this.city,
    required this.district,
    required this.state,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverAddress.fromJson(Map<String, dynamic> json) {
    return DriverAddress(
      addressLine1: json['addressLine1'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      if (landmark != null) 'landmark': landmark,
      'pincode': pincode,
      'city': city,
      'district': district,
      'state': state,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }
}