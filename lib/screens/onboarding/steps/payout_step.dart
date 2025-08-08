import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/payout_enums.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';

class PayoutStep extends ConsumerStatefulWidget {
  final OnboardingController controller;
  final VoidCallback onNext;

  const PayoutStep({super.key, required this.controller, required this.onNext});

  @override
  ConsumerState<PayoutStep> createState() => _PayoutStepState();
}

class _PayoutStepState extends ConsumerState<PayoutStep> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingStepContainer(
      controller: widget.controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          Center(
            child: OnboardingStepIcon(
              controller: widget.controller,
              icon: Icons.account_balance_wallet_rounded,
              color: colorScheme.secondary,
            ),
          ),

          const SizedBox(height: 24),

          OnboardingStepTitle(
            controller: widget.controller,
            title: 'Payout Details',
          ),

          const SizedBox(height: 12),

          OnboardingStepDescription(
            controller: widget.controller,
            description: 'Choose how you want to receive payouts. You can use a bank account or a UPI ID (VPA).',
          ),

          const SizedBox(height: 24),

          _buildPayoutMethodSelector(context),

          const SizedBox(height: 16),

          if (widget.controller.selectedPayoutMethod == PayoutMethod.bankAccount)
            _buildBankForm(context)
          else if (widget.controller.selectedPayoutMethod == PayoutMethod.vpa)
            _buildVpaForm(context),

          const SizedBox(height: 32),

          OnboardingNote(
            note: 'Your bank details are used only to create a secure payout account. We do not store your complete bank information.',
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPayoutMethodSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = widget.controller.selectedPayoutMethod;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ChoiceChip(
              label: const Text('Bank Account'),
              selected: selected == PayoutMethod.bankAccount,
              onSelected: (_) => widget.controller.updatePayoutMethod(PayoutMethod.bankAccount),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ChoiceChip(
              label: const Text('UPI (VPA)'),
              selected: selected == PayoutMethod.vpa,
              onSelected: (_) => widget.controller.updatePayoutMethod(PayoutMethod.vpa),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankForm(BuildContext context) {
    return Column(
      children: [
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.accountHolderNameController,
          focusNode: widget.controller.accountHolderNameFocus,
          label: 'Account Holder Name',
          hint: 'Enter account holder name',
          icon: Icons.person_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.accountNumberFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.accountNumberController,
          focusNode: widget.controller.accountNumberFocus,
          label: 'Account Number',
          hint: 'Enter bank account number',
          icon: Icons.numbers_rounded,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(18),
          ],
          isRequired: true,
          onSubmitted: (_) => widget.controller.ifscCodeFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ifscCodeController,
          focusNode: widget.controller.ifscCodeFocus,
          label: 'IFSC Code',
          hint: 'Ex: HDFC0000001',
          icon: Icons.account_balance_rounded,
          inputFormatters: [
            UpperCaseTextFormatter(),
            LengthLimitingTextInputFormatter(11),
          ],
          isRequired: true,
          onSubmitted: (_) => widget.onNext(),
        ),
      ],
    );
  }

  Widget _buildVpaForm(BuildContext context) {
    return Column(
      children: [
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.vpaController,
          focusNode: widget.controller.vpaFocus,
          label: 'UPI ID (VPA)',
          hint: 'e.g., username@okicici',
          icon: Icons.alternate_email_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.onNext(),
        ),
      ],
    );
  }
}