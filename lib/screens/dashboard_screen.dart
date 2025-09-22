import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _slide = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final showReadyPrompt = ref.watch(showReadyPromptProvider);

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

          // Bottom floating prompt (non-intrusive)
          if (showReadyPrompt.value ?? false) _readyPrompt(context),
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

  Widget _readyPrompt(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _fade,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 8)),
                  ],
                  border: Border.all(color: cs.outline.withValues(alpha: 0.12)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: cs.primary.withValues(alpha: 0.12),
                      ),
                      child: Icon(Icons.play_arrow_rounded, color: cs.primary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ready to take rides today?', style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text('You can change this anytime from the Rides tab.', style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final api = await ref.read(apiProvider.future);
                          await driver_api.updateDriverStatus(api, isAvailable: true);
                          ref.invalidate(driverProvider);
                        } catch (_) {}
                        await markAsReadyPromptSeen(ref);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("I'm ready"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


