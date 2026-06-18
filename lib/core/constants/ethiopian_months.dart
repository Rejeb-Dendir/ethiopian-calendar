/// Ethiopian month names and related calendar constants.
///
/// Month indices are 1-based (Meskerem = 1, Pagume = 13).
abstract final class EthiopianMonths {
  static const List<String> names = [
    'Meskerem',
    'Tikimt',
    'Hidar',
    'Tahsas',
    'Tir',
    'Yekatit',
    'Megabit',
    'Miazia',
    'Ginbot',
    'Sene',
    'Hamle',
    'Nehase',
    'Pagume',
  ];

  static const List<String> shortNames = [
    'Mes',
    'Tik',
    'Hid',
    'Tah',
    'Tir',
    'Yek',
    'Meg',
    'Mia',
    'Gin',
    'Sen',
    'Ham',
    'Neh',
    'Pag',
  ];

  static String nameFor(int month) {
    assert(month >= 1 && month <= 13);
    return names[month - 1];
  }

  static String shortNameFor(int month) {
    assert(month >= 1 && month <= 13);
    return shortNames[month - 1];
  }
}

/// Weekday labels — Monday-first (Ethiopian civil convention).
abstract final class WeekdayLabels {
  static const List<String> short = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> full = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
