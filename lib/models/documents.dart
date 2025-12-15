class DriverDocuments {
  final String licenseUrl;
  final DateTime? licenseExpiry;
  final String rcBookUrl;
  final String fcUrl;
  final DateTime? fcExpiry;
  final String insuranceUrl;
  final DateTime? insuranceExpiry;
  final String aadharUrl;
  final String panNumber;
  final String ebBillUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverDocuments({
    required this.licenseUrl,
    this.licenseExpiry,
    required this.rcBookUrl,
    required this.fcUrl,
    this.fcExpiry,
    required this.insuranceUrl,
    this.insuranceExpiry,
    required this.aadharUrl,
    required this.panNumber,
    required this.ebBillUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverDocuments.fromJson(Map<String, dynamic> json) {
    return DriverDocuments(
      licenseUrl: json['licenseUrl'],
      licenseExpiry: json['licenseExpiry'] != null ? DateTime.parse(json['licenseExpiry']) : null,
      rcBookUrl: json['rcBookUrl'],
      fcUrl: json['fcUrl'],
      fcExpiry: json['fcExpiry'] != null ? DateTime.parse(json['fcExpiry']) : null,
      insuranceUrl: json['insuranceUrl'],
      insuranceExpiry: json['insuranceExpiry'] != null ? DateTime.parse(json['insuranceExpiry']) : null,
      aadharUrl: json['aadharUrl'],
      panNumber: json['panNumber'],
      ebBillUrl: json['ebBillUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseUrl': licenseUrl,
      'rcBookUrl': rcBookUrl,
      'fcUrl': fcUrl,
      'insuranceUrl': insuranceUrl,
      'aadharUrl': aadharUrl,
      'panNumber': panNumber,
      'ebBillUrl': ebBillUrl,
    };
  }
}

class ExpiryAlerts {
  final String? licenseAlert;
  final String? fcAlert;
  final String? insuranceAlert;
  final bool isLicenseExpired;
  final bool isFcExpired;
  final bool isInsuranceExpired;
  final DateTime? licenseExpiry;
  final DateTime? fcExpiry;
  final DateTime? insuranceExpiry;

  const ExpiryAlerts({
    this.licenseAlert,
    this.fcAlert,
    this.insuranceAlert,
    this.isLicenseExpired = false,
    this.isFcExpired = false,
    this.isInsuranceExpired = false,
    this.licenseExpiry,
    this.fcExpiry,
    this.insuranceExpiry,
  });

  factory ExpiryAlerts.fromJson(Map<String, dynamic> json) {
    return ExpiryAlerts(
      licenseAlert: json['licenseAlert'],
      fcAlert: json['fcAlert'],
      insuranceAlert: json['insuranceAlert'],
      isLicenseExpired: json['isLicenseExpired'] ?? false,
      isFcExpired: json['isFcExpired'] ?? false,
      isInsuranceExpired: json['isInsuranceExpired'] ?? false,
      licenseExpiry: json['licenseExpiry'] != null ? DateTime.parse(json['licenseExpiry']) : null,
      fcExpiry: json['fcExpiry'] != null ? DateTime.parse(json['fcExpiry']) : null,
      insuranceExpiry: json['insuranceExpiry'] != null ? DateTime.parse(json['insuranceExpiry']) : null,
    );
  }

  bool get hasAlerts => licenseAlert != null || fcAlert != null || insuranceAlert != null;

  bool get hasExpiredDocuments => isLicenseExpired || isFcExpired || isInsuranceExpired;

  List<String> get allAlerts {
    final alerts = <String>[];
    if (licenseAlert != null) alerts.add(licenseAlert!);
    if (fcAlert != null) alerts.add(fcAlert!);
    if (insuranceAlert != null) alerts.add(insuranceAlert!);
    return alerts;
  }
}