import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/custom_text.dart';
import '../../../service/models/models.dart';

class ServiceActivePackageCard extends StatelessWidget {
  final ServicePackage package;
  final VoidCallback onToggle;

  const ServiceActivePackageCard({
    required this.package,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // SizedBox(width: 8.w),
              CustomText(
                'باقة نشطة',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.end,
                color: theme.colorScheme.onSurface,
              ),
              Spacer(),
              Switch.adaptive(
                value: package.isEnabled,
                onChanged: (_) => onToggle(),
                activeTrackColor: colorScheme.primary,
                inactiveTrackColor: colorScheme.primary.withValues(alpha: 0.15),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              CustomText(
                'اسم الباقة ',
                fontSize: 12.sp,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w400,
              ),
              Spacer(),
              CustomText(
                package.name,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Column(
            children: [
              _PackageDetailTile(
                title: 'الأيام المتبقية',
                value: '${package.remainingDays} يوم',
              ),
              SizedBox(height: 5.w),
              _PackageDetailTile(
                title: 'الغسلات المتبقية',
                value: '${package.remainingWashes} غسلات',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PackageDetailTile extends StatelessWidget {
  final String title;
  final String value;

  const _PackageDetailTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title,
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
        ),
        SizedBox(height: 4.h),
        CustomText(
          value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }
}
