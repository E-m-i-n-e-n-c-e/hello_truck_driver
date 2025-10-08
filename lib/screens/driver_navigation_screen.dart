import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/socket_providers.dart';
import 'package:hello_truck_driver/widgets/navigation_overlay.dart';

import '../utils/logger.dart';

final _navInfoListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final _roadSnappedLocationUpdatedListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final _remainingTimeOrDistanceChangedListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final _lastNavInfoProvider = StateProvider<NavInfo?>((ref) => null);
final _lastRoadSnappedProvider = StateProvider<LatLng?>((ref) => null);

class DriverNavigationScreen extends ConsumerStatefulWidget {
  final BookingAssignment assignment;

  const DriverNavigationScreen({
    super.key,
    required this.assignment,
  });

  @override
  ConsumerState<DriverNavigationScreen> createState() => _DriverNavigationScreenState();
}

class _DriverNavigationScreenState extends ConsumerState<DriverNavigationScreen> {
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _initSession();
  }

  Future<void> _initSession() async {
    try {
      if (!await GoogleMapsNavigator.areTermsAccepted()) {
        await GoogleMapsNavigator.showTermsAndConditionsDialog(
          'Hello Truck Navigation',
          'Hello Truck',
        );
      }
      if (!await GoogleMapsNavigator.isInitialized()) {
        AppLogger.log('Initializing navigation session');
        await GoogleMapsNavigator.initializeNavigationSession(
          taskRemovedBehavior: TaskRemovedBehavior.continueService,
        );
      }
      if (mounted) setState(() => _ready = true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to start navigation session')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<void> _startGuidance(GoogleNavigationViewController c) async {
    await c.setMyLocationEnabled(true);

    final booking = widget.assignment.booking;
    final isPickup = booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pickupArrived;

    final status = await GoogleMapsNavigator.setDestinations(
      Destinations(
        waypoints: [
          if (isPickup)
          NavigationWaypoint.withLatLngTarget(
            title: 'Pickup Location',
            target: LatLng(latitude: booking.pickupAddress.latitude, longitude: booking.pickupAddress.longitude),
          ),
          NavigationWaypoint.withLatLngTarget(
            title: 'Drop Location',
            target: LatLng(latitude: booking.dropAddress.latitude, longitude: booking.dropAddress.longitude),
          ),
        ],
        routingOptions: RoutingOptions(
          travelMode: NavigationTravelMode.driving,
        ),
        displayOptions: NavigationDisplayOptions(
          showDestinationMarkers: true,
          showStopSigns: true,
          showTrafficLights: true,
        ),
      ),
    );

    _setupListeners();

    if (status == NavigationRouteStatus.statusOk) {
      if(!await GoogleMapsNavigator.isGuidanceRunning()) {
        await GoogleMapsNavigator.startGuidance();
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route error: $status')),
      );
    }
  }

  Future<void> _setupListeners() async {
    final socket = ref.read(socketServiceProvider);
    final container = ProviderScope.containerOf(context);

    ref.read(_navInfoListenerProvider.notifier).state ??= GoogleMapsNavigator.setNavInfoListener(
      (NavInfoEvent event) {
        container.read(_lastNavInfoProvider.notifier).state = event.navInfo;
        AppLogger.log('nav_info_cached: ${event.navInfo}');
      },
    );

    ref.read(_roadSnappedLocationUpdatedListenerProvider.notifier).state ??= await GoogleMapsNavigator.setRoadSnappedLocationUpdatedListener(
      (RoadSnappedLocationUpdatedEvent event) {
        container.read(_lastRoadSnappedProvider.notifier).state = event.location;
        AppLogger.log('road_snapped_cached: ${event.location}');
      },
    );

    ref.read(_remainingTimeOrDistanceChangedListenerProvider.notifier).state ??= GoogleMapsNavigator.setOnRemainingTimeOrDistanceChangedListener(
      remainingDistanceThresholdMeters: 200, // 200 meters
      remainingTimeThresholdSeconds: 60, // 1 minute
      (RemainingTimeOrDistanceChangedEvent event) {
        final nav = container.read(_lastNavInfoProvider);
        final loc = container.read(_lastRoadSnappedProvider);
        // Build consolidated payload using cached NavInfo and location
        final Map<String, dynamic> payload = {
          // Always include the event-trigger values for telemetry
          'remainingDistance': event.remainingDistance,
          'remainingTime': event.remainingTime,
          // Include cached NavInfo
          'distanceToFinalDestinationMeters': nav?.distanceToFinalDestinationMeters,
          'timeToFinalDestinationSeconds': nav?.timeToFinalDestinationSeconds,
          'distanceToNextDestinationMeters': nav?.distanceToNextDestinationMeters,
          'timeToNextDestinationSeconds': nav?.timeToNextDestinationSeconds,

          // Include cached location
          'latitude': loc?.latitude,
          'longitude': loc?.longitude,
        };
        AppLogger.log('driver_navigation_update: $payload');
        socket.sendMessage('driver_navigation_update', payload);
      },
    );
  }

  Future<void> _cleanup() async {
    // clear listeners
    await ref.read(_navInfoListenerProvider.notifier).state?.cancel();
    await ref.read(_roadSnappedLocationUpdatedListenerProvider.notifier).state?.cancel();
    await ref.read(_remainingTimeOrDistanceChangedListenerProvider.notifier).state?.cancel();
    ref.read(_navInfoListenerProvider.notifier).state = null;
    ref.read(_roadSnappedLocationUpdatedListenerProvider.notifier).state = null;
    ref.read(_remainingTimeOrDistanceChangedListenerProvider.notifier).state = null;

    // Clear cached data
    ref.read(_lastNavInfoProvider.notifier).state = null;
    ref.read(_lastRoadSnappedProvider.notifier).state = null;
  }

  Future<void> _stopAndCleanup() async {
    try {
      await GoogleMapsNavigator.stopGuidance();
    } catch (_) {}
    try {
      await GoogleMapsNavigator.clearDestinations();
    } catch (_) {}
    await _cleanup();
  }

  void _handleNavigationExit() async {
    await _stopAndCleanup();
    if (mounted) Navigator.of(context).pop();
  }

  bool _canExitNavigation(Booking? booking) {
    if(booking == null) return false;
    final disallowedList = [
      BookingStatus.confirmed,
      BookingStatus.pickupArrived,
      BookingStatus.inTransit,
      BookingStatus.dropArrived
    ];
    return !disallowedList.contains(booking.status);
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.assignment.booking;
    final isPickup = booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pickupArrived;
    final title = isPickup ? 'Navigate to Pickup' : 'Navigate to Drop';

    // Watch for assignment updates to get real-time status changes
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.9),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              if(_canExitNavigation(currentAssignmentAsync.value?.booking)) {
                _handleNavigationExit();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          // leading: const SizedBox.shrink(),
          // leadingWidth: 10,
        ),
        body: !_ready
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  SafeArea(
                    child: GoogleMapsNavigationView(
                      onViewCreated: (c) async {
                        // View created; start guidance
                        await _startGuidance(c);
                      },
                    ),
                  ),
                  // Show overlay with current assignment data
                  currentAssignmentAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                    data: (assignment) {
                      if (assignment == null) return const SizedBox.shrink();
                      return NavigationOverlay(
                        assignment: assignment,
                        onNavigationExit: () {
                          final providerContainer = ProviderScope.containerOf(context);
                          _handleNavigationExit();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Future.delayed(const Duration(seconds: 1), () {
                              providerContainer.read(hasShownActionModalProvider.notifier).state = false;
                            });
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
