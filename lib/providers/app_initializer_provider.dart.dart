import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/fcm_providers.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/providers/socket_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';

import '../utils/logger.dart';

final appInitializerProvider = FutureProvider.autoDispose<void>((ref) async {
  final api = await ref.read(apiProvider.future);
  final socketService = ref.read(socketServiceProvider);
  await socketService.connect(api);
  final fcmService = ref.read(fcmServiceProvider);
  await fcmService.initialize(api);

  ref.invalidate(currentAssignmentProvider);

  final List<FutureProvider<Object>> futureProvidersToEagerInit = [
    driverProvider,
  ];

  final List<StreamProvider<Object>> streamProvidersToEagerInit = [
    currentPositionStreamProvider,
    fcmEventStreamProvider,
  ];

  final List<ProviderListenable> providersToEagerInit = [
    ...futureProvidersToEagerInit,
    ...streamProvidersToEagerInit,
  ];

  for (final provider in providersToEagerInit) {
    ref.read(provider);
  }

  ref.onDispose(() {
    AppLogger.log('AppInitializerProvider disposed');
    for (final provider in providersToEagerInit) {
      ref.invalidate(provider as ProviderOrFamily);
    }
    socketService.dispose();
    fcmService.stop();
  });
});
