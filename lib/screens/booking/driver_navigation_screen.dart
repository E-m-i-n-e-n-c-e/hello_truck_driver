import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/providers/socket_providers.dart';
import 'package:hello_truck_driver/widgets/navigation_overlay.dart';

import '../../utils/logger.dart';

final _navInfoListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final _roadSnappedLocationUpdatedListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final _remainingTimeOrDistanceChangedListenerProvider = StateProvider<StreamSubscription?>((ref) => null);
final _lastNavInfoProvider = StateProvider<NavInfo?>((ref) => null);
final _lastRoadSnappedProvider = StateProvider<LatLng?>((ref) => null);
final _cachedRouteProvider = StateProvider<String?>((ref) => null);

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
          showDestinationMarkers: false,
          showStopSigns: true,
          showTrafficLights: true,
        ),
      ),
    );

    // Cache the route polyline for sending with location updates
    await _cacheRoutePolyline();

    _setupListeners();

    if (status == NavigationRouteStatus.statusOk) {
      // Add simple pickup/drop markers using default icons and info windows.
      await c.addMarkers([
        if (isPickup)
          MarkerOptions(
            position: LatLng(
              latitude: booking.pickupAddress.latitude,
              longitude: booking.pickupAddress.longitude,
            ),
            infoWindow: const InfoWindow(
              title: 'Pickup Location',
            ),
          ),
        if(!isPickup)
        MarkerOptions(
          position: LatLng(
            latitude: booking.dropAddress.latitude,
            longitude: booking.dropAddress.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'Drop Location',
          ),
        ),
      ]);

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

  Future<void> _cacheRoutePolyline() async {
    try {
      final routeSegment = await GoogleMapsNavigator.getCurrentRouteSegment();
      if (routeSegment != null && routeSegment.latLngs != null) {
        // Get the route coordinates from latLngs
        final coordinates = routeSegment.latLngs!
            .where((latLng) => latLng != null)
            .map((latLng) => LatLng(latitude: latLng!.latitude, longitude: latLng.longitude))
            .toList();

        if (coordinates.isNotEmpty) {
          // Encode coordinates using Google polyline algorithm
          final encodedPolyline = _encodePolyline(coordinates);
          ref.read(_cachedRouteProvider.notifier).state = encodedPolyline;
          AppLogger.log('Cached encoded polyline: ${encodedPolyline.length} characters, ${coordinates.length} points');
        }
      }
    } catch (e) {
      AppLogger.log('Failed to cache route polyline: $e');
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
        final routePolyline = container.read(_cachedRouteProvider);

        // Build consolidated payload using cached NavInfo, location, and route
        final Map<String, dynamic> payload = {
          // Include booking id
          'bookingId': widget.assignment.bookingId,
          // Always include the event-trigger values for telemetry
          'remainingDistance': event.remainingDistance,
          'remainingTime': event.remainingTime,
          // Include cached NavInfo
          'distanceToFinalDestinationMeters': nav?.distanceToFinalDestinationMeters,
          'timeToFinalDestinationSeconds': nav?.timeToFinalDestinationSeconds,
          'distanceToNextDestinationMeters': nav?.distanceToNextDestinationMeters,
          'timeToNextDestinationSeconds': nav?.timeToNextDestinationSeconds,
          // Include cached location
          'latitude': loc?.latitude ?? ref.read(currentPositionStreamProvider).value?.latitude,
          'longitude': loc?.longitude ?? ref.read(currentPositionStreamProvider).value?.longitude,
          // Include route polyline
          'routePolyline': routePolyline,
          // Include timestamp
          'sentAt': DateTime.now().toIso8601String(),
        };
        AppLogger.log('driver-navigation-update: ${payload.keys.join(', ')}');
        socket.sendMessage('driver-navigation-update', payload);
      },
    );
  }

  Future<void> _cleanupListenersAndCache() async {
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
    ref.read(_cachedRouteProvider.notifier).state = null;
  }

  /// Encode a list of coordinates using google_polyline_algorithm
  String _encodePolyline(List<LatLng> coordinates) {
    // Convert PointLatLng to List<List<num>> format expected by google_polyline_algorithm
    final List<List<num>> coords = coordinates
        .map((point) => [point.latitude, point.longitude])
        .toList();

    return encodePolyline(coords);
  }

  Future<void> _stopAndCleanup() async {
    try {
      await GoogleMapsNavigator.stopGuidance();
    } catch (_) {}
    try {
      await GoogleMapsNavigator.clearDestinations();
    } catch (_) {}
    await _cleanupListenersAndCache();
  }

  void _handleNavigationExit() async {
    await _stopAndCleanup();
    if (mounted) Navigator.of(context).pop();
  }

  bool _canExitNavigation(Booking? booking) {
    // return true;
    if(booking == null) return false;
    final disallowedList = [
      BookingStatus.confirmed,
      BookingStatus.pickupArrived,
      BookingStatus.inTransit,
      BookingStatus.dropArrived
    ];
    return !disallowedList.contains(booking.status);
  }

  Future<void> _showForceExitDialog() async {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title with inline icon
            Row(
              children: [
                Icon(
                  Icons.warning_rounded,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Force Exit Navigation?',
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'This will stop navigation and location updates',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),

            // Warning Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.orange.shade700,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Consequences:',
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildWarningPoint(cs, tt, 'Navigation updates will stop'),
                  const SizedBox(height: 6),
                  _buildWarningPoint(cs, tt, 'Customer won\'t see your location'),
                  const SizedBox(height: 6),
                  _buildWarningPoint(cs, tt, 'May affect your rating'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: cs.outline.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Exit Anyway',
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (shouldExit == true) {
      _handleNavigationExit();
    }
  }

  Widget _buildWarningPoint(ColorScheme cs, TextTheme tt, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.orange.shade700,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final booking = widget.assignment.booking;
    final isPickup = booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pickupArrived;
    final title = isPickup ? 'Navigating to Pickup' : 'Navigating to Drop';

    // Watch for assignment updates to get real-time status changes
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          actions: [
            InkWell(
              onTap: () {
                if (_canExitNavigation(currentAssignmentAsync.value?.booking)) {
                  _handleNavigationExit();
                } else {
                  Navigator.of(context).pop();
                }
              },
              onLongPress: () {
                // Long-press to force exit with confirmation
                _showForceExitDialog();
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.close_rounded),
              ),
            ),
            const SizedBox(width: 12),
          ],
          leading: const SizedBox.shrink(),
          leadingWidth: 12,
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
