class Address {
  final String? addressName;
  final String contactName;
  final String contactPhone;
  final String? noteToDriver;
  final String formattedAddress;
  final String? addressDetails;
  final double latitude;
  final double longitude;

  Address({
    this.addressName,
    required this.contactName,
    required this.contactPhone,
    this.noteToDriver,
    required this.formattedAddress,
    this.addressDetails,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      contactName: json['contactName'],
      contactPhone: json['contactPhone'],
      noteToDriver: json['noteToDriver'],
      formattedAddress: json['formattedAddress'],
      addressDetails: json['addressDetails'],
      latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
      longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contactName': contactName,
      'contactPhone': contactPhone,
      'noteToDriver': noteToDriver,
      'formattedAddress': formattedAddress,
      'addressDetails': addressDetails,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}