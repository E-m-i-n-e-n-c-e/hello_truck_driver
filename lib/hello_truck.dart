import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_truck_driver/models/auth_state.dart';
import 'package:hello_truck_driver/providers/app_initializer_provider.dart.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/screens/dashboard_screen.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/screens/profile/profile_screen.dart';
import 'package:hello_truck_driver/screens/rides_screen.dart';
import 'package:hello_truck_driver/screens/payments_screen.dart';
import 'package:hello_truck_driver/screens/onboarding/onboarding_screen.dart';
import 'package:hello_truck_driver/services/location_service.dart';
import 'package:hello_truck_driver/widgets/bottom_navbar.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';

class HelloTruck extends ConsumerStatefulWidget {
  const HelloTruck({super.key});

  @override
  ConsumerState<HelloTruck> createState() => _HelloTruckState();
}

class _HelloTruckState extends ConsumerState<HelloTruck> {
  int _selectedIndex = 0;
  final List<Widget> _screens = List.filled(4, const SizedBox.shrink());
  final List<bool> _screenLoaded = List.filled(4, false); // Track loaded state
  bool _hasSetupListener = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybePromptForLocation();
    });
  }

  Future<void> _maybePromptForLocation() async {
    final locationService = ref.read(locationServiceProvider);

    final status = await locationService.checkAndRequestPermissions();

    if (status == LocationPermissionStatus.disabled) {
      final openSettings = await _showPermissionDialog(
        title: 'Turn on Location Services',
        content: 'Location services are off. Without location, you won’t be able to take rides.',
        primaryText: 'Open Settings',
        secondaryText: 'Skip for now',
      );
      if (openSettings == true) {
        await Geolocator.openLocationSettings();
      }
    }

    if (status == LocationPermissionStatus.denied) {
      final tryEnable = await _showPermissionDialog(
        title: 'Enable Location Permission',
        content: 'We need your location to assign rides. You won’t be able to take rides otherwise.',
        primaryText: 'Enable',
        secondaryText: 'Skip for now',
      );
      if (tryEnable == true) {
        await locationService.checkAndRequestPermissions();
      }
    }

    if (status == LocationPermissionStatus.deniedForever) {
      final openAppSettings = await _showPermissionDialog(
        title: 'Location Permission Required',
        content: 'Permission is permanently denied. Open app settings to allow location.\nWithout this, you won’t be able to take rides.',
        primaryText: 'Open Settings',
        secondaryText: 'Skip for now',
      );
      if (openAppSettings == true) {
        await Geolocator.openAppSettings();
      }
    }

    // If granted, nothing else to do — your existing updates flow will proceed.
  }

  Future<bool?> _showPermissionDialog({
    required String title,
    required String content,
    required String primaryText,
    required String secondaryText,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: textTheme.titleLarge?.copyWith(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              secondaryText,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              primaryText,
              style: TextStyle(color: colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _loadScreen(int index) {
    if (!_screenLoaded[index]) {
      _screens[index] = switch (index) {
        0 => const DashboardScreen(),
        1 => const RidesScreen(),
        2 => const PaymentsScreen(),
        3 => const ProfileScreen(),
        _ => const SizedBox.shrink(),
      };
      _screenLoaded[index] = true;
    }
  }

  void _setupListeners(AsyncValue<AuthState> authState) {
      if (!_hasSetupListener) {
        // Show offline snackbar if user is offline
        if (authState.value?.isOffline == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackBars.error(context, 'You are offline. Please check your internet connection.');
          });
        }

        _hasSetupListener = true;
      }
      // Listen for offline status changes
      ref.listen(authStateProvider, (previous, next) {
        if (next.value?.isOffline == true) {
          SnackBars.error(context, 'You are offline. Please check your internet connection.');
        }
        else if (previous?.value?.isOffline == true && next.value?.isOffline == false) {
          SnackBars.success(context, 'You are back online');
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    _setupListeners(authState);

    if (authState.value?.hasCompletedOnboarding!=true) {
      return const OnboardingScreen();
    }

    // Run app initializer and watch it to keep it running
    ref.watch(appInitializerProvider);

    // Start location updates
    ref.watch(locationUpdatesProvider);

    _loadScreen(_selectedIndex);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          if (index == 3 || index == 1) {
            ref.invalidate(driverProvider);
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
