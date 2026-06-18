import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/services/date_conversion_service.dart';

/// Snapshot of today's date information for the home screen.
class TodayInfo {
  const TodayInfo({
    required this.ethiopianDate,
    required this.gregorianDate,
    required this.weekdayName,
    required this.ethiopianMonthName,
    required this.ethiopianFormatted,
  });

  final EthiopianDate ethiopianDate;
  final GregorianDate gregorianDate;
  final String weekdayName;
  final String ethiopianMonthName;
  final String ethiopianFormatted;
}

/// Provides today's Ethiopian and Gregorian dates.
final todayInfoProvider = Provider<TodayInfo>((ref) {
  final service = ref.watch(dateConversionServiceProvider);
  final l10n = ref.watch(appLocalizationsProvider);
  final ethiopian = service.todayEthiopian();
  final gregorian = service.todayGregorian();

  return TodayInfo(
    ethiopianDate: ethiopian,
    gregorianDate: gregorian,
    weekdayName: l10n.weekdayFull(
      l10n.weekdayIndexFromDateTime(
        service.ethiopianToGregorian(ethiopian).dateTime,
      ),
    ),
    ethiopianMonthName: l10n.monthName(ethiopian.month),
    ethiopianFormatted: l10n.formatEthiopianDate(ethiopian),
  );
});
