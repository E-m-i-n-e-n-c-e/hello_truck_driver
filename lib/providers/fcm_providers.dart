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
      // Invalidate assignment (for current booking status) and driver (driver status)
      if (event == FcmEventType.driverAssignmentOffered ||
          event == FcmEventType.driverAssignmentTimeout) {
        ref.invalidate(currentAssignmentProvider);
        ref.invalidate(driverProvider);
      }

      // Driver verification updated event
      // Invalidate documents (for expiry dates and status) and driver (for verification status)
      if (event == FcmEventType.driverVerificationUpdate) {
        ref.invalidate(documentsProvider);
        ref.invalidate(driverProvider);
      }

      // Payment success event
      // Invalidate assignment (for current booking status)
      if(event == FcmEventType.paymentSuccess){
        ref.invalidate(currentAssignmentProvider);
      }

      // Payout processed event
      // Invalidate driver (for wallet balance), wallet logs, and transaction logs
      if(event == FcmEventType.payoutProcessed){
        ref.invalidate(driverProvider);
        ref.invalidate(walletLogsProvider);
        ref.invalidate(transactionLogsProvider);
      }

      // Ride cancelled event
      // Invalidate assignment (for current booking status) and driver (driver status)
      if(event == FcmEventType.rideCancelled){
        ref.invalidate(currentAssignmentProvider);
        ref.invalidate(driverProvider);
      }

      // Wallet change events (credit/debit)
      // Invalidate wallet logs and driver (for wallet balance)
      if (event == FcmEventType.walletChange) {
        ref.invalidate(walletLogsProvider);
        ref.invalidate(driverProvider);
      }
    });
  });
});