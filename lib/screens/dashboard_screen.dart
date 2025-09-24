import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/ready_modal.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _hasShownModalThisSession = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final showReadyPrompt = ref.watch(showReadyPromptProvider);

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
      body: Stack(
        children: [
          // Background gradient for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [cs.surface, cs.surface.withValues(alpha: 0.95)],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  const SizedBox(height: 16),
                  _quickStats(context),
                  const SizedBox(height: 16),
                  _toolsGrid(context),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                child: Icon(Icons.local_shipping_rounded, color: cs.primary, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dashboard', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text('Stay ready. Earn more.', style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Logout', style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold)),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('CANCEL')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('LOGOUT')),
                      ],
                    ),
                  );
                  if (shouldLogout == true && mounted) {
                    final api = ref.read(apiProvider).value!;
                    await api.signOut();
                  }
                },
                icon: const Icon(Icons.logout_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _statCard(context, 'Today\'s Rides', '0', Icons.route_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _statCard(context, 'Earnings', '₹0', Icons.currency_rupee_rounded)),
      ],
    );
  }

  Widget _statCard(BuildContext context, String title, String value, IconData icon) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: cs.primary.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                    const SizedBox(height: 4),
                    Text(value, style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toolsGrid(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _toolCard(context, Icons.assignment_rounded, 'My Orders', 'View deliveries', cs.primary),
        _toolCard(context, Icons.navigation_rounded, 'Navigation', 'Routes & maps', cs.secondary),
        _toolCard(context, Icons.account_balance_wallet_rounded, 'Earnings', 'Payment details', Colors.green),
        _toolCard(context, Icons.support_agent_rounded, 'Support', 'We\'re here to help', Colors.orange),
      ],
    );
  }

  Widget _toolCard(BuildContext context, IconData icon, String title, String subtitle, Color accent) {
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accent.withValues(alpha: 0.18),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(height: 12),
              Text(title, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(subtitle, style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
            ],
          ),
        ),
      ),
    );
  }

}


