import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/main_shell.dart';
import '../../../shared/services/date_conversion_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_month_pager.dart';

/// Ethiopian calendar screen with swipe and button month navigation.
class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);
    final l10n = ref.watch(appLocalizationsProvider);
    final service = ref.read(dateConversionServiceProvider);
    final theme = Theme.of(context);
    final selectedGregorian = service.ethiopianToGregorian(state.selectedDate);

    return Scaffold(
      appBar: TabAppBar(
        title: l10n.calendarTitle,
        actions: [
          TextButton(
            onPressed: notifier.goToToday,
            child: Text(l10n.today),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _MonthNavigator(
                monthName: l10n.monthName(state.displayMonth),
                yearLabel: l10n.ethiopianYearSuffix(state.displayYear),
                onPrevious: notifier.goToPreviousMonth,
                onNext: notifier.goToNextMonth,
                previousTooltip: l10n.previousMonth,
                nextTooltip: l10n.nextMonth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                l10n.swipeHint,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: AppCard(
                  padding: const EdgeInsets.all(16),
                  child: CalendarMonthPager(
                    onDaySelected: notifier.selectDay,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: AppCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.touch_app_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.selected,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.formatEthiopianDate(state.selectedDate),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.formatGregorianLong(selectedGregorian.dateTime),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  const _MonthNavigator({
    required this.monthName,
    required this.yearLabel,
    required this.onPrevious,
    required this.onNext,
    required this.previousTooltip,
    required this.nextTooltip,
  });

  final String monthName;
  final String yearLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String previousTooltip;
  final String nextTooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
          tooltip: previousTooltip,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            foregroundColor: AppColors.primaryGreen,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                monthName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                yearLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
          tooltip: nextTooltip,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
            foregroundColor: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }
}
