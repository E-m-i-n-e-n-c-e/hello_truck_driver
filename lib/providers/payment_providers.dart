import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/utils/mock_data.dart';

/// Wallet logs (latest 50)
final walletLogsProvider = FutureProvider.autoDispose<List<WalletLog>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 600));
  return MockData.getMockWalletLogs();

  // TODO: Uncomment when backend is ready
  // final api = await ref.watch(apiProvider.future);
  // return dashboard_api.getWalletLogs(api);
});

/// Transaction logs (latest 50)
final transactionLogsProvider = FutureProvider.autoDispose<List<TransactionLog>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 700));
  return MockData.getMockTransactionLogs();

  // TODO: Uncomment when backend is ready
  // final api = await ref.watch(apiProvider.future);
  // return dashboard_api.getTransactionLogs(api);
});