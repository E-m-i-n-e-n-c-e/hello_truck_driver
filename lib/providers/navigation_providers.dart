import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

final navInfoListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final roadSnappedLocationUpdatedListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final remainingTimeOrDistanceChangedListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final lastNavInfoProvider = StateProvider<NavInfo?>((ref) => null);
final lastRoadSnappedProvider = StateProvider<LatLng?>((ref) => null);
final cachedRouteProvider = StateProvider<String?>((ref) => null);

/// Cleanup navigation session
Future<void> stopAndCleanupNavigation(WidgetRef ref) async {
  try {
    await GoogleMapsNavigator.stopGuidance();
  } catch (_) {}
  try {
    await GoogleMapsNavigator.clearDestinations();
  } catch (_) {}
  await _cleanupNavigationListenersAndCache(ref);
}

Future<void> _cleanupNavigationListenersAndCache(WidgetRef ref) async {
  // clear listeners
  await ref.read(navInfoListenerProvider.notifier).state?.cancel();
  await ref.read(roadSnappedLocationUpdatedListenerProvider.notifier).state?.cancel();
  await ref.read(remainingTimeOrDistanceChangedListenerProvider.notifier).state?.cancel();
  ref.read(navInfoListenerProvider.notifier).state = null;
  ref.read(roadSnappedLocationUpdatedListenerProvider.notifier).state = null;
  ref.read(remainingTimeOrDistanceChangedListenerProvider.notifier).state = null;

  // Clear cached data
  ref.read(lastNavInfoProvider.notifier).state = null;
  ref.read(lastRoadSnappedProvider.notifier).state = null;
  ref.read(cachedRouteProvider.notifier).state = null;
}
