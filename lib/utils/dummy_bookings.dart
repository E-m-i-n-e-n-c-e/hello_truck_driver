import 'dart:math' as math;
import '../models/booking.dart';
import '../models/package.dart';
import '../models/address.dart';
import '../models/enums/booking_enums.dart';
import '../models/enums/package_enums.dart';

/// Dummy booking data for testing and development purposes
class DummyBookings {
  static final List<Booking> _dummyBookings = [
    // Agricultural product booking - Rice delivery
    Booking(
      id: 'booking_001',
      package: Package.agricultural(
        packageType: PackageType.commercial,
        productName: 'Basmati Rice',
        approximateWeight: 50.0,
        weightUnit: WeightUnit.kg,
        gstBillUrl: 'https://example.com/gst-bill-001.pdf',
        transportDocUrls: ['https://example.com/transport-doc-001.pdf'],
      ),
      pickupAddress: Address(
        formattedAddress: 'Cornell Dr & Rustad Ln, Mounds View, MN 55112',
        addressDetails: 'Near the community center, main gate',
        latitude: 45.1079,
        longitude: -93.2105,
      ),
      dropAddress: Address(
        formattedAddress: 'Shingle Creek Pkwy & Summit Dr N, Minneapolis, MN 55445',
        addressDetails: 'Building A, Loading dock 3',
        latitude: 45.1342,
        longitude: -93.2775,
      ),
      estimatedCost: 9.86,
      distanceKm: 10.2,
      baseFare: 5.00,
      distanceCharge: 3.06,
      weightMultiplier: 1.2,
      vehicleMultiplier: 1.5,
      suggestedVehicleType: VehicleType.fourWheeler,
      status: BookingStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
    ),

    // Non-agricultural product booking - Electronics
    Booking(
      id: 'booking_002',
      package: Package.nonAgricultural(
        packageType: PackageType.personal,
        averageWeight: 2.5,
        bundleWeight: 2.5,
        length: 40.0,
        width: 30.0,
        height: 15.0,
        dimensionUnit: DimensionUnit.cm,
        numberOfProducts: 1,
        description: 'Laptop computer in original packaging',
        packageImageUrl: 'https://example.com/package-image-002.jpg',
        transportDocUrls: ['https://example.com/transport-doc-002.pdf'],
      ),
      pickupAddress: Address(
        formattedAddress: 'Best Buy, 7601 Penn Ave S, Richfield, MN 55423',
        addressDetails: 'Customer service desk, order #12345',
        latitude: 44.8671,
        longitude: -93.3032,
      ),
      dropAddress: Address(
        formattedAddress: '123 Oak Street, Minneapolis, MN 55404',
        addressDetails: 'Apartment 4B, Ring doorbell',
        latitude: 44.9778,
        longitude: -93.2650,
      ),
      estimatedCost: 15.50,
      distanceKm: 18.5,
      baseFare: 5.00,
      distanceCharge: 7.40,
      weightMultiplier: 1.0,
      vehicleMultiplier: 1.8,
      suggestedVehicleType: VehicleType.fourWheeler,
      status: BookingStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),

    // Small package booking - Documents
    Booking(
      id: 'booking_003',
      package: Package.nonAgricultural(
        packageType: PackageType.commercial,
        averageWeight: 0.5,
        bundleWeight: 0.5,
        length: 25.0,
        width: 18.0,
        height: 5.0,
        dimensionUnit: DimensionUnit.cm,
        numberOfProducts: 1,
        description: 'Legal documents in sealed envelope',
        gstBillUrl: 'https://example.com/gst-bill-003.pdf',
        transportDocUrls: ['https://example.com/transport-doc-003.pdf'],
      ),
      pickupAddress: Address(
        formattedAddress: 'Law Office Building, 150 S 5th St, Minneapolis, MN 55402',
        addressDetails: 'Suite 1200, Reception desk',
        latitude: 44.9778,
        longitude: -93.2650,
      ),
      dropAddress: Address(
        formattedAddress: 'Government Center, 300 S 6th St, Minneapolis, MN 55487',
        addressDetails: 'County Clerk Office, Floor 2',
        latitude: 44.9732,
        longitude: -93.2654,
      ),
      estimatedCost: 8.25,
      distanceKm: 2.1,
      baseFare: 5.00,
      distanceCharge: 1.05,
      weightMultiplier: 1.0,
      vehicleMultiplier: 1.0,
      suggestedVehicleType: VehicleType.twoWheeler,
      status: BookingStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      scheduledAt: DateTime.now().add(const Duration(minutes: 30)),
    ),
  ];

