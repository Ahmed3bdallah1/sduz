import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class ServiceOption {
  final String id;
  final String title;
  final String price;

  const ServiceOption({
    required this.id,
    required this.title,
    required this.price,
  });
}

class ServiceOptionsSection extends StatelessWidget {
  final List<ServiceOption> options;
  final String? selectedOptionId;
  final ValueChanged<String> onOptionSelected;

  const ServiceOptionsSection({
    required this.options,
    required this.selectedOptionId,
    required this.onOptionSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: options.map((option) {
          final isSelected = option.id == selectedOptionId;

          return Column(
            children: [
              GestureDetector(
                onTap: () => onOptionSelected(option.id),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          option.title,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      CustomText(
                        option.price,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withValues(
                                    alpha: 0.3,
                                  ),
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? Center(
                                child: Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              if (option != options.last)
                Divider(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  height: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
