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
final positionStreamProvider = StreamProvider.family<Position, ({Duration? throttle, Duration? timeout})>((ref, config) async* {
  final locationService = ref.watch(locationServiceProvider);

  Position? initialPosition;

  while (initialPosition == null) {
    try {
      AppLogger.log('initialPosition: $initialPosition');
      initialPosition = await locationService.getCurrentPosition();
    } catch (e) {
      AppLogger.log('error: $e');
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  yield initialPosition;

  Stream<Position> stream = locationService.positionStream;

  if (config.throttle != null) {
    stream = stream.throttleTime(config.throttle!);
  }

  if (config.timeout != null) {
    stream = stream.timeout(config.timeout!, onTimeout: (sink) {
      locationService.getCurrentPosition().then((position) => sink.add(position));
    });
  }

  yield* stream;
});

final currentPositionStreamProvider = positionStreamProvider((
  throttle: null,
  timeout: null,
));

final locationUpdateStreamProvider = positionStreamProvider((
  throttle: const Duration(seconds: 5),
  timeout: null,
));

final locationUpdatesProvider = FutureProvider<void>((ref) async {
  final socketService = ref.read(socketServiceProvider);
  final currentPositionAsync = ref.watch(locationUpdateStreamProvider);
  Timer? timer;

  void sendLocation(Position position) {
    if (ref.read(driverProvider).value == null || ref.read(driverProvider).value!.driverStatus == DriverStatus.unavailable) return;
    socketService.sendMessage('update-location', {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  currentPositionAsync.when(
    data: (position) {
      sendLocation(position);
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 15), (timer) {
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