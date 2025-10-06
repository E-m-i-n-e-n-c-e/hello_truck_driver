import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/widgets/navigation_overlay.dart';

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
  bool _started = false;

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
      await GoogleMapsNavigator.initializeNavigationSession(
        taskRemovedBehavior: TaskRemovedBehavior.quitService,
      );
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
    if (_started) return;
    _started = true;

    await c.setMyLocationEnabled(true);

    final booking = widget.assignment.booking;
    final isPickup = booking.status == BookingStatus.confirmed || booking.status == BookingStatus.pickupArrived;
    final targetAddress = isPickup ? booking.pickupAddress : booking.dropAddress;
    final destinationName = isPickup ? 'Pickup Location' : 'Drop Location';

    final status = await GoogleMapsNavigator.setDestinations(
      Destinations(
        waypoints: [
          NavigationWaypoint.withLatLngTarget(
            title: destinationName,
            target: LatLng(latitude: targetAddress.latitude, longitude: targetAddress.longitude),
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

    if (status == NavigationRouteStatus.statusOk) {
      await GoogleMapsNavigator.startGuidance();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route error: $status')),
      );
    }
  }

  Future<void> _stopAndCleanup() async {
    try {
      await GoogleMapsNavigator.stopGuidance();
    } catch (_) {}
    try {
      await GoogleMapsNavigator.cleanup();
    } catch (_) {}
  }

  @override
  void dispose() {
    _stopAndCleanup();
    super.dispose();
  }

  void _handleNavigationExit() async {
    await _stopAndCleanup();
    if (mounted) Navigator.of(context).pop();
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
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _handleNavigationExit,
          ),
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
