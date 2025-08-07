import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/screens/onboarding/controllers/onboarding_controller.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/onboarding_components.dart';
import 'package:hello_truck_driver/screens/onboarding/widgets/document_upload_card.dart';

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
          DocumentUploadCard(
            title: 'Driving License',
            subtitle: 'Upload your valid driving license',
            icon: Icons.drive_eta_rounded,
            documentType: 'license',
            selectedFile: controller.selectedLicense,
            uploadedUrl: controller.uploadedLicenseUrl,
            isUploading: controller.isUploadingSpecificDocument('license'),
            onUpload: () => _handleDocumentUpload('license', ref),
          ),

          const SizedBox(height: 16),

          DocumentUploadCard(
            title: 'RC Book',
            subtitle: 'Upload your vehicle registration certificate',
            icon: Icons.local_shipping_rounded,
            documentType: 'rcBook',
            selectedFile: controller.selectedRcBook,
            uploadedUrl: controller.uploadedRcBookUrl,
            isUploading: controller.isUploadingSpecificDocument('rcBook'),
            onUpload: () => _handleDocumentUpload('rcBook', ref),
          ),

          const SizedBox(height: 16),

          DocumentUploadCard(
            title: 'FC Certificate',
            subtitle: 'Upload your fitness certificate',
            icon: Icons.verified_rounded,
            documentType: 'fc',
            selectedFile: controller.selectedFc,
            uploadedUrl: controller.uploadedFcUrl,
            isUploading: controller.isUploadingSpecificDocument('fc'),
            onUpload: () => _handleDocumentUpload('fc', ref),
          ),

          const SizedBox(height: 16),

          DocumentUploadCard(
            title: 'Insurance Certificate',
            subtitle: 'Upload your vehicle insurance certificate',
            icon: Icons.security_rounded,
            documentType: 'insurance',
            selectedFile: controller.selectedInsurance,
            uploadedUrl: controller.uploadedInsuranceUrl,
            isUploading: controller.isUploadingSpecificDocument('insurance'),
            onUpload: () => _handleDocumentUpload('insurance', ref),
          ),

          const SizedBox(height: 16),

          DocumentUploadCard(
            title: 'Aadhar Card',
            subtitle: 'Upload your Aadhar card',
            icon: Icons.person_rounded,
            documentType: 'aadhar',
            selectedFile: controller.selectedAadhar,
            uploadedUrl: controller.uploadedAadharUrl,
            isUploading: controller.isUploadingSpecificDocument('aadhar'),
            onUpload: () => _handleDocumentUpload('aadhar', ref),
          ),

          const SizedBox(height: 16),

          DocumentUploadCard(
            title: 'Electricity Bill',
            subtitle: 'Upload your address proof (electricity bill)',
            icon: Icons.receipt_long_rounded,
            documentType: 'ebBill',
            selectedFile: controller.selectedEbBill,
            uploadedUrl: controller.uploadedEbBillUrl,
            isUploading: controller.isUploadingSpecificDocument('ebBill'),
            onUpload: () => _handleDocumentUpload('ebBill', ref),
          ),

          const SizedBox(height: 40),
        ],
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