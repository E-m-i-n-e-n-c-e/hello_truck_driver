import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_truck_driver/services/location_service.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

class LocationPermissionHandler extends ConsumerStatefulWidget {
  final Widget child;
  final VoidCallback? onPermissionGranted;
  final VoidCallback? onPermissionDenied;

  const LocationPermissionHandler({
    super.key,
    required this.child,
    this.onPermissionGranted,
    this.onPermissionDenied,
  });

  @override
  ConsumerState<LocationPermissionHandler> createState() => _LocationPermissionHandlerState();
}

class _LocationPermissionHandlerState extends ConsumerState<LocationPermissionHandler> {
  LocationPermissionStatus? _permissionStatus;
  bool _isCheckingPermission = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final locationService = ref.read(locationServiceProvider);
    final status = await locationService.checkAndRequestPermissions();

    setState(() {
      _permissionStatus = status;
      _isCheckingPermission = false;
    });

    if (status == LocationPermissionStatus.granted) {
      widget.onPermissionGranted?.call();
    } else {
      widget.onPermissionDenied?.call();
    }
  }

  Future<void> _requestPermission() async {
    setState(() {
      _isCheckingPermission = true;
    });
    await _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isCheckingPermission) {
      final l10n = AppLocalizations.of(context)!;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.checkingLocationPermissions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_permissionStatus == LocationPermissionStatus.granted) {
      return widget.child;
    }

    final l10n = AppLocalizations.of(context)!;
    // Show permission request UI
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _permissionStatus == LocationPermissionStatus.disabled
                  ? Icons.location_disabled_rounded
                  : Icons.location_off_rounded,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              _getPermissionTitle(l10n),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _getPermissionDescription(l10n),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (_permissionStatus != LocationPermissionStatus.deniedForever)
              ElevatedButton.icon(
                onPressed: _requestPermission,
                icon: const Icon(Icons.location_on_rounded),
                label: Text(_getButtonText(l10n)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            if (_permissionStatus == LocationPermissionStatus.deniedForever) ...[
              ElevatedButton.icon(
                onPressed: () => _openAppSettings(),
                icon: const Icon(Icons.settings_rounded),
                label: Text(l10n.openSettings),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _requestPermission,
                child: Text(l10n.checkAgain),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getPermissionTitle(AppLocalizations l10n) {
    switch (_permissionStatus) {
      case LocationPermissionStatus.disabled:
        return l10n.locationServicesDisabled;
      case LocationPermissionStatus.denied:
        return l10n.locationPermissionRequired;
      case LocationPermissionStatus.deniedForever:
        return l10n.locationPermissionDenied;
      default:
        return l10n.locationAccessRequired;
    }
  }

  String _getPermissionDescription(AppLocalizations l10n) {
    switch (_permissionStatus) {
      case LocationPermissionStatus.disabled:
        return l10n.enableLocationServicesDesc;
      case LocationPermissionStatus.denied:
        return l10n.needLocationAccessDesc;
      case LocationPermissionStatus.deniedForever:
        return l10n.locationDeniedForeverDesc;
      default:
        return l10n.locationRequiredDesc;
    }
  }

  String _getButtonText(AppLocalizations l10n) {
    switch (_permissionStatus) {
      case LocationPermissionStatus.disabled:
        return l10n.enableLocationServices;
      case LocationPermissionStatus.denied:
        return l10n.grantPermission;
      default:
        return l10n.requestPermission;
    }
  }

  void _openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}
