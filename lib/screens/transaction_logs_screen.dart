import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/transaction_enums.dart';
import 'package:hello_truck_driver/models/transaction_log.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';
import 'package:intl/intl.dart';

class TransactionLogsScreen extends ConsumerWidget {
  const TransactionLogsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final transactionLogsAsync = ref.watch(transactionLogsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transaction History',
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
      ),
      body: transactionLogsAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(cs.primary),
          ),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: cs.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load transactions',
                  style: tt.titleMedium?.copyWith(color: cs.error),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        data: (logs) {
          if (logs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: cs.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: tt.titleMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(transactionLogsProvider);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _TransactionLogCard(log: logs[index]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _TransactionLogCard extends StatelessWidget {
  final TransactionLog log;

  const _TransactionLogCard({required this.log});

  IconData _getCategoryIcon() {
    switch (log.category) {
      case TransactionCategory.bookingPayment:
        return Icons.payments_rounded;
      case TransactionCategory.bookingRefund:
        return Icons.refresh_rounded;
      case TransactionCategory.driverPayout:
        return Icons.account_balance_rounded;
      case TransactionCategory.walletCredit:
        return Icons.account_balance_wallet_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isCredit = log.isCredit;
    final color = isCredit ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.description,
                      style: tt.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            log.category.displayName,
                            style: tt.bodySmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.circle,
                          size: 4,
                          color: cs.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM d, yyyy').format(log.createdAt),
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${isCredit ? '+' : '-'}₹${log.amount.abs().toStringAsFixed(0)}',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
            height: 1,
            color: cs.outline.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _InfoChip(
                icon: Icons.payment,
                label: log.paymentMethod.value,
                cs: cs,
                tt: tt,
              ),
              const SizedBox(width: 8),
              _InfoChip(
                icon: isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                label: log.type.value,
                cs: cs,
                tt: tt,
              ),
              if (log.bookingId != null) ...[
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.local_shipping_outlined,
                  label: 'Booking',
                  cs: cs,
                  tt: tt,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final ColorScheme cs;
  final TextTheme tt;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
