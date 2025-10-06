import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/fcm_enums.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
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
      print(event);
      if (event == FcmEventType.driverAssignmentOffered ||
          event == FcmEventType.driverAssignmentTimeout) {
        print("Invalidating current assignment");
        ref.invalidate(currentAssignmentProvider);
      }
    });

  });

});