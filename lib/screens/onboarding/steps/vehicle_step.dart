import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/document_upload_card.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/models/enums/vehicle_enums.dart';

class VehicleStep extends ConsumerStatefulWidget {
  final OnboardingController controller;
  final VoidCallback onNext;

  const VehicleStep({
    super.key,
    required this.controller,
    required this.onNext,
  });

  @override
  ConsumerState<VehicleStep> createState() => _VehicleStepState();
}

class _VehicleStepState extends ConsumerState<VehicleStep> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OnboardingStepContainer(
      controller: widget.controller,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),

          // Step Icon
          Center(
            child: OnboardingStepIcon(
              controller: widget.controller,
              icon: Icons.local_shipping_rounded,
              color: colorScheme.secondary,
            ),
          ),

          const SizedBox(height: 24),

          // Title
          OnboardingStepTitle(
            controller: widget.controller,
            title: 'Vehicle Details',
          ),

          const SizedBox(height: 12),

          OnboardingStepDescription(
            controller: widget.controller,
            description: 'Enter your vehicle information and owner details for registration.',
          ),

          const SizedBox(height: 32),

          // Vehicle Information Form
          _buildVehicleForm(context),

          const SizedBox(height: 24),
          Divider(color: colorScheme.primary.withValues(alpha: 0.3)),
          const SizedBox(height: 24),

          // Vehicle Owner Section
          _buildVehicleOwnerSection(context),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildVehicleForm(BuildContext context) {
    return Column(
      children: [
        // Vehicle Number
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.vehicleNumberController,
          focusNode: widget.controller.vehicleNumberFocus,
          label: 'Vehicle Number',
          hint: 'Enter vehicle registration number',
          icon: Icons.confirmation_number_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.vehicleBodyLengthFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Vehicle Type Dropdown
        OnboardingDropdown(
          controller: widget.controller,
          label: 'Vehicle Type',
          icon: Icons.directions_car_rounded,
          value: widget.controller.selectedVehicleType?.value,
          items: VehicleType.values.map((type) =>
            DropdownMenuItem(
              value: type.value,
              child: Text(type.value.split('_').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' '))
            )
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              widget.controller.updateVehicleType(value);
            }
          },
        ),

        const SizedBox(height: 16),

        // Vehicle Body Length
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.vehicleBodyLengthController,
          focusNode: widget.controller.vehicleBodyLengthFocus,
          label: 'Vehicle Body Length (ft)',
          hint: 'Enter body length',
          icon: Icons.straighten_rounded,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          isRequired: true,
          onSubmitted: (_) => widget.onNext(),
        ),

        const SizedBox(height: 16),

        // Vehicle Image Upload
        DocumentUploadCard(
          title: 'Vehicle Image',
          subtitle: 'Upload a clear image of your vehicle',
          icon: Icons.directions_car_rounded,
          documentType: 'vehicleImage',
          selectedFile: widget.controller.selectedVehicleImage,
          uploadedUrl: widget.controller.uploadedVehicleImageUrl,
          isUploading: widget.controller.isUploadingSpecificDocument('vehicleImage'),
          onUpload: () async {
            final success = await widget.controller.pickDocument(
              documentType: 'vehicleImage',
              onError: (error) {
                SnackBars.error(context, error);
              },
            );
            if (success) {
              await widget.controller.uploadDocument(
                documentType: 'vehicleImage',
                onError: (error) {
                  SnackBars.error(context, error);
                },
                onSuccess: (message) {
                  // Do nothing
                },
                ref: ref,
              );
            }
          },
        ),

        const SizedBox(height: 16),

        // Vehicle Body Type Dropdown
        OnboardingDropdown(
          controller: widget.controller,
          label: 'Vehicle Body Type',
          icon: Icons.inventory_2_rounded,
          value: widget.controller.selectedVehicleBodyType?.value,
          items: VehicleBodyType.values.map((type) =>
            DropdownMenuItem(
              value: type.value,
              child: Text(type.value.split('_').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ')))
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              widget.controller.updateVehicleBodyType(value);
            }
          },
        ),

        const SizedBox(height: 16),

        // Fuel Type Dropdown
        OnboardingDropdown(
          controller: widget.controller,
          label: 'Fuel Type',
          icon: Icons.local_gas_station_rounded,
          value: widget.controller.selectedFuelType?.value,
          items: FuelType.values.map((type) =>
            DropdownMenuItem(
              value: type.value,
              child: Text(type.value.split('_').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' '))
            )
          ).toList(),
          onChanged: (value) {
            if (value != null) {
              widget.controller.updateFuelType(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildVehicleOwnerSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Owner Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(height: 16),

        // Same as Driver Checkbox
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
            color: colorScheme.surface,
          ),
          child: CheckboxListTile(
            value: widget.controller.sameAsDriver,
            onChanged: (value) {
              widget.controller.updateSameAsDriver(value ?? false);
              if (value == true) {
                // Clear owner fields when same as driver is selected
                widget.controller.ownerNameController.clear();
                widget.controller.ownerContactController.clear();
                widget.controller.ownerAddressLine1Controller.clear();
                widget.controller.ownerLandmarkController.clear();
                widget.controller.ownerPincodeController.clear();
                widget.controller.ownerCityController.clear();
                widget.controller.ownerDistrictController.clear();
                widget.controller.ownerStateController.clear();
              }
            },
            title: Text(
              'Same as Driver',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              'Vehicle owner details are same as driver',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: colorScheme.primary,
          ),
        ),

        if (!widget.controller.sameAsDriver) ...[
          const SizedBox(height: 24),
          _buildOwnerDetailsForm(context),
        ],
      ],
    );
  }

  Widget _buildOwnerDetailsForm(BuildContext context) {
    return Column(
      children: [
        // Owner Name
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerNameController,
          focusNode: widget.controller.ownerNameFocus,
          label: 'Owner Name',
          hint: 'Enter owner full name',
          icon: Icons.person_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.ownerContactFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner Contact
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerContactController,
          focusNode: widget.controller.ownerContactFocus,
          label: 'Contact Number',
          hint: 'Enter contact number',
          icon: Icons.phone_rounded,
          isRequired: true,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          onSubmitted: (_) => widget.controller.ownerAddressLine1Focus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner Address
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerAddressLine1Controller,
          focusNode: widget.controller.ownerAddressLine1Focus,
          label: 'Address Line 1',
          hint: 'House/Building, Street',
          icon: Icons.home_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.ownerLandmarkFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner Landmark
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerLandmarkController,
          focusNode: widget.controller.ownerLandmarkFocus,
          label: 'Landmark (Optional)',
          hint: 'Near landmark or area',
          icon: Icons.place_rounded,
          onSubmitted: (_) => widget.controller.ownerPincodeFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner Pincode
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerPincodeController,
          focusNode: widget.controller.ownerPincodeFocus,
          label: 'Pincode',
          hint: 'Enter Pincode',
          icon: Icons.pin_drop_rounded,
          isRequired: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onSubmitted: (_) => widget.controller.ownerCityFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner City
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerCityController,
          focusNode: widget.controller.ownerCityFocus,
          label: 'City',
          hint: 'City name',
          icon: Icons.location_city_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.ownerDistrictFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner District
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerDistrictController,
          focusNode: widget.controller.ownerDistrictFocus,
          label: 'District',
          hint: 'District name',
          icon: Icons.map_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.controller.ownerStateFocus.requestFocus(),
        ),

        const SizedBox(height: 16),

        // Owner State
        OnboardingTextField(
          controller: widget.controller,
          textController: widget.controller.ownerStateController,
          focusNode: widget.controller.ownerStateFocus,
          label: 'State',
          hint: 'State name',
          icon: Icons.public_rounded,
          isRequired: true,
          onSubmitted: (_) => widget.onNext(),
        ),

        const SizedBox(height: 16),

        // Owner Aadhar Upload
        DocumentUploadCard(
          title: 'Owner Aadhar Card',
          subtitle: 'Upload owner\'s Aadhar card',
          icon: Icons.credit_card_rounded,
          documentType: 'ownerAadhar',
          selectedFile: widget.controller.selectedOwnerAadhar,
          uploadedUrl: widget.controller.uploadedOwnerAadharUrl,
          isUploading: widget.controller.isUploadingSpecificDocument('ownerAadhar'),
          onUpload: () async {
            final success = await widget.controller.pickDocument(
              documentType: 'ownerAadhar',
              onError: (error) {
                SnackBars.error(context, error);
              },
            );
            if (success) {
              await widget.controller.uploadDocument(
                documentType: 'ownerAadhar',
                onError: (error) {
                  SnackBars.error(context, error);
                },
                onSuccess: (message) {
                  // Do nothing
                },
                ref: ref,
              );
            }
          },
        ),
      ],
    );
  }
}