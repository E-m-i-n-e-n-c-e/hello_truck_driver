import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';

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
                    data: (driver) => _availabilityCard(
                      context,
                      isAvailable: driver.driverStatus == DriverStatus.available,
                    ),
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
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.my_location, size: 18, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(booking.pickupAddress.formattedAddress, style: tt.bodyMedium)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.flag, size: 18, color: cs.secondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(booking.dropAddress.formattedAddress, style: tt.bodyMedium)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _chip(context, icon: Icons.straighten, label: '${booking.distanceKm.toStringAsFixed(1)} km'),
                  const SizedBox(width: 8),
                  _chip(context, icon: Icons.payments, label: booking.finalCost?.toStringAsFixed(2) ?? booking.estimatedCost.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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


