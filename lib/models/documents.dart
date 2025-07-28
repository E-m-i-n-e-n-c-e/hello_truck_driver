class DriverDocuments {
  final String licenseUrl;
  final DateTime licenseExpiry;
  final String rcBookUrl;
  final String fcUrl;
  final DateTime fcExpiry;
  final String insuranceUrl;
  final DateTime insuranceExpiry;
  final String aadharUrl;
  final String panNumber;
  final String ebBillUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DriverDocuments({
    required this.licenseUrl,
    required this.licenseExpiry,
    required this.rcBookUrl,
    required this.fcUrl,
    required this.fcExpiry,
    required this.insuranceUrl,
    required this.insuranceExpiry,
    required this.aadharUrl,
    required this.panNumber,
    required this.ebBillUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverDocuments.fromJson(Map<String, dynamic> json) {
    return DriverDocuments(
      licenseUrl: json['licenseUrl'],
      licenseExpiry: DateTime.parse(json['licenseExpiry']),
      rcBookUrl: json['rcBookUrl'],
      fcUrl: json['fcUrl'],
      fcExpiry: DateTime.parse(json['fcExpiry']),
      insuranceUrl: json['insuranceUrl'],
      insuranceExpiry: DateTime.parse(json['insuranceExpiry']),
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
      'licenseExpiry': licenseExpiry.toIso8601String(),
      'rcBookUrl': rcBookUrl,
      'fcUrl': fcUrl,
      'fcExpiry': fcExpiry.toIso8601String(),
      'insuranceUrl': insuranceUrl,
      'insuranceExpiry': insuranceExpiry.toIso8601String(),
      'aadharUrl': aadharUrl,
      'panNumber': panNumber,
      'ebBillUrl': ebBillUrl,
    };
  }
}

class ExpiryAlerts {
  final String? licenseAlert;
  final String? insuranceAlert;

  const ExpiryAlerts({
    this.licenseAlert,
    this.insuranceAlert,
  });

  factory ExpiryAlerts.fromJson(Map<String, dynamic> json) {
    return ExpiryAlerts(
      licenseAlert: json['licenseAlert'],
      insuranceAlert: json['insuranceAlert'],
    );
  }

  bool get hasAlerts => licenseAlert != null || insuranceAlert != null;

  List<String> get allAlerts {
    final alerts = <String>[];
    if (licenseAlert != null) alerts.add(licenseAlert!);
    if (insuranceAlert != null) alerts.add(insuranceAlert!);
    return alerts;
  }
}