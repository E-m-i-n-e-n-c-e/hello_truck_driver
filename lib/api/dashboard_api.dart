import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';

/// Get driver's wallet transaction logs (latest 50)
Future<List<WalletLog>> getWalletLogs(API api) async {
  final response = await api.get('/driver/profile/wallet-logs');
  final List<dynamic> data = response.data;
  return data.map((json) => WalletLog.fromJson(json)).toList();
}

/// Get driver's transaction ledger (latest 50)
Future<List<TransactionLog>> getTransactionLogs(API api) async {
  final response = await api.get('/driver/profile/transaction-logs');
  final List<dynamic> data = response.data;
  return data.map((json) => TransactionLog.fromJson(json)).toList();
}

/// Get daily ride summary
/// [date] should be in YYYY-MM-DD format. Defaults to today in IST.
Future<RideSummary> getRideSummary(API api, {String? date}) async {
  final queryParams = <String, dynamic>{};
  if (date != null) {
    queryParams['date'] = date;
  }
  final response = await api.get('/bookings/driver/ride-summary', queryParameters: queryParams);
  return RideSummary.fromJson(response.data);
}
