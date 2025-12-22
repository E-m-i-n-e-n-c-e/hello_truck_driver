import 'enums/booking_enums.dart';
import 'enums/package_enums.dart';

/// Booking model matching BookingResponseDto from server
class Booking {
  final String id;
  final int bookingNumber;
  final BookingAddress pickupAddress;
  final BookingAddress dropAddress;
  final Package package;
  final List<Invoice>? invoices;
  final BookingStatus status;
  final String? assignedDriverId;
  final AssignedDriver? assignedDriver;
  final DateTime? acceptedAt;
  final DateTime? pickupArrivedAt;
  final DateTime? pickupVerifiedAt;
  final DateTime? dropArrivedAt;
  final DateTime? dropVerifiedAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? scheduledAt;

  const Booking({
    required this.id,
    required this.bookingNumber,
    required this.pickupAddress,
    required this.dropAddress,
    required this.package,
    this.invoices,
    required this.status,
    this.assignedDriverId,
    this.assignedDriver,
    this.acceptedAt,
    this.pickupArrivedAt,
    this.pickupVerifiedAt,
    this.dropArrivedAt,
    this.dropVerifiedAt,
    this.completedAt,
    this.cancelledAt,
    this.cancellationReason,
    required this.createdAt,
    required this.updatedAt,
    this.scheduledAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      bookingNumber: json['bookingNumber'],
      pickupAddress: BookingAddress.fromJson(json['pickupAddress']),
      dropAddress: BookingAddress.fromJson(json['dropAddress']),
      package: Package.fromJson(json['package']),
      invoices: json['invoices'] != null
          ? (json['invoices'] as List<dynamic>)
              .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      status: BookingStatus.fromString(json['status'] ?? 'PENDING'),
      assignedDriverId: json['assignedDriverId'],
      assignedDriver: json['assignedDriver'] != null
          ? AssignedDriver.fromJson(json['assignedDriver'])
          : null,
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.parse(json['acceptedAt'])
          : null,
      pickupArrivedAt: json['pickupArrivedAt'] != null
          ? DateTime.parse(json['pickupArrivedAt'])
          : null,
      pickupVerifiedAt: json['pickupVerifiedAt'] != null
          ? DateTime.parse(json['pickupVerifiedAt'])
          : null,
      dropArrivedAt: json['dropArrivedAt'] != null
          ? DateTime.parse(json['dropArrivedAt'])
          : null,
      dropVerifiedAt: json['dropVerifiedAt'] != null
          ? DateTime.parse(json['dropVerifiedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      cancellationReason: json['cancellationReason'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : null,
    );
  }

  /// Get the estimate invoice if available
  Invoice? get estimateInvoice {
    if (invoices == null || invoices!.isEmpty) return null;
    try {
      return invoices!.firstWhere((inv) => inv.type == InvoiceType.estimate);
    } catch (_) {
      return null;
    }
  }

  /// Get the final invoice if available
  Invoice? get finalInvoice {
    if (invoices == null || invoices!.isEmpty) return null;
    try {
      return invoices!.firstWhere((inv) => inv.type == InvoiceType.final_);
    } catch (_) {
      return null;
    }
  }

  /// Get estimated cost from estimate invoice
  double get estimatedCost => estimateInvoice?.totalPrice ?? finalInvoice?.totalPrice ?? 0.0;

  /// Get final cost from final invoice (total service cost, NOT customer's payment after wallet)
  double? get finalCost => finalInvoice?.totalPrice;

  /// Get the distance from the final invoice or estimate
  double get distanceKm => finalInvoice?.distanceKm ?? estimateInvoice?.distanceKm ?? 0.0;

  /// Get package type icon based on product type
  String get packageTypeIcon {
    switch (package.productType) {
      case ProductType.personal:
        return '📦';
      case ProductType.agricultural:
        return '🌾';
      case ProductType.nonAgricultural:
        return '🏭';
    }
  }

  /// Get formatted weight string
  String get formattedWeight {
    final weight = package.approximateWeight;
    final unit = package.weightUnit.value;
    return '$weight $unit';
  }

  /// Get vehicle type display name from invoice
  String get vehicleTypeDisplayName {
    return finalInvoice?.vehicleModelName ?? estimateInvoice?.vehicleModelName ?? 'Vehicle';
  }

  /// Get formatted pickup time
  String get formattedPickupTime {
    // Todo: Handle scheduled bookings
    return 'Now';
  }
}

/// Assigned driver info matching DriverResponseDto
class AssignedDriver {
  final String phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? photo;
  final int score;

  const AssignedDriver({
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
    required this.score,
  });

  factory AssignedDriver.fromJson(Map<String, dynamic> json) {
    return AssignedDriver(
      phoneNumber: json['phoneNumber'] ?? '',
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      photo: json['photo'],
      score: json['score'] ?? 0,
    );
  }

  String get fullName {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return '$first $last'.trim();
  }
}

/// Booking address matching BookingAddressResponseDto
class BookingAddress {
  final String? addressName;
  final String contactName;
  final String contactPhone;
  final String? noteToDriver;
  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String? addressDetails;

  const BookingAddress({
    this.addressName,
    required this.contactName,
    required this.contactPhone,
    this.noteToDriver,
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.addressDetails,
  });

  factory BookingAddress.fromJson(Map<String, dynamic> json) {
    return BookingAddress(
      addressName: json['addressName'],
      contactName: json['contactName'] ?? '',
      contactPhone: json['contactPhone'] ?? '',
      noteToDriver: json['noteToDriver'],
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      formattedAddress: json['formattedAddress'] ?? '',
      addressDetails: json['addressDetails'],
    );
  }
}

/// Package details matching PackageDetailsResponseDto from server
class Package {
  final String? id;
  final ProductType productType;
  final double approximateWeight;
  final WeightUnit weightUnit;

  // Product name (for PERSONAL and AGRICULTURAL)
  final String? productName;

  // Non-Agricultural fields
  final double? bundleWeight;
  final int? numberOfProducts;
  final double? length;
  final double? width;
  final double? height;
  final DimensionUnit? dimensionUnit;
  final String? description;

  // Common optional fields
  final String? packageImageUrl;
  final List<String> transportDocUrls;
  final String? gstBillUrl;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Package({
    this.id,
    required this.productType,
    required this.approximateWeight,
    required this.weightUnit,
    this.productName,
    this.bundleWeight,
    this.numberOfProducts,
    this.length,
    this.width,
    this.height,
    this.dimensionUnit,
    this.description,
    this.packageImageUrl,
    this.transportDocUrls = const [],
    this.gstBillUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      id: json['id'],
      productType: ProductType.fromString(json['productType'] ?? 'PERSONAL'),
      approximateWeight: (json['approximateWeight'] ?? 0).toDouble(),
      weightUnit: WeightUnit.fromString(json['weightUnit'] ?? 'KG'),
      productName: json['productName'],
      bundleWeight: json['bundleWeight']?.toDouble(),
      numberOfProducts: json['numberOfProducts']?.toInt(),
      length: json['length']?.toDouble(),
      width: json['width']?.toDouble(),
      height: json['height']?.toDouble(),
      dimensionUnit: json['dimensionUnit'] != null
          ? DimensionUnit.fromString(json['dimensionUnit'])
          : null,
      description: json['description'],
      packageImageUrl: json['packageImageUrl'],
      transportDocUrls: List<String>.from(json['transportDocUrls'] ?? []),
      gstBillUrl: json['gstBillUrl'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// Check if this is a personal package
  bool get isPersonal => productType == ProductType.personal;

  /// Check if this is agricultural
  bool get isAgricultural => productType == ProductType.agricultural;

  /// Check if this is non-agricultural
  bool get isNonAgricultural => productType == ProductType.nonAgricultural;

  /// Check if this is commercial (requires GST)
  bool get isCommercial => productType != ProductType.personal;

  /// Get display name for the package
  String get displayName {
    if (productName != null && productName!.isNotEmpty) {
      return productName!;
    }
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    return productType.value;
  }
}

/// Invoice for a booking
class Invoice {
  final String id;
  final String bookingId;
  final InvoiceType type; // ESTIMATE or FINAL
  final String vehicleModelName;
  final double basePrice;
  final double perKmPrice;
  final double baseKm;
  final double distanceKm;
  final double weightInTons;
  final double effectiveBasePrice;
  final double totalPrice;
  final String? paymentLinkUrl;
  final String? rzpPaymentLinkId;
  final String? rzpPaymentId;
  final bool isPaid;
  final DateTime? paidAt;
  final String? paymentMethod;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Invoice({
    required this.id,
    required this.bookingId,
    required this.type,
    required this.vehicleModelName,
    required this.basePrice,
    required this.perKmPrice,
    required this.baseKm,
    required this.distanceKm,
    required this.weightInTons,
    required this.effectiveBasePrice,
    required this.totalPrice,
    this.paymentLinkUrl,
    this.rzpPaymentLinkId,
    this.rzpPaymentId,
    this.isPaid = false,
    this.paidAt,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      type: InvoiceType.fromString(json['type'] ?? 'ESTIMATE'),
      vehicleModelName: json['vehicleModelName'] ?? '',
      basePrice: (json['basePrice'] ?? 0).toDouble(),
      perKmPrice: (json['perKmPrice'] ?? 0).toDouble(),
      baseKm: (json['baseKm'] ?? 0).toDouble(),
      distanceKm: (json['distanceKm'] ?? 0).toDouble(),
      weightInTons: (json['weightInTons'] ?? 0).toDouble(),
      effectiveBasePrice: (json['effectiveBasePrice'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      paymentLinkUrl: json['paymentLinkUrl'],
      rzpPaymentLinkId: json['rzpPaymentLinkId'],
      rzpPaymentId: json['rzpPaymentId'],
      isPaid: json['isPaid'] ?? false,
      paidAt: json['paidAt'] != null
          ? DateTime.parse(json['paidAt'])
          : null,
      paymentMethod: json['paymentMethod'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
