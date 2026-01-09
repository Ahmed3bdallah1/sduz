import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/home/models/models.dart';
import 'package:sudz/shared/widgets/widgets.dart';

class HomePackageCard extends StatelessWidget {
  final HomePackage package;
  final VoidCallback? onTap;

  const HomePackageCard({super.key, required this.package, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: CustomNetworkImage(
                imageUrl: package.imageUrl,
                height: 128.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        package.title,
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,

                        color: theme.colorScheme.onSurface,
                      ),
                      CustomText(
                        '${package.price.toStringAsFixed(0)} ${package.priceUnit}',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  CustomText(
                    package.description,
                    color: theme.hintColor,
                    fontSize: 12.sp,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _StatChip(icon: Icons.timer_outlined, label: "${package.ordersCount} غسلات"),
                      SizedBox(width: 12.w),
                      _StatChip(
                        icon: Icons.check_circle_outline,
                        label: '${package.durationMinutes} دقيقة',
                      ),
                    ],
                  ),
                  // SizedBox(height: 16.h),
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: EdgeInsets.symmetric(
                  //         horizontal: 14.w,
                  //         vertical: 8.h,
                  //       ),
                  //       decoration: BoxDecoration(
                  //         color: theme.colorScheme.primary.withValues(
                  //           alpha: 0.1,
                  //         ),
                  //         borderRadius: BorderRadius.circular(14.r),
                  //       ),
                  //       child: CustomText(
                  //         '${package.price.toStringAsFixed(0)} ${package.priceUnit}',
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w700,
                  //         color: theme.colorScheme.primary,
                  //       ),
                  //     ),
                  //     const Spacer(),
                  //     Icon(
                  //       Icons.arrow_forward_ios_rounded,
                  //       size: 18.sp,
                  //       color: AppTheme.iconInactive,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: theme.colorScheme.primary),
          SizedBox(width: 6.w),
          CustomText(
            label,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
