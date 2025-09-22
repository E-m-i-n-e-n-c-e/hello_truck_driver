import 'dart:ui';
import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _frostedHeader(context, 'Payments'),
              const SizedBox(height: 16),
              _statRow(context),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _paymentTile(context, title: 'Pending Dues', subtitle: '₹1,320.00', accent: Colors.orange),
                    const SizedBox(height: 12),
                    _paymentTile(context, title: 'Next Payout', subtitle: '₹4,560.00 • Fri, 26 Sep', accent: cs.primary),
                    const SizedBox(height: 12),
                    _paymentTile(context, title: 'Total Earned (This Month)', subtitle: '₹22,140.00', accent: Colors.green),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _frostedHeader(BuildContext context, String title) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.secondary.withValues(alpha: 0.08),
            border: Border.all(color: cs.secondary.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: cs.secondary),
              const SizedBox(width: 12),
              Text(title, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _frostedSmallCard(context, 'Completed Rides', '18')),
        const SizedBox(width: 12),
        Expanded(child: _frostedSmallCard(context, 'Avg. Earning/Ride', '₹253')),
      ],
    );
  }

  Widget _frostedSmallCard(BuildContext context, String title, String value) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.5),
            border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
              const SizedBox(height: 6),
              Text(value, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentTile(BuildContext context, {required String title, required String subtitle, required Color accent}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.06),
            border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accent.withValues(alpha: 0.18),
                ),
                child: Icon(Icons.receipt_long_rounded, color: accent),
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
}


