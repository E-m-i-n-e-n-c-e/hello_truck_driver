import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/documents.dart';

/// Get driver documents
Future<DriverDocuments> getDriverDocuments(API api) async {
  final response = await api.get('/driver/documents');
  print(response.data);
  return DriverDocuments.fromJson(response.data);
}

/// Update driver documents
Future<DriverDocuments> updateDriverDocuments(
  API api, {
  String? licenseUrl,
  DateTime? licenseExpiry,
  String? rcBookUrl,
  String? fcUrl,
  DateTime? fcExpiry,
  String? insuranceUrl,
  DateTime? insuranceExpiry,
  String? aadharUrl,
  String? panNumber,
  String? ebBillUrl,
}) async {
  final data = <String, dynamic>{};

  if (licenseUrl?.isNotEmpty ?? false) data['licenseUrl'] = licenseUrl;
  if (licenseExpiry != null) data['licenseExpiry'] = licenseExpiry.toIso8601String();
  if (rcBookUrl?.isNotEmpty ?? false) data['rcBookUrl'] = rcBookUrl;
  if (fcUrl?.isNotEmpty ?? false) data['fcUrl'] = fcUrl;
  if (fcExpiry != null) data['fcExpiry'] = fcExpiry.toIso8601String();
  if (insuranceUrl?.isNotEmpty ?? false) data['insuranceUrl'] = insuranceUrl;
  if (insuranceExpiry != null) data['insuranceExpiry'] = insuranceExpiry.toIso8601String();
  if (aadharUrl?.isNotEmpty ?? false) data['aadharUrl'] = aadharUrl;
  if (panNumber?.isNotEmpty ?? false) data['panNumber'] = panNumber;
  if (ebBillUrl?.isNotEmpty ?? false) data['ebBillUrl'] = ebBillUrl;

  final response = await api.put('/driver/documents', data: data);
  return DriverDocuments.fromJson(response.data);
}



/// Get document expiry alerts
Future<ExpiryAlerts> getDocumentExpiryAlerts(API api) async {
  final response = await api.get('/driver/documents/expiry-alerts');
  return ExpiryAlerts.fromJson(response.data);
}