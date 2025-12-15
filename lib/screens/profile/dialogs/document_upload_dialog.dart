import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/api/documents_api.dart' as documents_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class DocumentReUploadDialog extends ConsumerStatefulWidget {
  final String title;
  final String documentType;
  final DateTime? currentExpiry;
  final String? currentUrl;
  final VoidCallback onSuccess;

  const DocumentReUploadDialog({super.key,
    required this.title,
    required this.documentType,
    this.currentExpiry,
    this.currentUrl,
    required this.onSuccess,
  });

  @override
  ConsumerState<DocumentReUploadDialog> createState() => _DocumentReUploadDialogState();
}

class _DocumentReUploadDialogState extends ConsumerState<DocumentReUploadDialog> {
  File? _selectedFile;
  Uint8List? _selectedFileBytes;
  bool _isUploading = false;
  final _panController = TextEditingController();

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  bool get _canSave => _selectedFile != null;

  Future<void> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Validate file size (limit to 10MB)
        final fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) {
          if (mounted) {
            SnackBars.error(context, 'File size must be less than 10MB');
          }
          return;
        }

        // Read file bytes for preview
        final bytes = await file.readAsBytes();

        setState(() {
          _selectedFile = file;
          _selectedFileBytes = bytes;
        });
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to pick document: $e');
      }
    }
  }

  Future<void> _uploadAndSave() async {
    if (!_canSave) return;

    setState(() => _isUploading = true);

    try {
      // Upload to Firebase Storage
      final fileExtension = _selectedFile!.path.split('.').last.toLowerCase();
      final fileName = '${widget.documentType}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'driver-documents/$fileName';
      final api = ref.read(apiProvider).value!;
      final downloadUrl = await api.uploadFile(_selectedFile!, filePath, fileExtension);

      await documents_api.updateDriverDocuments(
        api,
        licenseUrl: widget.documentType == 'license' ? downloadUrl : null,
        rcBookUrl: widget.documentType == 'rcBook' ? downloadUrl : null,
        fcUrl: widget.documentType == 'fc' ? downloadUrl : null,
        insuranceUrl: widget.documentType == 'insurance' ? downloadUrl : null,
        aadharUrl: widget.documentType == 'aadhar' ? downloadUrl : null,
        panNumber: widget.documentType == 'aadhar' ? _panController.text.trim() : null,
        ebBillUrl: widget.documentType == 'ebBill' ? downloadUrl : null,
      );

      if (mounted) {
        widget.onSuccess();
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        SnackBars.error(context, 'Failed to upload document: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Re-upload ${widget.title}',
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: colorScheme.onSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File picker
                    GestureDetector(
                      onTap: _isUploading ? null : _pickDocument,
                      child: Container(
                        width: double.infinity,
                        height: _selectedFileBytes != null ? 200 : 120,
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedFile != null
                                ? colorScheme.secondary
                                : colorScheme.outline.withValues(alpha: 0.3),
                            width: _selectedFile != null ? 2 : 1,
                          ),
                        ),
                        child: _selectedFileBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.memory(
                                  _selectedFileBytes!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.description, size: 48),
                                          SizedBox(height: 8),
                                          Text('Document Selected'),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48,
                                    color: colorScheme.secondary,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to select document',
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'JPG, PNG, PDF (Max 10MB)',
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Info text about admin verification
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Document will be verified by admin. Expiry dates will be set during verification.',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isUploading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canSave && !_isUploading ? _uploadAndSave : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
                      ),
                      child: _isUploading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onSecondary),
                              ),
                            )
                          : const Text('Upload'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}