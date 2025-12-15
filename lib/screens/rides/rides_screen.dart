import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/widgets/action_modal.dart';

class RidesScreen extends ConsumerStatefulWidget {
  const RidesScreen({super.key});

  @override
  ConsumerState<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends ConsumerState<RidesScreen> with SingleTickerProviderStateMixin {
  bool _toggling = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final driverAsync = ref.watch(driverProvider);
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Rides',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'History'),
              ],
              labelColor: colorScheme.onPrimary,
              unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.6),
              labelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              indicator: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(4),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Availability Card (only show when no active ride)
          driverAsync.when(
            loading: () => const SizedBox(height: 4),
            error: (_, _) => const SizedBox(height: 4),
            data: (driver) {
              final hasActiveRide = currentAssignmentAsync.hasValue &&
                  currentAssignmentAsync.value?.status == AssignmentStatus.accepted;
              final isOnRideOrAssigned = driver.driverStatus == DriverStatus.onRide || driver.driverStatus == DriverStatus.rideOffered;
              if (hasActiveRide || isOnRideOrAssigned) {
                return const SizedBox(height: 4);
              }
              return Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _availabilityCard(
                  context,
                  isAvailable: driver.driverStatus == DriverStatus.available,
                ),
              );
            },
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveRidesList(context),
                _buildHistoryRidesList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveRidesList(BuildContext context) {
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);

    return currentAssignmentAsync.when(
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Failed to load active ride',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => ref.invalidate(currentAssignmentProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (assignment) {
        if (assignment == null) {
          return _buildEmptyState(
            context,
            'No active rides',
            'Your active rides will appear here',
            Icons.directions_car_filled_rounded,
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _activeRideTile(context, assignment),
          ],
        );
      },
    );
  }

  Widget _buildHistoryRidesList(BuildContext context) {
    final historyAsync = ref.watch(assignmentHistoryProvider);

    return historyAsync.when(
      loading: () => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Failed to load ride history',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => ref.invalidate(assignmentHistoryProvider),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return _buildEmptyState(
            context,
            'No ride history',
            'Your completed rides will appear here',
            Icons.history_rounded,
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _historyTile(context, items[index]);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String subtitle, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 64,
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  Widget _availabilityCard(BuildContext context, {required bool isAvailable}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable
              ? Colors.green.withValues(alpha: 0.3)
              : cs.outline.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isAvailable
                  ? Colors.green.withValues(alpha: 0.15)
                  : cs.surfaceContainerHigh,
            ),
            child: Icon(
              isAvailable ? Icons.check_circle_rounded : Icons.do_not_disturb_on_rounded,
              color: isAvailable ? Colors.green : cs.onSurface.withValues(alpha: 0.5),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAvailable ? 'You\'re available' : 'You\'re unavailable',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAvailable
                      ? 'Ready to accept new ride requests'
                      : 'Turn on to start receiving rides',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.scale(
            scale: 0.9,
            child: Switch.adaptive(
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
          ),
        ],
      ),
    );
  }


  Widget _activeRideTile(BuildContext context, BookingAssignment assignment) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final booking = assignment.booking;
    final package = booking.package;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with booking number and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking #${booking.bookingNumber}',
                      style: tt.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getPackageTitle(package),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  booking.status.value.replaceAll('_', ' '),
                  style: tt.labelMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Route section
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Pickup
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trip_origin_rounded,
                        size: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pickup',
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.pickupAddress.formattedAddress,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const SizedBox(width: 14),
                      Container(
                        width: 2,
                        height: 16,
                        decoration: BoxDecoration(
                          color: cs.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),

                // Drop
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 16,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Drop',
                            style: tt.labelSmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            booking.dropAddress.formattedAddress,
                            style: tt.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Info chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(context, icon: Icons.inventory_2_rounded, label: _getFormattedWeight(package)),
              _chip(context, icon: Icons.straighten_rounded, label: '${booking.distanceKm.toStringAsFixed(1)} km'),
              _chip(context, icon: Icons.currency_rupee_rounded, label: booking.finalCost?.toStringAsFixed(0) ?? booking.estimatedCost.toStringAsFixed(0)),
              if (booking.scheduledAt != null)
                _chip(context, icon: Icons.schedule_rounded, label: booking.formattedPickupTime),
            ],
          ),

          const SizedBox(height: 16),

          // Dynamic Action Button
          _buildActionButton(context, assignment, tt),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, BookingAssignment assignment, TextTheme tt) {
    final cs = Theme.of(context).colorScheme;
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
        buttonColor = Colors.red;
        break;
      case BookingStatus.dropVerified:
        buttonText = 'Complete Ride';
        buttonIcon = Icons.check_circle_rounded;
        buttonColor = Colors.green;
        break;
      default:
        // For other statuses, don't show button
        return const SizedBox.shrink();
    }

    return ElevatedButton(
      onPressed: () => showActionModal(context, assignment, ref),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: cs.onPrimary,
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
              color: cs.onPrimary,
            ),
          ),
        ],
      ),
    );
  }


  Widget _historyTile(BuildContext context, BookingAssignment assignment) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final booking = assignment.booking;
    final package = booking.package;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Booking number + Package
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking #${booking.bookingNumber}',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _getPackageTitle(package),
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusColor(booking.status, cs).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  booking.status.value.replaceAll('_', ' '),
                  style: tt.labelSmall?.copyWith(
                    color: _getStatusColor(booking.status, cs),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Pickup location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.trip_origin_rounded,
                  size: 14,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  booking.pickupAddress.formattedAddress,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Drop location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  size: 14,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  booking.dropAddress.formattedAddress,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Info chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _chip(context, icon: Icons.inventory_2_rounded, label: _getFormattedWeight(package)),
              _chip(context, icon: Icons.straighten_rounded, label: '${booking.distanceKm.toStringAsFixed(1)} km'),
              _chip(context, icon: Icons.currency_rupee_rounded, label: booking.finalCost?.toStringAsFixed(0) ?? booking.estimatedCost.toStringAsFixed(0)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status, ColorScheme cs) {
    switch (status) {
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
      default:
        return cs.primary;
    }
  }

  Widget _chip(BuildContext context, {required IconData icon, required String label}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: cs.surfaceContainerHighest,
        border: Border.all(color: cs.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: tt.labelMedium?.copyWith(
              color: cs.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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