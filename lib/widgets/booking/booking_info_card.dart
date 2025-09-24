import 'package:flutter/material.dart';
import '../../models/booking.dart';
import '../../models/enums/package_enums.dart';
import '../../models/enums/booking_enums.dart';
import '../../utils/dummy_bookings.dart';

class BookingInfoCard extends StatelessWidget {
  final Booking booking;
  final int remainingSeconds;

  const BookingInfoCard({
    super.key,
    required this.booking,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with earnings and distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildEarningsChip(context),
              _buildDistanceChip(context),
            ],
          ),

          const SizedBox(height: 20),

          // Package info
          _buildPackageInfo(context),

          const SizedBox(height: 20),

          // Route information
          _buildRouteInfo(context),

          const SizedBox(height: 16),

          // Pickup and drop details
          _buildLocationDetails(context),
        ],
      ),
    );
  }

  Widget _buildEarningsChip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.currency_rupee_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            '${booking.estimatedCost.toStringAsFixed(2)}',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceChip(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.route_rounded,
            color: Colors.grey.shade600,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${booking.distanceKm.toStringAsFixed(1)} km',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.packageTypeIcon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPackageTitle(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      booking.formattedWeight,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getVehicleTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getVehicleTypeColor()),
                ),
                child: Text(
                  booking.vehicleTypeDisplayName,
                  style: textTheme.labelMedium?.copyWith(
                    color: _getVehicleTypeColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_getPackageDescription().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _getPackageDescription(),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          'Pickup: ${booking.formattedPickupTime}',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '~${(booking.distanceKm * 2.5).round()} mins',
            style: textTheme.labelSmall?.copyWith(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDetails(BuildContext context) {

    return Column(
      children: [
        // Pickup location
        _buildLocationItem(
          context,
          icon: Icons.trip_origin_rounded,
          iconColor: Colors.green,
          title: 'Pickup',
          address: booking.pickupAddress.formattedAddress,
          details: booking.pickupAddress.addressDetails,
        ),

        // Route line
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Drop location
        _buildLocationItem(
          context,
          icon: Icons.location_on_rounded,
          iconColor: Colors.red,
          title: 'Drop',
          address: booking.dropAddress.formattedAddress,
          details: booking.dropAddress.addressDetails,
        ),
      ],
    );
  }

  Widget _buildLocationItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
    String? details,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
              if (details != null && details.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  details,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getPackageTitle() {
    if (booking.package.productType == ProductType.agricultural) {
      return booking.package.productName ?? 'Agricultural Product';
    } else {
      return booking.package.description ?? 'Package Delivery';
    }
  }

  String _getPackageDescription() {
    if (booking.package.productType == ProductType.agricultural) {
      return 'Agricultural product for ${booking.package.packageType.value.toLowerCase()} use';
    } else {
      final dimensions = booking.package.length != null &&
              booking.package.width != null &&
              booking.package.height != null
          ? '${booking.package.length}×${booking.package.width}×${booking.package.height} ${booking.package.dimensionUnit?.value ?? 'CM'}'
          : '';
      return dimensions.isNotEmpty ? 'Dimensions: $dimensions' : '';
    }
  }

  Color _getVehicleTypeColor() {
    switch (booking.suggestedVehicleType) {
      case VehicleType.twoWheeler:
        return Colors.blue;
      case VehicleType.threeWheeler:
        return Colors.orange;
      case VehicleType.fourWheeler:
        return Colors.green;
    }
  }
}
