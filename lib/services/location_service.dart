import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:hello_truck_driver/services/google_places_service.dart';

enum LocationPermissionStatus {
  denied,
  deniedForever,
  granted,
  disabled,
}

class AddressDetails {
  final String addressLine1;
  final String landmark;
  final String pincode;
  final String city;
  final String district;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final String formattedAddress;

  AddressDetails({
    required this.addressLine1,
    required this.landmark,
    required this.pincode,
    required this.city,
    required this.district,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });

  // Optional: A fallback factory constructor for unknown address
  factory AddressDetails.unknown({
    required double latitude,
    required double longitude,
  }) {
    return AddressDetails(
      addressLine1: 'Unknown Address',
      landmark: '',
      pincode: '',
      city: '',
      district: '',
      state: '',
      country: '',
      latitude: latitude,
      longitude: longitude,
      formattedAddress: 'Unknown Address',
    );
  }
}

class LocationService {
  // Platform-specific location settings
  static LocationSettings get _locationSettings {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
        forceLocationManager: false,
        intervalDuration: const Duration(seconds: 5),
        // Enable background location for Android
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "HelloTruck is tracking your location",
          notificationTitle: "Location Active",
          enableWakeLock: true,
        ),
      );
    } else if (Platform.isIOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
        activityType: ActivityType.automotiveNavigation,
        pauseLocationUpdatesAutomatically: false,
        showBackgroundLocationIndicator: true,
        allowBackgroundLocationUpdates: true,
      );
    }
    // Default fallback
    return const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );
  }

  // Stream of current position
  Stream<Position> get positionStream => Geolocator.getPositionStream(
        locationSettings: _locationSettings,
      );

  // Get current position once
  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Check and request location permissions
  Future<LocationPermissionStatus> checkAndRequestPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.disabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionStatus.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionStatus.deniedForever;
    }

    return LocationPermissionStatus.granted;
  }

  // Get address from LatLng
  Future<AddressDetails> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final address = await GooglePlacesService.getAddressFromLatLng(latitude, longitude);

      if (address.isNotEmpty) {
        final addressParts = (address['formattedAddress'] ?? '').split(',');
        final addressLine1 = addressParts.length > 3
            ? addressParts.take(addressParts.length - 3).join(',').trim()
            : (address['formattedAddress'] ?? '').trim();
        return AddressDetails(
          addressLine1: addressLine1,
          landmark: address['sublocality'] ??
              address['sublocalityLevel1'] ??
              address['sublocalityLevel2'] ??
              address['sublocalityLevel3'] ??
              '',
          pincode: address['postalCode'] ?? '',
          city: address['locality'] ?? '',
          district: address['administrativeAreaLevel2'] ?? address['administrativeAreaLevel3'] ?? '',
          state: address['administrativeAreaLevel1'] ?? '',
          country: address['country'] ?? '',
          latitude: latitude,
          longitude: longitude,
          formattedAddress: address['formattedAddress'] ?? '',
        );
      }
    } catch (e) {
      // Handle error silently
    }

    // Return default values if geocoding fails
    return AddressDetails.unknown(
      latitude: latitude,
      longitude: longitude,
    );
  }
}