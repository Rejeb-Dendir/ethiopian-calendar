import 'package:intl/intl.dart';

/// Detailed age breakdown from a birth moment to a reference moment.
class AgeBreakdown {
  const AgeBreakdown({
    required this.years,
    required this.months,
    required this.days,
    required this.totalMonths,
    required this.weeks,
    required this.weekDays,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
  });

  final int years;
  final int months;
  final int days;
  final int totalMonths;
  final int weeks;
  final int weekDays;
  final int totalDays;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;

  static final _numberFormat = NumberFormat('#,###');

  String formatCount(int value) => _numberFormat.format(value);
}

/// Computes calendar-aware age parts plus duration counters.
class AgeCalculatorService {
  const AgeCalculatorService();

  AgeBreakdown calculate(
    DateTime birthDateTime,
    DateTime referenceDateTime, {
    bool liveTotals = false,
  }) {
    if (referenceDateTime.isBefore(birthDateTime)) {
      return const AgeBreakdown(
        years: 0,
        months: 0,
        days: 0,
        totalMonths: 0,
        weeks: 0,
        weekDays: 0,
        totalDays: 0,
        totalHours: 0,
        totalMinutes: 0,
        totalSeconds: 0,
      );
    }

    final birth = DateTime(
      birthDateTime.year,
      birthDateTime.month,
      birthDateTime.day,
    );
    final reference = DateTime(
      referenceDateTime.year,
      referenceDateTime.month,
      referenceDateTime.day,
    );

    var years = reference.year - birth.year;
    var months = reference.month - birth.month;
    var days = reference.day - birth.day;

    if (days < 0) {
      months -= 1;
      days += _daysInMonth(
        reference.month == 1 ? reference.year - 1 : reference.year,
        reference.month == 1 ? 12 : reference.month - 1,
      );
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    final duration = referenceDateTime.difference(birthDateTime);
    final totalDays = duration.inDays;
    final totalMonths = years * 12 + months;
    final weeks = totalDays ~/ 7;
    final weekDays = totalDays % 7;
    final totalHours =
        liveTotals ? duration.inHours : totalDays * 24;
    final totalMinutes =
        liveTotals ? duration.inMinutes : totalDays * 24 * 60;
    final totalSeconds =
        liveTotals ? duration.inSeconds : totalDays * 24 * 60 * 60;

    return AgeBreakdown(
      years: years,
      months: months,
      days: days,
      totalMonths: totalMonths,
      weeks: weeks,
      weekDays: weekDays,
      totalDays: totalDays,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
    );
  }

  int _daysInMonth(int year, int month) {
    const lengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && _isLeapYear(year)) return 29;
    return lengths[month - 1];
  }

  bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
