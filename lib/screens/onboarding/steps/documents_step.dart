import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';

class DocumentsStep extends StatelessWidget {
  final OnboardingController controller;
  final VoidCallback onNext;
  final Function(String) onError;

  const DocumentsStep({
    super.key,
    required this.controller,
    required this.onNext,
    required this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingStepContainer(
      controller: controller,
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Step Icon
          OnboardingStepIcon(
            controller: controller,
            icon: Icons.description_rounded,
          ),

          const SizedBox(height: 32),

          // Title
          OnboardingStepTitle(
            controller: controller,
            title: 'Upload Documents',
          ),

          const SizedBox(height: 16),

          // Description
          OnboardingStepDescription(
            controller: controller,
            description: 'Please upload all required documents to complete your driver profile verification.',
          ),

          const SizedBox(height: 40),

          // PAN Number Field
          OnboardingTextField(
            controller: controller,
            textController: controller.panNumberController,
            focusNode: controller.panNumberFocus,
            label: 'PAN Number',
            hint: 'Enter your PAN number',
            icon: Icons.credit_card_rounded,
            isRequired: true,
            keyboardType: TextInputType.text,
          ),

          const SizedBox(height: 24),

          // Document Upload Cards
          _buildDocumentCard(
            context,
            title: 'Driving License',
            subtitle: 'Upload your valid driving license',
            icon: Icons.drive_eta_rounded,
            documentType: 'license',
            selectedFile: controller.selectedLicense,
            uploadedUrl: controller.uploadedLicenseUrl,
            showExpiryDate: true,
            expiryDate: controller.licenseExpiry,
            onExpiryDateSelected: controller.setLicenseExpiry,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'RC Book',
            subtitle: 'Upload your vehicle registration certificate',
            icon: Icons.local_shipping_rounded,
            documentType: 'rcBook',
            selectedFile: controller.selectedRcBook,
            uploadedUrl: controller.uploadedRcBookUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'FC Certificate',
            subtitle: 'Upload your fitness certificate',
            icon: Icons.verified_rounded,
            documentType: 'fc',
            selectedFile: controller.selectedFc,
            uploadedUrl: controller.uploadedFcUrl,
            showExpiryDate: true,
            expiryDate: controller.fcExpiry,
            onExpiryDateSelected: controller.setFcExpiry,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'Insurance Certificate',
            subtitle: 'Upload your vehicle insurance certificate',
            icon: Icons.security_rounded,
            documentType: 'insurance',
            selectedFile: controller.selectedInsurance,
            uploadedUrl: controller.uploadedInsuranceUrl,
            showExpiryDate: true,
            expiryDate: controller.insuranceExpiry,
            onExpiryDateSelected: controller.setInsuranceExpiry,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'Aadhar Card',
            subtitle: 'Upload your Aadhar card',
            icon: Icons.person_rounded,
            documentType: 'aadhar',
            selectedFile: controller.selectedAadhar,
            uploadedUrl: controller.uploadedAadharUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            title: 'Electricity Bill',
            subtitle: 'Upload your address proof (electricity bill)',
            icon: Icons.receipt_long_rounded,
            documentType: 'ebBill',
            selectedFile: controller.selectedEbBill,
            uploadedUrl: controller.uploadedEbBillUrl,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String documentType,
    required File? selectedFile,
    required String? uploadedUrl,
    bool showExpiryDate = false,
    DateTime? expiryDate,
    Function(DateTime)? onExpiryDateSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUploaded = uploadedUrl != null;
    final isSelected = selectedFile != null;
    final isUploading = controller.isUploadingSpecificDocument(documentType);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isUploaded
              ? colorScheme.secondary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: isUploaded ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? colorScheme.secondary.withValues(alpha: 0.1)
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUploaded
                          ? colorScheme.secondary
                          : colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isUploaded ? colorScheme.secondary : colorScheme.onSurface,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Supports: JPG, PNG, PDF (Max 10MB)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.secondary.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                if (isUploaded)
                  Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.secondary,
                    size: 24,
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Upload Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isUploading
                    ? null
                    : () => _handleDocumentUpload(documentType),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(
                    color: isUploaded
                        ? colorScheme.secondary
                        : colorScheme.outline.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: isUploading
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(colorScheme.secondary),
                        ),
                      )
                    : Icon(
                        isUploaded ? Icons.refresh_rounded : Icons.upload_file_rounded,
                        color: isUploaded ? colorScheme.secondary : null,
                        size: 18,
                      ),
                label: Text(
                  isUploading
                      ? 'Uploading...'
                      : isUploaded
                          ? 'Re-upload Document'
                          : isSelected
                              ? 'Upload Selected File'
                              : 'Choose File to Upload',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isUploaded ? colorScheme.secondary : null,
                  ),
                ),
              ),
            ),

            // Expiry Date Picker
            if (showExpiryDate) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _selectExpiryDate(context, onExpiryDateSelected!),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: expiryDate != null
                          ? colorScheme.secondary
                          : colorScheme.outline.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    size: 18,
                    color: expiryDate != null ? colorScheme.secondary : null,
                  ),
                  label: Text(
                    expiryDate != null
                        ? 'Expires: ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}'
                        : 'Select Expiry Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: expiryDate != null ? colorScheme.secondary : null,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleDocumentUpload(String documentType) async {
    // First pick the document
    await controller.pickDocument(
      documentType: documentType,
      onError: onError,
    );

    // Then upload it if selected
    await controller.uploadDocument(
      documentType: documentType,
      onError: onError,
      onSuccess: (message) {
        // Success message will be handled by the parent
      },
    );
  }

  Future<void> _selectExpiryDate(
    BuildContext context,
    Function(DateTime) onDateSelected,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.secondary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }
}