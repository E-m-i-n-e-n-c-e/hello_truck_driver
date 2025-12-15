import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/screens/driver_navigation_screen.dart';
import 'package:hello_truck_driver/widgets/finish_ride_modal.dart';

final isActionModalOpenProvider = StateProvider<bool>((ref) => false);

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
  });
}

void showActionModal(BuildContext context, BookingAssignment assignment, WidgetRef ref) {
  final booking = assignment.booking;

  // Check if modal is already being shown
  if (ref.read(isActionModalOpenProvider)) {
    return;
  }

  // If booking is completed, show finish ride modal instead
  if (booking.status == BookingStatus.dropVerified) {
    showFinishRideModal(context, assignment, whenComplete: () {
      ref.read(isActionModalOpenProvider.notifier).state = false;
    });
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

  // Mark modal as open
  ref.read(isActionModalOpenProvider.notifier).state = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _NavigationContent(assignment: assignment),
      ),
    ),
  ).whenComplete(() {
    ref.read(isActionModalOpenProvider.notifier).state = false;
  });
}

class _NavigationContent extends ConsumerWidget {
  final BookingAssignment assignment;

  const _NavigationContent({required this.assignment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final currentAssigment = ref.watch(currentAssignmentProvider).value ?? assignment;
    final booking = currentAssigment.booking;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      navigationInfo.title,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Booking #${booking.bookingNumber}',
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: cs.onSurface.withValues(alpha: 0.6),
                  size: 26,
                ),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Package Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Package',
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getPackageTitle(package),
                        style: tt.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getFormattedWeight(package),
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Location Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: navigationInfo.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    navigationInfo.locationIcon,
                    color: navigationInfo.color,
                    size: 18,
                  ),
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
                      const SizedBox(height: 6),
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
                        const SizedBox(height: 6),
                        Text(
                          booking.pickupAddress.addressDetails!,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                            height: 1.3,
                          ),
                        ),
                      ] else if (!navigationInfo.isPickup && (booking.dropAddress.addressDetails?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 6),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.straighten_rounded, size: 18, color: cs.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  '${booking.distanceKm.toStringAsFixed(1)} km',
                  style: tt.titleSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Button
          if (navigationInfo.showButton)
            FilledButton(
              onPressed: () async {
                  // Start ride if pickup is verified
                  if(booking.status == BookingStatus.pickupVerified) {
                    final api = await ref.read(apiProvider.future);
                    await startRide(api);
                    ref.invalidate(currentAssignmentProvider);
                  }
                  if (!context.mounted) return;
                  // Close modal and open in-app Google Maps navigation screen
                  Navigator.pop(context);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DriverNavigationScreen(
                        assignment: currentAssigment,
                      ),
                    ),
                  );
              },
              style: FilledButton.styleFrom(
                backgroundColor: navigationInfo.color,
                foregroundColor: cs.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
                      fontWeight: FontWeight.w800,
                      color: cs.onPrimary,
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
          color: Colors.red,
          isPickup: false,
          showButton: true,
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
        );
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
    final weight = package.approximateWeight;
    final unit = package.weightUnit.value;
    return '$weight $unit';
  }
}
