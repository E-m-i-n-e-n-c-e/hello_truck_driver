import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';
import 'package:hello_truck_driver/auth/api.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({super.key, required this.phoneNumber});

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  final _timerState = ValueNotifier<TimerState>(
    TimerState(canResendOtp: false, resendCountdown: 30),
  );
  final _loadingState = ValueNotifier<bool>(false);
  Timer? _resendTimer;
  StreamController<ErrorAnimationType>? _errorController;

  @override
  void initState() {
    super.initState();
    _errorController = StreamController<ErrorAnimationType>();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timerState.value = TimerState(canResendOtp: false, resendCountdown: 30);
    _resendTimer?.cancel();

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      final currentCount = _timerState.value.resendCountdown;
      if (currentCount > 0) {
        _timerState.value = TimerState(
          canResendOtp: false,
          resendCountdown: currentCount - 1,
        );
      } else {
        _timerState.value = TimerState(canResendOtp: true, resendCountdown: 0);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _errorController?.close();
    _timerState.dispose();
    _loadingState.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // Resend OTP
  Future<void> _resendOtp(API api) async {
    if (_loadingState.value) return; // Prevent double tap
    _loadingState.value = true;

    try {
      await api.sendOtp(widget.phoneNumber);
      if (!mounted) return;

      SnackBars.success(context, 'OTP sent successfully!');
      _otpController.clear();
      _startResendTimer();
    } catch (e) {
      if (!mounted) return;
      print('Error sending OTP: $e');
      SnackBars.error(context, 'Error sending OTP: ${e.toString()}');
    } finally {
      if (mounted) {
        _loadingState.value = false;
      }
    }
  }

  // Verify OTP
  Future<void> _verifyOtp(API api) async {
    if (_otpController.text.length != 6 || _loadingState.value) return;
    _loadingState.value = true;

    try {
      await api.verifyOtp(widget.phoneNumber, _otpController.text);
      // The auth provider will handle the navigation if verification is successful
    } catch (e) {
      if (!mounted) return;
      print('Error verifying OTP: $e');
      if (mounted) {
        _otpController.clear();
        _errorController?.add(ErrorAnimationType.shake);
        SnackBars.error(context, "Error verifying OTP: ${e.toString()}");
        _loadingState.value = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // Only watch what we need from the API
    final api = ref.watch(apiProvider.select((value) => value));

    if (api.value?.accessToken?.isNotEmpty ?? false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon:  BackButton(color: Colors.black.withValues(alpha: 0.8)),
                  ),
                  Text(
                    'OTP Verification',
                    style: textTheme.titleLarge?.copyWith(
                      color: Colors.black.withValues(alpha: 0.85),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),

                          Text(
                            'We have sent a verification code to',
                            style: textTheme.titleMedium?.copyWith(
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),

                          Text(
                            '+91-${widget.phoneNumber}',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),

                          // PinCodeFields
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              controller: _otpController,
                              autoFocus: true,
                              autoDismissKeyboard: true,
                              errorAnimationController: _errorController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              animationType: AnimationType.scale,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(6),
                                fieldHeight: 50,
                                fieldWidth: 45,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white,
                                selectedFillColor: Colors.white,
                                activeColor: colorScheme.primary,
                                inactiveColor: Colors.grey.shade300,
                                selectedColor: colorScheme.primary,
                                borderWidth: 1,
                                activeBorderWidth: 2,
                                selectedBorderWidth: 2,
                              ),
                              animationDuration: const Duration(milliseconds: 100),
                              enableActiveFill: true,
                              enablePinAutofill: true,
                              autoDisposeControllers: false,
                              onCompleted: (value) {
                                if (mounted) {
                                  _verifyOtp(api.value!);
                                }
                              },
                              beforeTextPaste: (text) {
                                // Allow only numbers12
                                if (text == null) return false;
                                return text.contains(RegExp(r'^[0-9]+$'));
                              },

                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Check text messages for your OTP',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Resend OTP section with ValueListenableBuilder
                          ValueListenableBuilder<TimerState>(
                            valueListenable: _timerState,
                            builder: (context, timerState, _) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't get the OTP? ",
                                    style: textTheme.titleMedium?.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _loadingState,
                                    builder: (context, isLoading, _) {
                                      return timerState.canResendOtp
                                          ? TextButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () => _resendOtp(api.value!),
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                                minimumSize: Size.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize.shrinkWrap,
                                              ),
                                              child: Text(
                                                'Resend SMS',
                                                style: textTheme.titleMedium?.copyWith(
                                                  color: colorScheme.secondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : Text(
                                              'Resend SMS in ${timerState.resendCountdown}s',
                                              style: textTheme.titleMedium?.copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),

                          const Spacer(),

                          // Bottom button
                          Padding(
                            padding: const EdgeInsets.only(bottom: 80.0),
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Change phone number',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              ValueListenableBuilder<bool>(
                valueListenable: _loadingState,
                builder: (context, isLoading, _) {
                  return IgnorePointer(
                    ignoring: !isLoading,
                    child: AnimatedOpacity(
                      opacity: isLoading ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Stack(
                        children: [
                          ModalBarrier(
                            dismissible: false,
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
      ),
    );
  }

}

// Class to hold timer state
class TimerState {
  final bool canResendOtp;
  final int resendCountdown;

  const TimerState({required this.canResendOtp, required this.resendCountdown});
}
