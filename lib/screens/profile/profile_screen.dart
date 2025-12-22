import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/utils/format_utils.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/screens/profile/dialogs/profile_edit_dialogs.dart';
import 'package:hello_truck_driver/screens/profile/dialogs/profile_picture_dialog.dart';
import 'package:hello_truck_driver/screens/profile/dialogs/email_link_dialog.dart';
import 'package:hello_truck_driver/screens/profile/documents_screen.dart';
import 'package:hello_truck_driver/screens/profile/vehicle_screen.dart';
import 'package:hello_truck_driver/screens/profile/address_screen.dart';
import 'package:hello_truck_driver/utils/date_time_utils.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _getVerificationStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'Pending Verification';
      case 'VERIFIED':
        return 'Verified';
      case 'REJECTED':
        return 'Verification Rejected';
      default:
        return status;
    }
  }

  Color _getVerificationStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'VERIFIED':
        return Colors.green;
      case 'REJECTED':
        return colorScheme.error;
      default:
        return colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final driverAsync = ref.watch(driverProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: driverAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        error: (error, stack) => _buildErrorState(context, error),
        data: (driver) => _buildProfileContent(context, driver),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: cs.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to load profile',
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => ref.invalidate(driverProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, Driver driver) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Profile',
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 24),

            // Profile Card
            _buildProfileCard(context, driver),
            const SizedBox(height: 20),

            // Wallet Balance Card
            _buildWalletBalanceCard(context, driver),
            const SizedBox(height: 20),

            // Quick Access Cards (Documents, Vehicle, Address)
            _buildQuickAccessSection(context),
            const SizedBox(height: 24),

            // Personal Information Section
            _buildSectionHeader(context, 'Personal Information'),
            const SizedBox(height: 12),
            _buildPersonalInfoSection(context, driver),
            const SizedBox(height: 24),

            // Account Section
            _buildSectionHeader(context, 'Account'),
            const SizedBox(height: 12),
            _buildAccountSection(context, driver),
            const SizedBox(height: 24),

            // Logout Button
            _buildLogoutButton(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, Driver driver) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () => _showProfilePictureDialog(driver),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: cs.primary.withValues(alpha: 0.15),
                  backgroundImage: driver.photo != null && driver.photo!.isNotEmpty
                      ? NetworkImage(driver.photo!)
                      : null,
                  child: driver.photo == null || driver.photo!.isEmpty
                      ? Text(
                          ('${driver.firstName?.isNotEmpty == true ? driver.firstName![0] : ''}'
                                  '${driver.lastName?.isNotEmpty == true ? driver.lastName![0] : ''}')
                              .toUpperCase(),
                          style: tt.headlineSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: cs.surfaceContainerHighest,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 14,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${driver.firstName ?? ''} ${driver.lastName ?? ''}'.trim(),
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  driver.phoneNumber,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                // Verification Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getVerificationStatusColor(driver.verificationStatus.value, cs)
                        .withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        driver.verificationStatus.value == 'VERIFIED'
                            ? Icons.verified_rounded
                            : Icons.pending_rounded,
                        size: 14,
                        color: _getVerificationStatusColor(driver.verificationStatus.value, cs),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getVerificationStatusText(driver.verificationStatus.value),
                        style: tt.labelSmall?.copyWith(
                          color: _getVerificationStatusColor(driver.verificationStatus.value, cs),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletBalanceCard(BuildContext context, Driver driver) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cs.primary,
            cs.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: cs.onPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wallet Balance',
                  style: tt.labelMedium?.copyWith(
                    color: cs.onPrimary.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  driver.walletBalance.toRupees(),
                  style: tt.titleLarge?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: cs.onPrimary.withValues(alpha: 0.7),
            size: 22,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Column(
      children: [
        // Documents Card
        _buildQuickAccessCard(
          context,
          icon: Icons.description_rounded,
          title: 'Documents',
          subtitle: 'License, RC, Insurance & more',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DocumentsScreen()),
            );
          },
        ),
        const SizedBox(height: 12),

        // Vehicle Card
        _buildQuickAccessCard(
          context,
          icon: Icons.local_shipping_rounded,
          title: 'Vehicle',
          subtitle: 'Vehicle details & owner info',
          onTap: () {
            ref.invalidate(vehicleProvider);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VehicleScreen()),
            );
          },
        ),
        const SizedBox(height: 12),

        // Address Card
        _buildQuickAccessCard(
          context,
          icon: Icons.location_on_rounded,
          title: 'Address',
          subtitle: 'Your registered address',
          onTap: () {
            ref.invalidate(addressProvider);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddressScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: cs.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
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
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: tt.bodyMedium?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: cs.onSurface.withValues(alpha: 0.5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Text(
      title,
      style: tt.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: cs.onSurface,
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, Driver driver) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.person_rounded,
            title: 'First Name',
            value: driver.firstName ?? 'Not set',
            onEdit: () => _showEditDialog(
              context,
              'First Name',
              driver.firstName ?? '',
              (value) => _updateFirstName(value),
            ),
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.person_rounded,
            title: 'Last Name',
            value: driver.lastName?.isNotEmpty == true ? driver.lastName! : 'Not set',
            onEdit: () => _showEditDialog(
              context,
              'Last Name',
              driver.lastName ?? '',
              (value) => _updateLastName(value),
            ),
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.phone_android_rounded,
            title: 'Alternate Phone',
            value: driver.alternatePhone?.isNotEmpty == true ? driver.alternatePhone! : 'Not set',
            onEdit: () => _showEditDialog(
              context,
              'Alternate Phone',
              driver.alternatePhone ?? '',
              (value) => _updateAlternatePhone(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, Driver driver) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(
            context,
            icon: Icons.phone_rounded,
            title: 'Phone Number',
            value: driver.phoneNumber,
            onEdit: null,
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.email_rounded,
            title: 'Email',
            value: driver.email ?? 'Not linked',
            onEdit: () => _showEmailLinkDialog(driver),
            isAction: driver.email == null,
            actionLabel: 'Link',
          ),
          _buildDivider(context),
          _buildInfoRow(
            context,
            icon: Icons.calendar_today_rounded,
            title: 'Member Since',
            value: DateTimeUtils.formatShortDateIST(driver.createdAt),
            onEdit: null,
          ),
          if (driver.referalCode?.isNotEmpty == true) ...[
            _buildDivider(context),
            _buildInfoRow(
              context,
              icon: Icons.card_giftcard_rounded,
              title: 'Referral Code',
              value: driver.referalCode!,
              onEdit: null,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    VoidCallback? onEdit,
    bool isAction = false,
    String? actionLabel,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(
            icon,
            color: cs.onSurface.withValues(alpha: 0.6),
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.labelMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: tt.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
              ),
              child: Text(
                isAction ? (actionLabel ?? 'Add') : 'Edit',
                style: tt.labelLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      thickness: 1,
      color: cs.outline.withValues(alpha: 0.1),
      indent: 52,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return OutlinedButton(
      onPressed: () => _showLogoutDialog(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: cs.error,
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(color: cs.error.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, size: 20),
          const SizedBox(width: 8),
          Text(
            'Logout',
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showEditDialog(BuildContext context, String title, String currentValue, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditDialog(
        title: title,
        currentValue: currentValue,
        onSave: onSave,
      ),
    );
  }

  void _showProfilePictureDialog(Driver driver) {
    showDialog(
      context: context,
      builder: (ctx) => ProfilePictureDialog(
        currentPhotoUrl: driver.photo,
        onSuccess: () {
          ref.invalidate(driverProvider);
          SnackBars.success(context, 'Profile picture updated successfully');
        },
      ),
    );
  }

  void _showEmailLinkDialog(Driver driver) {
    showDialog(
      context: context,
      builder: (ctx) => EmailLinkDialog(
        currentEmail: driver.email,
        onSuccess: () {
          ref.invalidate(driverProvider);
          SnackBars.success(context, 'Email linked successfully');
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final cs = Theme.of(context).colorScheme;

    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: TextStyle(color: cs.error),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      await ref.read(apiProvider).value!.signOut();
    }
  }

  // Update methods
  Future<void> _updateFirstName(String value) async {
    try {
      final api = ref.read(apiProvider).value!;
      await driver_api.updateDriverProfile(
        api,
        firstName: value.trim(),
      );
      ref.invalidate(driverProvider);
      if (mounted) {
        SnackBars.success(context, 'First name updated successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to update first name: $e');
      }
    }
  }

  Future<void> _updateLastName(String value) async {
    try {
      final api = ref.read(apiProvider).value!;
      await driver_api.updateDriverProfile(
        api,
        lastName: value.trim(),
      );
      ref.invalidate(driverProvider);
      if (mounted) {
        SnackBars.success(context, 'Last name updated successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to update last name: $e');
      }
    }
  }

  Future<void> _updateAlternatePhone(String value) async {
    try {
      final api = ref.read(apiProvider).value!;
      await driver_api.updateDriverProfile(
        api,
        alternatePhone: value.trim(),
      );
      ref.invalidate(driverProvider);
      if (mounted) {
        SnackBars.success(context, 'Alternate phone updated successfully');
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to update alternate phone: $e');
      }
    }
  }
}