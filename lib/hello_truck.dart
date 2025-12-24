import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hello_truck_driver/api/driver_api.dart' as driver_api;
import 'package:hello_truck_driver/models/auth_state.dart';
import 'package:hello_truck_driver/models/enums/driver_enums.dart';
import 'package:hello_truck_driver/providers/app_initializer_provider.dart.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/providers/fcm_providers.dart';
import 'package:hello_truck_driver/models/enums/fcm_enums.dart';
import 'package:hello_truck_driver/providers/location_providers.dart';
import 'package:hello_truck_driver/providers/navigation_providers.dart';
import 'package:hello_truck_driver/screens/dashboard/dashboard_screen.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/screens/profile/profile_screen.dart';
import 'package:hello_truck_driver/screens/rides/rides_screen.dart';
import 'package:hello_truck_driver/screens/earnings/earnings_screen.dart';
import 'package:hello_truck_driver/screens/onboarding/onboarding_screen.dart';
import 'package:hello_truck_driver/services/location_service.dart';
import 'package:hello_truck_driver/utils/document_expiry_utils.dart';
import 'package:hello_truck_driver/widgets/bottom_navbar.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/providers/assignment_providers.dart';
import 'package:hello_truck_driver/screens/booking/booking_request_screen.dart';
import 'package:hello_truck_driver/models/enums/booking_enums.dart';
import 'package:hello_truck_driver/api/assignment_api.dart';
import 'package:hello_truck_driver/widgets/action_modal.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    final status = await locationService.checkAndRequestPermissions();

    if (status == LocationPermissionStatus.disabled) {
      final openSettings = await _showPermissionDialog(
        title: l10n.turnOnLocationServices,
        content: l10n.locationServicesOffMessage,
        primaryText: l10n.openSettings,
        secondaryText: l10n.skipForNow,
      );
      if (openSettings == true) {
        await Geolocator.openLocationSettings();
      }
    }

    if (status == LocationPermissionStatus.denied) {
      final tryEnable = await _showPermissionDialog(
        title: l10n.enableLocationPermission,
        content: l10n.locationPermissionMessage,
        primaryText: l10n.enable,
        secondaryText: l10n.skipForNow,
      );
      if (tryEnable == true) {
        await locationService.checkAndRequestPermissions();
      }
    }

    if (status == LocationPermissionStatus.deniedForever) {
      final openAppSettings = await _showPermissionDialog(
        title: l10n.locationPermissionRequired,
        content: l10n.locationPermissionDeniedMessage,
        primaryText: l10n.openSettings,
        secondaryText: l10n.skipForNow,
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
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
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
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
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
        2 => const EarningsScreen(),
        3 => const ProfileScreen(),
        _ => const SizedBox.shrink(),
      };
      _screenLoaded[index] = true;
    }
  }

  void _setupListeners(AsyncValue<AuthState> authState) {
    final l10n = AppLocalizations.of(context)!;

    if (!_hasSetupListener) {
      // Show offline snackbar if user is offline
      if (authState.value?.isOffline == true) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SnackBars.error(context, l10n.youAreOffline);
        });
      }

      _hasSetupListener = true;
    }
    // Listen for offline status changes
    ref.listen(authStateProvider, (previous, next) {
      if (next.value?.isOffline == true) {
        SnackBars.error(context, l10n.youAreOffline);
      }
      else if (previous?.value?.isOffline == true && next.value?.isOffline == false) {
        SnackBars.success(context, l10n.youAreBackOnline);
      }
    });

    // Listen for driver status changes to start/stop location tracking
    ref.listen(driverProvider, (previous, next) {
      final driver = next.value;
      if (driver == null) return;

      final locationService = ref.read(locationServiceProvider);
      final isAvailable = driver.driverStatus == DriverStatus.available &&
          driver.verificationStatus == VerificationStatus.verified;

      if (isAvailable) {
        locationService.startLocationUpdates();
      } else {
        locationService.stopLocationUpdates();
      }
    });

    // Listen for document expiry - set unavailable if any document expired
    ref.listen(documentsProvider, (previous, next) {
      next.whenData((documents) async {
        if (documents == null) return;
        final alerts = calculateExpiryAlerts(documents, l10n);
        if (!alerts.hasExpiredDocuments) return;

        // Set driver to unavailable (driver listener will stop location tracking)
        final api = await ref.read(apiProvider.future);
        await driver_api.updateDriverStatus(api, isAvailable: false);
        ref.invalidate(driverProvider);
      });
    });

    // Listen for ride cancellations
    ref.listen(fcmEventStreamProvider, (previous, next) {
      next.whenData((event) {
        if (event == FcmEventType.rideCancelled && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            // Cleanup navigation session
            await stopAndCleanupNavigation(RefReader.fromWidgetRef(ref));

            // Pop all screens to home
            if (mounted) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Show cancellation dialog
            if (mounted) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: Row(
                    children: [
                      Icon(Icons.cancel_rounded, color: Theme.of(dialogContext).colorScheme.error),
                      const SizedBox(width: 12),
                      Text(l10n.bookingCancelled),
                    ],
                  ),
                  content: Text(l10n.bookingCancelledMessage),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(l10n.ok),
                    ),
                  ],
                ),
              );
            }}
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final hasShownActionModalThisSession = ref.watch(hasShownActionModalProvider);
    final l10n = AppLocalizations.of(context)!;

    _setupListeners(authState);

    if (authState.value?.hasCompletedOnboarding!=true) {
      return const OnboardingScreen();
    }

    // Run app initializer and watch it to keep it running
    ref.watch(appInitializerProvider);

    // Start location updates
    ref.watch(locationUpdatesProvider);

    // Handle fcm events
    ref.watch(fcmEventsHandlerProvider);

    // Handle app lifecycle events
    ref.watch(appLifecycleHandlerProvider);

    // If there is an offered assignment, show booking request screen directly
    final currentAssignment = ref.watch(currentAssignmentProvider);
    if (currentAssignment.hasValue &&
        currentAssignment.value != null &&
        currentAssignment.value!.status == AssignmentStatus.offered) {
      final assignment = currentAssignment.value!;
      return BookingRequestScreen(
        booking: assignment.booking,
        onTimeExpired: () async {
          try {
            final api = await ref.read(apiProvider.future);
            await rejectAssignment(api, assignment.id);
          } catch (e) {
            if (context.mounted) {
              SnackBars.error(context, l10n.failedToRejectBooking(e.toString()));
            }
          } finally {
            ref.invalidate(currentAssignmentProvider);
            ref.invalidate(driverProvider);
          }
        },
        onBookingResponse: (accepted) async {
          try {
            final api = await ref.read(apiProvider.future);
            if (accepted) {
              await acceptAssignment(api, assignment.id);
            } else {
              await rejectAssignment(api, assignment.id);
            }
          } catch (e) {
            if (context.mounted) {
              SnackBars.error(context, l10n.failedToProcessBooking(e.toString()));
            }
          } finally {
            // This will cause the UI to transition away when status becomes on_ride/available
            ref.read(hasShownActionModalProvider.notifier).state = false;
            ref.invalidate(currentAssignmentProvider);
            ref.invalidate(driverProvider);
          }
        },
      );
    }

    // Show pickup navigation modal when assignment is accepted (once per session)
    if (currentAssignment.hasValue &&
        currentAssignment.value != null &&
        currentAssignment.value!.status == AssignmentStatus.accepted &&
        !hasShownActionModalThisSession) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(hasShownActionModalProvider.notifier).state = true;
          showActionModal(context, currentAssignment.value!, ref);
        }
      });
    }

    _loadScreen(_selectedIndex);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          if(index == 1) {
            ref.invalidate(currentAssignmentProvider);
          }
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
