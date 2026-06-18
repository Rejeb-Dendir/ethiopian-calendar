import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/models/app_models.dart';

/// Single day cell showing Ethiopian day with Gregorian date underneath.
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.onTap,
  });

  final CalendarDay day;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isToday = day.isToday;
    final isSelected = day.isSelected;
    final isCurrentMonth = day.isCurrentMonth;

    Color? background;
    Color ethiopianColor;
    Color gregorianColor;
    FontWeight fontWeight = FontWeight.w600;

    if (isSelected) {
      background = AppColors.primaryGreen;
      ethiopianColor = Colors.white;
      gregorianColor = Colors.white.withValues(alpha: 0.75);
      fontWeight = FontWeight.w700;
    } else if (isToday) {
      background = AppColors.accentYellow.withValues(alpha: 0.35);
      ethiopianColor = const Color(0xFF3D3200);
      gregorianColor = AppColors.onSurfaceVariant;
      fontWeight = FontWeight.w700;
    } else if (isCurrentMonth) {
      ethiopianColor = theme.colorScheme.onSurface;
      gregorianColor = AppColors.onSurfaceVariant.withValues(alpha: 0.65);
    } else {
      ethiopianColor = AppColors.onSurfaceVariant.withValues(alpha: 0.4);
      gregorianColor = AppColors.onSurfaceVariant.withValues(alpha: 0.3);
    }

    return Semantics(
      label: _semanticLabel(),
      button: day.isSelectable,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: day.isSelectable ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(12),
              border: isToday && !isSelected
                  ? Border.all(
                      color: AppColors.accentYellow,
                      width: 1.5,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.ethiopianDate.day}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: ethiopianColor,
                    fontWeight: fontWeight,
                    height: 1.1,
                  ),
                ),
                Text(
                  day.gregorianLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: gregorianColor,
                    fontSize: 9,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _semanticLabel() {
    final date = day.ethiopianDate;
    final parts = <String>[
      date.formattedLong,
      day.gregorianLabel,
      if (day.isToday) 'today',
      if (day.isSelected) 'selected',
      if (!day.isCurrentMonth) 'outside current month',
    ];
    return parts.join(', ');
  }
}
