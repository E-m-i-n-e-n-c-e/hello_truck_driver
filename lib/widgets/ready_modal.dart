import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';

class ReadyModal extends ConsumerStatefulWidget {
  const ReadyModal({super.key});

  @override
  ConsumerState<ReadyModal> createState() => _ReadyModalState();
}

class _ReadyModalState extends ConsumerState<ReadyModal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleReady() async {
    setState(() => _isLoading = true);

    try {
      await markAsReadyPromptSeen(ref);
      final api = await ref.read(apiProvider.future);
      await driver_api.updateDriverStatus(api, isAvailable: true);
      ref.invalidate(driverProvider);

      if (mounted) {
        Navigator.of(context).pop();
        SnackBars.success(context, 'You are now available for rides');
      }
    } catch (e) {
      if(mounted) {
        Navigator.of(context).pop();
        SnackBars.error(context, 'Failed to mark driver as ready: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleSkip() async {
    if (_isLoading) return; // Prevent multiple taps

    setState(() => _isLoading = true);

    try {
      await markAsReadyPromptSeen(ref);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        SnackBars.error(context, 'Failed to mark prompt as seen: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => markAsReadyPromptSeen(ref),
      child: Material(
        type: MaterialType.transparency,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, (1 - _scaleAnimation.value) * 100),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: screenSize.height * 0.85,
                  ),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: cs.shadow.withValues(alpha: 0.2),
                        blurRadius: 40,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Drag indicator
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(top: 12, bottom: 8),
                        decoration: BoxDecoration(
                          color: cs.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Header with gradient background
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              cs.primary,
                              cs.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            // Icon
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: cs.onPrimary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.local_shipping_rounded,
                                size: 36,
                                color: cs.onPrimary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Ready to take rides today?',
                              style: tt.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cs.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start earning by accepting ride requests from customers near you',
                              style: tt.bodyLarge?.copyWith(
                                color: cs.onPrimary.withValues(alpha: 0.9),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      // Content section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        child: Column(
                          children: [
                            // Benefits list
                            _buildBenefitItem(
                              context,
                              Icons.notifications_active_rounded,
                              'Get instant notifications',
                              'Receive ride requests immediately',
                            ),
                            const SizedBox(height: 12),
                            _buildBenefitItem(
                              context,
                              Icons.location_on_rounded,
                              'Find nearby rides',
                              'Connect with customers in your area',
                            ),
                            const SizedBox(height: 12),
                            _buildBenefitItem(
                              context,
                              Icons.currency_rupee_rounded,
                              'Start earning today',
                              'Maximize your daily income potential',
                            ),

                            const SizedBox(height: 28),

                            // Action buttons
                            Row(
                              children: [
                                // "Maybe later" button
                                Expanded(
                                  flex: 5,
                                  child: OutlinedButton(
                                    onPressed: _isLoading ? null : _handleSkip,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: cs.onSurface.withValues(alpha: 0.7),
                                      side: BorderSide(
                                        color: _isLoading
                                            ? cs.outline.withValues(alpha: 0.3)
                                            : cs.outline.withValues(alpha: 0.5),
                                        width: 1.5,
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text(
                                      'Maybe later',
                                      style: tt.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // "I'm ready!" button
                                Expanded(
                                  flex: 6,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleReady,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: cs.primary,
                                      foregroundColor: cs.onPrimary,
                                      disabledBackgroundColor: cs.surfaceContainerHighest,
                                      disabledForegroundColor: cs.onSurface.withValues(alpha: 0.4),
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.check_circle_rounded, size: 20),
                                              const SizedBox(width: 8),
                                              Text(
                                                "I'm ready!",
                                                style: tt.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.w700,
                                                  color: cs.onPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Footer text
                            Text(
                              'You can change this anytime from the Rides tab',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: cs.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    height: 1.3,
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

// Function to show the modal as a full screen modal
Future<void> showReadyModal(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: colorScheme.shadow.withValues(alpha: 0.7),
    builder: (context) => const ReadyModal(),
  );
}