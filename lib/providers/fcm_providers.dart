import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/fcm_enums.dart';
import '../services/fcm_service.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService();
});

final fcmEventStreamProvider = StreamProvider<FcmEventType>((ref) async* {
  final service = ref.watch(fcmServiceProvider);
  yield* service.eventStream;
});
