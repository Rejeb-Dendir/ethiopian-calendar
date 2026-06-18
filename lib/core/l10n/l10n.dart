export 'app_language_provider.dart';
export 'app_localizations.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_language_provider.dart';
import 'app_localizations.dart';

final appLocalizationsProvider = Provider<AppLocalizations>((ref) {
  final language = ref.watch(currentLanguageProvider);
  return AppLocalizations(language);
});
