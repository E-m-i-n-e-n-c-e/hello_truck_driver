import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/models/ride_summary.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/models/wallet_log.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/ready_modal.dart';
import 'package:intl/intl.dart';

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
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(rideSummaryProvider);
          ref.invalidate(expiryAlertsProvider);
          ref.invalidate(walletLogsProvider);
          ref.invalidate(transactionLogsProvider);
          ref.invalidate(driverProvider);
        },
        child: SafeArea(
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

                // Recent wallet activity
                _buildWalletActivitySection(context),
                const SizedBox(height: 24),

                // Recent transactions
                _buildTransactionsSection(context),
                const SizedBox(height: 16),
              ],
            ),
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
                  fontWeight: FontWeight.bold,
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
          value: (summary?.totalEarnings ?? 0).toStringAsFixed(0),
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
          child: _QuickStatCard(
            icon: Icons.verified_rounded,
            label: 'Status',
            value: isAvailable ? 'Available' : 'Unavailable',
            color: isAvailable ? Colors.green : Colors.grey,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
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

  Widget _buildWalletActivitySection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final walletLogsAsync = ref.watch(walletLogsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Wallet Activity',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to full wallet history
                },
                child: Text(
                  'See All',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        walletLogsAsync.when(
          loading: () => _buildWalletLogsShimmer(context),
          error: (error, _) => _buildErrorCard(context, 'Failed to load wallet activity'),
          data: (logs) {
            if (logs.isEmpty) {
              return _buildEmptyCard(context, 'No wallet activity yet', Icons.account_balance_wallet_outlined);
            }
            // Show only first 3 entries
            final recentLogs = logs.take(3).toList();
            return Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: recentLogs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final log = entry.value;
                  return _WalletLogTile(
                    log: log,
                    showDivider: index < recentLogs.length - 1,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionsSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final transactionLogsAsync = ref.watch(transactionLogsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to full transaction history
                },
                child: Text(
                  'See All',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        transactionLogsAsync.when(
          loading: () => _buildTransactionLogsShimmer(context),
          error: (error, _) => _buildErrorCard(context, 'Failed to load transactions'),
          data: (logs) {
            if (logs.isEmpty) {
              return _buildEmptyCard(context, 'No transactions yet', Icons.receipt_long_outlined);
            }
            // Show only first 5 entries
            final recentLogs = logs.take(5).toList();
            return Container(
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: recentLogs.asMap().entries.map((entry) {
                  final index = entry.key;
                  final log = entry.value;
                  return _TransactionLogTile(
                    log: log,
                    showDivider: index < recentLogs.length - 1,
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWalletLogsShimmer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(cs.primary),
        ),
      ),
    );
  }

  Widget _buildTransactionLogsShimmer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation(cs.primary),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String message, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: cs.onSurface.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            message,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 20, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: tt.bodySmall?.copyWith(color: cs.error),
            ),
          ),
        ],
      ),
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

// Wallet Log Tile Widget
class _WalletLogTile extends StatelessWidget {
  final WalletLog log;
  final bool showDivider;

  const _WalletLogTile({required this.log, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isCredit = log.isCredit;
    final color = isCredit ? Colors.green : Colors.red;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.reason,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat('MMM d, h:mm a').format(log.createdAt),
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${isCredit ? '+' : '-'}₹${log.absoluteAmount.toStringAsFixed(0)}',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 66,
            color: cs.outline.withValues(alpha: 0.1),
          ),
      ],
    );
  }
}

// Transaction Log Tile Widget
class _TransactionLogTile extends StatelessWidget {
  final TransactionLog log;
  final bool showDivider;

  const _TransactionLogTile({required this.log, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isCredit = log.isCredit;
    final color = isCredit ? Colors.green : Colors.red;

    IconData icon;
    switch (log.category) {
      case TransactionCategory.bookingPayment:
        icon = Icons.payments_rounded;
        break;
      case TransactionCategory.bookingRefund:
        icon = Icons.refresh_rounded;
        break;
      case TransactionCategory.driverPayout:
        icon = Icons.account_balance_rounded;
        break;
      case TransactionCategory.walletCredit:
        icon = Icons.account_balance_wallet_rounded;
        break;
      default:
        icon = Icons.receipt_rounded;
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.description,
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          log.category.displayName,
                          style: tt.bodySmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          ' • ${DateFormat('MMM d').format(log.createdAt)}',
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${isCredit ? '+' : '-'}₹${log.amount.abs().toStringAsFixed(0)}',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 66,
            color: cs.outline.withValues(alpha: 0.1),
          ),
      ],
    );
  }
}
