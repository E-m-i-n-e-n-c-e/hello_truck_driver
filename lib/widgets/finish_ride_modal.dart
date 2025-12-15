import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';

void showFinishRideModal(BuildContext context, BookingAssignment assignment, {required VoidCallback whenComplete}) {
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
              color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _FinishRideContent(assignment: assignment),
      ),
    ),
  ).whenComplete(() {
    whenComplete();
  });
}

class _FinishRideContent extends ConsumerStatefulWidget {
  final BookingAssignment assignment;

  const _FinishRideContent({required this.assignment});

  @override
  ConsumerState<_FinishRideContent> createState() => _FinishRideContentState();
}

class _FinishRideContentState extends ConsumerState<_FinishRideContent> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final booking = widget.assignment.booking;

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
                      'Ride Complete!',
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

          // Success Message
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.celebration_rounded, color: Colors.green, size: 36),
                const SizedBox(height: 10),
                Text(
                  'Package delivered successfully!',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors. green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Both pickup and drop have been verified. You can now finish this ride.',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Trip Summary
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Summary',
                  style: tt.labelLarge?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _summaryItem(
                        context,
                        icon: Icons.straighten_rounded,
                        label: 'Distance',
                        value: '${booking.distanceKm.toStringAsFixed(1)} km',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _summaryItem(
                        context,
                        icon: Icons.currency_rupee_rounded,
                        label: 'Earnings',
                        value: '₹${booking.finalCost?.toStringAsFixed(0) ?? booking.estimatedCost.toStringAsFixed(0)}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Finish Ride Button
          FilledButton(
            onPressed: _isLoading ? null : _handleFinishRide,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: cs.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Finish Ride',
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
              'Not Now',
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

  Widget _summaryItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 17, color: cs.onSurfaceVariant),
            const SizedBox(width: 7),
            Text(
              label,
              style: tt.labelMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Future<void> _handleFinishRide() async {
    setState(() => _isLoading = true);

    try {
      final api = await ref.read(apiProvider.future);
      await finishRide(api);

      // There is no current assignment after finishing
      ref.invalidate(currentAssignmentProvider);
      // Driver is now available
      ref.invalidate(driverProvider);
      // As current assignment is now history
      ref.invalidate(assignmentHistoryProvider);
      // Ride summary is updated
      ref.invalidate(rideSummaryProvider);

      if (mounted) {
        Navigator.pop(context);
        SnackBars.success(context, 'Ride completed successfully! 🎉');
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to finish ride: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
