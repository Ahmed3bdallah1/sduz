import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/packages/data/models/models.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackageCheckoutSummaryCard extends StatelessWidget {
  final Package package;

  const PackageCheckoutSummaryCard({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(22.r),
              topRight: Radius.circular(22.r),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 8,
              child: Image.network(package.imageUrl!, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  package.title.tr(),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.directions_car_filled_outlined,
                      size: 18.sp,
                      color: Color(0xffABC2E3),
                    ),
                    SizedBox(width: 6.w),
                    CustomTextCaption(
                      'packages.washes'.tr(
                        namedArgs: {'count': package.washesCount.toString()},
                      ),
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    SizedBox(width: 14.w),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18.sp,
                      color: Color(0xffABC2E3),
                    ),
                    SizedBox(width: 6.w),
                    CustomTextCaption(
                      'packages.validity'.tr(
                        namedArgs: {'days': package.validityDays.toString()},
                      ),
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                CustomText(
                  'packages.price'.tr(
                    namedArgs: {'value': package.price.toStringAsFixed(0)},
                  ),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
