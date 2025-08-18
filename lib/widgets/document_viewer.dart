import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/screens/profile/profile_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentViewer extends ConsumerWidget {
  final String documentType;
  final String title;
  final String? documentUrl; // Optional URL for onboarding scenarios

  const DocumentViewer({
    super.key,
    required this.documentType,
    required this.title,
    this.documentUrl,
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
        body: _buildDocumentContent(context, ref),
      ),
    );
  }

  Widget _buildDocumentContent(BuildContext context, WidgetRef ref) {
    // If documentUrl is provided (onboarding scenario), use it directly
    if (documentUrl != null && documentUrl!.isNotEmpty) {
      final bool isPdf = documentUrl!.toLowerCase().contains('.pdf');
      return isPdf
          ? _buildPdfViewer(context, ref, documentUrl!)
          : _buildImageViewer(context, ref, documentUrl!);
    }

    // Otherwise, try to get from driver profile (profile scenario)
    return ref.watch(driverProvider).when(
      data: (driver) {
        if (driver.documents == null) {
          return _buildErrorState(
            context,
            ref,
            'Documents not found',
            'The documents may not be uploaded yet.',
          );
        }

        final String url = _getDocumentUrl(driver.documents!, documentType);
        if (url.isEmpty) {
          return _buildErrorState(
            context,
            ref,
            'Document not found',
            'This document has not been uploaded yet.',
          );
        }

        final bool isPdf = url.toLowerCase().contains('.pdf');
        return isPdf
            ? _buildPdfViewer(context, ref, url)
            : _buildImageViewer(context, ref, url);
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
    );
  }

  String _getDocumentUrl(DriverDocuments documents, String documentType) {
    switch (documentType) {
      case 'license':
        return documents.licenseUrl;
      case 'rcBook':
        return documents.rcBookUrl;
      case 'fc':
        return documents.fcUrl;
      case 'insurance':
        return documents.insuranceUrl;
      case 'aadhar':
        return documents.aadharUrl;
      case 'ebBill':
        return documents.ebBillUrl;
      default:
        return '';
    }
  }

  Widget _buildPdfViewer(BuildContext context, WidgetRef ref, String url) {
    return SfPdfViewer.network(
      url,
      enableDoubleTapZooming: true,
      enableTextSelection: true,
      canShowPaginationDialog: true,
      canShowScrollHead: true,
      canShowScrollStatus: true,
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        // Handle PDF load failure
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.of(context).pop();
            SnackBars.retry(context, 'Failed to load PDF: ${details.description}', () {
              ref.invalidate(driverProvider);
            });
          }
        });
      },
      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
        debugPrint('PDF loaded successfully: ${details.document.pages.count} pages');
      },
    );
  }

  Widget _buildImageViewer(BuildContext context, WidgetRef ref, String url) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 5.0,
      child: Center(
        child: Image.network(
          url,
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text('Loading image...'),
                ],
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorState(
              context,
              ref,
              'Failed to load document',
              'The document could not be loaded. Please check your internet connection and try again.\n\nError: $error',
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
              ref.invalidate(driverProvider);
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Show document viewer dialog
void showDocumentViewer(
  BuildContext context, {
  required String documentType,
  required String title,
  String? documentUrl,
}) {
  showDialog(
    context: context,
    builder: (context) => DocumentViewer(
      documentType: documentType,
      title: title,
      documentUrl: documentUrl,
    ),
  );
}