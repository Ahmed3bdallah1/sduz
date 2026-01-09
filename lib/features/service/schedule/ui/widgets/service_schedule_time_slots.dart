import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/models.dart';

class ServiceScheduleTimeSlots extends StatelessWidget {
  final ServiceScheduleDay? day;
  final String? selectedSlotId;
  final ValueChanged<String> onSlotSelected;

  const ServiceScheduleTimeSlots({
    required this.day,
    required this.selectedSlotId,
    required this.onSlotSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (day == null) {
      return const SizedBox.shrink();
    }

    final slots = day!.slots;

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.start,
      children: slots.map((slot) {
        final isSelected = slot.id == selectedSlotId;
        final isAvailable = slot.isAvailable;
        final isRecommended = slot.isRecommended;

        return SizedBox(
          width:
              (MediaQuery.of(context).size.width - 60.w) / 2, // 2 slots per row
          child: GestureDetector(
            onTap: () {
              if (!isAvailable) return;
              onSlotSelected(slot.id);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: 2.w,
                vertical: isRecommended && isAvailable && !isSelected
                    ? 10.h
                    : 14.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xffABC2E3) : Color(0xffF3F4F6),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: isRecommended && isAvailable && !isSelected
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'لا يوجد',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              height: 1.2,
                            ),
                          ),
                          Text(
                            'مواعيد',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                              height: 1.2,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        slot.displayLabel,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: !isAvailable
                              ? theme.colorScheme.error
                              : (isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      )),
                          decoration: !isAvailable
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: theme.colorScheme.error,
                          decorationThickness: 1.5,
                        ),
                      ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