  /// Get all dummy bookings
  static List<Booking> getAllBookings() => List.unmodifiable(_dummyBookings);

  /// Get a random booking for testing
  static Booking getRandomBooking() {
    final random = DateTime.now().millisecondsSinceEpoch % _dummyBookings.length;
    return _dummyBookings[random];
  }

  /// Get booking by ID
  static Booking? getBookingById(String id) {
    try {
      return _dummyBookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get bookings by status
  static List<Booking> getBookingsByStatus(BookingStatus status) {
    return _dummyBookings.where((booking) => booking.status == status).toList();
  }

  /// Get upcoming scheduled bookings
  static List<Booking> getUpcomingBookings() {
    final now = DateTime.now();
    return _dummyBookings
        .where((booking) =>
            booking.scheduledAt != null &&
            booking.scheduledAt!.isAfter(now))
        .toList()
      ..sort((a, b) => a.scheduledAt!.compareTo(b.scheduledAt!));
  }

  /// Get bookings within a certain distance range (for location-based filtering)
  static List<Booking> getBookingsNearby({
    required double currentLatitude,
    required double currentLongitude,
    double maxDistanceKm = 50.0,
  }) {
    return _dummyBookings.where((booking) {
      final pickupDistance = _calculateDistance(
        currentLatitude,
        currentLongitude,
        booking.pickupAddress.latitude,
        booking.pickupAddress.longitude,
      );
      return pickupDistance <= maxDistanceKm;
    }).toList();
  }

  /// Calculate distance between two coordinates (Haversine formula)
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
        math.sin(dLon / 2) * math.sin(dLon / 2);

    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}

/// Extension methods for Booking to add utility functions
extension BookingExtensions on Booking {
  /// Check if booking is scheduled for today
  bool get isScheduledForToday {
    if (scheduledAt == null) return false;
    final now = DateTime.now();
    final scheduled = scheduledAt!;
    return scheduled.year == now.year &&
           scheduled.month == now.month &&
           scheduled.day == now.day;
  }

  /// Get time until scheduled pickup
  Duration? get timeUntilScheduled {
    if (scheduledAt == null) return null;
    final now = DateTime.now();
    return scheduledAt!.difference(now);
  }

  /// Get formatted pickup time
  String get formattedPickupTime {
    if (scheduledAt == null) return 'ASAP';
    final time = scheduledAt!;
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '${hour == 0 ? 12 : hour}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  /// Get package weight in standard format
  String get formattedWeight {
    if (package.productType == ProductType.agricultural) {
      final weight = package.approximateWeight ?? 0;
      final unit = package.weightUnit?.value ?? 'KG';
      return '$weight $unit';
    } else {
      final weight = package.averageWeight ?? 0;
      return '$weight KG';
    }
  }

  /// Get vehicle type display name
  String get vehicleTypeDisplayName {
    switch (suggestedVehicleType) {
      case VehicleType.twoWheeler:
        return 'Bike';
      case VehicleType.threeWheeler:
        return 'Auto';
      case VehicleType.fourWheeler:
        return 'Car/Truck';
    }
  }

  /// Get package type icon
  String get packageTypeIcon {
    if (package.productType == ProductType.agricultural) {
      return '🌾';
    } else {
      return '📦';
    }
  }
}
