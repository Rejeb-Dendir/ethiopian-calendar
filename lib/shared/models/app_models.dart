import 'package:intl/intl.dart';

import '../../core/constants/ethiopian_months.dart';

/// Immutable Ethiopian calendar date.
///
/// Month is 1-based (1 = Meskerem, 13 = Pagume).
class EthiopianDate {
  const EthiopianDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  /// Full formatted label, e.g. "11 Sene 2017".
  String get formattedLong =>
      '$day ${EthiopianMonths.nameFor(month)} $year';

  /// Compact label, e.g. "11/10/2017".
  String get formattedShort => '$day/$month/$year';

  EthiopianDate copyWith({int? year, int? month, int? day}) {
    return EthiopianDate(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EthiopianDate &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => 'EthiopianDate($year-$month-$day)';
}

/// Gregorian date wrapper with formatting helpers.
class GregorianDate {
  const GregorianDate(this.dateTime);

  final DateTime dateTime;

  String get formattedLong => DateFormat('EEEE, MMMM d, y').format(dateTime);
  String get formattedShort => DateFormat('d/M/y').format(dateTime);
  String get weekdayName => DateFormat('EEEE').format(dateTime);

  int get year => dateTime.year;
  int get month => dateTime.month;
  int get day => dateTime.day;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GregorianDate &&
          dateTime.year == other.dateTime.year &&
          dateTime.month == other.dateTime.month &&
          dateTime.day == other.dateTime.day;

  @override
  int get hashCode => Object.hash(dateTime.year, dateTime.month, dateTime.day);
}

/// A single cell in the monthly calendar grid.
class CalendarDay {
  const CalendarDay({
    required this.ethiopianDate,
    required this.isCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.gregorianLabel,
  });

  final EthiopianDate ethiopianDate;
  final bool isCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final String gregorianLabel;

  bool get isSelectable => isCurrentMonth;
}

/// One month of calendar data for grid rendering.
class CalendarMonthData {
  const CalendarMonthData({
    required this.year,
    required this.month,
    required this.days,
    required this.weekdayHeaders,
  });

  final int year;
  final int month;
  final List<CalendarDay> days;
  final List<String> weekdayHeaders;

  String get monthName => EthiopianMonths.nameFor(month);
}

/// Direction of a date conversion operation.
enum ConversionDirection {
  gregorianToEthiopian,
  ethiopianToGregorian,
}

/// Result of a date conversion attempt.
sealed class ConversionResult {
  const ConversionResult();
}

class ConversionSuccess extends ConversionResult {
  const ConversionSuccess({
    required this.sourceLabel,
    required this.resultLabel,
    required this.resultSubtitle,
  });

  final String sourceLabel;
  final String resultLabel;
  final String resultSubtitle;
}

class ConversionError extends ConversionResult {
  const ConversionError(this.message);

  final String message;
}
