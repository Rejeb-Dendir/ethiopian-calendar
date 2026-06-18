import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/services/age_calculator_service.dart';

final ageCalculatorServiceProvider = Provider<AgeCalculatorService>(
  (ref) => const AgeCalculatorService(),
);

/// State for the age calculator tab.
class AgeCalculatorState {
  const AgeCalculatorState({
    this.birthDate,
    this.referenceDate,
    this.breakdown,
  });

  final DateTime? birthDate;
  final DateTime? referenceDate;
  final AgeBreakdown? breakdown;

  bool get hasBirthDate => birthDate != null;

  bool get isLive {
    if (referenceDate == null) return true;
    final now = DateTime.now();
    return referenceDate!.year == now.year &&
        referenceDate!.month == now.month &&
        referenceDate!.day == now.day;
  }

  AgeCalculatorState copyWith({
    DateTime? birthDate,
    DateTime? referenceDate,
    AgeBreakdown? breakdown,
    bool clearBirthDate = false,
    bool clearReferenceDate = false,
  }) {
    return AgeCalculatorState(
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      referenceDate:
          clearReferenceDate ? null : (referenceDate ?? this.referenceDate),
      breakdown: breakdown ?? this.breakdown,
    );
  }
}

class AgeCalculatorNotifier extends Notifier<AgeCalculatorState> {
  @override
  AgeCalculatorState build() => const AgeCalculatorState();

  void setBirthDate(DateTime date) {
    final birth = DateTime(date.year, date.month, date.day);
    _recalculate(birth: birth);
  }

  void setReferenceDate(DateTime date) {
    final reference = DateTime(date.year, date.month, date.day);
    _recalculate(referenceDate: reference);
  }

  void resetReferenceToToday() {
    _recalculate(clearReferenceDate: true);
  }

  void tick() {
    if (state.birthDate == null || !state.isLive) return;
    _recalculate();
  }

  void _recalculate({
    DateTime? birth,
    DateTime? referenceDate,
    bool clearReferenceDate = false,
  }) {
    final birthDate = birth ?? state.birthDate;
    if (birthDate == null) return;

    final service = ref.read(ageCalculatorServiceProvider);
    final newReferenceDate =
        clearReferenceDate ? null : (referenceDate ?? state.referenceDate);
    final reference = _referenceDateTime(newReferenceDate);
    final liveTotals =
        newReferenceDate == null || _isSameDay(newReferenceDate, DateTime.now());

    state = AgeCalculatorState(
      birthDate: birthDate,
      referenceDate: newReferenceDate,
      breakdown: service.calculate(
        birthDate,
        reference,
        liveTotals: liveTotals,
      ),
    );
  }

  bool _isSameDay(DateTime? date, DateTime now) {
    if (date == null) return true;
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  DateTime _referenceDateTime(DateTime? referenceDate) {
    if (referenceDate == null) return DateTime.now();

    final now = DateTime.now();
    final isToday = referenceDate.year == now.year &&
        referenceDate.month == now.month &&
        referenceDate.day == now.day;

    if (isToday) return now;

    return DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
      23,
      59,
      59,
    );
  }
}

final ageCalculatorProvider =
    NotifierProvider<AgeCalculatorNotifier, AgeCalculatorState>(
  AgeCalculatorNotifier.new,
);
