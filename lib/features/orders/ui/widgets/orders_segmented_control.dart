import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/orders/bloc/orders_event.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class OrdersSegmentedControl extends StatelessWidget {
  final OrdersSegment selectedSegment;
  final ValueChanged<OrdersSegment> onSegmentChanged;

  const OrdersSegmentedControl({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: OrdersSegment.values.map((segment) {
          final isSelected = segment == selectedSegment;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSegmentChanged(segment),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFB9CCE9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: CustomText(
                  segment.label,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF1A1930)
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
