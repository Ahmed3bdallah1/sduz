import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class ServiceDescriptionSection extends StatelessWidget {
  final String description;

  const ServiceDescriptionSection({required this.description, super.key});

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
        children: [
          CustomText(
            'service.schedule.description_title'.tr(),
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          SizedBox(height: 12.h),
          CustomText(
            description,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            height: 1.6,
          ),
        ],
      ),
    );
  }
}
