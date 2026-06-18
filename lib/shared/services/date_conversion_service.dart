import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/ethiopian_months.dart';
import '../models/app_models.dart';

/// Ethiopian ↔ Gregorian date conversion service.
///
/// # Algorithm Overview
///
/// Conversions use two complementary, integer-based strategies that mirror
/// established Ethiopian calendar libraries and work fully offline.
///
/// ## Gregorian → Ethiopian (offset method)
///
/// A known anchor maps **12 September 1971 (G)** to **1 Meskerem 1964 (E)**.
/// The millisecond difference from that anchor is decomposed into:
///
/// - 4-year cycles (1461 days — accounts for Pagume leap days)
/// - Remaining years (365 days each, capped at 3 per cycle)
/// - Remaining months (30 days each)
/// - Remaining days
///
/// This handles the Ethiopian 4-year leap cycle (Pagume has 6 days when
/// `year % 4 == 3`) without maintaining lookup tables.
///
/// ## Ethiopian → Gregorian (new-year offset method)
///
/// 1. Find the Gregorian date of **Meskerem 1** for the target Ethiopian year.
///    New Year falls on September 11, or September 12 when the *following*
///    Gregorian year is a leap year.
/// 2. Add `(month − 1) × 30 + (day − 1)` days to that anchor.
/// 3. Resolve the resulting day-of-year back to a Gregorian month and day,
///    rolling into the next Gregorian year if needed.
///
/// ## Weekday
///
/// Weekday is derived by converting to Gregorian. The calendar grid uses a
/// Monday-first index (0 = Monday … 6 = Sunday).
class DateConversionService {
  const DateConversionService();

  /// Anchor: 12 Sep 1971 (Gregorian) = 1 Meskerem 1964 (Ethiopian).
  static final DateTime _gregorianAnchor = DateTime(1971, 9, 12);
  static const int _ethiopianAnchorYear = 1964;

  static const int _oneDayMs = 86400000;
  static const int _oneYearMs = 365 * _oneDayMs;
  static const int _fourYearsMs = 1461 * _oneDayMs;
  static const int _oneMonthMs = 30 * _oneDayMs;

  static const int minEthiopianYear = 1;
  static const int maxEthiopianYear = 9999;
  static const int minGregorianYear = 1900;
  static const int maxGregorianYear = 2100;

  EthiopianDate todayEthiopian() {
    final now = DateTime.now();
    return gregorianToEthiopian(
      GregorianDate(DateTime(now.year, now.month, now.day)),
    );
  }

  GregorianDate todayGregorian() {
    final now = DateTime.now();
    return GregorianDate(DateTime(now.year, now.month, now.day));
  }

  EthiopianDate gregorianToEthiopian(GregorianDate gregorian) {
    _validateGregorian(gregorian);

    final input = DateTime(gregorian.year, gregorian.month, gregorian.day);
    final diff = input.millisecondsSinceEpoch - _gregorianAnchor.millisecondsSinceEpoch;

    final fourYearCycles = diff ~/ _fourYearsMs;
    var remainder = diff - fourYearCycles * _fourYearsMs;

    var remainingYears = remainder ~/ _oneYearMs;
    if (remainingYears == 4) remainingYears = 3;
    remainder -= remainingYears * _oneYearMs;

    final remainingMonths = remainder ~/ _oneMonthMs;
    remainder -= remainingMonths * _oneMonthMs;

    final remainingDays = remainder ~/ _oneDayMs;

    return EthiopianDate(
      year: _ethiopianAnchorYear + fourYearCycles * 4 + remainingYears,
      month: remainingMonths + 1,
      day: remainingDays + 1,
    );
  }

