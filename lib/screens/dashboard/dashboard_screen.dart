import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/ready_modal.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _hasShownModalThisSession = false;
  bool _isAlertDismissed = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final showReadyPrompt = ref.watch(showReadyPromptProvider);
    final driverAsync = ref.watch(driverProvider);

    // Show modal when ready prompt should be displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showReadyPrompt.hasValue &&
          showReadyPrompt.value == true &&
          !_hasShownModalThisSession &&
          mounted) {
        _hasShownModalThisSession = true;
        showReadyModal(context);
      }
    });

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting
              _buildHeader(context, driverAsync),
              const SizedBox(height: 20),

              // Document expiry alerts (if any)
              _buildExpiryAlerts(context),

              // Ride summary section
              _buildRideSummary(context),
              const SizedBox(height: 20),

              // Quick stats grid
              _buildQuickStats(context),
              const SizedBox(height: 24),

              // Today's completed rides
              _buildTodaysRides(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue driverAsync) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final driverName = driverAsync.whenOrNull(
      data: (driver) => driver.firstName ?? 'Driver',
    ) ?? 'Driver';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $driverName 👋',
                style: tt.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Stay ready. Earn more.',
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        // Logout button
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => _showLogoutDialog(context),
            icon: Icon(Icons.logout_rounded, color: cs.onSurface.withValues(alpha: 0.7)),
          ),
        ),
      ],
    );
  }

  Widget _buildExpiryAlerts(BuildContext context) {
    if (_isAlertDismissed) {
      return const SizedBox.shrink();
    }

    final expiryAlertsAsync = ref.watch(expiryAlertsProvider);

    return expiryAlertsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (alerts) {
        if (!alerts.hasAlerts && !alerts.hasExpiredDocuments) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            _AlertCard(
              alerts: alerts,
              onDismiss: () {
                setState(() {
                  _isAlertDismissed = true;
                });
              },
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildRideSummary(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final rideSummaryAsync = ref.watch(rideSummaryProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: rideSummaryAsync.when(
        loading: () => _buildRideSummaryContent(context, null),
        error: (_, _) => _buildRideSummaryContent(context, null),
        data: (summary) => _buildRideSummaryContent(context, summary),
      ),
    );
  }

  Widget _buildRideSummaryContent(BuildContext context, RideSummary? summary) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      children: [
        // Title section
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cs.onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.today_rounded, color: cs.onPrimary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Today's Summary",
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                summary?.date ?? _getTodayDate(),
                style: tt.bodySmall?.copyWith(
                  color: cs.onPrimary.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Rides stat
        _buildCompactStat(
          context,
          icon: Icons.route_rounded,
          value: summary?.totalRides.toString() ?? '0',
          label: 'rides',
        ),
        const SizedBox(width: 20),
        // Earnings stat
        _buildCompactStat(
          context,
          icon: Icons.currency_rupee_rounded,
          value: (summary?.netEarnings ?? 0).toStringAsFixed(0),
          label: 'earned',
        ),
      ],
    );
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Widget _buildCompactStat(BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: cs.onPrimary.withValues(alpha: 0.9), size: 18),
            const SizedBox(width: 4),
            Text(
              value,
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onPrimary,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: tt.bodySmall?.copyWith(
            color: cs.onPrimary.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    final driverAsync = ref.watch(driverProvider);

    final isAvailable = driverAsync.whenOrNull(
      data: (driver) => driver.driverStatus.value == 'AVAILABLE',
    ) ?? false;

    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _QuickStatCard(
            icon: Icons.verified_rounded,
            label: 'Status',
            value: isAvailable ? 'Available' : 'Unavailable',
            color: isAvailable ? Colors.green : Colors.grey,
          ),
        ),
        Expanded(
          flex: 3,
          child: _QuickStatCard(
            icon: Icons.star_rounded,
            label: 'Score',
            value: driverAsync.whenOrNull(data: (d) => d.score.toString()) ?? '0',
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysRides(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final rideSummaryAsync = ref.watch(rideSummaryProvider);

    return rideSummaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (summary) {
        if (summary.assignments.isEmpty) {
          return _buildEmptyRidesCard(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                "Today's Rides",
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...summary.assignments.map((assignment) {
              final booking = assignment.booking;

              // Calculate driver earnings (after commission)
              final grossAmount = booking.finalCost ?? booking.estimatedCost;
              final commission = grossAmount * summary.commissionRate;
              final driverEarnings = grossAmount - commission;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: cs.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Booking #${booking.bookingNumber}',
                                    style: tt.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Completed',
                                    style: tt.bodySmall?.copyWith(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '+₹${driverEarnings.toStringAsFixed(0)}',
                                  style: tt.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  'earned',
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(
                          height: 1,
                          color: cs.outline.withValues(alpha: 0.2),
                        ),
                        const SizedBox(height: 12),
                        _buildRouteInfo(context, booking),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildRouteInfo(BuildContext context, Booking booking) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 18,
              color: cs.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                booking.pickupAddress.formattedAddress.split(',').take(2).join(','),
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.arrow_downward_rounded,
              size: 18,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
            Text(
              '${booking.distanceKm.toStringAsFixed(1)} km',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.flag_rounded,
              size: 18,
              color: cs.error,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                booking.dropAddress.formattedAddress.split(',').take(2).join(','),
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmptyRidesCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            "Today's Rides",
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: cs.outline.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: 32,
                  color: cs.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No rides completed yet',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Complete your first ride today!',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCEL', style: TextStyle(color: cs.onSurface.withValues(alpha: 0.7))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
            ),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && mounted) {
      final api = ref.read(apiProvider).value!;
      await api.signOut();
    }
  }
}

// Alert Card Widget
class _AlertCard extends StatelessWidget {
  final ExpiryAlerts alerts;
  final VoidCallback onDismiss;

  const _AlertCard({required this.alerts, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final isExpired = alerts.hasExpiredDocuments;
    final color = isExpired ? cs.error : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isExpired ? Icons.error_rounded : Icons.warning_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpired ? 'Document Expired!' : 'Document Expiring Soon',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                ...alerts.allAlerts.map((alert) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    alert,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                )),
                if (isExpired)
                  Text(
                    'You cannot take bookings until documents are updated.',
                    style: tt.bodySmall?.copyWith(
                      color: cs.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          TextButton(
            onPressed: onDismiss,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Dismiss',
              style: tt.bodySmall?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Stat Card Widget
class _QuickStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _QuickStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  label,
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


