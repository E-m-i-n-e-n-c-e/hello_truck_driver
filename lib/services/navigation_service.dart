import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:hello_truck_driver/utils/logger.dart';

class NavigationService {
  static bool _isInitialized = false;

  /// Initialize Google Navigation SDK
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Check if terms are accepted
      if (!await GoogleMapsNavigator.areTermsAccepted()) {
        await GoogleMapsNavigator.showTermsAndConditionsDialog(
          'Hello Truck Navigation',
          'Hello Truck',
        );
      }

      // Initialize navigation session
      await GoogleMapsNavigator.initializeNavigationSession(
        taskRemovedBehavior: TaskRemovedBehavior.quitService,
      );

      _isInitialized = await GoogleMapsNavigator.isInitialized();
      AppLogger.log('Navigation SDK initialized: $_isInitialized');
      return _isInitialized;
    } catch (e) {
      AppLogger.log('Failed to initialize Navigation SDK: $e');
      return false;
    }
  }

  /// Start navigation to a destination
  static Future<bool> startNavigation({
    required double latitude,
    required double longitude,
    required String destinationName,
  }) async {
    try {
      if (!_isInitialized) {
        final initialized = await initialize();
        if (!initialized) return false;
      }

      // Create waypoint for destination
      final waypoint = NavigationWaypoint.withLatLngTarget(
        title: destinationName,
        target: LatLng(
          latitude: latitude,
          longitude: longitude,
        ),
      );

      // Create destinations object
      final destinations = Destinations(
        waypoints: [waypoint],
        routingOptions: RoutingOptions(travelMode: NavigationTravelMode.driving),
        displayOptions: NavigationDisplayOptions(
          showDestinationMarkers: true,
          showStopSigns: true,
          showTrafficLights: true,
        ),
      );

      // Set destinations and start navigation
      final routeStatus = await GoogleMapsNavigator.setDestinations(destinations);

      if (routeStatus == NavigationRouteStatus.statusOk) {
        await GoogleMapsNavigator.startGuidance();
        AppLogger.log('Navigation started to: $destinationName');
        return true;
      } else {
        AppLogger.log('Failed to create route: $routeStatus');
        return false;
      }
    } catch (e) {
      AppLogger.log('Failed to start navigation: $e');
      return false;
    }
  }

  /// Stop navigation
  static Future<void> stopNavigation() async {
    try {
      await GoogleMapsNavigator.stopGuidance();
      AppLogger.log('Navigation stopped');
    } catch (e) {
      AppLogger.log('Failed to stop navigation: $e');
    }
  }

  /// Check if navigation is running
  static Future<bool> isNavigationRunning() async {
    try {
      return await GoogleMapsNavigator.isGuidanceRunning();
    } catch (e) {
      AppLogger.log('Failed to check navigation status: $e');
      return false;
    }
  }

  /// Cleanup navigation resources
  static Future<void> cleanup() async {
    try {
      await GoogleMapsNavigator.cleanup();
      _isInitialized = false;
      AppLogger.log('Navigation SDK cleaned up');
    } catch (e) {
      AppLogger.log('Failed to cleanup navigation: $e');
    }
  }
}
