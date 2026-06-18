import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_links.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/main_shell.dart';
import '../../calendar/providers/calendar_provider.dart';
import '../providers/settings_provider.dart';

/// Settings screen for language and app preferences.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(appLocalizationsProvider);
    final language = ref.watch(currentLanguageProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: TabAppBar(title: l10n.settingsTitle),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              l10n.languageSection,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.languageDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SegmentedButton<AppLanguage>(
              segments: [
                ButtonSegment(
                  value: AppLanguage.english,
                  label: Text(l10n.englishLabel),
                ),
                ButtonSegment(
                  value: AppLanguage.amharic,
                  label: Text(l10n.amharicLabel),
                ),
              ],
              selected: {language},
              onSelectionChanged: (selection) async {
                await ref
                    .read(appLanguageProvider.notifier)
                    .setLanguage(selection.first);
                ref.invalidate(calendarProvider);
              },
            ),
            const SizedBox(height: 32),
            Text(
              l10n.supportSection,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _SettingsActionTile(
              icon: Icons.star_outline_rounded,
              title: l10n.rateApp,
              onTap: () => _openPlayStore(),
            ),
            _SettingsActionTile(
              icon: Icons.share_outlined,
              title: l10n.shareApp,
              onTap: () => SharePlus.instance.share(
                ShareParams(
                  text: '${l10n.shareMessage}\n${AppLinks.playStoreUrl}',
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.aboutSection,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.versionLabel),
              trailing: Text(
                appVersion,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPlayStore() async {
    final uri = Uri.parse(AppLinks.playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.divider),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryGreen),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: onTap,
      ),
    );
  }
}
