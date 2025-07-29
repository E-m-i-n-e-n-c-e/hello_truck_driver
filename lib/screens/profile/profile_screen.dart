import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/driver.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/screens/profile/document_upload_screen.dart';
import 'package:hello_truck_driver/utils/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/screens/profile/profile_providers.dart';
import 'package:hello_truck_driver/screens/profile/document_viewer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _alternatePhoneController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _alternatePhoneController = TextEditingController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _alternatePhoneController.dispose();
    super.dispose();
  }

  void _initializeControllers(Driver driver) {
    _firstNameController.text = driver.firstName ?? '';
    _lastNameController.text = driver.lastName ?? '';
    _emailController.text = driver.email ?? '';
    _alternatePhoneController.text = driver.alternatePhone ?? '';
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final api = ref.read(apiProvider).value!;
      await driver_api.updateDriverProfile(
        api,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        alternatePhone: _alternatePhoneController.text.trim(),
      );

      if (mounted) {
        setState(() => _isEditing = false);
        SnackBars.success(context, 'Profile updated successfully');
        ref.invalidate(driverProvider);
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to update profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _reUploadDocument(String documentType, String title) async {
    final documents = (await ref.read(driverProvider.future)).documents;
    if (documents == null) return;

    final currentExpiry = switch (documentType) {
      'license' => documents.licenseExpiry,
      'fc' => documents.fcExpiry,
      'insurance' => documents.insuranceExpiry,
      _ => null,
    };

    final currentUrl = switch (documentType) {
      'license' => documents.licenseUrl,
      'rcBook' => documents.rcBookUrl,
      'fc' => documents.fcUrl,
      'insurance' => documents.insuranceUrl,
      'aadhar' => documents.aadharUrl,
      'ebBill' => documents.ebBillUrl,
      _ => '',
    };

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => DocumentReUploadDialog(
        title: title,
        documentType: documentType,
        currentExpiry: currentExpiry,
        currentUrl: currentUrl,
        onSuccess: () {
          ref.invalidate(driverProvider);
          SnackBars.success(context, '$title re-uploaded successfully');
        },
      ),
    );
  }

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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final driverAsync = ref.watch(driverProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.secondary,
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.onSecondary,
          unselectedLabelColor: colorScheme.onSecondary.withValues(alpha: 0.7),
          indicatorColor: colorScheme.onSecondary,
          tabs: const [
            Tab(text: 'Personal Info'),
            Tab(text: 'Documents'),
          ],
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _isEditing = false),
            ),
          ],
        ],
      ),
      body: driverAsync.when(
        data: (driver) {
          if (!_isEditing) {
            _initializeControllers(driver);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Personal Info Tab
              _buildPersonalInfoTab(driver, colorScheme, textTheme),
              // Documents Tab
              _buildDocumentsTab(driver, colorScheme, textTheme),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile: $error',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => ref.invalidate(driverProvider),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoTab(Driver driver, ColorScheme colorScheme, TextTheme textTheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.secondary.withValues(alpha: 0.1),
                    backgroundImage: driver.photo != null && driver.photo!.isNotEmpty
                        ? NetworkImage(driver.photo!)
                        : null,
                    child: driver.photo == null || driver.photo!.isEmpty
                        ? Text(
                            ('${driver.firstName?.isNotEmpty == true ? driver.firstName![0] : ''}'
                                    '${driver.lastName?.isNotEmpty == true ? driver.lastName![0] : ''}')
                                .toUpperCase(),
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  if (!_isEditing) ...[
                    Text(
                      '${driver.firstName ?? ''} ${driver.lastName ?? ''}'.trim(),
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (driver.email?.isNotEmpty == true)
                      Text(
                        driver.email!,
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Verification Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getVerificationStatusColor(driver.verificationStatus, colorScheme).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _getVerificationStatusColor(driver.verificationStatus, colorScheme),
                        ),
                      ),
                      child: Text(
                        _getVerificationStatusText(driver.verificationStatus),
                        style: textTheme.bodyMedium?.copyWith(
                          color: _getVerificationStatusColor(driver.verificationStatus, colorScheme),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (_isEditing) ...[
              // Edit Form
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                ),
                enabled: _isEditing && !_isLoading,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name (Optional)',
                  hintText: 'Enter your last name',
                ),
                enabled: _isEditing && !_isLoading,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                ),
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _alternatePhoneController,
                decoration: const InputDecoration(
                  labelText: 'Alternate Phone (Optional)',
                  hintText: 'Enter alternate phone number',
                ),
                enabled: _isEditing && !_isLoading,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  if (value.length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.secondary,
                  foregroundColor: colorScheme.onSecondary,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ] else ...[
              // Profile Info
              _InfoTile(
                icon: Icons.phone,
                title: 'Phone Number',
                subtitle: driver.phoneNumber.isEmpty ? 'Not set' : driver.phoneNumber,
              ),
              const SizedBox(height: 16),

              if (driver.alternatePhone?.isNotEmpty == true)
                _InfoTile(
                  icon: Icons.phone_android,
                  title: 'Alternate Phone',
                  subtitle: driver.alternatePhone!,
                ),
              if (driver.alternatePhone?.isNotEmpty == true) const SizedBox(height: 16),

              if (driver.referalCode?.isNotEmpty == true)
                _InfoTile(
                  icon: Icons.card_giftcard,
                  title: 'Referral Code',
                  subtitle: driver.referalCode!,
                ),
              if (driver.referalCode?.isNotEmpty == true) const SizedBox(height: 16),

              _InfoTile(
                icon: Icons.verified_user,
                title: 'Account Status',
                subtitle: driver.isActive ? 'Active' : 'Inactive',
              ),
              const SizedBox(height: 16),

              _InfoTile(
                icon: Icons.calendar_today,
                title: 'Member Since',
                subtitle: '${driver.createdAt.day}/${driver.createdAt.month}/${driver.createdAt.year}',
              ),
            ],

            // Logout Button
            if (!_isEditing) ...[
              const SizedBox(height: 32),
              OutlinedButton(
                onPressed: () async {
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            'LOGOUT',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true && mounted) {
                    await ref.read(apiProvider).value!.signOut();
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.error,
                  minimumSize: const Size(double.infinity, 50),
                  side: BorderSide(color: colorScheme.error),
                ),
                child: const Text('Logout'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsTab(Driver driver, ColorScheme colorScheme, TextTheme textTheme) {
    if (driver.documents == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No documents found',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete your onboarding to upload documents',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    final documents = driver.documents!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PAN Number display
          _InfoTile(
            icon: Icons.credit_card_rounded,
            title: 'PAN Number',
            subtitle: documents.panNumber,
          ),
          const SizedBox(height: 16),

          // Document Cards
          _buildDocumentCard(
            context,
            title: 'Driving License',
            subtitle: 'Valid until ${_formatDate(documents.licenseExpiry)}',
            icon: Icons.drive_eta_rounded,
            documentType: 'license',
            currentUrl: documents.licenseUrl,
            showExpiryDate: true,
            expiryDate: documents.licenseExpiry,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'RC Book',
            subtitle: 'Vehicle registration certificate',
            icon: Icons.local_shipping_rounded,
            documentType: 'rcBook',
            currentUrl: documents.rcBookUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'FC Certificate',
            subtitle: 'Valid until ${_formatDate(documents.fcExpiry)}',
            icon: Icons.verified_rounded,
            documentType: 'fc',
            currentUrl: documents.fcUrl,
            showExpiryDate: true,
            expiryDate: documents.fcExpiry,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'Insurance Certificate',
            subtitle: 'Valid until ${_formatDate(documents.insuranceExpiry)}',
            icon: Icons.security_rounded,
            documentType: 'insurance',
            currentUrl: documents.insuranceUrl,
            showExpiryDate: true,
            expiryDate: documents.insuranceExpiry,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'Aadhar Card',
            subtitle: 'Identity proof',
            icon: Icons.person_rounded,
            documentType: 'aadhar',
            currentUrl: documents.aadharUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'Electricity Bill',
            subtitle: 'Address proof',
            icon: Icons.receipt_long_rounded,
            documentType: 'ebBill',
            currentUrl: documents.ebBillUrl,
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String documentType,
    required String currentUrl,
    bool hasChanges = false,
    bool showExpiryDate = false,
    DateTime? expiryDate,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: hasChanges
              ? Colors.orange
              : colorScheme.outline.withValues(alpha: 0.3),
          width: hasChanges ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                    ],
                  ),
                ),
                if (hasChanges)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: Text(
                      'Updated',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // View/Re-upload Actions
            Row(
              children: [
                // View Document Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => showDocumentViewer(context, documentType: documentType, title: title),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.visibility_rounded, size: 18),
                    label: Text(
                      'View',
                      style: TextStyle(
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),
                // Re-upload Document Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _reUploadDocument(documentType, title),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.upload_file_rounded, size: 18),
                    label: const Text(
                      'Re-upload',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Expiry Date Display (always visible when expiry exists)
            if (showExpiryDate && expiryDate != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Expires: ${_formatDate(expiryDate)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}


class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.secondary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
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