import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/widgets/document_viewer.dart';

class DocumentsStep extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {

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
            ref: ref,
            title: 'Driving License',
            subtitle: 'Upload your valid driving license',
            icon: Icons.drive_eta_rounded,
            documentType: 'license',
            selectedFile: controller.selectedLicense,
            uploadedUrl: controller.uploadedLicenseUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            ref: ref,
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
            ref: ref,
            title: 'FC Certificate',
            subtitle: 'Upload your fitness certificate',
            icon: Icons.verified_rounded,
            documentType: 'fc',
            selectedFile: controller.selectedFc,
            uploadedUrl: controller.uploadedFcUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            ref: ref,
            title: 'Insurance Certificate',
            subtitle: 'Upload your vehicle insurance certificate',
            icon: Icons.security_rounded,
            documentType: 'insurance',
            selectedFile: controller.selectedInsurance,
            uploadedUrl: controller.uploadedInsuranceUrl,
          ),

          const SizedBox(height: 16),

          _buildDocumentCard(
            context,
            ref: ref,
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
            ref: ref,
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
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required IconData icon,
    required String documentType,
    required File? selectedFile,
    required String? uploadedUrl,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUploaded = uploadedUrl != null;
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
                    color: colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.secondary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.secondary,
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
                              color: colorScheme.secondary.withValues(alpha: 0.85),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                if (isUploaded)
                  Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.secondary.withValues(alpha: 0.85),
                    size: 24,
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // View/Upload Actions
            Row(
              children: [
                // View Document Button (only show if uploaded)
                if (isUploaded) ...[
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => showDocumentViewer(
                        context,
                        documentType: documentType,
                        title: title,
                        documentUrl: uploadedUrl,
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.visibility_rounded, size: 18),
                      label: Text(
                        'View',
                        style: TextStyle(
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Upload/Re-upload Document Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isUploading
                        ? null
                        : () => _handleDocumentUpload(documentType, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                              valueColor: AlwaysStoppedAnimation(colorScheme.onSecondary),
                            ),
                          )
                        : Icon(
                            isUploaded ? Icons.upload_file_rounded : Icons.upload_file_rounded,
                            size: 18,
                          ),
                    label: Text(
                      isUploading
                          ? 'Uploading...'
                          : isUploaded
                              ? 'Re-upload'
                              : 'Choose File',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // File info of uploading document
            if (isUploading && selectedFile != null ) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description_rounded,
                      size: 18,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Selected: ${selectedFile.path.split('/').last}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleDocumentUpload(String documentType, WidgetRef ref) async {
    // First pick the document
    final success = await controller.pickDocument(
      documentType: documentType,
      onError: onError,
    );
    if (!success) return;
    // Then upload it if selected
    await controller.uploadDocument(
      documentType: documentType,
      onError: onError,
      onSuccess: (message) {
        // Success message will be handled by the parent
      },
      ref: ref,
    );
  }
}