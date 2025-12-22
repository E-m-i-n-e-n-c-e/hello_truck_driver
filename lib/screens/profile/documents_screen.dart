import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/models/documents.dart';
import 'package:hello_truck_driver/providers/driver_providers.dart';
import 'package:hello_truck_driver/widgets/document_viewer.dart';
import 'package:hello_truck_driver/screens/profile/dialogs/document_upload_dialog.dart';
import 'package:hello_truck_driver/widgets/snackbars.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final documentsAsync = ref.watch(documentsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          l10n.titleDocuments,
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: documentsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          error: (error, stack) => _buildErrorState(context, ref, error),
          data: (documents) {
            if (documents == null) {
              return _buildEmptyState(context);
            }
            return _buildDocumentsList(context, ref, documents);
          },
        ),
      );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: cs.error,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.failedToLoadDocuments,
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => ref.invalidate(documentsProvider),
              icon: const Icon(Icons.refresh_rounded),
              label: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.description_outlined,
                color: cs.primary,
                size: 48,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.noDocumentsFound,
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.completeOnboardingToUploadDocuments,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList(BuildContext context, WidgetRef ref, DriverDocuments documents) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PAN Number
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: cs.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.credit_card_rounded,
                    color: cs.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.panNumber,
                        style: tt.labelMedium?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        documents.panNumber,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Document Cards
          _buildDocumentCard(
            context,
            ref,
            title: l10n.drivingLicense,
            documentType: 'license',
            icon: Icons.drive_eta_rounded,
            expiryDate: documents.licenseExpiry,
          ),
          const SizedBox(height: 12),

          _buildDocumentCard(
            context,
            ref,
            title: l10n.rcBook,
            documentType: 'rcBook',
            icon: Icons.local_shipping_rounded,
          ),
          const SizedBox(height: 12),

          _buildDocumentCard(
            context,
            ref,
            title: l10n.fcCertificate,
            documentType: 'fc',
            icon: Icons.verified_rounded,
            expiryDate: documents.fcExpiry,
          ),
          const SizedBox(height: 12),

          _buildDocumentCard(
            context,
            ref,
            title: l10n.insuranceCertificate,
            documentType: 'insurance',
            icon: Icons.security_rounded,
            expiryDate: documents.insuranceExpiry,
          ),
          const SizedBox(height: 12),

          _buildDocumentCard(
            context,
            ref,
            title: l10n.aadharCard,
            documentType: 'aadhar',
            icon: Icons.person_rounded,
          ),
          const SizedBox(height: 12),

          _buildDocumentCard(
            context,
            ref,
            title: l10n.electricityBill,
            documentType: 'ebBill',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String documentType,
    required IconData icon,
    DateTime? expiryDate,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;

    final isExpired = expiryDate != null && expiryDate.isBefore(DateTime.now());
    final isExpiringSoon = expiryDate != null &&
        !isExpired &&
        expiryDate.isBefore(DateTime.now().add(const Duration(days: 30)));

    Color statusColor = cs.primary;
    if (isExpired) {
      statusColor = cs.error;
    } else if (isExpiringSoon) {
      statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpired
              ? cs.error.withValues(alpha: 0.4)
              : isExpiringSoon
                  ? Colors.orange.withValues(alpha: 0.4)
                  : cs.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: statusColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (expiryDate != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isExpired ? Icons.error_rounded : Icons.schedule_rounded,
                            size: 14,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isExpired
                                ? l10n.expiredOn(_formatDate(expiryDate))
                                : l10n.validUntil(_formatDate(expiryDate)),
                            style: tt.bodySmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showDocumentViewer(
                    context,
                    documentType: documentType,
                    title: title,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: Icon(Icons.visibility_rounded, size: 18, color: cs.primary),
                  label: Text(
                    l10n.view,
                    style: tt.labelMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _reUploadDocument(context, ref, documentType, title, expiryDate),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.upload_rounded, size: 18),
                  label: Text(
                    l10n.reupload,
                    style: tt.labelMedium?.copyWith(
                      color: cs.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _reUploadDocument(
    BuildContext context,
    WidgetRef ref,
    String documentType,
    String title,
    DateTime? currentExpiry,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => DocumentReUploadDialog(
        title: title,
        documentType: documentType,
        currentExpiry: currentExpiry,
        currentUrl: '',
        onSuccess: () {
          ref.invalidate(documentsProvider);
          SnackBars.success(context, AppLocalizations.of(context)!.reuploadedSuccess(title));
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
