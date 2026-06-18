import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/services/date_conversion_service.dart';

/// State for the Ethiopian calendar screen.
class CalendarState {
  const CalendarState({
    required this.displayYear,
    required this.displayMonth,
    required this.selectedDate,
    required this.monthData,
  });

  final int displayYear;
  final int displayMonth;
  final EthiopianDate selectedDate;
  final CalendarMonthData monthData;

  CalendarState copyWith({
    int? displayYear,
    int? displayMonth,
    EthiopianDate? selectedDate,
    CalendarMonthData? monthData,
  }) {
    return CalendarState(
      displayYear: displayYear ?? this.displayYear,
      displayMonth: displayMonth ?? this.displayMonth,
      selectedDate: selectedDate ?? this.selectedDate,
      monthData: monthData ?? this.monthData,
    );
  }
}

/// Manages visible month and selected day for the calendar grid.
class CalendarNotifier extends Notifier<CalendarState> {
  @override
  CalendarState build() {
    final service = ref.read(dateConversionServiceProvider);
    final today = service.todayEthiopian();
    return _buildState(
      service,
      today.year,
      today.month,
      today,
    );
  }

  void goToPreviousMonth() {
    final service = ref.read(dateConversionServiceProvider);
    final (year, month) = _previousMonth(state.displayYear, state.displayMonth);
    state = _buildState(service, year, month, state.selectedDate);
  }

  void goToNextMonth() {
    final service = ref.read(dateConversionServiceProvider);
    final (year, month) = _nextMonth(state.displayYear, state.displayMonth);
    state = _buildState(service, year, month, state.selectedDate);
  }

  void selectDay(EthiopianDate date) {
    final service = ref.read(dateConversionServiceProvider);
    state = _buildState(
      service,
      date.year,
      date.month,
      date,
    );
  }

  void goToToday() {
    final service = ref.read(dateConversionServiceProvider);
    final today = service.todayEthiopian();
    state = _buildState(service, today.year, today.month, today);
  }

  CalendarState _buildState(
    DateConversionService service,
    int year,
    int month,
    EthiopianDate selected,
  ) {
    final l10n = ref.read(appLocalizationsProvider);
    return CalendarState(
      displayYear: year,
      displayMonth: month,
      selectedDate: selected,
      monthData: service.buildMonthGrid(
        year: year,
        month: month,
        selectedDate: selected,
        weekdayHeaders: l10n.weekdayHeadersShort,
      ),
    );
  }

  (int, int) _previousMonth(int year, int month) {
    if (month == 1) return (year - 1, 13);
    return (year, month - 1);
  }

  (int, int) _nextMonth(int year, int month) {
    if (month == 13) return (year + 1, 1);
    return (year, month + 1);
  }
}

final calendarProvider =
    NotifierProvider<CalendarNotifier, CalendarState>(CalendarNotifier.new);

/// Returns `(year, month)` offset by [delta] months on the Ethiopian calendar.
(int, int) offsetEthiopianMonth(int year, int month, int delta) {
  var y = year;
  var m = month + delta;
  while (m < 1) {
    m += 13;
    y -= 1;
  }
  while (m > 13) {
    m -= 13;
    y += 1;
  }
  return (y, m);
}
