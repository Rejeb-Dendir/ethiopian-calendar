import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/services/date_conversion_service.dart';

/// Manages converter input, validation, and conversion results.
class ConverterNotifier extends Notifier<ConverterState> {
  @override
  ConverterState build() {
    final service = ref.read(dateConversionServiceProvider);
    final today = service.todayGregorian();
    return ConverterState(
      direction: ConversionDirection.gregorianToEthiopian,
      year: today.year,
      month: today.month,
      day: today.day,
    );
  }

  void setDirection(ConversionDirection direction) {
    final service = ref.read(dateConversionServiceProvider);

    if (direction == ConversionDirection.gregorianToEthiopian) {
      final today = service.todayGregorian();
      state = ConverterState(
        direction: direction,
        year: today.year,
        month: today.month,
        day: today.day,
      );
    } else {
      final today = service.todayEthiopian();
      state = ConverterState(
        direction: direction,
        year: today.year,
        month: today.month,
        day: today.day,
      );
    }
  }

  void setYear(int year) => state = state.copyWith(year: year, clearResult: true);
  void setMonth(int month) =>
      state = state.copyWith(month: month, clearResult: true);
  void setDay(int day) => state = state.copyWith(day: day, clearResult: true);

  void setDate({required int year, required int month, required int day}) {
    state = state.copyWith(
      year: year,
      month: month,
      day: day,
      clearResult: true,
    );
  }

  void convert(AppLocalizations l10n) {
    final service = ref.read(dateConversionServiceProvider);
    state = state.copyWith(isConverting: true, clearResult: true);

    final result = service.convert(
      direction: state.direction,
      year: state.year,
      month: state.month,
      day: state.day,
      formatEthiopian: l10n.formatEthiopianDate,
      weekdayForEthiopian: (date) => l10n.weekdayFull(
        l10n.weekdayIndexFromDateTime(
          service.ethiopianToGregorian(date).dateTime,
        ),
      ),
    );

    state = state.copyWith(result: result, isConverting: false);
  }
}

final converterProvider =
    NotifierProvider<ConverterNotifier, ConverterState>(ConverterNotifier.new);

/// Input state for the date converter screen.
class ConverterState {
  const ConverterState({
    required this.direction,
    required this.year,
    required this.month,
    required this.day,
    this.result,
    this.isConverting = false,
  });

  final ConversionDirection direction;
  final int year;
  final int month;
  final int day;
  final ConversionResult? result;
  final bool isConverting;

  ConverterState copyWith({
    ConversionDirection? direction,
    int? year,
    int? month,
    int? day,
    ConversionResult? result,
    bool? isConverting,
    bool clearResult = false,
  }) {
    return ConverterState(
      direction: direction ?? this.direction,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      result: clearResult ? null : (result ?? this.result),
      isConverting: isConverting ?? this.isConverting,
    );
  }

  bool get isGregorianInput =>
      direction == ConversionDirection.gregorianToEthiopian;

  int get maxMonth => isGregorianInput ? 12 : 13;
}
