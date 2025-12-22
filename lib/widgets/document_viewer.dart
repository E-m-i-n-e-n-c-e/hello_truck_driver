import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

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

    // Otherwise, try to get from documents provider (profile scenario)
    return ref.watch(documentsProvider).when(
      data: (documents) {
        if (documents == null) {
          final l10n = AppLocalizations.of(context)!;
          return _buildErrorState(
            context,
            ref,
            l10n.documentsNotFound,
            l10n.documentsNotUploadedYet,
          );
        }

        final String url = _getDocumentUrl(documents, documentType);
        if (url.isEmpty) {
          final l10n = AppLocalizations.of(context)!;
          return _buildErrorState(
            context,
            ref,
            l10n.documentNotFound,
            l10n.documentNotUploadedYet,
          );
        }

        final bool isPdf = url.toLowerCase().contains('.pdf');
        return isPdf
            ? _buildPdfViewer(context, ref, url)
            : _buildImageViewer(context, ref, url);
      },
      loading: () {
        final l10n = AppLocalizations.of(context)!;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(l10n.loadingDocument),
            ],
          ),
        );
      },
      error: (error, stack) {
        final l10n = AppLocalizations.of(context)!;
        return _buildErrorState(
          context,
          ref,
          l10n.failedToLoadDocument,
          '${l10n.checkInternetAndRetry}\n\nError: $error',
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
            final l10n = AppLocalizations.of(context)!;
            Navigator.of(context).pop();
            SnackBars.retry(context, l10n.failedToLoadPdf(details.description), () {
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
            final l10n = AppLocalizations.of(context)!;
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
                  Text(l10n.loadingImage),
                ],
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            final l10n = AppLocalizations.of(context)!;
            return _buildErrorState(
              context,
              ref,
              l10n.failedToLoadDocument,
              '${l10n.documentLoadError}\n\nError: $error',
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
              ref.invalidate(documentsProvider);
            },
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.retry),
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