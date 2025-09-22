class Address {
  final String formattedAddress;
  final String? addressDetails;
  final double latitude;
  final double longitude;

  Address({
    required this.formattedAddress,
    this.addressDetails,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      formattedAddress: json['formattedAddress'],
      addressDetails: json['addressDetails'],
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formattedAddress': formattedAddress,
      'addressDetails': addressDetails,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}