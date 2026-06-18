import 'package:flutter/material.dart';

import '../providers/converter_provider.dart';

/// Year / month / day inputs that keep keyboard focus while typing.
///
/// Previously each keystroke updated Riverpod state and rebuilt the field
/// via [ValueKey], which dismissed the keyboard after every character.
class DateInputRow extends StatefulWidget {
  const DateInputRow({
    super.key,
    required this.state,
    required this.notifier,
    required this.yearLabel,
    required this.monthLabel,
    required this.dayLabel,
  });

  final ConverterState state;
  final ConverterNotifier notifier;
  final String yearLabel;
  final String monthLabel;
  final String dayLabel;

  @override
  State<DateInputRow> createState() => _DateInputRowState();
}

class _DateInputRowState extends State<DateInputRow> {
  late final TextEditingController _yearController;
  late final TextEditingController _monthController;
  late final TextEditingController _dayController;

  late final FocusNode _yearFocus;
  late final FocusNode _monthFocus;
  late final FocusNode _dayFocus;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(text: '${widget.state.year}');
    _monthController = TextEditingController(text: '${widget.state.month}');
    _dayController = TextEditingController(text: '${widget.state.day}');
    _yearFocus = FocusNode();
    _monthFocus = FocusNode();
    _dayFocus = FocusNode();
  }

  @override
  void didUpdateWidget(DateInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);

    final directionChanged = oldWidget.state.direction != widget.state.direction;
    if (directionChanged ||
        (!_yearFocus.hasFocus &&
            _yearController.text != '${widget.state.year}')) {
      _yearController.text = '${widget.state.year}';
    }
    if (directionChanged ||
        (!_monthFocus.hasFocus &&
            _monthController.text != '${widget.state.month}')) {
      _monthController.text = '${widget.state.month}';
    }
    if (directionChanged ||
        (!_dayFocus.hasFocus &&
            _dayController.text != '${widget.state.day}')) {
      _dayController.text = '${widget.state.day}';
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    _yearFocus.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    super.dispose();
  }

  void _commitYear(String text) {
    final parsed = int.tryParse(text.trim());
    if (parsed != null && parsed > 0) {
      widget.notifier.setYear(parsed);
    }
  }

  void _commitMonth(String text) {
    final parsed = int.tryParse(text.trim());
    if (parsed != null && parsed > 0 && parsed <= widget.state.maxMonth) {
      widget.notifier.setMonth(parsed);
    }
  }

  void _commitDay(String text) {
    final parsed = int.tryParse(text.trim());
    if (parsed != null && parsed > 0 && parsed <= 31) {
      widget.notifier.setDay(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _yearController,
            focusNode: _yearFocus,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: widget.yearLabel),
            onSubmitted: _commitYear,
            onEditingComplete: () => _commitYear(_yearController.text),
            onTapOutside: (_) => _commitYear(_yearController.text),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _monthController,
            focusNode: _monthFocus,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: widget.monthLabel),
            onSubmitted: _commitMonth,
            onEditingComplete: () => _commitMonth(_monthController.text),
            onTapOutside: (_) => _commitMonth(_monthController.text),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _dayController,
            focusNode: _dayFocus,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: widget.dayLabel),
            onSubmitted: _commitDay,
            onEditingComplete: () => _commitDay(_dayController.text),
            onTapOutside: (_) => _commitDay(_dayController.text),
          ),
        ),
      ],
    );
  }
}
