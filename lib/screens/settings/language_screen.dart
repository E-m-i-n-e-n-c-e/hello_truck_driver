import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hello_truck_driver/providers/locale_provider.dart';
import 'package:hello_truck_driver/l10n/app_localizations.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(l10n.languageTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.languageTitle,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: cs.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // System Default
                    _buildLanguageOption(
                      context: context,
                      ref: ref,
                      title: l10n.languageSystem,
                      locale: null,
                      isSelected: currentLocale == null,
                    ),
                    _buildDivider(cs),
                    // English
                    _buildLanguageOption(
                      context: context,
                      ref: ref,
                      title: l10n.languageEnglish,
                      locale: const Locale('en'),
                      isSelected: currentLocale?.languageCode == 'en',
                    ),
                    _buildDivider(cs),
                    // Hindi
                    _buildLanguageOption(
                      context: context,
                      ref: ref,
                      title: l10n.languageHindi,
                      locale: const Locale('hi'),
                      isSelected: currentLocale?.languageCode == 'hi',
                    ),
                    _buildDivider(cs),
                    // Tamil
                    _buildLanguageOption(
                      context: context,
                      ref: ref,
                      title: l10n.languageTamil,
                      locale: const Locale('ta'),
                      isSelected: currentLocale?.languageCode == 'ta',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required WidgetRef ref,
    required String title,
    required Locale? locale,
    required bool isSelected,
  }) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return RadioListTile<Locale?>(
      title: Text(
        title,
        style: tt.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      value: locale,
      groupValue: ref.watch(localeProvider),
      onChanged: (value) {
        ref.read(localeProvider.notifier).setLocale(value);
      },
      activeColor: cs.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildDivider(ColorScheme cs) {
    return Divider(
      height: 1,
      thickness: 1,
      color: cs.outline.withValues(alpha: 0.1),
      indent: 16,
      endIndent: 16,
    );
  }
}
