import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/packages/data/models/package.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class PackageCard extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final VoidCallback? onTap;

  const PackageCard({
    super.key,
    required this.package,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isSelected
                ? Color(0xffABC2E3)
                : theme.colorScheme.outline.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: isSelected ? 16 : 12,
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
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 8,
                    child: Image.network(package.imageUrl!, fit: BoxFit.cover),
                  ),
                  if (package.isRecommended)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffABC2E3),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomTextCaption(
                          'packages.recommended_badge'.tr(),
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(
                        package.title.tr(),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                      Spacer(),
                      CustomText(
                        'packages.price'.tr(
                          namedArgs: {
                            'value': package.price.toStringAsFixed(0),
                          },
                        ),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xffABC2E3),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
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
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      SizedBox(width: 16.w),
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
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ...package.benefits.map(
                    (benefitKey) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Icon(
                              Icons.check_circle,
                              size: 16.sp,
                              color: Color(0xffABC2E3),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: CustomTextBody(
                              benefitKey.tr(),
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
