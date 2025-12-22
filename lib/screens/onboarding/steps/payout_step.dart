import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/enums/payout_enums.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

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
            title: l10n.payoutDetails,
          ),

          const SizedBox(height: 12),

          OnboardingStepDescription(
            controller: widget.controller,
            description: l10n.payoutDescription,
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
            note: l10n.bankDetailsNote,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPayoutMethodSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = widget.controller.selectedPayoutMethod;
    final l10n = AppLocalizations.of(context)!;

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
              label: Text(l10n.bankAccount),
              selected: selected == PayoutMethod.bankAccount,
              onSelected: (_) => widget.controller.updatePayoutMethod(PayoutMethod.bankAccount),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ChoiceChip(
              label: Text(l10n.upiVpa),
              selected: selected == PayoutMethod.vpa,
              onSelected: (_) => widget.controller.updatePayoutMethod(PayoutMethod.vpa),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankForm(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.accountHolderNameController,
          focusNode: widget.controller.accountHolderNameFocus,
          label: l10n.accountHolderName,
          hint: l10n.enterAccountHolderName,
          icon: Icons.person_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.accountNumberFocus.requestFocus(),
        ),
        const SizedBox(height: 16),
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.accountNumberController,
          focusNode: widget.controller.accountNumberFocus,
          label: l10n.accountNumber,
          hint: l10n.enterAccountNumber,
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
          label: l10n.ifscCode,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.vpaController,
          focusNode: widget.controller.vpaFocus,
          label: l10n.upiId,
          hint: l10n.upiHint,
          icon: Icons.alternate_email_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.onNext(),
        ),
      ],
    );
  }
}