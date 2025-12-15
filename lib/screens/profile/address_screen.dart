import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hello_truck_driver/models/driver_address.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/services/location_service.dart';
import 'package:hello_truck_driver/widgets/location_permission_handler.dart';
import 'package:hello_truck_driver/widgets/address_search_widget.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/api/address_api.dart' as address_api;

class AddressScreen extends ConsumerStatefulWidget {
  const AddressScreen({super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  bool _isEditing = false;
  bool _isSaving = false;

  // Text controllers
  final _addressLine1Controller = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();

  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  void _populateFields(DriverAddress? address) {
    if (address != null) {
      _addressLine1Controller.text = address.addressLine1;
      _landmarkController.text = address.landmark ?? '';
      _pincodeController.text = address.pincode;
      _cityController.text = address.city;
      _districtController.text = address.district;
      _stateController.text = address.state;
      _latitude = address.latitude;
      _longitude = address.longitude;

      // Set marker if location exists
      if (address.latitude != null && address.longitude != null) {
        _updateMarker(LatLng(address.latitude!, address.longitude!));
      }
    }
  }

  Future<void> _updateMarker(LatLng location) async {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId('address_marker'),
        position: location,
        draggable: _isEditing,
        onDragEnd: _isEditing ? (newPosition) => _updateLocationAndAddress(newPosition) : null,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );
    setState(() {});
  }

  Future<void> _updateLocationAndAddress(LatLng location) async {
    _latitude = location.latitude;
    _longitude = location.longitude;

    await _updateMarker(location);

    // Get address details from coordinates
    final locationService = ref.read(locationServiceProvider);
    final addressData = await locationService.getAddressFromLatLng(
      location.latitude,
      location.longitude,
    );

    setState(() {
      _addressLine1Controller.text = addressData.addressLine1;
      _landmarkController.text = addressData.landmark;
      _pincodeController.text = addressData.pincode;
      _cityController.text = addressData.city;
      _districtController.text = addressData.district;
      _stateController.text = addressData.state;
    });

    // Move camera to location
    _mapController?.animateCamera(CameraUpdate.newLatLng(location));
  }

  Future<void> _initializeFromCurrentLocation() async {
    final locationService = ref.read(locationServiceProvider);
    final permission = await locationService.checkAndRequestPermissions();

    if (permission == LocationPermissionStatus.granted) {
      try {
        final position = await ref.read(currentPositionStreamProvider.future);
        await _updateLocationAndAddress(LatLng(position.latitude, position.longitude));
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 16),
        );
      } catch (e) {
        debugPrint('Error getting current position: $e');
      }
    }
  }

  void _showAddressSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddressSearchWidget(
        currentAddress: _addressLine1Controller.text,
        onLocationSelected: (LatLng location, String address) {
          _updateLocationAndAddress(location);
        },
        title: 'Search for Address',
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (_addressLine1Controller.text.isEmpty ||
        _pincodeController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _districtController.text.isEmpty ||
        _stateController.text.isEmpty) {
      SnackBars.error(context, 'Please fill all required fields');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final api = await ref.read(apiProvider.future);

      // Check if address exists - update or create
      final currentAddress = ref.read(addressProvider).value;

      if (currentAddress != null) {
        await address_api.updateAddress(
          api,
          addressLine1: _addressLine1Controller.text.trim(),
          landmark: _landmarkController.text.trim(),
          pincode: _pincodeController.text.trim(),
          city: _cityController.text.trim(),
          district: _districtController.text.trim(),
          state: _stateController.text.trim(),
          latitude: _latitude,
          longitude: _longitude,
        );
      } else {
        await address_api.createAddress(
          api,
          addressLine1: _addressLine1Controller.text.trim(),
          landmark: _landmarkController.text.trim(),
          pincode: _pincodeController.text.trim(),
          city: _cityController.text.trim(),
          district: _districtController.text.trim(),
          state: _stateController.text.trim(),
          latitude: _latitude,
          longitude: _longitude,
        );
      }

      ref.invalidate(addressProvider);

      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        SnackBars.success(context, 'Address updated successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        SnackBars.error(context, 'Failed to save address: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final addressAsync = ref.watch(addressProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Address',
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isEditing)
            TextButton.icon(
              onPressed: () {
                final address = addressAsync.value;
                _populateFields(address);
                setState(() => _isEditing = true);
              },
              icon: Icon(Icons.edit_rounded, size: 18, color: cs.primary),
              label: Text(
                'Edit',
                style: tt.labelLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(addressProvider);
        },
        child: addressAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          error: (error, stack) => _buildErrorState(context, error),
          data: (address) {
            if (!_isEditing && address == null) {
              return _buildEmptyState(context);
            }
            if (_isEditing) {
              return _buildEditMode(context, address);
            }
            return _buildViewMode(context, address!);
          },
        ),
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
              'Failed to load address',
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
              onPressed: () => ref.invalidate(addressProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                color: cs.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No address found',
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your address to continue',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () {
                _populateFields(null);
                setState(() => _isEditing = true);
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Address'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewMode(BuildContext context, DriverAddress address) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Preview
          if (address.latitude != null && address.longitude != null)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: cs.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(address.latitude!, address.longitude!),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('address'),
                      position: LatLng(address.latitude!, address.longitude!),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                    ),
                  },
                  zoomControlsEnabled: false,
                  scrollGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                ),
              ),
            ),
          const SizedBox(height: 20),

          // Address Details
          Container(
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
                _buildInfoRow(context, Icons.home_rounded, 'Address', address.addressLine1),
                if (address.landmark?.isNotEmpty == true) ...[
                  _buildDivider(context),
                  _buildInfoRow(context, Icons.place_rounded, 'Landmark', address.landmark!),
                ],
                _buildDivider(context),
                _buildInfoRow(context, Icons.pin_drop_rounded, 'Pincode', address.pincode),
                _buildDivider(context),
                _buildInfoRow(context, Icons.location_city_rounded, 'City', address.city),
                _buildDivider(context),
                _buildInfoRow(context, Icons.map_rounded, 'District', address.district),
                _buildDivider(context),
                _buildInfoRow(context, Icons.public_rounded, 'State', address.state),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEditMode(BuildContext context, DriverAddress? address) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Map Container
          LocationPermissionHandler(
            onPermissionGranted: () {
              if (_latitude == null && _longitude == null) {
                _initializeFromCurrentLocation();
              }
            },
            child: Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: cs.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                        if (_latitude != null && _longitude != null) {
                          controller.animateCamera(
                            CameraUpdate.newLatLngZoom(LatLng(_latitude!, _longitude!), 15),
                          );
                        }
                      },
                      initialCameraPosition: CameraPosition(
                        target: _latitude != null && _longitude != null
                            ? LatLng(_latitude!, _longitude!)
                            : const LatLng(12.9716, 77.5946),
                        zoom: 14,
                      ),
                      markers: _markers,
                      onTap: _updateLocationAndAddress,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: false,
                      tiltGesturesEnabled: false,
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    ),

                    // Search Button
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10),
                        color: cs.surface,
                        child: InkWell(
                          onTap: _showAddressSearchModal,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.search_rounded, size: 20, color: cs.primary),
                          ),
                        ),
                      ),
                    ),

                    // My Location Button
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10),
                        color: cs.surface,
                        child: InkWell(
                          onTap: () async {
                            final position = await ref.read(currentPositionStreamProvider.future);
                            await _updateLocationAndAddress(LatLng(position.latitude, position.longitude));
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Icon(Icons.my_location_rounded, size: 20, color: cs.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap on map or drag marker to select location',
            style: tt.bodySmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 20),

          // Address Form
          _buildTextField(
            controller: _addressLine1Controller,
            label: 'Address Line 1 *',
            hint: 'House/Building, Street',
            icon: Icons.home_rounded,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _landmarkController,
            label: 'Landmark (Optional)',
            hint: 'Near landmark or area',
            icon: Icons.place_rounded,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _pincodeController,
            label: 'Pincode *',
            hint: 'Enter pincode',
            icon: Icons.pin_drop_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _cityController,
            label: 'City *',
            hint: 'City name',
            icon: Icons.location_city_rounded,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _districtController,
            label: 'District *',
            hint: 'District name',
            icon: Icons.map_rounded,
          ),
          const SizedBox(height: 14),

          _buildTextField(
            controller: _stateController,
            label: 'State *',
            hint: 'State name',
            icon: Icons.public_rounded,
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () {
                    setState(() => _isEditing = false);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: tt.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _isSaving ? null : _saveAddress,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cs.onPrimary,
                          ),
                        )
                      : Text(
                          'Save',
                          style: tt.labelLarge?.copyWith(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: tt.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: tt.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
          hintStyle: tt.bodyMedium?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.4),
          ),
          prefixIcon: Icon(icon, color: cs.primary, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  label,
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
}