  GregorianDate ethiopianToGregorian(EthiopianDate ethiopian) {
    _validateEthiopian(ethiopian);

    final newYear = _gregorianDateOfEthiopianNewYear(ethiopian.year);
    final daysSinceNewYear = (ethiopian.month - 1) * 30 + ethiopian.day - 1;

    var gregorianYear = newYear.year;
    var dayOfYear = _dayOfYear(newYear.year, newYear.month, newYear.day) +
        daysSinceNewYear;

    final yearLength = _isGregorianLeapYear(gregorianYear) ? 366 : 365;
    if (dayOfYear > yearLength) {
      dayOfYear -= yearLength;
      gregorianYear += 1;
    }

    final monthDay = _monthDayFromDayOfYear(gregorianYear, dayOfYear);
    return GregorianDate(
      DateTime(gregorianYear, monthDay.month, monthDay.day),
    );
  }

  /// Day-of-week index for the calendar grid (0 = Monday … 6 = Sunday).
  int weekdayIndex(EthiopianDate date) {
    final gregorian = ethiopianToGregorian(date);
    return gregorian.dateTime.weekday - 1;
  }

  String weekdayName(EthiopianDate date) =>
      WeekdayLabels.full[weekdayIndex(date)];

  String weekdayShort(EthiopianDate date) =>
      WeekdayLabels.short[weekdayIndex(date)];

  int daysInEthiopianMonth(int year, int month) {
    _validateYear(year);
    if (month < 1 || month > 13) {
      throw ArgumentError('Month must be between 1 and 13.');
    }
    if (month <= 12) return 30;
    return _isEthiopianLeapYear(year) ? 6 : 5;
  }

  bool _isEthiopianLeapYear(int year) => year % 4 == 3;

  CalendarMonthData buildMonthGrid({
    required int year,
    required int month,
    EthiopianDate? selectedDate,
    EthiopianDate? today,
    List<String>? weekdayHeaders,
  }) {
    _validateYear(year);
    if (month < 1 || month > 13) {
      throw ArgumentError('Month must be between 1 and 13.');
    }

    final todayDate = today ?? todayEthiopian();
    final selected = selectedDate ?? todayDate;
    final daysInMonth = daysInEthiopianMonth(year, month);

    final firstDay = EthiopianDate(year: year, month: month, day: 1);
    final firstWeekday = weekdayIndex(firstDay);

    final leadingDays = firstWeekday;
    final totalCells = ((leadingDays + daysInMonth + 6) ~/ 7) * 7;

    final days = <CalendarDay>[];

    if (leadingDays > 0) {
      final prev = _previousMonth(year, month);
      final prevDays = daysInEthiopianMonth(prev.$1, prev.$2);
      for (var i = leadingDays - 1; i >= 0; i--) {
        final day = prevDays - i;
        final date = EthiopianDate(year: prev.$1, month: prev.$2, day: day);
        days.add(_calendarDay(date, false, todayDate, selected));
      }
    }

    for (var day = 1; day <= daysInMonth; day++) {
      final date = EthiopianDate(year: year, month: month, day: day);
      days.add(_calendarDay(date, true, todayDate, selected));
    }

    final remaining = totalCells - days.length;
    if (remaining > 0) {
      final next = _nextMonth(year, month);
      for (var day = 1; day <= remaining; day++) {
        final date = EthiopianDate(year: next.$1, month: next.$2, day: day);
        days.add(_calendarDay(date, false, todayDate, selected));
      }
    }

    return CalendarMonthData(
      year: year,
      month: month,
      days: days,
      weekdayHeaders: weekdayHeaders ?? WeekdayLabels.short,
    );
  }

  CalendarDay _calendarDay(
    EthiopianDate date,
    bool isCurrentMonth,
    EthiopianDate today,
    EthiopianDate selected,
  ) {
    final gregorian = ethiopianToGregorian(date);
    final g = gregorian.dateTime;
    final gregorianLabel = '${_gregorianMonthShort(g.month)} ${g.day}';

    return CalendarDay(
      ethiopianDate: date,
      isCurrentMonth: isCurrentMonth,
      isToday: date == today,
      isSelected: isCurrentMonth && date == selected,
      gregorianLabel: gregorianLabel,
    );
  }

  String _gregorianMonthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  (int, int) _previousMonth(int year, int month) {
    if (month == 1) return (year - 1, 13);
    return (year, month - 1);
  }

