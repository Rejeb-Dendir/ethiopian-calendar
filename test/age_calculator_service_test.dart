import 'package:flutter_test/flutter_test.dart';

import 'package:ethiopian_calendar/shared/services/age_calculator_service.dart';

void main() {
  const service = AgeCalculatorService();

  group('AgeCalculatorService', () {
    test('calculates age for Feb 5 2000 at Jun 18 2026 end of day', () {
      final birth = DateTime(2000, 2, 5);
      final reference = DateTime(2026, 6, 18, 23, 59, 59);

      final age = service.calculate(birth, reference);

      expect(age.years, 26);
      expect(age.months, 4);
      expect(age.days, 13);
      expect(age.totalMonths, 316);
      expect(age.weeks, 1375);
      expect(age.weekDays, 5);
      expect(age.totalDays, 9630);
      expect(age.totalHours, 9630 * 24);
      expect(age.totalMinutes, 9630 * 24 * 60);
      expect(age.totalSeconds, 9630 * 24 * 60 * 60);
    });

    test('returns zero for future birth date', () {
      final birth = DateTime(2030, 1, 1);
      final now = DateTime(2026, 1, 1);

      final age = service.calculate(birth, now);

      expect(age.years, 0);
      expect(age.totalDays, 0);
    });
  });
}
