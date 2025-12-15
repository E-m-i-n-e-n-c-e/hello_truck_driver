import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingActionButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final bool isProcessing;
  final int remainingSeconds;

  const BookingActionButtons({
    super.key,
    required this.onAccept,
    required this.onReject,
    required this.isProcessing,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Action instruction text
          Text(
            'Choose your response',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              // Reject button
              Expanded(
                child: _buildActionButton(
                  context: context,
                  label: 'Decline',
                  icon: Icons.close_rounded,
                  onPressed: isProcessing ? null : onReject,
                  backgroundColor: Colors.grey.shade100,
                  textColor: Colors.grey.shade700,
                  borderColor: Colors.grey.shade300,
                  isDestructive: true,
                  isCompact: true,
                ),
              ),

              const SizedBox(width: 12),

              // Accept button
              Expanded(
                flex: 2,
                child: _buildActionButton(
                  context: context,
                  label: 'Accept Ride',
                  icon: Icons.check_rounded,
                  onPressed: isProcessing ? null : onAccept,
                  backgroundColor: colorScheme.primary,
                  textColor: colorScheme.onPrimary,
                  borderColor: colorScheme.primary,
                  isPrimary: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Status text
          if (isProcessing) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Processing...',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ] else if (remainingSeconds <= 5) ...[
            Text(
              'Hurry up! Only ${remainingSeconds}s left',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Text(
              'Swipe up for more details',
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    bool isPrimary = false,
    bool isDestructive = false,
    bool isCompact = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                // Provide haptic feedback
                if (isPrimary) {
                  HapticFeedback.lightImpact();
                } else if (isDestructive) {
                  HapticFeedback.mediumImpact();
                }
                onPressed();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: Colors.grey.shade100,
          disabledForegroundColor: Colors.grey.shade400,
          elevation: isPrimary ? 6 : 2,
          shadowColor: isPrimary ? backgroundColor.withValues(alpha: 0.4) : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: onPressed == null ? Colors.grey.shade300 : borderColor,
              width: 1.5,
            ),
          ),
        ),
        child: isCompact
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: onPressed == null ? Colors.grey.shade400 : textColor,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      label,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: onPressed == null ? Colors.grey.shade400 : textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: isPrimary ? 22 : 20,
                    color: onPressed == null ? Colors.grey.shade400 : textColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: onPressed == null ? Colors.grey.shade400 : textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
