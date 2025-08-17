import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';

class Driver {
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? alternatePhone;
  final String? referalCode;
  final String? photo;
  final VerificationStatus verificationStatus;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DriverDocuments? documents;

  const Driver({
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.alternatePhone,
    this.referalCode,
    this.photo,
    required this.verificationStatus,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.documents,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      phoneNumber: json['phoneNumber'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      alternatePhone: json['alternatePhone'],
      referalCode: json['referalCode'],
      photo: json['photo'],
      verificationStatus: VerificationStatus.fromString(json['verificationStatus'] ?? 'PENDING'),
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      documents: json['documents'] != null ? DriverDocuments.fromJson(json['documents']) : null,
    );
  }
}
