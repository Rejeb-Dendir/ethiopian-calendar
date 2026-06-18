import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/services/date_conversion_service.dart';
import '../providers/calendar_provider.dart';
import 'calendar_grid.dart';

/// Horizontally swipeable month pager (prev / current / next).
///
/// Uses a 3-page [PageView] so swiping feels infinite: after each swipe the
/// controller resets to the center page with updated month data.
class CalendarMonthPager extends ConsumerStatefulWidget {
  const CalendarMonthPager({
    super.key,
    required this.onDaySelected,
  });

  final ValueChanged<EthiopianDate> onDaySelected;

  @override
  ConsumerState<CalendarMonthPager> createState() => _CalendarMonthPagerState();
}

class _CalendarMonthPagerState extends ConsumerState<CalendarMonthPager> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _resetToCenter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.jumpToPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calendarProvider);
    final notifier = ref.read(calendarProvider.notifier);
    final service = ref.read(dateConversionServiceProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final headers = l10n.weekdayHeadersShort;

    final prev = offsetEthiopianMonth(
      state.displayYear,
      state.displayMonth,
      -1,
    );
    final next = offsetEthiopianMonth(
      state.displayYear,
      state.displayMonth,
      1,
    );

    final pages = [
      service.buildMonthGrid(
        year: prev.$1,
        month: prev.$2,
        selectedDate: state.selectedDate,
        weekdayHeaders: headers,
      ),
      service.buildMonthGrid(
        year: state.displayYear,
        month: state.displayMonth,
        selectedDate: state.selectedDate,
        weekdayHeaders: headers,
      ),
      service.buildMonthGrid(
        year: next.$1,
        month: next.$2,
        selectedDate: state.selectedDate,
        weekdayHeaders: headers,
      ),
    ];

    return PageView.builder(
      controller: _pageController,
      onPageChanged: (index) {
        if (index == 0) {
          notifier.goToPreviousMonth();
          _resetToCenter();
        } else if (index == 2) {
          notifier.goToNextMonth();
          _resetToCenter();
        }
      },
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return CalendarGrid(
          monthData: pages[index],
          onDaySelected: widget.onDaySelected,
        );
      },
    );
  }
}
