import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/package.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/services/navigation_service.dart';
import 'package:hello_truck_driver/screens/driver_navigation_screen.dart';
import 'package:hello_truck_driver/widgets/finish_ride_modal.dart';

class NavigationInfo {
  final String title;
  final String locationTitle;
  final IconData locationIcon;
  final String buttonText;
  final IconData buttonIcon;
  final IconData icon;
  final Color color;
  final bool isPickup;
  final bool showButton;
  final bool isCompleteAction;

  const NavigationInfo({
    required this.title,
    required this.locationTitle,
    required this.locationIcon,
    required this.buttonText,
    required this.buttonIcon,
    required this.icon,
    required this.color,
    required this.isPickup,
    required this.showButton,
    required this.isCompleteAction,
  });
}

void showNavigationModal(BuildContext context, BookingAssignment assignment) {
  final booking = assignment.booking;

  // If booking is completed, show finish ride modal instead
  if (booking.status == BookingStatus.completed) {
    showFinishRideModal(context, assignment);
    return;
  }

  // Check if booking is in a valid state for navigation
  final validStates = [
    BookingStatus.confirmed,
    BookingStatus.pickupArrived,
    BookingStatus.pickupVerified,
    BookingStatus.inTransit,
    BookingStatus.dropArrived,
    BookingStatus.dropVerified,
  ];

  if (!validStates.contains(booking.status)) {
    // Return early for invalid states
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _NavigationContent(assignment: assignment),
      ),
    ),
  );
}

class _NavigationContent extends ConsumerWidget {
  final BookingAssignment assignment;

  const _NavigationContent({required this.assignment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final booking = assignment.booking;
    final package = booking.package;

    // Determine navigation type based on booking status
    final navigationInfo = _getNavigationInfo(booking.status);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: navigationInfo.color.withValues(alpha: 0.15),
                ),
                child: Icon(navigationInfo.icon, color: navigationInfo.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      navigationInfo.title,
                      style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Booking • ${booking.id}',
                      style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: cs.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Package Info
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _getPackageIcon(package),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPackageTitle(package),
                        style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getFormattedWeight(package),
                        style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Location Section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: navigationInfo.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(navigationInfo.locationIcon, color: navigationInfo.color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        navigationInfo.locationTitle,
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        navigationInfo.isPickup
                            ? booking.pickupAddress.formattedAddress
                            : booking.dropAddress.formattedAddress,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                      if (navigationInfo.isPickup && (booking.pickupAddress.addressDetails?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 4),
                        Text(
                          booking.pickupAddress.addressDetails!,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                            height: 1.3,
                          ),
                        ),
                      ] else if (!navigationInfo.isPickup && (booking.dropAddress.addressDetails?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 4),
                        Text(
                          booking.dropAddress.addressDetails!,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Distance Info
          Row(
            children: [
              Expanded(
                child: _infoChip(
                  context,
                  icon: Icons.straighten,
                  label: '${booking.distanceKm.toStringAsFixed(1)} km',
                  color: cs.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Button
          if (navigationInfo.showButton)
            ElevatedButton(
              onPressed: () async {
                if (navigationInfo.isCompleteAction) {
                  // Handle complete ride action
                  Navigator.pop(context);
                  final api = await ref.read(apiProvider.future);
                  await finishRide(api);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Ride completed Successfully!'),
                      backgroundColor: navigationInfo.color,
                    ),
                  );
                } else {
                  // Close modal and open in-app Google Maps navigation screen
                  Navigator.pop(context);
                  // Stop any existing headless guidance to avoid stuck notification
                  await NavigationService.stopNavigation();
                  // Start ride if pickup is verified
                  if(assignment.booking.status == BookingStatus.pickupVerified) {
                    final api = await ref.read(apiProvider.future);
                    await startRide(api);
                  }
                  if (!context.mounted) return;
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DriverNavigationScreen(
                        assignment: assignment,
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: navigationInfo.color,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: navigationInfo.color.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(navigationInfo.buttonIcon, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    navigationInfo.buttonText,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Close',
              style: tt.labelLarge?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  NavigationInfo _getNavigationInfo(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
      case BookingStatus.pickupArrived:
        return NavigationInfo(
          title: 'Navigate to Pickup',
          locationTitle: 'Pickup Location',
          locationIcon: Icons.trip_origin_rounded,
          buttonText: 'Navigate to Pickup',
          buttonIcon: Icons.navigation_rounded,
          icon: Icons.navigation_rounded,
          color: Colors.green,
          isPickup: true,
          showButton: true,
          isCompleteAction: false,
        );

      case BookingStatus.pickupVerified:
      case BookingStatus.inTransit:
      case BookingStatus.dropArrived:
        return NavigationInfo(
          title: 'Navigate to Drop',
          locationTitle: 'Drop Location',
          locationIcon: Icons.location_on_rounded,
          buttonText: 'Navigate to Drop',
          buttonIcon: Icons.navigation_rounded,
          icon: Icons.navigation_rounded,
          color: Colors.blue,
          isPickup: false,
          showButton: true,
          isCompleteAction: false,
        );

      case BookingStatus.dropVerified:
        return NavigationInfo(
          title: 'Complete Ride',
          locationTitle: 'Drop Location',
          locationIcon: Icons.location_on_rounded,
          buttonText: 'Complete Ride',
          buttonIcon: Icons.check_circle_rounded,
          icon: Icons.check_circle_rounded,
          color: Colors.purple,
          isPickup: false,
          showButton: true,
          isCompleteAction: true,
        );

      default:
        return NavigationInfo(
          title: 'Navigation',
          locationTitle: 'Location',
          locationIcon: Icons.location_on_rounded,
          buttonText: 'Navigate',
          buttonIcon: Icons.navigation_rounded,
          icon: Icons.navigation_rounded,
          color: Colors.grey,
          isPickup: true,
          showButton: false,
          isCompleteAction: false,
        );
    }
  }

  Widget _infoChip(BuildContext context, {required IconData icon, required String label, required Color color}) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: tt.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getPackageIcon(Package package) {
    if (package.productType.value == 'AGRICULTURAL') {
      return '🌾';
    } else {
      return '📦';
    }
  }

  String _getPackageTitle(Package package) {
    if (package.productType.value == 'AGRICULTURAL') {
      return package.productName ?? 'Agricultural Product';
    } else {
      return package.description ?? 'Package Delivery';
    }
  }

  String _getFormattedWeight(Package package) {
    if (package.productType.value == 'AGRICULTURAL') {
      final weight = package.approximateWeight ?? 0;
      final unit = package.weightUnit?.value ?? 'KG';
      return '$weight $unit';
    } else {
      final weight = package.averageWeight ?? 0;
      return '$weight KG';
    }
  }
}
