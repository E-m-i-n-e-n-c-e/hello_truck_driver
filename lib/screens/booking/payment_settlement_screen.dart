import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/models/booking.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/providers/dashboard_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';

import '../../utils/logger.dart';
import '../../utils/format_utils.dart';

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
  bool _isRefreshing = false;
  bool _hasHandledPaymentSuccess = false;

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

  /// Centralized payment success handler
  void _handlePaymentSuccess() {
    AppLogger.log("Payment success handler called");
    if (!mounted) return;

    SnackBars.success(context, 'Payment received successfully! 💰');

    // Delay to let user see the message
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(true);
      }
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
    if (_isRefreshing) return; // Prevent spam

    setState(() => _isRefreshing = true);

    ref.invalidate(currentAssignmentProvider);
    // Wait for 1 second to prevent spamming
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final currentAssignmentAsync = ref.watch(currentAssignmentProvider);

    if(currentAssignmentAsync.hasValue &&
      currentAssignmentAsync.value?.booking.finalInvoice?.isPaid == true &&
      !_hasHandledPaymentSuccess) {
      _hasHandledPaymentSuccess = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handlePaymentSuccess();
      });
    }

    final rideSummaryAsync = ref.watch(rideSummaryProvider);
    final commissionRate = rideSummaryAsync.value?.commissionRate ?? 0.07;

    final finalInvoice = widget.booking.finalInvoice;
    final totalPrice = finalInvoice?.totalPrice ?? 0.0;
    final walletApplied = finalInvoice?.walletApplied ?? 0.0;
    final cashToCollect = finalInvoice?.finalAmount ?? 0.0;
    final commission = totalPrice * commissionRate;
    final driverEarnings = totalPrice - commission;
    // walletChange = walletApplied - commission (what happens to driver wallet after cash collection)
    final walletChange = walletApplied - commission;

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
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: (_isProcessing || _isRefreshing) ? null : _refresh,
                color: cs.onSurface,
                icon: _isRefreshing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(cs.onSurface),
                        ),
                      )
                    : Icon(Icons.refresh_rounded),
                tooltip: 'Check Payment Status',
              ),
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
              _buildAmountCard(cs, tt, totalPrice, cashToCollect, walletApplied, commission, driverEarnings, walletChange, commissionRate),
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

  Widget _buildAmountCard(
    ColorScheme cs,
    TextTheme tt,
    double totalPrice,
    double cashToCollect,
    double walletApplied,
    double commission,
    double driverEarnings,
    double walletChange,
    double commissionRate,
  ) {
    final hasWalletAdjustment = walletApplied != 0;

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
          // Cash to Collect (main highlight)
          Text(
            'Cash to Collect',
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
                cashToCollect.toCurrency(),
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

          // Breakdown rows
          _buildBreakdownRow(tt, cs, 'Service Cost', totalPrice.toRupees()),
          if (hasWalletAdjustment) ...[
            const SizedBox(height: 8),
            _buildBreakdownRow(
              tt, cs,
              walletApplied > 0 ? 'Customer Wallet Used' : 'Customer Debt Recovery',
              walletApplied > 0 ? '-${walletApplied.toRupees()}' : '+${(-walletApplied).toRupees()}',
            ),
          ],
          const SizedBox(height: 12),
          Divider(color: cs.onPrimary.withValues(alpha: 0.2), height: 1),
          const SizedBox(height: 12),

          // Commission and earnings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Platform Fee (${(commissionRate * 100).toStringAsFixed(0)}%)',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    commission.toRupees(),
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
                    driverEarnings.toRupees(),
                    style: tt.titleMedium?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Wallet change indicator (only for cash with wallet adjustments)
          if (hasWalletAdjustment) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: cs.onPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    walletChange >= 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                    size: 16,
                    color: cs.onPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    walletChange >= 0
                        ? 'Wallet Credit: +${walletChange.abs().toRupees()}'
                        : 'Wallet Debit: ${walletChange.toRupees()}',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(TextTheme tt, ColorScheme cs, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tt.bodySmall?.copyWith(
            color: cs.onPrimary.withValues(alpha: 0.8),
          ),
        ),
        Text(
          value,
          style: tt.bodyMedium?.copyWith(
            color: cs.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
            'Platform fee ($percentage%) is calculated on the full service cost, not the cash collected.',
          ),
          const SizedBox(height: 8),
          _buildDisclaimerPoint(
            cs,
            tt,
            'If customer used wallet credit, you\'ll receive a wallet credit. If customer had debt, extra amount collected will be debited.',
          ),
          const SizedBox(height: 8),
          _buildDisclaimerPoint(
            cs,
            tt,
            'Make sure you have collected the exact "Cash to Collect" amount shown above.',
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Confirm Cash Payment',
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Description
          Text(
            'By confirming, you declare that you have received the full cash payment from the customer.',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.75),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Commission info box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: cs.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.85),
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: commission.toRupees(),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' platform fee will be deducted from your wallet',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: cs.outline.withValues(alpha: 0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: tt.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
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
                        'Confirm ',
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
