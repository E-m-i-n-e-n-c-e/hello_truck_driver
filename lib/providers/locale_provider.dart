import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleKey = 'app_locale';

/// Provider for the current locale.
/// - `null` means use system default
/// - `Locale('en')`, `Locale('hi')`, etc. means forced language
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// Async provider to load the initial locale from SharedPreferences
final localeInitializerProvider = FutureProvider<Locale?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final languageCode = prefs.getString(_kLocaleKey);
  if (languageCode == null) return null;
  return Locale(languageCode);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null);

  /// Initialize locale from stored preference
  void initialize(Locale? locale) {
    state = locale;
  }

  /// Set and persist locale preference
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_kLocaleKey);
    } else {
      await prefs.setString(_kLocaleKey, locale.languageCode);
    }
  }
}