  (int, int) _nextMonth(int year, int month) {
    if (month == 13) return (year + 1, 1);
    return (year, month + 1);
  }

  ConversionResult convert({
    required ConversionDirection direction,
    required int year,
    required int month,
    required int day,
    String Function(EthiopianDate date)? formatEthiopian,
    String Function(EthiopianDate date)? weekdayForEthiopian,
  }) {
    final formatE = formatEthiopian ?? (d) => d.formattedLong;
    final weekdayE = weekdayForEthiopian ?? weekdayName;

    try {
      if (direction == ConversionDirection.gregorianToEthiopian) {
        if (!_isValidGregorianDate(year, month, day)) {
          return const ConversionError('Invalid Gregorian date.');
        }
        final gregorian = GregorianDate(DateTime(year, month, day));
        final ethiopian = gregorianToEthiopian(gregorian);
        return ConversionSuccess(
          sourceLabel: gregorian.formattedLong,
          resultLabel: formatE(ethiopian),
          resultSubtitle: weekdayE(ethiopian),
        );
      } else {
        final ethiopian = EthiopianDate(year: year, month: month, day: day);
        final gregorian = ethiopianToGregorian(ethiopian);
        return ConversionSuccess(
          sourceLabel: formatE(ethiopian),
          resultLabel: gregorian.formattedLong,
          resultSubtitle: gregorian.weekdayName,
        );
      }
    } on ArgumentError catch (e) {
      return ConversionError(e.message ?? 'Invalid date.');
    }
  }

  DateTime _gregorianDateOfEthiopianNewYear(int ethiopianYear) {
    final gregorianYear = ethiopianYear + 7;
    final day = _isGregorianLeapYear(gregorianYear + 1) ? 12 : 11;
    return DateTime(gregorianYear, 9, day);
  }

  int _dayOfYear(int year, int month, int day) {
    const monthLengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var doy = day;
    for (var i = 0; i < month - 1; i++) {
      doy += i == 1 && _isGregorianLeapYear(year) ? 29 : monthLengths[i];
    }
    return doy;
  }

  ({int month, int day}) _monthDayFromDayOfYear(int year, int dayOfYear) {
    final monthLengths = [
      31,
      _isGregorianLeapYear(year) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31,
    ];

    var month = 1;
    var remaining = dayOfYear;
    while (remaining > monthLengths[month - 1]) {
      remaining -= monthLengths[month - 1];
      month++;
    }
    return (month: month, day: remaining);
  }

  void _validateGregorian(GregorianDate date) {
    if (date.year < minGregorianYear || date.year > maxGregorianYear) {
      throw ArgumentError(
        'Gregorian year must be between $minGregorianYear and $maxGregorianYear.',
      );
    }
    if (!_isValidGregorianDate(date.year, date.month, date.day)) {
      throw ArgumentError('Invalid Gregorian date.');
    }
  }

  void _validateEthiopian(EthiopianDate date) {
    _validateYear(date.year);
    if (date.month < 1 || date.month > 13) {
      throw ArgumentError('Ethiopian month must be between 1 and 13.');
    }
    final maxDay = daysInEthiopianMonth(date.year, date.month);
    if (date.day < 1 || date.day > maxDay) {
      throw ArgumentError(
        'Day must be between 1 and $maxDay for '
        '${EthiopianMonths.nameFor(date.month)} ${date.year}.',
      );
    }
  }

  void _validateYear(int year) {
    if (year < minEthiopianYear || year > maxEthiopianYear) {
      throw ArgumentError(
        'Ethiopian year must be between $minEthiopianYear and $maxEthiopianYear.',
      );
    }
  }

  bool _isValidGregorianDate(int year, int month, int day) {
    try {
      final date = DateTime(year, month, day);
      return date.year == year && date.month == month && date.day == day;
    } on Object {
      return false;
    }
  }

  bool _isGregorianLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}

/// Riverpod provider for the conversion service (singleton, stateless).
final dateConversionServiceProvider = Provider<DateConversionService>(
  (ref) => const DateConversionService(),
);
