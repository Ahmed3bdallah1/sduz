import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/shared/widgets/widgets.dart';

import 'package:sudz/features/service/models/models.dart';

class ServicePackageAvailabilityInfo extends StatelessWidget {
  final ServicePackage? package;
  final bool isAvailable;
  final String? disabledHint;

  const ServicePackageAvailabilityInfo({
    required this.package,
    required this.isAvailable,
    this.disabledHint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (package == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              size: 24.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                'service.checkout.package_unavailable'.tr(),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isAvailable
              ? colorScheme.secondary.withValues(alpha: 0.5)
              : colorScheme.outline.withValues(alpha: 0.5),
          width: 1.4,
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CustomText(
                  'service.checkout.package_header'.tr(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.secondary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: CustomText(
                  package!.name,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                isAvailable ? Icons.verified : Icons.error_outline,
                color: isAvailable ? colorScheme.secondary : colorScheme.error,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _PackageMetricChip(
                icon: Icons.repeat,
                label: 'service.checkout.package_washes'.tr(
                  args: ['${package!.remainingWashes}'],
                ),
              ),
              SizedBox(width: 10.w),
              _PackageMetricChip(
                icon: Icons.schedule_outlined,
                label: 'service.checkout.package_days'.tr(
                  args: ['${package!.remainingDays}'],
                ),
              ),
            ],
          ),
          if (!isAvailable && disabledHint != null) ...[
            SizedBox(height: 12.h),
            CustomText(
              disabledHint!,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.error.withValues(alpha: 0.9),
            ),
          ],
        ],
      ),
    );
  }
}

class _PackageMetricChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PackageMetricChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18.w, color: colorScheme.primary),
          SizedBox(width: 6.w),
          CustomText(
            label,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
