import 'package:ethiopian_date_picker/ethiopian_date_picker.dart'
    hide EthiopianDate;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/router/main_shell.dart';
import '../../../shared/models/app_models.dart';
import '../../../shared/services/date_conversion_service.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/converter_provider.dart';
import '../widgets/converter_result_card.dart';
import '../widgets/date_input_row.dart';

/// Date converter screen supporting bidirectional calendar conversion.
class ConverterScreen extends ConsumerWidget {
  const ConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(converterProvider);
    final notifier = ref.read(converterProvider.notifier);
    final l10n = ref.watch(appLocalizationsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: TabAppBar(title: l10n.converterTitle),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<ConversionDirection>(
                segments: [
                  ButtonSegment(
                    value: ConversionDirection.gregorianToEthiopian,
                    label: Text(l10n.gregorianToEthiopian),
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                  ButtonSegment(
                    value: ConversionDirection.ethiopianToGregorian,
                    label: Text(l10n.ethiopianToGregorian),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ],
                selected: {state.direction},
                onSelectionChanged: (selection) {
                  notifier.setDirection(selection.first);
                },
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.inputDate,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.isGregorianInput
                          ? l10n.enterGregorian
                          : l10n.enterEthiopian,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DateInputRow(
                      state: state,
                      notifier: notifier,
                      yearLabel: l10n.year,
                      monthLabel: l10n.month,
                      dayLabel: l10n.day,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _pickDate(context, ref),
                        icon: const Icon(Icons.calendar_today_rounded),
                        label: Text(l10n.pickFromCalendar),
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
                    if (!state.isGregorianInput) ...[
                      const SizedBox(height: 8),
                      Text(
                        l10n.pickHint,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: state.isConverting
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        notifier.convert(l10n);
                      },
                child: state.isConverting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(l10n.convert),
              ),
              if (state.result != null) ...[
                const SizedBox(height: 24),
                ConverterResultCard(result: state.result!, l10n: l10n),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, WidgetRef ref) async {
    final state = ref.read(converterProvider);
    final notifier = ref.read(converterProvider.notifier);
    final service = ref.read(dateConversionServiceProvider);
    final l10n = ref.read(appLocalizationsProvider);

    if (state.isGregorianInput) {
      final picked = await showDatePicker(
        context: context,
        initialDate: DateTime(state.year, state.month, state.day),
        firstDate: DateTime(DateConversionService.minGregorianYear),
        lastDate: DateTime(DateConversionService.maxGregorianYear),
        helpText: l10n.pickFromCalendar,
      );
      if (picked != null) {
        notifier.setDate(
          year: picked.year,
          month: picked.month,
          day: picked.day,
        );
      }
      return;
    }

    final gregorianInitial = service.ethiopianToGregorian(
      EthiopianDate(year: state.year, month: state.month, day: state.day),
    );

    final picked = await showEthiopianDatePicker(
      context: context,
      initialDate: gregorianInitial.dateTime,
      firstDate: DateTime(DateConversionService.minGregorianYear),
      lastDate: DateTime(DateConversionService.maxGregorianYear),
      localization: l10n.pickerLocalization,
    );

    if (picked == null || !context.mounted) return;

    final ethiopian = service.gregorianToEthiopian(GregorianDate(picked));
    notifier.setDate(
      year: ethiopian.year,
      month: ethiopian.month,
      day: ethiopian.day,
    );
  }
}
