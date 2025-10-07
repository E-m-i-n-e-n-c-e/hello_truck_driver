import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
        ),
        child: NavigationBar(
          destinations: [
            _buildNavItem(icon: Icons.dashboard_rounded, index: 0, label: 'Home', colorScheme: colorScheme),
            _buildNavItem(icon: Icons.directions_car_filled_rounded, index: 1, label: 'Rides', colorScheme: colorScheme),
            _buildNavItem(icon: Icons.account_balance_wallet_rounded, index: 2, label: 'Payments', colorScheme: colorScheme),
            _buildNavItem(icon: Icons.person_rounded, index: 3, label: 'Profile', colorScheme: colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    String? label,
    required ColorScheme colorScheme,
  }) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      borderRadius: BorderRadius.circular(1000),
      onTap: () => onItemSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 4),
            if (label != null)
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
