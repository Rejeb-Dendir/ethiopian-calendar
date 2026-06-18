import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/app_models.dart';
import 'calendar_day_cell.dart';

/// Weekday headers and day grid for one Ethiopian month.
///
/// Uses [LayoutBuilder] so the grid scales to the height available inside
/// the horizontal month pager.
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.monthData,
    required this.onDaySelected,
  });

  final CalendarMonthData monthData;
  final ValueChanged<EthiopianDate> onDaySelected;

  static const double _headerHeight = 28;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowCount = monthData.days.length ~/ 7;
        final gridHeight =
            (constraints.maxHeight - _headerHeight - 8).clamp(120.0, 600.0);
        final cellSize = gridHeight / rowCount;

        return Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: Row(
                children: monthData.weekdayHeaders
                    .map(
                      (label) => Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: gridHeight,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  childAspectRatio: cellSize / cellSize,
                ),
                itemCount: monthData.days.length,
                itemBuilder: (context, index) {
                  final day = monthData.days[index];
                  return CalendarDayCell(
                    day: day,
                    onTap: day.isSelectable
                        ? () => onDaySelected(day.ethiopianDate)
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
