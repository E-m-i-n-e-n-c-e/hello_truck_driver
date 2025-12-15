import 'package:flutter/material.dart';

class BookingTimerBar extends StatelessWidget {
  final int remainingSeconds;
  final int totalSeconds;

  const BookingTimerBar({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = remainingSeconds / totalSeconds;

    // Change color based on remaining time
    Color progressColor;
    if (remainingSeconds > 15) {
      progressColor = Colors.green;
    } else if (remainingSeconds > 5) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.onInverseSurface.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Request',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: progressColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: progressColor, width: 1),
                ),
                child: Text(
                  '${remainingSeconds}s',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: progressColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: colorScheme.onInverseSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Helper text
          Text(
            remainingSeconds > 10
                ? 'Accept or decline this booking request'
                : 'Time is running out!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onInverseSurface.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
