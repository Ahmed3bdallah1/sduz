import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sudz/features/profile/shared/models/models.dart';
import 'package:sudz/shared/widgets/custom_network_image.dart';
import 'package:sudz/shared/widgets/custom_text.dart';

class MyCarCard extends StatelessWidget {
  final ProfileCar car;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const MyCarCard({
    super.key,
    required this.car,
    required this.isSelected,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.secondary;
    final outline = Colors.transparent;

    final borderColor = isSelected ? secondary : outline;
    final backgroundColor = isSelected
        ? secondary.withValues(alpha: 0.12)
        : theme.colorScheme.surface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: borderColor, width: 1.6),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      car.fullDescription,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    SizedBox(height: 6.h),
                    CustomTextBody(
                      'profile.cars.plate_prefix'.tr(args: [car.plateNumber]),
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    if (car.isPrimary) ...[
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: CustomTextCaption(
                          'profile.cars.primary_badge'.tr(),
                          color: secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              CustomNetworkImage(
                imageUrl: car.imageUrl,
                width: 86.w,
                height: 68.h,
                borderRadius: BorderRadius.circular(18.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
