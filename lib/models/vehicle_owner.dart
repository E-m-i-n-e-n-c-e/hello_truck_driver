class VehicleOwner {
  final String name;
  final String aadharUrl;
  final String contactNumber;
  final String addressLine1;
  final String? landmark;
  final String pincode;
  final String city;
  final String district;
  final String state;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleOwner({
    required this.name,
    required this.aadharUrl,
    required this.contactNumber,
    required this.addressLine1,
    this.landmark,
    required this.pincode,
    required this.city,
    required this.district,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleOwner.fromJson(Map<String, dynamic> json) {
    return VehicleOwner(
      name: json['name'],
      aadharUrl: json['aadharUrl'],
      contactNumber: json['contactNumber'],
      addressLine1: json['addressLine1'],
      landmark: json['landmark'],
      pincode: json['pincode'],
      city: json['city'],
      district: json['district'],
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'aadharUrl': aadharUrl,
      'contactNumber': contactNumber,
      'addressLine1': addressLine1,
      if (landmark != null) 'landmark': landmark,
      'pincode': pincode,
      'city': city,
      'district': district,
      'state': state,
    };
  }
}