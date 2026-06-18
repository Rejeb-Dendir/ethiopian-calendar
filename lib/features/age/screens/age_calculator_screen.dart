import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/main_shell.dart';
import '../../../shared/services/age_calculator_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/age_provider.dart';

/// Age calculator with optional live second-by-second updates.
class AgeCalculatorScreen extends ConsumerStatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  ConsumerState<AgeCalculatorScreen> createState() =>
      _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends ConsumerState<AgeCalculatorScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(ageCalculatorProvider.notifier).tick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: stateBirthDate ?? DateTime(2000, 2, 5),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: ref.read(appLocalizationsProvider).selectBirthDate,
    );
    if (picked != null) {
      ref.read(ageCalculatorProvider.notifier).setBirthDate(picked);
    }
  }

  Future<void> _pickReferenceDate() async {
    final l10n = ref.read(appLocalizationsProvider);
    final picked = await showDatePicker(
      context: context,
      initialDate: stateReferenceDate ?? DateTime.now(),
      firstDate: stateBirthDate ?? DateTime(1900),
      lastDate: DateTime.now(),
      helpText: l10n.ageAtDate,
    );
    if (picked == null) return;

    final now = DateTime.now();
    final isToday = picked.year == now.year &&
        picked.month == now.month &&
        picked.day == now.day;

    if (isToday) {
      ref.read(ageCalculatorProvider.notifier).resetReferenceToToday();
    } else {
      ref.read(ageCalculatorProvider.notifier).setReferenceDate(picked);
    }
  }

  DateTime? get stateBirthDate => ref.read(ageCalculatorProvider).birthDate;

  DateTime? get stateReferenceDate {
    final state = ref.read(ageCalculatorProvider);
    return state.referenceDate ?? DateTime.now();
  }

  String _referenceLabel(AppLocalizations l10n, AgeCalculatorState state) {
    if (state.isLive) return l10n.today;
    return l10n.formatGregorianLong(state.referenceDate!);
  }

  List<String> _ageLines(AppLocalizations l10n, AgeBreakdown age) {
    return [
      l10n.ageYearsMonthsDays(age.years, age.months, age.days),
      l10n.ageTotalMonthsDays(age.totalMonths, age.days),
      l10n.ageWeeksDays(age.weeks, age.weekDays),
      l10n.ageTotalDays(age.totalDays),
      l10n.ageTotalHours(age.totalHours),
      l10n.ageTotalMinutes(age.totalMinutes),
      l10n.ageTotalSeconds(age.totalSeconds),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ageCalculatorProvider);
    final l10n = ref.watch(appLocalizationsProvider);
    final theme = Theme.of(context);
    final breakdown = state.breakdown;

    return Scaffold(
      appBar: TabAppBar(title: l10n.ageTitle),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.birthDate,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.selectBirthDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _pickBirthDate,
                        icon: const Icon(Icons.cake_outlined),
                        label: Text(
                          state.birthDate == null
                              ? l10n.selectBirthDate
                              : l10n.formatGregorianLong(state.birthDate!),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.ageAtDate,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.ageAtDateHint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: state.hasBirthDate ? _pickReferenceDate : null,
                        icon: const Icon(Icons.event_outlined),
                        label: Text(_referenceLabel(l10n, state)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (breakdown != null) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Text(
                      l10n.ageLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (state.isLive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentRed.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.accentRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              l10n.live,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.accentRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                ...() {
                  final lines = _ageLines(l10n, breakdown);
                  return List.generate(lines.length, (index) {
                    final line = lines[index];
                    final prefix = index == 0 ? '' : '${l10n.orPrefix} ';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '$prefix$line',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          fontWeight:
                              index == 0 ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    );
                  });
                }(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
