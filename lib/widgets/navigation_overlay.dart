import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/widgets/otp_bottom_sheet.dart';

class NavigationOverlay extends ConsumerStatefulWidget {
  final BookingAssignment assignment;
  final VoidCallback onNavigationExit;

  const NavigationOverlay({
    super.key,
    required this.assignment,
    required this.onNavigationExit,
  });

  @override
  ConsumerState<NavigationOverlay> createState() => _NavigationOverlayState();
}

class _NavigationOverlayState extends ConsumerState<NavigationOverlay> {
  bool _isLoading = false;
  bool _isExpanded = false;
  Offset _position = const Offset(20, 120); // Initial position

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final booking = widget.assignment.booking;
    final status = booking.status;

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _position += details.delta;
            // Keep within screen bounds
            final screenSize = MediaQuery.of(context).size;
            _position = Offset(
              _position.dx.clamp(0, screenSize.width - (_isExpanded ? 300 : 120)),
              _position.dy.clamp(0, screenSize.height - (_isExpanded ? 400 : 60)),
            );
          });
        },
        child: _isExpanded ? _buildExpandedOverlay(context, status, tt, cs) : _buildCompactOverlay(context, status, tt, cs),
      ),
    );
  }

  Widget _buildCompactOverlay(BuildContext context, BookingStatus status, TextTheme tt, ColorScheme cs) {
    final (title, _, icon, color) = _getStatusInfo(status);

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: cs.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 14),
            ),
            const SizedBox(width: 8),
            Text(
              'Actions',
              style: tt.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.touch_app_rounded, size: 16, color: cs.onSurface.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedOverlay(BuildContext context, BookingStatus status, TextTheme tt, ColorScheme cs) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatusHeader(context, status, tt, cs)),
                  IconButton(
                    onPressed: () => setState(() => _isExpanded = false),
                    icon: Icon(Icons.close_rounded, size: 20, color: cs.onSurface.withValues(alpha: 0.6)),
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (status != BookingStatus.dropVerified) _buildActionButton(context, status, tt, cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, BookingStatus status, TextTheme tt, ColorScheme cs) {
    final (title, subtitle, icon, color) = _getStatusInfo(status);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildActionButton(BuildContext context, BookingStatus status, TextTheme tt, ColorScheme cs) {
    final (buttonText, buttonIcon, buttonColor, isEnabled) = _getButtonInfo(status);

    return ElevatedButton(
      onPressed: isEnabled && !_isLoading ? () => _handleAction(status) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: cs.onPrimary,
        elevation: 2,
        shadowColor: buttonColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(buttonIcon, size: 16),
                const SizedBox(width: 6),
                Text(
                  buttonText,
                  style: tt.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
    );
  }

  (String, String, IconData, Color) _getStatusInfo(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return ('Navigate to Pickup', 'Tap when you arrive at pickup location', Icons.trip_origin_rounded, Colors.green);
      case BookingStatus.pickupArrived:
        return ('Verify Pickup', 'Enter OTP to verify pickup', Icons.verified_rounded, Colors.blue);
      case BookingStatus.pickupVerified:
      case BookingStatus.inTransit:
        return ('Navigate to Drop', 'Tap when you arrive at drop location', Icons.location_on_rounded, Colors.orange);
      case BookingStatus.dropArrived:
        return ('Verify Drop', 'Enter OTP to verify drop', Icons.verified_rounded, Colors.purple);
      case BookingStatus.dropVerified:
        return ('Ride Complete', 'Ready to finish the ride', Icons.check_circle_rounded, Colors.green);
      default:
        return ('Navigation', 'Follow the route', Icons.navigation_rounded, Colors.grey);
    }
  }

  (String, IconData, Color, bool) _getButtonInfo(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return ('Mark as Arrived', Icons.location_on_rounded, Colors.green, true);
      case BookingStatus.pickupArrived:
        return ('Verify Pickup', Icons.verified_rounded, Colors.blue, true);
      case BookingStatus.pickupVerified:
      case BookingStatus.inTransit:
        return ('Mark as Arrived', Icons.location_on_rounded, Colors.orange, true);
      case BookingStatus.dropArrived:
        return ('Verify Drop', Icons.verified_rounded, Colors.purple, true);
      case BookingStatus.dropVerified:
        return ('Finish Ride', Icons.check_circle_rounded, Colors.green, true);
      default:
        return ('Continue', Icons.arrow_forward_rounded, Colors.grey, false);
    }
  }

  Future<void> _handleAction(BookingStatus status) async {
    setState(() => _isLoading = true);

    try {
      final api = await ref.read(apiProvider.future);

      switch (status) {
        case BookingStatus.confirmed:
          await pickupArrived(api);
          ref.invalidate(currentAssignmentProvider);
          _showSuccess('Marked as arrived at pickup');
          break;
        case BookingStatus.pickupArrived:
          // Show OTP dialog for pickup verification
          if(!mounted) return;
          final otp = await _showOtpDialog(context, 'Pickup Verification', 'Enter the OTP provided by the customer');
          if (otp != null && otp.length == 4) {
            try {
              await verifyPickupOtp(api, otp);
              ref.invalidate(currentAssignmentProvider);
              _showSuccess('Pickup verified successfully! 🎉');
              // Exit navigation and invalidate provider to trigger drop navigation
              widget.onNavigationExit();
            } catch (e) {
              _showError('Invalid OTP. Please try again.');
            }
          }
          break;
        case BookingStatus.pickupVerified:
        case BookingStatus.inTransit:
          await dropArrived(api);
          ref.invalidate(currentAssignmentProvider);
          _showSuccess('Marked as arrived at drop');
          break;
        case BookingStatus.dropArrived:
          // Show OTP dialog for drop verification
          if(!mounted) return;
          final otp = await _showOtpDialog(context, 'Drop Verification', 'Enter the OTP provided by the customer');
          if (otp != null && otp.length == 4) {
            try {
              await verifyDropOtp(api, otp);
              ref.invalidate(currentAssignmentProvider);
              _showSuccess('Drop verified successfully! 🎉');
              // Exit navigation and show finish ride modal
              widget.onNavigationExit();
            } catch (e) {
              _showError('Invalid OTP. Please try again.');
            }
          }
          break;
        case BookingStatus.dropVerified:
          await finishRide(api);
          ref.invalidate(currentAssignmentProvider);
          _showSuccess('Ride completed successfully! 🎉');
          break;
        default:
          break;
      }
    } catch (e) {
      _showError('Failed to update status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccess(String message) {
    if (context.mounted) {
      SnackBars.success(context, message);
    }
  }

  void _showError(String message) {
    if (context.mounted) {
      SnackBars.error(context, message);
    }
  }

  Future<String?> _showOtpDialog(BuildContext context, String title, String subtitle) async {
    final cs = Theme.of(context).colorScheme;
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      barrierColor: cs.shadow.withValues(alpha: 0.35),
      builder: (ctx) {
        return OtpBottomSheet(title: title, subtitle: subtitle);
      },
    );
  }
}
