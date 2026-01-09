import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/profile/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_network_image.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class MyPackageCard extends StatelessWidget {
  final ProfilePackage package;
  final bool isSelected;
  final VoidCallback onTap;

  const MyPackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(0.w),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            // border: Border.all(color: borderColor, width: 1.4),
            // boxShadow: [
            //   if (isSelected)
            //     BoxShadow(
            //       color: secondary.withValues(alpha: 0.12),
            //       blurRadius: 16,
            //       offset: const Offset(0, 8),
            //     ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomNetworkImage(
                imageUrl: package.imageUrl,
                width: double.infinity,
                height: 200.h,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(16.r),
              ),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          package.name,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        const Spacer(),
                        CustomText(
                          'profile.packages.price_format'.tr(
                            args: [package.price.toStringAsFixed(0)],
                          ),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 12.w),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.directions_car_filled_outlined,
                          label: 'profile.packages.wash_count'.tr(
                            args: [package.totalWashes.toString()],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _InfoChip(
                          icon: Icons.calendar_month_outlined,
                          label: 'profile.packages.validity_days'.tr(
                            args: [package.validityDays.toString()],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Column(
                      children: package.benefits
                          .map(
                            (benefit) => Padding(
                              padding: EdgeInsets.only(bottom: 8.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 18.sp,
                                    color: theme.colorScheme.primary,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: CustomTextBody(
                                      benefit.tr(),
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        // border: Border.all(
        //   color: theme.colorScheme.outline.withValues(alpha: 0.6),
        // ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: theme.colorScheme.primary),
          SizedBox(width: 6.w),
          CustomTextBody(label, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }
}
