import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/app_routes.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/quick_action_card.dart';
import '../providers/home_provider.dart';

/// Home screen — entry point showing today's date and quick actions.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayInfoProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AppHeader(l10n: l10n, theme: theme),
              const SizedBox(height: 32),
              _TodayCard(today: today, l10n: l10n, theme: theme),
              const SizedBox(height: 32),
              Text(
                l10n.quickActions,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              QuickActionCard(
                title: l10n.navCalendar,
                subtitle: l10n.browseCalendar,
                icon: Icons.calendar_month_rounded,
                iconColor: AppColors.primaryGreen,
                onTap: () => context.go(AppRoutes.calendar),
              ),
              const SizedBox(height: 12),
              QuickActionCard(
                title: l10n.converterTitle,
                subtitle: l10n.convertDates,
                icon: Icons.swap_horiz_rounded,
                iconColor: AppColors.accentRed,
                onTap: () => context.go(AppRoutes.converter),
              ),
              const SizedBox(height: 12),
              QuickActionCard(
                title: l10n.ageTitle,
                subtitle: l10n.calculateAge,
                icon: Icons.cake_outlined,
                iconColor: const Color(0xFF3D8BDC),
                onTap: () => context.go(AppRoutes.age),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.l10n, required this.theme});

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                l10n.appSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TodayCard extends StatelessWidget {
  const _TodayCard({
    required this.today,
    required this.l10n,
    required this.theme,
  });

  final TodayInfo today;
  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentYellow.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  l10n.today,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF6B5A00),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            today.ethiopianFormatted,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            today.gregorianDate.formattedLong,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.event_rounded,
            label: l10n.dayOfWeek,
            value: today.weekdayName,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.date_range_rounded,
            label: l10n.ethiopianMonth,
            value: today.ethiopianMonthName,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryGreen),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
