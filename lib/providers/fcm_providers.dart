import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/fcm_enums.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/payment_providers.dart';
import '../services/fcm_service.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService();
});

final fcmEventStreamProvider = StreamProvider<FcmEventType>((ref) async* {
  final service = ref.watch(fcmServiceProvider);
  yield* service.eventStream;
});

final fcmEventsHandlerProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<FcmEventType>>(fcmEventStreamProvider, (previous, next) {
    next.whenData((event) {
      // Assignment events
      if (event == FcmEventType.driverAssignmentOffered ||
          event == FcmEventType.driverAssignmentTimeout) {
        ref.invalidate(currentAssignmentProvider);
      }

      // Wallet change events (credit/debit)
      // Invalidate wallet logs and driver (for wallet balance)
      if (event == FcmEventType.walletCredit ||
          event == FcmEventType.walletDebit) {
        ref.invalidate(walletLogsProvider);
        ref.invalidate(driverProvider);
      }

      // Payout processed event
      // Invalidate all three: wallet logs, transaction logs, and driver
      if (event == FcmEventType.payoutProcessed) {
        ref.invalidate(walletLogsProvider);
        ref.invalidate(transactionLogsProvider);
        ref.invalidate(driverProvider);
      }

      // Driver verification updated event
      // Invalidate documents (for expiry dates and status) and driver (for verification status)
      if (event == FcmEventType.driverVerificationUpdated) {
        ref.invalidate(documentsProvider);
        ref.invalidate(driverProvider);
      }
    });
  });
});