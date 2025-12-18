import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/earnings_api.dart' as dashboard_api;
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/mock_data.dart';

/// Wallet logs (latest 50)
final walletLogsProvider = FutureProvider.autoDispose<List<WalletLog>>((ref) async {
  final api = await ref.watch(apiProvider.future);
  final logs = await dashboard_api.getWalletLogs(api);
  return logs.isEmpty ? MockData.getMockWalletLogs() : logs;
});

/// Transaction logs (latest 50)
final transactionLogsProvider = FutureProvider.autoDispose<List<TransactionLog>>((ref) async {
  final api = await ref.watch(apiProvider.future);
  final logs = await dashboard_api.getTransactionLogs(api);
  return logs.isEmpty ? MockData.getMockTransactionLogs() : logs;
});