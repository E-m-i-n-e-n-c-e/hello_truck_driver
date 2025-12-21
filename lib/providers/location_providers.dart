import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/socket_providers.dart';
import 'package:hello_truck_driver/services/location_service.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/logger.dart';

// Location service provider
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

// Configurable position stream provider using family
final positionStreamProvider = StreamProvider.family<Position, ({Duration? throttle})>((ref, config) async* {
  final locationService = ref.watch(locationServiceProvider);

  Position? initialPosition;

  while (initialPosition == null) {
    try {
      initialPosition = await locationService.getCurrentPosition();
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  yield initialPosition;

  Stream<Position> stream = locationService.positionStream;

  if (config.throttle != null) {
    stream = stream.throttleTime(config.throttle!);
  }

  yield* stream;
});

final currentPositionStreamProvider = positionStreamProvider((
  throttle: null,
));

final throttlePositionStreamProvider = positionStreamProvider((
  throttle: const Duration(seconds: 5),
));

final locationUpdatesProvider = FutureProvider<void>((ref) async {
  final socketService = ref.read(socketServiceProvider);
  final locationService = ref.read(locationServiceProvider);

  final currentPositionAsync = ref.watch(throttlePositionStreamProvider);

  locationService.checkAndRequestPermissions();
  Timer? timer;

  void sendLocation(Position position) {
    AppLogger.log('sendLocation: $position');
    final driver = ref.read(driverProvider).value;
    if (driver == null ||
        driver.driverStatus != DriverStatus.available ||
        driver.verificationStatus != VerificationStatus.verified) {
      return;
    }
    socketService.sendMessage('update-location', {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  currentPositionAsync.when(
    data: (position) {
      sendLocation(position);
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        sendLocation(position);
      });
    },
    loading: () {},
    error: (_, _) {},
  );

  ref.onDispose(() {
    timer?.cancel();
    timer = null;
  });
});