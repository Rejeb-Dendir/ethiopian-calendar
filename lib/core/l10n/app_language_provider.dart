import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported app display languages.
enum AppLanguage {
  english('en'),
  amharic('am');

  const AppLanguage(this.code);
  final String code;

  static AppLanguage fromCode(String? code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

const _languageKey = 'app_language';

/// Persists and exposes the user's language preference offline.
class AppLanguageNotifier extends AsyncNotifier<AppLanguage> {
  @override
  Future<AppLanguage> build() async {
    final prefs = await SharedPreferences.getInstance();
    return AppLanguage.fromCode(prefs.getString(_languageKey));
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = AsyncData(language);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language.code);
  }
}

final appLanguageProvider =
    AsyncNotifierProvider<AppLanguageNotifier, AppLanguage>(
  AppLanguageNotifier.new,
);

/// Synchronous access with English fallback while preferences load.
final currentLanguageProvider = Provider<AppLanguage>((ref) {
  return ref.watch(appLanguageProvider).value ?? AppLanguage.english;
});
