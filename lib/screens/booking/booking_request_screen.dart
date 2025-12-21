import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/booking.dart';
import '../../utils/currency_format.dart';

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
  late AnimationController _progressAnimationController;
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
    HapticFeedback.mediumImpact();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

    // Smooth progress animation from 1.0 to 0.0 over the total time
    _progressAnimationController = AnimationController(
      duration: const Duration(seconds: _totalSeconds),
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

    _mapAnimationController.forward();
    _slideAnimationController.forward();

    // Start the smooth progress animation from 1.0 to 0.0
    _progressAnimationController.reverse(from: 1.0);
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
          title: 'Pickup',
          snippet: widget.booking.pickupAddress.formattedAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('drop'),
        position: dropLatLng,
        infoWindow: InfoWindow(
          title: 'Drop',
          snippet: widget.booking.dropAddress.formattedAddress,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };

    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [pickupLatLng, dropLatLng],
        color: Theme.of(context).colorScheme.primary,
        width: 6,
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
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          timer.cancel();
          widget.onTimeExpired();
        }
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _fitMapToRoute();
  }

  void _fitMapToRoute() {
    if (_mapController == null) return;

    final pickup = widget.booking.pickupAddress;
    final drop = widget.booking.dropAddress;

    final double minLat = pickup.latitude < drop.latitude ? pickup.latitude : drop.latitude;
    final double maxLat = pickup.latitude > drop.latitude ? pickup.latitude : drop.latitude;
    final double minLng = pickup.longitude < drop.longitude ? pickup.longitude : drop.longitude;
    final double maxLng = pickup.longitude > drop.longitude ? pickup.longitude : drop.longitude;

    const double padding = 0.01;

    final bounds = LatLngBounds(
      southwest: LatLng(minLat - padding, minLng - padding),
      northeast: LatLng(maxLat + padding, maxLng + padding),
    );

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
    _progressAnimationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: cs.surface,
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
                    cs.shadow.withValues(alpha: 0.2),
                    cs.shadow.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),

            // Bottom Sheet
            SlideTransition(
              position: _slideAnimation,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildBottomSheet(),
              ),
            ),

            // Processing overlay
            if (_isProcessing)
              Container(
                color: cs.shadow.withValues(alpha: 0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Timer bar
          _buildTimerBar(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with new ride alert
                _buildHeader(cs, tt),
                const SizedBox(height: 20),

                // Earnings and distance chips
                _buildInfoChips(cs, tt),
                const SizedBox(height: 20),

                // Package and route info
                _buildDetailsSection(cs, tt),
                const SizedBox(height: 24),

                // Action buttons
                _buildActionButtons(cs, tt),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBar() {
    final cs = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _progressAnimationController,
      builder: (context, child) {
        final progress = _progressAnimationController.value;

        // Smooth color transition based on progress
        Color timerColor;
        if (progress > 0.5) {
          timerColor = Colors.green;
        } else if (progress > 0.17) {
          // Interpolate between green and orange
          timerColor = Color.lerp(
            Colors.orange,
            Colors.green,
            (progress - 0.17) / 0.33,
          )!;
        } else {
          // Interpolate between red and orange
          timerColor = Color.lerp(
            cs.error,
            Colors.orange,
            progress / 0.17,
          )!;
        }

        return Container(
          height: 6,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: timerColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ColorScheme cs, TextTheme tt) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.local_shipping_rounded,
            color: cs.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Ride Request',
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'Booking #${widget.booking.bookingNumber}',
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _getTimerColor(cs).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_rounded,
                color: _getTimerColor(cs),
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                '$_remainingSeconds s',
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _getTimerColor(cs),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTimerColor(ColorScheme cs) {
    if (_remainingSeconds > 15) return Colors.green;
    if (_remainingSeconds > 5) return Colors.orange;
    return cs.error;
  }

  Widget _buildInfoChips(ColorScheme cs, TextTheme tt) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.currency_rupee_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.booking.estimatedCost.toCurrency(),
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.route_rounded,
                  color: cs.primary,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.booking.distanceKm.toStringAsFixed(1)} km',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cs.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Package info
          Row(
            children: [
              Text(
                widget.booking.packageTypeIcon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.booking.package.displayName,
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.booking.formattedWeight,
                      style: tt.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: cs.outline.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),

          // Route info
          _buildRouteRow(
            cs,
            tt,
            Icons.location_on_rounded,
            cs.primary,
            'Pickup',
            widget.booking.pickupAddress.formattedAddress,
          ),
          const SizedBox(height: 12),
          _buildRouteRow(
            cs,
            tt,
            Icons.flag_rounded,
            cs.error,
            'Drop',
            widget.booking.dropAddress.formattedAddress,
          ),

          // Pickup time if scheduled
          if (widget.booking.scheduledAt != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 18,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 8),
                Text(
                  'Pickup: ${widget.booking.formattedPickupTime}',
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRouteRow(
    ColorScheme cs,
    TextTheme tt,
    IconData icon,
    Color iconColor,
    String label,
    String address,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                  fontSize: 11,
                ),
              ),
              Text(
                address.split(',').take(2).join(', '),
                style: tt.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ColorScheme cs, TextTheme tt) {
    return Row(
      children: [
        // Reject button
        Expanded(
          child: OutlinedButton(
            onPressed: _isProcessing
                ? null
                : () {
                    setState(() => _isProcessing = true);
                    HapticFeedback.lightImpact();
                    widget.onBookingResponse(false);
                  },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              side: BorderSide(
                color: cs.error.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Text(
              'Reject',
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.error,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Accept button
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () {
                    setState(() => _isProcessing = true);
                    HapticFeedback.mediumImpact();
                    widget.onBookingResponse(true);
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_rounded, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Accept Ride',
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
    );
  }
}
