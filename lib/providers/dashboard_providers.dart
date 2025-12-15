import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/dashboard_api.dart' as dashboard_api;
import 'package:hello_truck_driver/api/documents_api.dart' as documents_api;
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/mock_data.dart';

// TODO: Remove mock data and uncomment API calls when backend is ready

/// Ride summary for today
final rideSummaryProvider = FutureProvider<RideSummary>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  return MockData.getMockRideSummary();

  // TODO: Uncomment when backend is ready
  // final api = await ref.watch(apiProvider.future);
  // return dashboard_api.getRideSummary(api);
});

/// Document expiry alerts
final expiryAlertsProvider = FutureProvider<ExpiryAlerts>((ref) async {
  final api = await ref.watch(apiProvider.future);
  return documents_api.getDocumentExpiryAlerts(api);
});

/// Wallet logs (latest 50)
final walletLogsProvider = FutureProvider<List<WalletLog>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 600));
  return MockData.getMockWalletLogs();

  // TODO: Uncomment when backend is ready
  // final api = await ref.watch(apiProvider.future);
  // return dashboard_api.getWalletLogs(api);
});

/// Transaction logs (latest 50)
final transactionLogsProvider = FutureProvider<List<TransactionLog>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 700));
  return MockData.getMockTransactionLogs();

  // TODO: Uncomment when backend is ready
  // final api = await ref.watch(apiProvider.future);
  // return dashboard_api.getTransactionLogs(api);
});
