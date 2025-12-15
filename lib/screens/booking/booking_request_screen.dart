import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/booking.dart';
import '../../models/enums/package_enums.dart';

const int _totalSeconds = 30;

class BookingRequestScreen extends StatefulWidget {
  final Booking booking;
  final VoidCallback onTimeExpired;
  final Function(bool accepted) onBookingResponse;

  const BookingRequestScreen({
    super.key,
    required this.booking,
    required this.onTimeExpired,
    required this.onBookingResponse,
  });

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen>
    with TickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _mapAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _mapOpacityAnimation;
  late Animation<Offset> _slideAnimation;

  GoogleMapController? _mapController;
  int _remainingSeconds = _totalSeconds;
  bool _isProcessing = false;
  bool _markersSetup = false;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTimer();

    // Add haptic feedback when screen appears
    HapticFeedback.mediumImpact();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Setup map markers here since we need Theme.of(context)
    if (!_markersSetup) {
      _setupMapMarkers();
      _markersSetup = true;
    }
  }

  void _initializeAnimations() {
    _mapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _mapOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mapAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _mapAnimationController.forward();
    _slideAnimationController.forward();
  }

  void _setupMapMarkers() {
    final pickupLatLng = LatLng(
      widget.booking.pickupAddress.latitude,
      widget.booking.pickupAddress.longitude,
    );
    final dropLatLng = LatLng(
      widget.booking.dropAddress.latitude,
      widget.booking.dropAddress.longitude,
    );

    _markers = {
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLatLng,
        infoWindow: InfoWindow(
          title: 'Pickup Location',
          snippet: widget.booking.pickupAddress.formattedAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: dropLatLng,
        infoWindow: InfoWindow(
          title: 'Drop Location',
          snippet: widget.booking.dropAddress.formattedAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    final pickup = LatLng(
      widget.booking.pickupAddress.latitude,
      widget.booking.pickupAddress.longitude,
    );
    final drop = LatLng(
      widget.booking.dropAddress.latitude,
      widget.booking.dropAddress.longitude,
    );

    _polylines = {
      // Simple, highly visible route line
      Polyline(
        polylineId: const PolylineId('route'),
        points: [pickup, drop], // Direct line first to test
        color: Theme.of(context).colorScheme.primary,
        width: 8,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        jointType: JointType.round,
      ),
    };
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _remainingSeconds--;
      });

      // Haptic feedback at 10, 5, and 3 seconds
      if (_remainingSeconds == 10 || _remainingSeconds == 5 || _remainingSeconds == 3) {
        HapticFeedback.lightImpact();
      }

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _handleTimeExpired();
      }
    });
  }

  void _handleTimeExpired() {
    if (!mounted || _isProcessing) return;

    HapticFeedback.heavyImpact();
    widget.onTimeExpired();
  }

  void _handleBookingResponse(bool accepted) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    _timer.cancel();

    // Provide haptic feedback
    if (accepted) {
      HapticFeedback.lightImpact();
    } else {
      HapticFeedback.mediumImpact();
    }

    // Animate out
    await _slideAnimationController.reverse();

    if (mounted) {
      await widget.onBookingResponse(accepted);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    _fitMapToRoute();
  }

  void _fitMapToRoute() {
    if (_mapController == null) return;

    final pickup = widget.booking.pickupAddress;
    final drop = widget.booking.dropAddress;

    // Create bounds with generous padding
    final double minLat = pickup.latitude < drop.latitude ? pickup.latitude : drop.latitude;
    final double maxLat = pickup.latitude > drop.latitude ? pickup.latitude : drop.latitude;
    final double minLng = pickup.longitude < drop.longitude ? pickup.longitude : drop.longitude;
    final double maxLng = pickup.longitude > drop.longitude ? pickup.longitude : drop.longitude;

    // Add fixed padding (about 1km in each direction)
    const double padding = 0.01;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - padding, minLng - padding),
      northeast: LatLng(maxLat + padding, maxLng + padding),
    );

    // Fit to bounds with delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (_mapController != null && mounted) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100.0),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _mapAnimationController.dispose();
    _slideAnimationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colorScheme.inverseSurface,
        body: Stack(
          children: [
            // Background Map
            AnimatedBuilder(
              animation: _mapOpacityAnimation,
              builder: (context, child) => Opacity(
                opacity: _mapOpacityAnimation.value,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.booking.pickupAddress.latitude,
                      widget.booking.pickupAddress.longitude,
                    ),
                    zoom: 13,
                  ),
                  markers: _markers,
                  polylines: _polylines,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,
                ),
              ),
            ),

            // Dark overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.shadow.withValues(alpha: 0.3),
                    colorScheme.shadow.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),

            // Unified Bottom Sheet
            SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: _buildUnifiedBottomSheet(),
                ),
              ),
            ),

            // Status overlay when processing
            if (_isProcessing)
              Container(
                color: colorScheme.shadow.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thin Timer Bar at top
          _buildThinTimerBar(colorScheme),

          // Main content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with earnings and distance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEarningsChip(colorScheme, textTheme),
                    _buildDistanceChip(textTheme),
                  ],
                ),

                const SizedBox(height: 20),

                // Package info
                _buildPackageInfo(colorScheme, textTheme),

                const SizedBox(height: 20),

                // Route information
                _buildRouteInfo(textTheme),

                const SizedBox(height: 16),

                // Pickup and drop details
                _buildLocationDetails(textTheme),

                const SizedBox(height: 24),

                // Action buttons row
                _buildActionButtonsRow(colorScheme, textTheme),

                const SizedBox(height: 12),

                // Status text
                _buildStatusText(colorScheme, textTheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThinTimerBar(ColorScheme colorScheme) {
    final progress = _remainingSeconds / _totalSeconds.toDouble();

    // Change color based on remaining time
    Color progressColor;
    if (_remainingSeconds > 15) {
      progressColor = Colors.green;
    } else if (_remainingSeconds > 5) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: MediaQuery.of(context).size.width * progress,
            height: 6,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
          ),
          // Timer text overlay
          Positioned(
            top: 10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: progressColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: progressColor, width: 1),
              ),
              child: Text(
                '${_remainingSeconds}s',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChip(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.currency_rupee_rounded,
            color: colorScheme.onPrimary,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            widget.booking.estimatedCost.toStringAsFixed(2),
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistanceChip(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.route_rounded,
            color: Colors.grey.shade600,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.booking.distanceKm.toStringAsFixed(1)} km',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageInfo(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.booking.packageTypeIcon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getPackageTitle(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.booking.formattedWeight,
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getVehicleTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getVehicleTypeColor()),
                ),
                child: Text(
                  widget.booking.vehicleTypeDisplayName,
                  style: textTheme.labelMedium?.copyWith(
                    color: _getVehicleTypeColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (_getPackageDescription().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _getPackageDescription(),
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteInfo(TextTheme textTheme) {
    return Row(
      children: [
        Icon(
          Icons.schedule_rounded,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 6),
        Text(
          'Pickup: ${widget.booking.formattedPickupTime}',
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '~${(widget.booking.distanceKm * 2.5).round()} mins',
            style: textTheme.labelSmall?.copyWith(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDetails(TextTheme textTheme) {
    return Column(
      children: [
        // Pickup location
        _buildLocationItem(
          textTheme,
          icon: Icons.trip_origin_rounded,
          iconColor: Colors.green,
          title: 'Pickup',
          address: widget.booking.pickupAddress.formattedAddress,
          details: widget.booking.pickupAddress.addressDetails,
        ),

        // Route line
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Container(
                width: 2,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Drop location
        _buildLocationItem(
          textTheme,
          icon: Icons.location_on_rounded,
          iconColor: Colors.red,
          title: 'Drop',
          address: widget.booking.dropAddress.formattedAddress,
          details: widget.booking.dropAddress.addressDetails,
        ),
      ],
    );
  }

  Widget _buildLocationItem(
    TextTheme textTheme, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String address,
    String? details,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
              ),
              if (details != null && details.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  details,
                  style: textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtonsRow(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        // Reject button
        Expanded(
          flex: 5,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : () => _handleBookingResponse(false),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade100,
              foregroundColor: Colors.grey.shade700,
              disabledBackgroundColor: Colors.grey.shade100,
              disabledForegroundColor: Colors.grey.shade400,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _isProcessing ? Colors.grey.shade300 : Colors.grey.shade400,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: _isProcessing ? Colors.grey.shade400 : Colors.grey.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  'Decline',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _isProcessing ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Accept button
        Expanded(
          flex: 6,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : () => _handleBookingResponse(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey.shade500,
              elevation: 4,
              shadowColor: colorScheme.primary.withValues(alpha: 0.3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isProcessing
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Accept Ride',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusText(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isProcessing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 14,
            height: 14,
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
      );
    } else if (_remainingSeconds <= 5) {
      return Text(
        'Hurry up! Only ${_remainingSeconds}s left',
        style: textTheme.bodySmall?.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return Text(
        'Choose your response',
        style: textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade500,
        ),
        textAlign: TextAlign.center,
      );
    }
  }

  // Helper methods for package info
  String _getPackageTitle() {
    if (widget.booking.package.productType == ProductType.agricultural) {
      return widget.booking.package.productName ?? 'Agricultural Product';
    } else {
      return widget.booking.package.description ?? 'Package Delivery';
    }
  }

  String _getPackageDescription() {
    if (widget.booking.package.productType == ProductType.agricultural) {
      return 'Agricultural product';
    } else if (widget.booking.package.productType == ProductType.personal) {
      return 'Personal product';
    } else {
      final dimensions = widget.booking.package.length != null &&
              widget.booking.package.width != null &&
              widget.booking.package.height != null
          ? '${widget.booking.package.length}×${widget.booking.package.width}×${widget.booking.package.height} ${widget.booking.package.dimensionUnit?.value ?? 'CM'}'
          : '';
      return dimensions.isNotEmpty ? 'Dimensions: $dimensions' : 'Commercial goods';
    }
  }

  Color _getVehicleTypeColor() {
    // Default color since suggestedVehicleType is now in invoice
    return Colors.green;
  }
}
