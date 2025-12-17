import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/models/enums/fcm_enums.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';
import 'package:hello_truck_driver/providers/fcm_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';

class PaymentSettlementScreen extends ConsumerStatefulWidget {
  final Booking booking;

  const PaymentSettlementScreen({
    super.key,
    required this.booking,
  });

  @override
  ConsumerState<PaymentSettlementScreen> createState() => _PaymentSettlementScreenState();
}

class _PaymentSettlementScreenState extends ConsumerState<PaymentSettlementScreen> {
  bool _isProcessing = false;
  bool _showDisclaimer = false;
  bool hasSetupFCMListener = false;

  @override
  void initState() {
    super.initState();
    // Show disclaimer after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) setState(() => _showDisclaimer = true);
        });
      }
    });
  }

  void _setupFCMListener() {
    ref.listen<AsyncValue<FcmEventType>>(fcmEventStreamProvider, (previous, next) {
      next.whenData((event) {
        if (event == FcmEventType.paymentSuccess && mounted) {
          // Payment received! Show success and close
          SnackBars.success(context, 'Payment received successfully! 💰');

          // Delay to let user see the message
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          });
        }
      });
    });
  }

  Future<void> _settleCash() async {
    setState(() => _isProcessing = true);

    try {
      final api = await ref.read(apiProvider.future);
      await settleCash(api);

      // Invalidate providers to refresh data
      ref.invalidate(currentAssignmentProvider);

      if (mounted) {
        SnackBars.success(context, 'Payment settled successfully! 💰');
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _refresh() async {
    ref.invalidate(currentAssignmentProvider);
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if payment was received
    final assignment = await ref.read(currentAssignmentProvider.future);
    final isPaid = assignment?.booking.finalInvoice?.isPaid ?? false;

    if (isPaid && mounted) {
      SnackBars.success(context, 'Payment received! 💰');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.of(context).pop(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final rideSummaryAsync = ref.watch(rideSummaryProvider);
    final commissionRate = rideSummaryAsync.value?.commissionRate ?? 0.07;

    if (!hasSetupFCMListener) {
      _setupFCMListener();
      hasSetupFCMListener = true;
    }

    final finalInvoice = widget.booking.finalInvoice;
    final amount = finalInvoice?.finalAmount ?? 0.0;
    final commission = amount * commissionRate;

    return PopScope(
      canPop: !_isProcessing,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          title: Text(
            'Payment Settlement',
            style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          backgroundColor: cs.surface,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            color: cs.onSurface,
            icon: const Icon(Icons.arrow_back),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: _isProcessing ? null : _refresh,
              color: cs.onSurface,
              icon: Icon(Icons.refresh_rounded),
              tooltip: 'Check Payment Status',
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Payment Pending Alert
              _buildPaymentAlert(cs, tt),
              const SizedBox(height: 24),

              // Amount Summary Card
              _buildAmountCard(cs, tt, amount, commission, commissionRate),
              const SizedBox(height: 24),

              // Payment Options
              Text(
                'Select Payment Method',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Cash Payment Option
              _buildCashOption(cs, tt, commission),
              const SizedBox(height: 12),

              // Online Payment Option
              _buildOnlineOption(cs, tt, finalInvoice?.paymentLinkUrl),
              const SizedBox(height: 24),

              // Commission Disclaimer
              if (_showDisclaimer)
                AnimatedOpacity(
                  opacity: _showDisclaimer ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _buildDisclaimerCard(cs, tt, commission, commissionRate),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentAlert(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.payment_rounded,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Pending',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Customer hasn\'t paid yet. Choose how to receive payment below.',
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountCard(ColorScheme cs, TextTheme tt, double amount, double commission, double commissionRate) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          Text(
            'Total Amount',
            style: tt.bodyLarge?.copyWith(
              color: cs.onPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹',
                style: tt.headlineMedium?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                amount.toStringAsFixed(0),
                style: tt.displaySmall?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: cs.onPrimary.withValues(alpha: 0.3), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Platform Fee',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    '₹${commission.toStringAsFixed(0)}',
                    style: tt.titleMedium?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Your Earnings',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    '₹${(amount - commission).toStringAsFixed(0)}',
                    style: tt.titleMedium?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCashOption(ColorScheme cs, TextTheme tt, double commission) {
    return InkWell(
      onTap: _isProcessing ? null : () => _showCashConfirmation(cs, tt, commission),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cs.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.payments_rounded,
                color: Colors.green,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Received Cash',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'I collected cash from customer',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineOption(ColorScheme cs, TextTheme tt, String? paymentLink) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.smartphone_rounded,
              color: cs.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Pays via App',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ask customer to pay via payment link in their app',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCard(ColorScheme cs, TextTheme tt, double commission, double commissionRate) {
    final percentage = (commissionRate * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: cs.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Important Information',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDisclaimerPoint(
            cs,
            tt,
            'If you select "Received Cash", $percentage% platform fee (₹${commission.toStringAsFixed(0)}) will be deducted from your wallet.',
          ),
          const SizedBox(height: 8),
          _buildDisclaimerPoint(
            cs,
            tt,
            'Make sure you have collected the full amount from the customer before confirming.',
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimerPoint(ColorScheme cs, TextTheme tt, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: cs.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showCashConfirmation(ColorScheme cs, TextTheme tt, double commission) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CashConfirmationSheet(commission: commission),
    );

    if (confirmed == true) {
      await _settleCash();
    }
  }
}

class _CashConfirmationSheet extends StatelessWidget {
  final double commission;

  const _CashConfirmationSheet({required this.commission});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: Colors.orange,
              size: 48,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Confirm Cash Payment',
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'By confirming, you declare that you have received cash payment from the customer.',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '₹${commission.toStringAsFixed(0)} will be deducted from your wallet as platform fee.',
              style: tt.bodyMedium?.copyWith(
                color: cs.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: cs.outline.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_rounded, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Confirm',
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
