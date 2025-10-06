import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/models/package.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/utils/dummy_bookings.dart';
import 'package:hello_truck_driver/widgets/action_modal.dart';

class RidesScreen extends ConsumerStatefulWidget {
  const RidesScreen({super.key});

  @override
  ConsumerState<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends ConsumerState<RidesScreen> {
  bool _toggling = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final driverAsync = ref.watch(driverProvider);
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Subtle gradient background for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _frostedHeader(context, textTheme),
                  const SizedBox(height: 16),
                  driverAsync.when(
                    loading: () => _availabilitySkeleton(context),
                    error: (_, _) => _availabilitySkeleton(context),
                    data: (driver) {
                      final hasActiveRide = currentAssignmentAsync.hasValue &&
                          currentAssignmentAsync.value?.status == AssignmentStatus.accepted;
                      final isOnRide = driver.driverStatus == DriverStatus.onRide;
                      if (hasActiveRide || isOnRide) {
                        return const SizedBox.shrink();
                      }
                      return _availabilityCard(
                        context,
                        isAvailable: driver.driverStatus == DriverStatus.available,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _ridesBody(context, textTheme)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _frostedHeader(BuildContext context, TextTheme textTheme) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.local_shipping_rounded, color: cs.primary),
              const SizedBox(width: 12),
              Text('Rides', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _availabilitySkeleton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 78,
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _availabilityCard(BuildContext context, {required bool isAvailable}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isAvailable ? Colors.green : cs.secondary).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: (isAvailable ? Colors.green : cs.secondary).withValues(alpha: 0.15),
                ),
                child: Icon(
                  isAvailable ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: isAvailable ? Colors.green : cs.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAvailable ? 'Available for rides' : 'Unavailable',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAvailable
                          ? 'You will receive new ride offers.'
                          : 'Go available to start receiving offers.',
                      style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: isAvailable,
                onChanged: _toggling
                    ? null
                    : (v) async {
                        setState(() => _toggling = true);
                        try {
                          final api = await ref.read(apiProvider.future);
                          await driver_api.updateDriverStatus(api, isAvailable: v);
                          // if available, mark as ready prompt seen
                          if(v) {
                            await markAsReadyPromptSeen(ref);
                          }
                          // Refresh driver profile
                          ref.invalidate(driverProvider);
                          if (context.mounted) {
                            SnackBars.success(context, v ? 'You are now available' : 'You are now unavailable');
                          }
                        } catch (e) {
                          if (context.mounted) SnackBars.error(context, 'Failed to update status');
                        } finally {
                          if (mounted) setState(() => _toggling = false);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ridesBody(BuildContext context, TextTheme textTheme) {
    final cs = Theme.of(context).colorScheme;
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);
    final historyAsync = ref.watch(assignmentHistoryProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(currentAssignmentProvider);
        ref.invalidate(assignmentHistoryProvider);
        await Future.wait([
          ref.read(currentAssignmentProvider.future).catchError((_) => null),
          ref.read(assignmentHistoryProvider.future).catchError((_) => <BookingAssignment>[]),
        ]);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Active Ride
          currentAssignmentAsync.when(
            loading: () => _frostedTile(context,
                title: 'Active Ride',
                subtitle: 'Loading active ride...',
                icon: Icons.directions_car_filled_rounded,
                accent: cs.primary),
            error: (_, _) => _frostedTile(context,
                title: 'Active Ride',
                subtitle: 'Could not load active ride',
                icon: Icons.directions_car_filled_rounded,
                accent: cs.error),
            data: (assignment) {
              if (assignment == null) {
                return _frostedTile(context,
                    title: 'Active Ride',
                    subtitle: 'No active rides',
                    icon: Icons.directions_car_filled_rounded,
                    accent: cs.primary);
              }
              return _activeRideTile(context, assignment);
            },
          ),
          const SizedBox(height: 12),

          // History
          historyAsync.when(
            loading: () => _frostedTile(context,
                title: 'Ride History',
                subtitle: 'Loading history...',
                icon: Icons.history_rounded,
                accent: cs.secondary),
            error: (_, _) => _frostedTile(context,
                title: 'Ride History',
                subtitle: 'Could not load history',
                icon: Icons.history_rounded,
                accent: cs.error),
            data: (items) {
              if (items.isEmpty) {
                return _frostedTile(context,
                    title: 'Ride History',
                    subtitle: 'Your past rides will appear here',
                    icon: Icons.history_rounded,
                    accent: cs.secondary);
              }
              return _historyList(context, items);
            },
          ),
        ],
      ),
    );
  }

  Widget _frostedTile(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color accent}) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: accent.withValues(alpha: 0.06),
            border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accent.withValues(alpha: 0.15),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _activeRideTile(BuildContext context, BookingAssignment assignment) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final booking = assignment.booking;
    final package = booking.package;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: cs.primary.withValues(alpha: 0.06),
            border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: cs.primary.withValues(alpha: 0.15),
                    ),
                    child: Icon(Icons.directions_car_filled_rounded, color: cs.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Active Ride', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Booking • ${booking.id}', style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: cs.primary.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      booking.status.value.replaceAll('_', ' '),
                      style: tt.labelSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Package Details Section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outline.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getPackageIcon(package),
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 10),
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
                    if (_getPackageDescription(package).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _getPackageDescription(package),
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Pickup Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.trip_origin_rounded, size: 18, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pickup', style: tt.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.6))),
                        Text(booking.pickupAddress.formattedAddress, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Drop Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_rounded, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Drop', style: tt.labelSmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.6))),
                        Text(booking.dropAddress.formattedAddress, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Distance and Cost Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(context, icon: Icons.straighten, label: '${booking.distanceKm.toStringAsFixed(1)} km'),
                  _chip(context, icon: Icons.payments, label: '₹${booking.finalCost?.toStringAsFixed(2) ?? booking.estimatedCost.toStringAsFixed(2)}'),
                  if (booking.scheduledAt != null)
                    _chip(context, icon: Icons.schedule, label: booking.formattedPickupTime),
                ],
              ),
              const SizedBox(height: 16),

              // Dynamic Action Button
              _buildActionButton(context, assignment, tt),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, BookingAssignment assignment, TextTheme tt) {
    final booking = assignment.booking;

    // Determine button properties based on booking status
    String buttonText;
    IconData buttonIcon;
    Color buttonColor;

    switch (booking.status) {
      case BookingStatus.confirmed:
      case BookingStatus.pickupArrived:
        buttonText = 'Navigate to Pickup';
        buttonIcon = Icons.navigation_rounded;
        buttonColor = Colors.green;
        break;
      case BookingStatus.pickupVerified:
      case BookingStatus.inTransit:
      case BookingStatus.dropArrived:
        buttonText = 'Navigate to Drop';
        buttonIcon = Icons.navigation_rounded;
        buttonColor = Colors.blue;
        break;
      case BookingStatus.dropVerified:
        buttonText = 'Complete Ride';
        buttonIcon = Icons.check_circle_rounded;
        buttonColor = Colors.purple;
        break;
      default:
        // For other statuses, don't show button
        return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => showActionModal(context, assignment),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: buttonColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(buttonIcon, size: 20),
          const SizedBox(width: 8),
          Text(
            buttonText,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
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

  String _getPackageDescription(Package package) {
    if (package.productType.value == 'AGRICULTURAL') {
      return 'Agricultural product for ${package.packageType.value.toLowerCase()} use';
    } else {
      final dimensions = package.length != null &&
              package.width != null &&
              package.height != null
          ? '${package.length}×${package.width}×${package.height} ${package.dimensionUnit?.value ?? 'CM'}'
          : '';
      return dimensions.isNotEmpty ? 'Dimensions: $dimensions' : '';
    }
  }

  Widget _historyList(BuildContext context, List<BookingAssignment> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final assignment in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _historyTile(context, assignment),
          ),
      ],
    );
  }

  Widget _historyTile(BuildContext context, BookingAssignment assignment) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final booking = assignment.booking;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: cs.secondary.withValues(alpha: 0.06),
            border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cs.secondary.withValues(alpha: 0.15),
                ),
                child: const Icon(Icons.history_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking • ${booking.id}', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('${booking.pickupAddress.formattedAddress} → ${booking.dropAddress.formattedAddress}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _chip(context, icon: Icons.straighten, label: '${booking.distanceKm.toStringAsFixed(1)} km'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, {required IconData icon, required String label}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        border: Border.all(color: cs.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(label, style: tt.labelSmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ),
    );
  }
}


