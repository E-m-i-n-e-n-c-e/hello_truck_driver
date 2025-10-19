import 'dart:math' as math;
import '../models/booking.dart';
import '../models/package.dart';
import '../models/address.dart';
import '../models/enums/booking_enums.dart';
import '../models/enums/package_enums.dart';

/// Dummy booking data for testing and development purposes
class DummyBookings {
  static final List<Booking> _dummyBookings = [
    // Booking based on @request.http, pickup is Hyderabad, drop is Kerala
    Booking(
      id: 'booking_001',
      bookingNumber: 1,
      package: Package.agricultural(
        packageType: PackageType.commercial,
        productName: 'Basmati Rice',
        approximateWeight: 50.0,
        weightUnit: WeightUnit.kg,
        gstBillUrl: 'https://example.com/gst-bill-001.pdf',
        transportDocUrls: ['https://example.com/transport-doc-001.pdf'],
      ),
      pickupAddress: Address(
        contactName: 'John Doe',
        contactPhone: '1234567890',
        formattedAddress: 'Rama Bhaathi Nilayam, Plot 122/A, 301, Moti Nagar Phase III, Kalyan Nagar, Moti Nagar, Hyderabad, Telangana 500114, India',
        addressDetails: '',
        latitude: 17.4510495,
        longitude: 78.42151087,
      ),
      dropAddress: Address(
        contactName: 'Jane Doe',
        contactPhone: '0987654321',
        formattedAddress: 'QJ4X+G6, Vallichira, Nechipuzhoor, Kerala 686635, India',
        addressDetails: '',
        latitude: 9.7560312,
        longitude: 76.6479833,
      ),
      estimatedCost: 1000,
      distanceKm: 877,
      baseFare: 100,
      distanceCharge: 3.06,
      weightMultiplier: 1.2,
      vehicleMultiplier: 1.5,
      suggestedVehicleType: VehicleType.fourWheeler,
      status: BookingStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      scheduledAt: DateTime.now().add(const Duration(hours: 2)),
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
