import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/ready_modal.dart';
import 'package:hello_truck_driver/screens/booking/booking_request_screen.dart';
import 'package:hello_truck_driver/utils/dummy_bookings.dart';

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
      body: SafeArea(
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
    );
  }

  Widget _header(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cs.secondary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: cs.primary.withValues(alpha: 0.8),
              ),
              child: Icon(Icons.local_shipping_rounded, color: cs.onPrimary, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard', style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onPrimaryContainer,
                  )),
                  const SizedBox(height: 4),
                  Text('Stay ready. Earn more.', style: tt.bodySmall?.copyWith(
                    color: cs.onPrimaryContainer.withValues(alpha: 0.7),
                  )),
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
              icon: Icon(Icons.logout_rounded, color: cs.onPrimaryContainer),
            ),
          ],
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
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: cs.primaryContainer,
              ),
              child: Icon(icon, color: cs.surface, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(title, style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7))),
                  const SizedBox(height: 4),
                  Text(value, style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  )),
                ],
              ),
            ),
          ],
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
        _toolCard(context, Icons.navigation_rounded, 'Navigation', 'Routes & maps', cs.secondary.withValues(alpha: 0.8)),
        _toolCard(context, Icons.account_balance_wallet_rounded, 'Earnings', 'Payment details', Colors.green),
        _testBookingCard(context), // Temporary test button
      ],
    );
  }

  Widget _toolCard(BuildContext context, IconData icon, String title, String subtitle, Color accent) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  color: accent.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: accent, size: 20),
            ),
            const SizedBox(height: 12),
            Text(title, style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.onSurface,
            )),
            const SizedBox(height: 4),
            Text(subtitle, style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            )),
          ],
        ),
      ),
    );
  }

  Widget _testBookingCard(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showTestBookingRequest(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepOrange.withValues(alpha: 0.15),
                  ),
                  child: const Icon(Icons.local_shipping_rounded, color: Colors.deepOrange, size: 20),
                ),
                const SizedBox(height: 12),
                Text('Test Booking', style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                )),
                const SizedBox(height: 4),
                Text('Demo ride request', style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTestBookingRequest(BuildContext context) {
    final randomBooking = DummyBookings.getRandomBooking();

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => BookingRequestScreen(
          booking: randomBooking,
          onTimeExpired: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Booking request expired'),
                backgroundColor: Colors.orange,
              ),
            );
          },
          onBookingResponse: (accepted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(accepted ? 'Booking accepted!' : 'Booking declined'),
                backgroundColor: accepted ? Colors.green : Colors.red,
              ),
            );
          },
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
      ),
    );
  }

}


