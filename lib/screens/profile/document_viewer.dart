import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/screens/profile/profile_providers.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewer extends ConsumerWidget {
  final String documentType;
  final String fileType;
  final String title;

  const DocumentViewer({
    super.key,
    required this.documentType,
    required this.fileType,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ref.watch(documentFilesProvider).when(
          data: (documentBytes) {
            final documentData = documentBytes[documentType];
            if (documentData == null) {
              return _buildErrorState(
                context,
                ref,
                'Document not found',
                'The document may not be uploaded yet or failed to load.',
              );
            }

            // Handle PDF documents
            if (fileType == 'pdf') {
              return SfPdfViewer.memory(
                documentData,
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                canShowPaginationDialog: true,
                canShowScrollHead: true,
                canShowScrollStatus: true,
                onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                  // Handle PDF load failure
                  return;
                },
              );
            }

            // Handle image documents
            return InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(
                child: Image.memory(
                  documentData,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildErrorState(
                      context,
                      ref,
                      'Failed to load document',
                      'The document file may be corrupted or in an unsupported format.\n\nError: $error',
                    );
                  },
                ),
              ),
            );
          },
          loading: () => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading document...'),
              ],
            ),
          ),
          error: (error, stack) {
            return _buildErrorState(
              context,
              ref,
              'Failed to load document',
              'Check your internet connection and try again.\n\nError: $error',
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    WidgetRef ref,
    String title,
    String message,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(documentFilesProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

 Future<String> _getDocumentFileType(WidgetRef ref, String documentType) async {
    // Try to get the current document URL to determine file type
    final driver = await ref.read(driverProvider.future);
    final documents = driver.documents;
    String url = '';

    switch (documentType) {
      case 'license':
        url = documents!.licenseUrl;
        break;
      case 'rcBook':
        url = documents!.rcBookUrl;
        break;
      case 'fc':
        url = documents!.fcUrl;
        break;
      case 'insurance':
        url = documents!.insuranceUrl;
        break;
      case 'aadhar':
        url = documents!.aadharUrl;
        break;
      case 'ebBill':
        url = documents!.ebBillUrl;
        break;
    }

    // Check file extension from URL
    if (url.toLowerCase().contains('.pdf')) {
      return 'pdf';
    }
    return 'image';
  }

/// Show document viewer dialog
Future<void> showDocumentViewer(
  BuildContext context, {
  required String documentType,
  required String title,
  required WidgetRef ref,
}) async {
  final fileType = await _getDocumentFileType(ref, documentType);
  if(!context.mounted) return;
  showDialog(
    context: context,
    builder: (context) => DocumentViewer(
      documentType: documentType,
      title: title,
      fileType: fileType,
    ),
  );
}