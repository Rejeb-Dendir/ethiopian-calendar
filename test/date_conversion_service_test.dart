import 'package:flutter_test/flutter_test.dart';

import 'package:ethiopian_calendar/shared/models/app_models.dart';
import 'package:ethiopian_calendar/shared/services/date_conversion_service.dart';

void main() {
  const service = DateConversionService();

  group('DateConversionService', () {
    test('converts known Gregorian date to Ethiopian', () {
      final ethiopian = service.gregorianToEthiopian(
        GregorianDate(DateTime(2024, 3, 20)),
      );

      expect(ethiopian.year, 2016);
      expect(ethiopian.month, 7);
      expect(ethiopian.day, 11);
    });

    test('converts known Ethiopian date to Gregorian', () {
      final gregorian = service.ethiopianToGregorian(
        const EthiopianDate(year: 2016, month: 7, day: 11),
      );

      expect(gregorian.year, 2024);
      expect(gregorian.month, 3);
      expect(gregorian.day, 20);
    });

    test('round-trip conversion is consistent', () {
      final original = const EthiopianDate(year: 2017, month: 10, day: 5);
      final gregorian = service.ethiopianToGregorian(original);
      final back = service.gregorianToEthiopian(gregorian);

      expect(back, original);
    });

    test('Pagume has 6 days in Ethiopian leap year', () {
      expect(service.daysInEthiopianMonth(2015, 13), 6);
      expect(service.daysInEthiopianMonth(2016, 13), 5);
    });

    test('rejects invalid Ethiopian date', () {
      expect(
        () => service.ethiopianToGregorian(
          const EthiopianDate(year: 2016, month: 13, day: 6),
        ),
        throwsArgumentError,
      );
    });

    test('rejects invalid Gregorian date via convert', () {
      final result = service.convert(
        direction: ConversionDirection.gregorianToEthiopian,
        year: 2024,
        month: 2,
        day: 30,
      );

      expect(result, isA<ConversionError>());
    });

    test('calendar grid contains correct number of current-month days', () {
      final grid = service.buildMonthGrid(year: 2017, month: 1);
      final currentMonthDays =
          grid.days.where((d) => d.isCurrentMonth).length;

      expect(currentMonthDays, 30);
      expect(grid.days.length % 7, 0);
    });
  });
}
