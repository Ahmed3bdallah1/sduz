import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/models.dart';

class ServiceScheduleDateSelector extends StatelessWidget {
  final List<ServiceScheduleDay> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const ServiceScheduleDateSelector({
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          // Week navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onPrevious,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
              Text(
                'service.schedule.calendar_title'.tr(),
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              GestureDetector(
                onTap: onNext,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          // Divider line
          Container(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
          SizedBox(height: 24.h),
          // Days row with weekday names and dates
          Row(
            children: List.generate(days.length > 4 ? 4 : days.length, (index) {
              final actualIndex = selectedIndex - (selectedIndex % 4) + index;
              if (actualIndex >= days.length) return const Spacer();

              final day = days[actualIndex];
              final isSelected = actualIndex == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDaySelected(actualIndex),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Weekday name
                      Text(
                        day.dayLabel.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      // Date number with background
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xffABC2E3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day.dayNumber,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
