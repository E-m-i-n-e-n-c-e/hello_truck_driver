import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpBottomSheet extends StatefulWidget {
  final String title;
  final String subtitle;

  const OtpBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<OtpBottomSheet> createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  final TextEditingController _otpController = TextEditingController();
  String _otpValue = '';

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: tt.bodyMedium?.copyWith(color: cs.onSurface.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close_rounded, color: cs.onSurface.withValues(alpha: 0.7)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _otpController,
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  animationType: AnimationType.scale,
                  autoDismissKeyboard: true,
                  onChanged: (value) {
                    if (!mounted) return;
                    setState(() => _otpValue = value);
                  },
                  autoDisposeControllers: false,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 45,
                    activeFillColor: cs.surface,
                    inactiveFillColor: cs.surface,
                    selectedFillColor: cs.surface,
                    activeColor: cs.primary,
                    inactiveColor: cs.outline.withValues(alpha: 0.5),
                    selectedColor: cs.primary,
                    borderWidth: 1,
                    activeBorderWidth: 2,
                    selectedBorderWidth: 2,
                  ),
                  enableActiveFill: true,
                  enablePinAutofill: true,
                  beforeTextPaste: (text) {
                    if (text == null) return false;
                    return text.contains(RegExp(r'^[0-9]+$'));
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _otpValue.length == 4
                          ? () => Navigator.of(context).pop(_otpValue)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: cs.onPrimary,
                      ),
                      child: const Text('Verify'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
