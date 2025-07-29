import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/auth_providers.dart';
import 'package:hello_truck_driver/utils/api/documents_api.dart' as documents_api;
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  DateTime? _selectedExpiry;
  bool _isUploading = false;
  final _panController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Don't use current expiry - force user to select a new expiry date
    _selectedExpiry = null;
  }

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  bool get _hasExpiryDate => [
    'license',
    'fc',
    'insurance'
  ].contains(widget.documentType);

  bool get _needsPanNumber => widget.documentType == 'aadhar';

  bool get _canSave => _selectedFile != null &&
    (!_hasExpiryDate || _selectedExpiry != null) &&
    (!_needsPanNumber || _panController.text.trim().isNotEmpty);

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
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('driver-documents/$fileName');

      final uploadTask = storageRef.putFile(_selectedFile!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update document in backend
      final api = ref.read(apiProvider).value!;

      await documents_api.updateDriverDocuments(
        api,
        licenseUrl: widget.documentType == 'license' ? downloadUrl : null,
        licenseExpiry: widget.documentType == 'license' ? _selectedExpiry : null,
        rcBookUrl: widget.documentType == 'rcBook' ? downloadUrl : null,
        fcUrl: widget.documentType == 'fc' ? downloadUrl : null,
        fcExpiry: widget.documentType == 'fc' ? _selectedExpiry : null,
        insuranceUrl: widget.documentType == 'insurance' ? downloadUrl : null,
        insuranceExpiry: widget.documentType == 'insurance' ? _selectedExpiry : null,
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

  Future<void> _selectExpiryDate() async {
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
      setState(() => _selectedExpiry = picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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

                    // Expiry date picker (for documents that need it)
                    if (_hasExpiryDate) ...[
                      Text(
                        'Expiry Date',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isUploading ? null : _selectExpiryDate,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: colorScheme.secondary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: Icon(
                            Icons.calendar_today_rounded,
                            color: colorScheme.secondary,
                          ),
                          label: Text(
                            _selectedExpiry != null
                                ? 'Expires: ${_formatDate(_selectedExpiry!)}'
                                : 'Select expiry date',
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // PAN number (for Aadhar)
                    if (_needsPanNumber) ...[
                      Text(
                        'PAN Number',
                        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _panController,
                        decoration: const InputDecoration(
                          hintText: 'Enter PAN number (e.g., ABCDE1234F)',
                          prefixIcon: Icon(Icons.credit_card_rounded),
                        ),
                        enabled: !_isUploading,
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (_) => setState(() {}),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'PAN number is required';
                          }
                          if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value.trim())) {
                            return 'Please enter a valid PAN number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
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
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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