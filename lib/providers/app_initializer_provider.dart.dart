import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/fcm_providers.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/providers/socket_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';

import '../utils/logger.dart';

final appInitializerProvider = FutureProvider.autoDispose<void>((ref) async {
  final api = await ref.read(apiProvider.future);
  final socketService = ref.read(socketServiceProvider);
  await socketService.connect(api);
  final fcmService = ref.read(fcmServiceProvider);
  await fcmService.initialize(api);

  ref.invalidate(currentAssignmentProvider);

  final List<FutureProvider<Object>> futureProvidersToEagerInit = [
    // driverProvider,
    // assignmentHistoryProvider,
    // rideSummaryProvider,
    // expiryAlertsProvider,
    // walletLogsProvider,
    // transactionLogsProvider,
  ];

  final List<StreamProvider<Object>> streamProvidersToEagerInit = [
    currentPositionStreamProvider,
    fcmEventStreamProvider,
  ];

  final List<ProviderListenable> providersToEagerInit = [
    ...streamProvidersToEagerInit,
    ...futureProvidersToEagerInit,
  ];

  for (final provider in providersToEagerInit) {
    ref.invalidate(provider as ProviderOrFamily);
    AppLogger.log("Invalidated provider: ${provider.toString()}");
    ref.read(provider);
  }

  ref.onDispose(() {
    AppLogger.log('AppInitializerProvider disposed');
    for (final provider in providersToEagerInit) {
      ref.invalidate(provider as ProviderOrFamily);
      AppLogger.log("Invalidated provider: ${provider.toString()}");
    }
    socketService.dispose();
    fcmService.stop();
  });
});
