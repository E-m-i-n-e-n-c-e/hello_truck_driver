import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/booking_assignment.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/screens/booking/payment_settlement_screen.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/widgets/otp_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

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
  Offset _position = const Offset(20, 120);

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
            final screenSize = MediaQuery.of(context).size;
            _position = Offset(
              _position.dx.clamp(0, screenSize.width - (_isExpanded ? 280 : 120)),
              _position.dy.clamp(0, screenSize.height - (_isExpanded ? 250 : 250)),
            );
          });
        },
        child: _isExpanded
            ? _buildExpandedOverlay(context, status, tt, cs)
            : _buildCompactOverlay(context, status, tt, cs),
      ),
    );
  }

  Widget _buildCompactOverlay(BuildContext context, BookingStatus status, TextTheme tt, ColorScheme cs) {
    final l10n = AppLocalizations.of(context)!;
    final (_, _, icon, color) = _getStatusInfo(l10n, status);

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = true),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outline.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              l10n.actions,
              style: tt.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
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
    final booking = widget.assignment.booking;

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
                color: cs.shadow.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 8),
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
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Call button for all navigation statuses
              if (status != BookingStatus.dropVerified)
                _buildCallButton(context, status, booking, tt, cs),
              if (status != BookingStatus.dropVerified) _buildActionButton(context, status, tt, cs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCallButton(BuildContext context, BookingStatus status, dynamic booking, TextTheme tt, ColorScheme cs) {
    final l10n = AppLocalizations.of(context)!;
    // Pickup phase: confirmed, pickupArrived
    // Drop phase: pickupVerified, inTransit, dropArrived
    final isPickupPhase = status == BookingStatus.confirmed || status == BookingStatus.pickupArrived;
    final phone = isPickupPhase
        ? booking.pickupAddress.contactPhone
        : booking.dropAddress.contactPhone;
    final contactName = isPickupPhase
        ? booking.pickupAddress.contactName
        : booking.dropAddress.contactName;

    if (phone.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: () async {
          final url = Uri.parse('tel:$phone');
          if (!await launchUrl(url)) {
            if (context.mounted) SnackBars.error(context, l10n.couldNotMakeCall);
          }
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.green,
          side: BorderSide(color: Colors.green.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.call_rounded, size: 18, color: Colors.green),
            const SizedBox(width: 8),
            Text(
              l10n.callContact(contactName.isNotEmpty ? contactName.split(' ').first : 'Contact'),
              style: tt.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, BookingStatus status, TextTheme tt, ColorScheme cs) {
    final l10n = AppLocalizations.of(context)!;
    final (title, subtitle, icon, color) = _getStatusInfo(l10n, status);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withValues(alpha: 0.15),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
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
              const SizedBox(height: 2),
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
    final l10n = AppLocalizations.of(context)!;
    final (buttonText, buttonIcon, buttonColor, isEnabled) = _getButtonInfo(l10n, status);

    return ElevatedButton(
      onPressed: isEnabled && !_isLoading ? () => _handleAction(status) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: buttonColor.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(buttonIcon, size: 18),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: tt.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
    );
  }

  (String, String, IconData, Color) _getStatusInfo(AppLocalizations l10n, BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return (l10n.navigateToPickup, l10n.markArrivalAtPickup, Icons.trip_origin_rounded, Colors.green);
      case BookingStatus.pickupArrived:
        return (l10n.verifyPickup, l10n.enterCustomerOtp, Icons.verified_rounded, Colors.blue);
      case BookingStatus.pickupVerified:
      case BookingStatus.inTransit:
        return (l10n.navigateToDrop, l10n.markArrivalAtDrop, Icons.location_on_rounded, Colors.orange);
      case BookingStatus.dropArrived:
        return (l10n.verifyDrop, l10n.enterCustomerOtp, Icons.verified_rounded, Colors.purple);
      case BookingStatus.dropVerified:
        return (l10n.rideComplete, l10n.readyToFinish, Icons.check_circle_rounded, Colors.green);
      default:
        return (l10n.navigation, l10n.followTheRoute, Icons.navigation_rounded, Colors.grey);
    }
  }

  (String, IconData, Color, bool) _getButtonInfo(AppLocalizations l10n, BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return (l10n.markArrived, Icons.location_on_rounded, Colors.green, true);
      case BookingStatus.pickupArrived:
        return (l10n.verifyPickup, Icons.verified_rounded, Colors.blue, true);
      case BookingStatus.pickupVerified:
      case BookingStatus.inTransit:
        return (l10n.markArrived, Icons.location_on_rounded, Colors.orange, true);
      case BookingStatus.dropArrived:
        return (l10n.verifyDrop, Icons.verified_rounded, Colors.purple, true);
      case BookingStatus.dropVerified:
        return (l10n.finishRide, Icons.check_circle_rounded, Colors.green, true);
      default:
        return (l10n.continueText, Icons.arrow_forward_rounded, Colors.grey, false);
    }
  }

  Future<void> _handleAction(BookingStatus status) async {
    setState(() => _isLoading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      final api = await ref.read(apiProvider.future);

      switch (status) {
        case BookingStatus.confirmed:
          await pickupArrived(api);
          ref.invalidate(currentAssignmentProvider);
          _showSuccess(l10n.markedAsArrivedAtPickup);
          break;

        case BookingStatus.pickupArrived:
          // Check payment status BEFORE showing OTP dialog
          final assignment = await ref.read(currentAssignmentProvider.future);
          final finalInvoice = assignment?.booking.finalInvoice;

          if (finalInvoice != null && !finalInvoice.isPaid) {
            // Payment pending - show payment settlement screen as modal
            if (!mounted) return;

            final settled = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => PaymentSettlementScreen(
                  booking: assignment!.booking,
                ),
              ),
            );

            // If payment was settled, refresh and continue with OTP
            if (settled == true && mounted) {
              ref.invalidate(currentAssignmentProvider);

              // Small delay to let provider refresh
              await Future.delayed(const Duration(milliseconds: 300));

              if (!mounted) return;
              final otp = await _showOtpDialog(context, l10n.pickupVerificationTitle, l10n.enterCustomerOtp);
              if (otp != null && otp.length == 4) {
                try {
                  await verifyPickupOtp(api, otp);
                  ref.invalidate(currentAssignmentProvider);
                  _showSuccess(l10n.pickupVerified);
                  widget.onNavigationExit();
                } catch (e) {
                  _showError(l10n.invalidOtpTryAgain);
                }
              }
            }
          } else {
            // Payment already received - proceed with OTP verification
            if (!mounted) return;
            final otp = await _showOtpDialog(context, l10n.pickupVerificationTitle, l10n.enterCustomerOtp);
            if (otp != null && otp.length == 4) {
              try {
                await verifyPickupOtp(api, otp);
                ref.invalidate(currentAssignmentProvider);
                _showSuccess(l10n.pickupVerified);
                widget.onNavigationExit();
              } catch (e) {
                _showError(l10n.invalidOtpTryAgain);
              }
            }
          }
          break;

        case BookingStatus.pickupVerified:
        case BookingStatus.inTransit:
          await dropArrived(api);
          ref.invalidate(currentAssignmentProvider);
          _showSuccess(l10n.markedAsArrivedAtDrop);
          break;

        case BookingStatus.dropArrived:
          if (!mounted) return;
          final otp = await _showOtpDialog(context, l10n.dropVerificationTitle, l10n.enterCustomerOtp);
          if (otp != null && otp.length == 4) {
            try {
              await verifyDropOtp(api, otp);
              ref.invalidate(currentAssignmentProvider);
              _showSuccess(l10n.dropVerified);
              widget.onNavigationExit();
            } catch (e) {
              _showError(l10n.invalidOtpTryAgain);
            }
          }
          break;

        case BookingStatus.dropVerified:
          await finishRide(api);
          ref.invalidate(currentAssignmentProvider);
          _showSuccess(l10n.rideCompleted);
          break;

        default:
          break;
      }
    } catch (e) {
      _showError('Failed: ${e.toString().replaceAll('Exception: ', '')}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
