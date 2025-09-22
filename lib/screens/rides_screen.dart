import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';

class RidesScreen extends ConsumerStatefulWidget {
  const RidesScreen({super.key});

  @override
  ConsumerState<RidesScreen> createState() => _RidesScreenState();
}

class _RidesScreenState extends ConsumerState<RidesScreen> {
  bool _toggling = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final driverAsync = ref.watch(driverProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          // Subtle gradient background for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.surface,
                  colorScheme.surface.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _frostedHeader(context, textTheme),
                  const SizedBox(height: 16),
                  driverAsync.when(
                    loading: () => _availabilitySkeleton(context),
                    error: (_, _) => _availabilitySkeleton(context),
                    data: (driver) => _availabilityCard(
                      context,
                      isAvailable: driver.driverStatus == DriverStatus.available,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(child: _ridesPlaceholder(context, textTheme)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _frostedHeader(BuildContext context, TextTheme textTheme) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.local_shipping_rounded, color: cs.primary),
              const SizedBox(width: 12),
              Text('Rides', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.onSurface)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _availabilitySkeleton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 78,
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _availabilityCard(BuildContext context, {required bool isAvailable}) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: (isAvailable ? Colors.green : cs.secondary).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: (isAvailable ? Colors.green : cs.secondary).withValues(alpha: 0.15),
                ),
                child: Icon(
                  isAvailable ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  color: isAvailable ? Colors.green : cs.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAvailable ? 'Available for rides' : 'Unavailable',
                      style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAvailable
                          ? 'You will receive new ride offers.'
                          : 'Go available to start receiving offers.',
                      style: tt.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch.adaptive(
                value: isAvailable,
                onChanged: _toggling
                    ? null
                    : (v) async {
                        setState(() => _toggling = true);
                        try {
                          final api = await ref.read(apiProvider.future);
                          await driver_api.updateDriverStatus(api, isAvailable: v);
                          // if available, mark as ready prompt seen
                          if(v) {
                            await markAsReadyPromptSeen(ref);
                          }
                          // Refresh driver profile
                          ref.invalidate(driverProvider);
                          if (context.mounted) {
                            SnackBars.success(context, v ? 'You are now available' : 'You are now unavailable');
                          }
                        } catch (e) {
                          if (context.mounted) SnackBars.error(context, 'Failed to update status');
                        } finally {
                          if (mounted) setState(() => _toggling = false);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ridesPlaceholder(BuildContext context, TextTheme textTheme) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      children: [
        _frostedTile(context,
            title: 'Active Ride',
            subtitle: 'No active rides',
            icon: Icons.directions_car_filled_rounded,
            accent: cs.primary),
        const SizedBox(height: 12),
        _frostedTile(context,
            title: 'Ride History',
            subtitle: 'Your past rides will appear here',
            icon: Icons.history_rounded,
            accent: cs.secondary),
      ],
    );
  }

  Widget _frostedTile(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color accent}) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: accent.withValues(alpha: 0.06),
            border: Border.all(color: cs.outline.withValues(alpha: 0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: accent.withValues(alpha: 0.15),
                ),
                child: Icon(icon, color: accent),
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


